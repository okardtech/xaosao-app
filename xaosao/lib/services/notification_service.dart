import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
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

  /// Global reactive badge. Read anywhere with:
  ///   Obx(() => NotificationService.unreadCount.value)
  static final RxInt unreadCount = 0.obs;

  /// Fires when a foreground push arrives so NotifListLogic can refresh.
  static Function()? onNewNotification;

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
      // Delay until the widget tree is ready
      Future.delayed(const Duration(milliseconds: 600), _navigateToNotifications);
    }

    // FCM token
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken();
    } catch (_) {}
    FirebaseMessaging.instance.onTokenRefresh.listen((t) => _fcmToken = t);
  }

  // ── Foreground handler ─────────────────────────────────────────────────────
  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    print('message received: ${message.messageId}, data: ${message.data}');
    print('notification: ${message.notification?.title}/${message.notification?.body}');
    unreadCount.value++;
    await _showBanner(
      title: message.notification?.title ?? 'ແຈ້ງເຕືອນໃໝ່',
      body: message.notification?.body ?? '',
      data: message.data,
    );
    onNewNotification?.call();
  }

  // ── Tap handlers ───────────────────────────────────────────────────────────
  static void _onRemoteTap(RemoteMessage _) => _navigateToNotifications();
  static void _onLocalTap(NotificationResponse _) => _navigateToNotifications();

  // ── Auth-gated navigation ──────────────────────────────────────────────────
  static void _navigateToNotifications() {
    try {
      final role = Get.find<StorageService>().read<String>('role');
      if (role == null || role.isEmpty) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }
      Get.toNamed(AppRoutes.notifications);
    } catch (_) {
      // StorageService not ready — app still initialising from terminated state
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
