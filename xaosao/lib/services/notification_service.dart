import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/notification_item_model.dart';
import 'package:xaosao/services/storage_service.dart';

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

  /// Global reactive notification badge.
  static final RxInt unreadCount = 0.obs;

  /// Global reactive badge counts from me/badges API.
  static final RxInt chatUnreadCount = 0.obs;
  static final RxInt bookingUnreadCount = 0.obs;
  static final RxInt postUnreadCount = 0.obs;

  /// Fires when a foreground push arrives so NotifListLogic can refresh.
  static Function()? onNewNotification;

  /// Fires with (type, data) so controllers can refresh type-specific data.
  static Function(String type, Map<String, dynamic> data)? onForegroundNotification;

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
  static Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // iOS: present notifications when app is in foreground
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
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDesc,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ));

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

    // FCM token
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken();
    } catch (_) {}
    FirebaseMessaging.instance.onTokenRefresh.listen((t) => _fcmToken = t);
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
    onForegroundNotification?.call(type, message.data);
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
        final viewId = _s('viewerId').isNotEmpty ? _s('viewerId') : _s('modelId');
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
        final friendId = _s('friendId').isNotEmpty ? _s('friendId') : _s('modelId');
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
        final bookingId = _s('bookingId');
        if (bookingId.isNotEmpty) {
          Get.toNamed(AppRoutes.bookingDetail, arguments: {
            'bookingId': bookingId,
            'isCustomer': isCustomer,
          });
        }
        return;

      // ── Wallet / finance ──────────────────────────────────────────
      case 'topup_created':
      case 'topup_approved':
      case 'topup_rejected':
      case 'withdraw_approved':
      case 'withdraw_rejected':
      case 'booking_payout_released':
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
