import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/notification_item_model.dart';
import 'package:xaosao/repository/notification_repo.dart';
import 'package:xaosao/services/api_service.dart';
import 'package:xaosao/services/storage_service.dart';

typedef ForegroundPushListener =
    void Function(String type, Map<String, dynamic> data);

/// Handles all push notification concerns for the app.
///
/// ┌─────────────────────────────────────────────────────┐
/// │  App state    │  Who shows notification?            │
/// ├─────────────────────────────────────────────────────┤
/// │  Foreground   │  _showBanner (flutter_local_notif.) │
/// │  Background   │  FCM SDK → Android system tray      │
/// │  Terminated   │  FCM SDK → Android system tray      │
/// └─────────────────────────────────────────────────────┘
///
/// Background/terminated taps are caught by:
///   - onMessageOpenedApp  (background)
///   - getInitialMessage   (terminated)
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static String? _fcmToken;
  static String? get fcmToken => _fcmToken;

  /// Last device token we successfully POSTed to `/notifications/register-device`.
  /// Persisted so a re-open of the app doesn't re-register an unchanged token,
  /// and cleared automatically on logout (logout calls `storage.clear()`).
  static const String _syncedTokenKey = 'fcm_synced_token';

  /// The sync currently in flight, if any.
  ///
  /// Concurrent callers (login + PermissionCoordinator + onTokenRefresh can
  /// all fire within the same second) share this one run instead of being
  /// skipped. A boolean "busy" flag would turn the racing caller into a
  /// permanent no-op: if the run it collided with then failed, nobody retried.
  static Future<bool>? _inFlight;

  /// Last failure reason. Readable from anywhere as
  /// `NotificationService.lastSyncError` — useful for diagnosing a release
  /// build you cannot attach a debugger to.
  static String? lastSyncError;

  /// Global reactive notification badge.
  static final RxInt unreadCount = 0.obs;

  /// Global reactive badge counts from me/badges API.
  static final RxInt chatUnreadCount = 0.obs;
  static final RxInt bookingUnreadCount = 0.obs;
  static final RxInt postUnreadCount = 0.obs;

  /// Fires when a foreground push arrives so NotifListLogic can refresh.
  static Function()? onNewNotification;

  /// Foreground-push broadcaster.
  ///
  /// Any number of controllers can subscribe via [addForegroundListener]
  /// to react to specific push types (booking, post, wallet, ...).
  /// Each listener receives `(type, data)` where `data` is the FCM payload.
  ///
  /// Listeners MUST call [removeForegroundListener] in `onClose` to avoid
  /// holding references to disposed controllers.
  static final Set<ForegroundPushListener> _foregroundListeners =
      <ForegroundPushListener>{};

  static void addForegroundListener(ForegroundPushListener listener) {
    _foregroundListeners.add(listener);
  }

  static void removeForegroundListener(ForegroundPushListener listener) {
    _foregroundListeners.remove(listener);
  }

  // ── Channel constants (must match AndroidManifest default_notification_channel_id) ──
  static const String _channelId = 'default_channel';
  static const String _channelName = 'Default Notifications';
  static const String _channelDesc = 'Default notification channel';

  // ── Background handler ─────────────────────────────────────────────────────
  // Called from main.dart's top-level @pragma function.
  // Runs in its own Dart isolate — platform channels are NOT available here,
  // so we must NOT call flutter_local_notifications.
  // FCM SDK shows the notification via the manifest channel automatically.
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    // Nothing else — FCM SDK takes care of the system tray notification.
  }

  // ── Main initialisation (call once from main()) ────────────────────────────
  //
  // NOTE: This intentionally does NOT call `requestPermission(...)`.
  // The OS permission dialog is shown later by PermissionCoordinator,
  // so users are asked in context. The token is fetched AND uploaded by
  // `syncTokenToServer()`, which runs here when permission is already
  // granted, after login, after a permission grant, and on token rotation.
  static Future<void> initialize() async {
    // iOS: present notifications when app is in foreground (no permission
    // ask here — just configures presentation if/when permission is granted).
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Initialise flutter_local_notifications (foreground banners only)
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: _onLocalTap,
    );

    // Create the Android notification channel.
    // Must use the same ID as com.google.firebase.messaging.default_notification_channel_id
    // in AndroidManifest.xml so background/terminated messages appear here too.
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDesc,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );

    // Foreground messages → show a local banner
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Background tap → user tapped the system tray notification while app was alive
    FirebaseMessaging.onMessageOpenedApp.listen(_onRemoteTap);

    // Terminated tap → app was launched by tapping the notification
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      // Longer delay: splash + login/dashboard controllers must be registered first
      Future.delayed(
        const Duration(milliseconds: 1200),
        () => _navigateFromData(initial.data),
      );
    }

    // Subscribe to token rotation — Firebase rotates tokens on reinstall,
    // restore-from-backup and app-data clear. A rotated token MUST be
    // pushed to the server or the device silently stops receiving pushes.
    FirebaseMessaging.instance.onTokenRefresh.listen((t) {
      _fcmToken = t;
      unawaited(syncTokenToServer(force: true));
    });

    // Cold start with an existing session: make sure the server has the
    // current token without waiting for the dashboard's PermissionCoordinator
    // pass (which only runs once the user reaches the dashboard, and only on
    // the permission-granted branch).
    unawaited(_syncOnLaunch());
  }

  /// Registers the token on launch.
  ///
  /// Android hands out a usable FCM token BEFORE POST_NOTIFICATIONS is
  /// granted, so register it immediately: the server then already holds the
  /// token the moment the user allows notifications, and a user who never
  /// reaches the in-app prompt is still reachable once they enable
  /// notifications from system settings.
  ///
  /// iOS is different — `getToken()` needs an APNS token, which only exists
  /// after the user authorises — so there we wait for the grant.
  static Future<void> _syncOnLaunch() async {
    try {
      // InitialBinding registers ApiService with an un-awaited putAsync, so
      // at this point in main() it may not be resolvable yet.
      await _awaitApiService();

      if (Platform.isAndroid) {
        await syncTokenToServer();
        return;
      }

      final settings = await FirebaseMessaging.instance
          .getNotificationSettings();
      final granted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      if (granted) await syncTokenToServer();
    } catch (e) {
      // debugPrint('[fcm] launch sync skipped: $e');
      // The dashboard permission pass retries.
    }
  }

  /// Waits (briefly) for [ApiService] to finish its async registration.
  static Future<void> _awaitApiService() async {
    for (var i = 0; i < 20 && !Get.isRegistered<ApiService>(); i++) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Fetch (or re-fetch) the FCM device token AND register it with the
  /// backend. This is the single entry point for device registration —
  /// getting the token without uploading it is what silently broke push
  /// in production, so the two steps deliberately live together.
  ///
  /// Safe to call at any time; it becomes a no-op when:
  ///   - the user is not logged in (no auth token) — login re-runs it,
  ///   - no device token is available yet (iOS before the APNS grant),
  ///   - the same token was already registered and [force] is false.
  ///
  /// Returns true when the server holds the current token.
  static Future<bool> syncTokenToServer({bool force = false}) {
    final running = _inFlight;
    if (running != null) return running;
    final run = _runSync(force: force).whenComplete(() => _inFlight = null);
    _inFlight = run;
    return run;
  }

  static Future<bool> _runSync({required bool force}) async {
    try {
      final storage = _storageOrNull();
      final auth = storage?.read<String>('token');
      if (auth == null || auth.isEmpty) {
        // Not signed in yet — LoginLogic.saveFcmToken() runs this again
        // right after a successful login.
        lastSyncError = 'not signed in';
        // debugPrint('[fcm] skip — not signed in');
        return false;
      }

      final token = await _fetchToken();
      // debugPrint('device token is here ==>$token');
      if (token == null || token.isEmpty) {
        lastSyncError = 'no device token';
        return false;
      }
      _fcmToken = token;

      if (!force && storage?.read<String>(_syncedTokenKey) == token) {
        // debugPrint('[fcm] token unchanged — already registered');
        return true;
      }

      // Retry transient failures. A real phone on mobile data drops requests
      // far more often than an emulator on the host's wired connection, and
      // this fires during startup alongside profile + wallet + socket traffic.
      // `_syncedTokenKey` is only written on success, so a run that exhausts
      // its retries is picked up again by the next launch or the next
      // dashboard permission pass.
      for (var attempt = 1; attempt <= 3; attempt++) {
        final res = await NotificationRepo().registerDevice(deviceToken: token);
        if (res.success) {
          await storage?.write(_syncedTokenKey, token);
          lastSyncError = null;
          // debugPrint('[fcm] register-device OK (attempt $attempt)');
          return true;
        }
        lastSyncError =
            'register-device failed: ${res.statusCode} ${res.message}';
        // debugPrint('[fcm] attempt $attempt/3 — $lastSyncError');
        if (attempt < 3) await Future.delayed(Duration(seconds: 2 * attempt));
      }
      return false;
    } catch (e) {
      lastSyncError = 'sync error: $e';
      // debugPrint('[fcm] $lastSyncError');
      return false;
    }
  }

  /// Backwards-compatible alias — kept so existing call sites keep working.
  /// Prefer [syncTokenToServer].
  static Future<void> refreshToken() => syncTokenToServer();

  /// Reads the device token, waiting for APNS first on iOS.
  ///
  /// On iOS `getToken()` throws `apns-token-not-set` until APNS has handed
  /// Firebase a device token, which can lag a few seconds after launch. The
  /// old code swallowed that error and left the token null forever, so the
  /// device was never registered. Poll briefly instead.
  static Future<String?> _fetchToken() async {
    try {
      if (Platform.isIOS) {
        String? apns = await FirebaseMessaging.instance.getAPNSToken();
        for (var i = 0; i < 10 && apns == null; i++) {
          await Future.delayed(const Duration(milliseconds: 500));
          apns = await FirebaseMessaging.instance.getAPNSToken();
        }
        if (apns == null) {
          // debugPrint('[fcm] APNS token unavailable — skipping this sync');
          return null;
        }
      }
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      // debugPrint('[fcm] getToken failed: $e');
      return null;
    }
  }

  static StorageService? _storageOrNull() {
    try {
      return Get.find<StorageService>();
    } catch (_) {
      return null;
    }
  }

  // ── Foreground handler ─────────────────────────────────────────────────────
  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    // print('message received: ${message.messageId}, data: ${message.data}');
    // print('notification: ${message.notification?.title}/${message.notification?.body}');
    unreadCount.value++;
    await _showBanner(
      title: message.notification?.title ?? 'ແຈ້ງເຕືອນໃໝ່',
      body: message.notification?.body ?? '',
      data: message.data,
    );
    onNewNotification?.call();
    final type = message.data['type'] as String? ?? '';
    final data = Map<String, dynamic>.from(message.data);
    // Iterate over a snapshot so a listener that unsubscribes during dispatch
    // doesn't mutate the iterator.
    for (final listener in _foregroundListeners.toList()) {
      try {
        listener(type, data);
      } catch (_) {
        // Never let a buggy listener block the rest.
      }
    }
  }

  // ── Tap handlers ───────────────────────────────────────────────────────────
  static void _onRemoteTap(RemoteMessage message) =>
      _navigateFromData(message.data);

  static void _onLocalTap(NotificationResponse response) {
    try {
      final payload = response.payload;
      final data = (payload != null && payload.isNotEmpty)
          ? Map<String, dynamic>.from(jsonDecode(payload) as Map)
          : <String, dynamic>{};
      _navigateFromData(data);
    } catch (_) {
      _navigateFromData({});
    }
  }

  // ── Auth-gated deep navigation entry point ────────────────────────────────
  static void _navigateFromData(Map<String, dynamic> data) {
    try {
      final role = Get.find<StorageService>().read<String>('role');
      if (role == null || role.isEmpty) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }
      final type = data['type'] as String? ?? '';
      final isCustomer = role == 'customer';

      // Admin broadcast → the announcement page (mirrors NotifListLogic.
      // handleTap). FCM data values are always strings, so `is_admin` arrives
      // as "true"/"false", not a bool. Requires the backend to include
      // `is_admin` in the push data payload; without it this is a no-op and
      // the type-based routing below still runs.
      final isAdmin = (data['is_admin'] as String?)?.toLowerCase() == 'true';
      if (isAdmin && type != 'welcome') {
        Get.toNamed(
          AppRoutes.announcement,
          arguments: NotificationItemModel(
            type: type,
            title: data['title'] as String?,
            laTitle: data['la_title'] as String?,
            message: data['body'] as String?,
            laMessage: data['la_body'] as String?,
            isAdmin: true,
            // No reliable send time in the data payload — the page simply
            // omits the date pill rather than showing an invented one.
          ),
        );
        return;
      }

      if (type.isEmpty) {
        Get.toNamed(AppRoutes.notifications);
        return;
      }
      _navigateByType(type, data, isCustomer);
    } catch (_) {
      // StorageService not ready — app still initialising from terminated state
    }
  }

  // ── Type-specific navigation (mirrors notification_list_logic) ─────────────
  static void _navigateByType(
    String type,
    Map<String, dynamic> data,
    bool isCustomer,
  ) {
    String _s(String key) => (data[key] as String?) ?? '';

    switch (type) {
      // ── Home ────────────────────────────────────────────────────
      case 'welcome':
        Get.toNamed(
          AppRoutes.welcomeNotification,
          arguments: NotificationItemModel(
            type: 'welcome',
            title: data['title'] as String?,
            laTitle: data['la_title'] as String?,
            message: data['body'] as String?,
            laMessage: data['la_body'] as String?,
          ),
        );
        return;
      case 'account_deleted':
        Get.until((r) => r.settings.name == AppRoutes.dashboard);
        return;

      // ── Account ─────────────────────────────────────────────────
      case 'account_approved':
      case 'account_rejected':
      case 'account_banned':
      case 'account_role_changed':
      case 'account_reported':
        Get.toNamed(AppRoutes.profileDetail, arguments: isCustomer);
        return;

      // ── New companion ────────────────────────────────────────────
      case 'new_model_registered':
      case 'new_model_service':
        final modelId = _s('modelId');
        if (modelId.isNotEmpty) {
          Get.toNamed(AppRoutes.companionProfile, arguments: modelId);
        }
        return;

      // ── Gifts ────────────────────────────────────────────────────
      case 'post_gift_received':
      case 'gift_received':
       case 'gift_reaction':
        final postId = _s('postId');
        if (postId.isNotEmpty) {
          Get.toNamed(AppRoutes.myGifts, arguments: postId);
        }
        return;

      // ── Post comments → post detail (no BuildContext for CommentSheet) ──
      case 'post_comment':
      case 'post_comment_reply':
        final commentPostId = _s('postId');
        if (commentPostId.isNotEmpty) {
          Get.toNamed(AppRoutes.postDetail, arguments: commentPostId);
        } else {
          Get.toNamed(AppRoutes.notifications);
        }
        return;

      // ── Post like → interest page ─────────────────────────────────
      case 'post_like':
        final likePostId = _s('postId');
        if (likePostId.isNotEmpty) {
          Get.toNamed(AppRoutes.postInterests, arguments: likePostId);
        } else {
          Get.toNamed(AppRoutes.notifications);
        }
        return;

      // ── New posts → post detail ───────────────────────────────────
      case 'new_model_post':
      case 'new_customer_post':
        final postId = _s('postId');
        if (postId.isNotEmpty) {
          Get.toNamed(AppRoutes.postDetail, arguments: postId);
        } else {
          Get.toNamed(AppRoutes.notifications);
        }
        return;

      // ── Profile interactions ──────────────────────────────────────
      case 'profile_viewed':
        final viewId = _s('viewerId').isNotEmpty
            ? _s('viewerId')
            : _s('modelId');
        if (viewId.isNotEmpty) {
          Get.toNamed(
            isCustomer ? AppRoutes.companionProfile : AppRoutes.customerProfile,
            arguments: viewId,
          );
        }
        return;

      case 'profile_liked':
        final likeId = _s('likerId').isNotEmpty ? _s('likerId') : _s('modelId');
        if (likeId.isNotEmpty) {
          Get.toNamed(
            isCustomer ? AppRoutes.companionProfile : AppRoutes.customerProfile,
            arguments: likeId,
          );
        }
        return;

      case 'friend_added':
        final friendId = _s('friendId').isNotEmpty
            ? _s('friendId')
            : _s('modelId');
        if (friendId.isNotEmpty) {
          Get.toNamed(
            isCustomer ? AppRoutes.companionProfile : AppRoutes.customerProfile,
            arguments: friendId,
          );
        }
        return;

      // ── Booking ───────────────────────────────────────────────────
      case 'booking_created':
      case 'booking_accepted':
      case 'booking_rejected':
      case 'booking_cancelled':
      case 'booking_completed':
      case 'booking_payout_released':
        final bookingId = _s('bookingId');
        if (bookingId.isNotEmpty) {
          Get.toNamed(
            AppRoutes.bookingDetail,
            arguments: {'bookingId': bookingId, 'isCustomer': isCustomer},
          );
        }
        return;

      // ── Wallet / finance ──────────────────────────────────────────
      // Note: `booking_payout_released` is handled by the booking block above
      // (taps go to the booking detail page). Wallet refresh on that push is
      // driven by DashboardLogic listening on the foreground broadcaster.
      case 'topup_created':
      case 'topup_approved':
      case 'topup_rejected':
      case 'withdraw_approved':
      case 'withdraw_rejected':
        Get.toNamed(isCustomer ? AppRoutes.wallet : AppRoutes.modelWallet);
        return;

      default:
        Get.toNamed(AppRoutes.notifications);
        return;
    }
  }

  // ── Local banner (foreground only) ─────────────────────────────────────────
  static Future<void> _showBanner({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    await _plugin.show(
      id: Random().nextInt(0x7FFFFFFF),
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: data != null ? jsonEncode(data) : null,
    );
  }
}
