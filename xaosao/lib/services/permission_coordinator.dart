import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:xaosao/pages/permissions/permission_sheets.dart';
import 'package:xaosao/services/location_manager.dart';
import 'package:xaosao/services/location_service.dart';
import 'package:xaosao/services/notification_service.dart';
import 'package:xaosao/services/storage_service.dart';

// ═══════════════════════════════════════════════════════════════
//  permission_coordinator.dart
//
//  Single entry point for runtime permissions in Xaosao.
//
//  Flow (per permission):
//    granted        → run side-effect (push GPS / refresh FCM token)
//    notDetermined  → show primer sheet → on consent, trigger OS dialog
//                     → verify result → on grant run side-effect,
//                                       on deny show settings sheet
//    denied (hard)  → show settings sheet (only re-entry path is OS)
//
//  Flow per permission:
//    granted        → run side-effect (push GPS / refresh FCM token)
//    notDetermined  → trigger OS dialog directly (no priming sheet).
//                     If user grants → side-effect. If user denies →
//                     SettingsReminderSheet (only recovery path).
//    denied (hard)  → SettingsReminderSheet (OS dialog won't show again
//                     on iOS / Android 13+ after first denial).
//
//  Re-ask cadence: once the SettingsReminderSheet is dismissed in a
//  session (either via "ປິດ" or via tapping the settings shortcut),
//  it's suppressed for the REST OF THAT SESSION ONLY. Cold-restarting
//  the app clears the flag and the sheet is shown again. This is the
//  right cadence for a booking app — notifications are business-
//  critical and we don't want users locked out for days.
//
//  Order: notifications first (more critical for booking flow),
//  then location.
// ═══════════════════════════════════════════════════════════════
class PermissionCoordinator {
  PermissionCoordinator._();

  // SharedPreferences keys for side-effect rate-limit (so re-mounts /
  // resumes don't re-do network + GPS work on every coordinator run).
  // These persist across sessions — unlike the dismiss flags below.
  static const _locSyncKey = 'perm_loc_last_sync_at';
  static const _fcmSyncKey = 'perm_fcm_last_sync_at';
  static const _sideEffectInterval = Duration(minutes: 5);

  // In-memory session-only dismiss flags. Cleared on cold start, NOT
  // on resume-from-background. Set when the user dismisses or engages
  // any sheet for the given permission; cleared automatically when
  // the static class is initialised on next cold start.
  static bool _notifDismissedThisSession = false;
  static bool _locDismissedThisSession = false;

  // Re-entry guard — prevents concurrent runs (e.g. from rapid nav).
  static bool _running = false;

  // ─────────────────────────────────────────────────────────────
  //  Public API
  // ─────────────────────────────────────────────────────────────

  /// Main entry point — call once from DashboardPage after first frame.
  /// Safe to call multiple times; only one run executes concurrently.
  static Future<void> checkAndPrime(BuildContext context) async {
    if (_running) return;
    _running = true;
    try {
      await _handleNotification(context);
      if (!context.mounted) return;
      await _handleLocation(context);
    } finally {
      _running = false;
    }
  }

  /// Quick read for UI banners — true iff the OS currently grants
  /// notification authorization.
  static Future<bool> isNotificationGranted() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// Quick read for UI banners — true iff GPS service is on AND
  /// permission is whileInUse / always.
  static Future<bool> isLocationGranted() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    final perm = await Geolocator.checkPermission();
    return perm == LocationPermission.whileInUse ||
        perm == LocationPermission.always;
  }

  // ─────────────────────────────────────────────────────────────
  //  Notification flow
  // ─────────────────────────────────────────────────────────────
  static Future<void> _handleNotification(BuildContext context) async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    final status = settings.authorizationStatus;

    // Already granted — make sure the token is fresh then bail.
    if (status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional) {
      unawaited(_runNotificationSideEffect());
      return;
    }

    // Hard-denied → only the OS settings can recover.
    if (status == AuthorizationStatus.denied) {
      if (_notifDismissedThisSession) return;
      if (!context.mounted) return;
      final goSettings = await SettingsReminderSheet.show(
        context,
        icon: Icons.notifications_off_rounded,
        title: 'ການແຈ້ງເຕືອນຖືກປິດໄວ້',
        message:
            'ກະລຸນາເປີດການແຈ້ງເຕືອນໃນການຕັ້ງຄ່າ ເພື່ອບໍ່ພາດການຈອງ '
            'ແລະ ຂໍ້ຄວາມສຳຄັນຈາກ Xaosao',
      );
      // Mark dismissed for this session regardless of choice — the
      // resume-from-background hook would otherwise loop the sheet
      // when the user returns from Settings without changing anything.
      // Next cold start clears the flag and the sheet shows again.
      _notifDismissedThisSession = true;
      if (goSettings) {
        await ph.openAppSettings();
      }
      return;
    }

    // notDetermined → fire the OS dialog directly (no primer).
    if (status == AuthorizationStatus.notDetermined) {
      final result = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final ok =
          result.authorizationStatus == AuthorizationStatus.authorized ||
          result.authorizationStatus == AuthorizationStatus.provisional;
      if (ok) {
        // Granted on the OS dialog — nothing else to show.
        unawaited(_runNotificationSideEffect());
      } else if (context.mounted && !_notifDismissedThisSession) {
        // User tapped Don't Allow on the OS dialog → custom sheet is
        // the only re-engagement path (OS won't re-prompt on iOS).
        final goSettings = await SettingsReminderSheet.show(
          context,
          icon: Icons.notifications_off_rounded,
          title: 'ການແຈ້ງເຕືອນຍັງບໍ່ໄດ້ເປີດ',
          message:
              'ເປີດການແຈ້ງເຕືອນໃນການຕັ້ງຄ່າ ເພື່ອບໍ່ພາດການຈອງ '
              'ແລະ ຂໍ້ຄວາມສຳຄັນ',
        );
        _notifDismissedThisSession = true;
        if (goSettings) {
          await ph.openAppSettings();
        }
      }
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  Location flow
  // ─────────────────────────────────────────────────────────────
  static Future<void> _handleLocation(BuildContext context) async {
    // GPS toggle is OS-level and orthogonal to permission.
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (_locDismissedThisSession) return;
      if (!context.mounted) return;
      final goSettings = await SettingsReminderSheet.show(
        context,
        icon: Icons.location_off_rounded,
        title: 'GPS ປິດໄວ້',
        message:
            'ກະລຸນາເປີດ GPS ໃນການຕັ້ງຄ່າ ເພື່ອໃຫ້ Xaosao '
            'ສະແດງບໍລິການໃກ້ທ່ານ ແລະ ປັບປຸງການແນະນຳ',
      );
      _locDismissedThisSession = true;
      if (goSettings) {
        await Geolocator.openLocationSettings();
      }
      return;
    }

    var perm = await Geolocator.checkPermission();

    // Granted → push GPS (rate-limited inside).
    if (perm == LocationPermission.whileInUse ||
        perm == LocationPermission.always) {
      unawaited(_runLocationSideEffect());
      return;
    }

    // Hard-denied → settings.
    if (perm == LocationPermission.deniedForever) {
      if (_locDismissedThisSession) return;
      if (!context.mounted) return;
      final goSettings = await SettingsReminderSheet.show(
        context,
        icon: Icons.location_off_rounded,
        title: 'ການເຂົ້າເຖິງສະຖານທີ່ຖືກປິດ',
        message:
            'ກະລຸນາເປີດການເຂົ້າເຖິງສະຖານທີ່ໃນການຕັ້ງຄ່າ '
            'ເພື່ອປະສົບການທ້ອງຖິ່ນທີ່ດີຍິ່ງຂຶ້ນ',
      );
      _locDismissedThisSession = true;
      if (goSettings) {
        await ph.openAppSettings();
      }
      return;
    }

    // denied / unableToDetermine → fire the OS dialog directly.
    perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.whileInUse ||
        perm == LocationPermission.always) {
      // Granted on the OS dialog — nothing else to show.
      unawaited(_runLocationSideEffect());
    } else if (perm == LocationPermission.deniedForever &&
        context.mounted &&
        !_locDismissedThisSession) {
      // Permanent denial — custom sheet is the only recovery path.
      final goSettings = await SettingsReminderSheet.show(
        context,
        icon: Icons.location_off_rounded,
        title: 'ການເຂົ້າເຖິງສະຖານທີ່ຖືກປິດ',
        message:
            'ກະລຸນາເປີດການເຂົ້າເຖິງສະຖານທີ່ໃນການຕັ້ງຄ່າ '
            'ເພື່ອປະສົບການທ້ອງຖິ່ນທີ່ດີຍິ່ງຂຶ້ນ',
      );
      _locDismissedThisSession = true;
      if (goSettings) {
        await ph.openAppSettings();
      }
    }
    // Regular Android "denied" (not Forever) — OS will re-prompt next
    // cold start automatically; no custom sheet needed here.
  }

  // ─────────────────────────────────────────────────────────────
  //  Side-effects after a successful grant
  //
  //  Wrapped in a rate-limit (5 min) so that re-mounts of the dashboard
  //  (logout/login, deep-link entry, lifecycle resume) don't re-fire
  //  the GPS hardware + network round-trips on every coordinator run.
  // ─────────────────────────────────────────────────────────────

  /// Fire-and-forget: refresh the in-memory GPS cache and PATCH the
  /// position to the server. `LocationService.push()` itself reads from
  /// the cached `LocationManager.position`, so this is a single GPS fix
  /// shared by both consumers.
  static Future<void> _runLocationSideEffect() async {
    if (await _withinInterval(_locSyncKey, _sideEffectInterval)) return;
    await _stampSync(_locSyncKey);
    try {
      // Warm the cache; LocationService.push() will reuse it.
      await Get.find<LocationManager>().getOrRefresh();
    } catch (_) {
      // LocationManager not registered yet — first launch race; safe to skip.
    }
    unawaited(LocationService.push());
  }

  /// Fire-and-forget: fetch a fresh FCM token. Rate-limited to once
  /// per [_sideEffectInterval]; Firebase's `onTokenRefresh` stream will
  /// still pick up rotations in between.
  static Future<void> _runNotificationSideEffect() async {
    if (await _withinInterval(_fcmSyncKey, _sideEffectInterval)) return;
    await _stampSync(_fcmSyncKey);
    unawaited(NotificationService.refreshToken());
  }

  // ─────────────────────────────────────────────────────────────
  //  Persistent rate-limit helpers (timestamp in SharedPreferences +
  //  window). Used only by the granted-path side effects so re-mounts
  //  and resumes don't re-fire GPS / network work on every coordinator
  //  run. Sheet display itself is gated by in-memory session flags
  //  (`_notifDismissedThisSession`, `_locDismissedThisSession`) so the
  //  primer shows again on next cold start.
  // ─────────────────────────────────────────────────────────────
  static Future<bool> _withinInterval(String key, Duration window) async {
    final storage = _storageOrNull();
    if (storage == null) return false;
    final last = storage.read<int>(key);
    if (last == null) return false;
    final at = DateTime.fromMillisecondsSinceEpoch(last);
    return DateTime.now().difference(at) < window;
  }

  static Future<void> _stampSync(String key) async {
    final storage = _storageOrNull();
    if (storage == null) return;
    await storage.write(key, DateTime.now().millisecondsSinceEpoch);
  }

  static StorageService? _storageOrNull() {
    try {
      return Get.find<StorageService>();
    } catch (_) {
      return null;
    }
  }
}
