import 'dart:io';

import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '../models/call_models.dart';

/// The full-screen ringing call on Android, for when the app is closed or
/// in the background.
///
/// The backend sends an Android incoming call as a data-only push; the
/// app's background message handler calls [show] (it runs in a background
/// isolate, so nothing here may depend on GetX or app state). Accepting it
/// opens the app, and CallService answers the call.
///
/// iOS is not handled here: ringing a closed iPhone needs VoIP push and
/// CallKit, which the backend does not send yet.
class AndroidCallRinger {
  AndroidCallRinger._();

  static Future<void> show(Map<String, dynamic> data) async {
    if (!Platform.isAndroid) return;
    final call = IncomingCall.tryParse(data);
    if (call == null) return;

    final name = call.callerName.isNotEmpty ? call.callerName : 'Xaosao';
    await FlutterCallkitIncoming.showCallkitIncoming(
      CallKitParams(
        id: call.sessionId,
        nameCaller: name,
        appName: 'Xaosao',
        handle: call.isVideo ? 'ສາຍວິດີໂອ' : 'ສາຍໂທ',
        type: call.isVideo ? 1 : 0,
        // Ring only as long as the backend keeps the call ringing.
        duration: call.expiresIn * 1000,
        extra: Map<String, dynamic>.from(data),
        missedCallNotification: const NotificationParams(
          showNotification: true,
          isShowCallback: false,
          subtitle: 'ສາຍທີ່ບໍ່ໄດ້ຮັບ',
        ),
        android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#1A1A2E',
          actionColor: '#22C55E',
          textColor: '#FFFFFF',
          incomingCallNotificationChannelName: 'Incoming calls',
          missedCallNotificationChannelName: 'Missed calls',
          isShowFullLockedScreen: true,
          textAccept: 'ຮັບສາຍ',
          textDecline: 'ປະຕິເສດ',
        ),
      ),
    );
  }

  /// Stop ringing / remove the call notification for this session.
  static Future<void> end(String sessionId) async {
    if (!Platform.isAndroid) return;
    try {
      await FlutterCallkitIncoming.endCall(sessionId);
    } catch (_) {}
  }

  /// A call the model accepted from the ringing screen while the app was
  /// not running. The plugin remembers it; the app answers it on launch.
  static Future<IncomingCall?> acceptedWhileClosed() async {
    if (!Platform.isAndroid) return null;
    try {
      final calls = await FlutterCallkitIncoming.activeCalls();
      for (final c in calls) {
        if (c.isAccepted) {
          final parsed = IncomingCall.tryParse(
            c.extra ?? <String, dynamic>{'session_id': c.id},
          );
          if (parsed != null) return parsed;
        }
      }
    } catch (_) {}
    return null;
  }

  /// Android 14+ only lets an app show a full-screen ring if the user
  /// allowed it. Asked once, for models, who are the ones being rung.
  static Future<void> ensureFullScreenPermission() async {
    if (!Platform.isAndroid) return;
    try {
      if (!await FlutterCallkitIncoming.canUseFullScreenIntent()) {
        await FlutterCallkitIncoming.requestFullIntentPermission();
      }
    } catch (_) {}
  }
}
