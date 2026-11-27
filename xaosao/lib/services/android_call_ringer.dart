import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';
import '../models/call_models.dart';

/// Runs when the model taps a button on the Android ringing screen while
/// the app is not running (the plugin starts a bare engine for it). With
/// the app open, CallService handles the same buttons instead.
///
/// Only Decline needs work here: Accept opens the app, which answers.
/// Without this, a Decline on a closed phone told the server nothing, and
/// the customer kept hearing "calling" until the ring ran out.
@pragma('vm:entry-point')
Future<void> androidRingerBackgroundHandler(CallEvent event) async {
  if (event is CallEventActionCallDecline) {
    final id = event.callKitParams.id;
    if (await AndroidCallRinger.consumeEndedByApp(id)) return;
    await AndroidCallRinger.declineWithoutApp(id);
  }
}

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

  /// Register [androidRingerBackgroundHandler]. Call once at startup; the
  /// plugin remembers it, so it also works after the app is closed.
  static Future<void> registerBackgroundHandler() async {
    if (!Platform.isAndroid) return;
    try {
      await FlutterCallkitIncoming.onBackgroundMessage(
        androidRingerBackgroundHandler,
      );
    } catch (_) {}
  }

  /// Tell the server she declined, using the login saved on the phone.
  /// Plain Dio, no GetX: this runs where the app is not running.
  static Future<void> declineWithoutApp(String sessionId) async {
    if (sessionId.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty || prefs.getString('role') != 'model') return;
      await Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      )).post(ApiConstants.callDecline(sessionId), data: <String, dynamic>{});
    } catch (_) {
      // The call times out as missed on its own; nothing more to do.
    }
  }

  /// Sessions whose ringer or ongoing notification the app itself took
  /// down. The plugin reports that as if she had pressed Decline (or Hang
  /// up), so without this the app would decline a call she was answering
  /// on the in-app screen.
  static final Set<String> _endedByApp = {};

  /// True (once) if this ringer event was caused by [end], not by her.
  static bool wasEndedByApp(String sessionId) => _endedByApp.remove(sessionId);

  /// Same as [wasEndedByApp], for code running outside the app (the
  /// background push handler), which cannot see the app's memory: [end]
  /// also writes the mark to SharedPreferences.
  static const _endedByAppKey = 'ringer_ended_by_app';

  static Future<bool> consumeEndedByApp(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final ids = prefs.getStringList(_endedByAppKey) ?? const <String>[];
      if (!ids.contains(sessionId)) return false;
      await prefs.setStringList(
        _endedByAppKey,
        ids.where((i) => i != sessionId).toList(),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Stop ringing / remove the call notification for this session.
  static Future<void> end(String sessionId) async {
    if (!Platform.isAndroid) return;
    try {
      final active = await FlutterCallkitIncoming.activeCalls();
      if (!active.any((c) => c.id == sessionId)) return;
      _endedByApp.add(sessionId);
      // Written before the ringer goes, so whoever hears the resulting
      // "Decline" can tell it was not her.
      final prefs = await SharedPreferences.getInstance();
      final ids = [
        ...(prefs.getStringList(_endedByAppKey) ?? const <String>[]),
        sessionId,
      ];
      await prefs.setStringList(
        _endedByAppKey,
        ids.length > 20 ? ids.sublist(ids.length - 20) : ids,
      );
      await FlutterCallkitIncoming.endCall(sessionId);
    } catch (_) {}
  }

  /// Wait, where the ringer was raised, for what she does with it, and
  /// tell the server if she declines.
  ///
  /// When the phone woke the app just to ring (app closed), nothing else
  /// is running to hear the Decline button: the app's own listener is not
  /// there, and the plugin's background handler only exists if the app
  /// was started normally. So the push handler stays up for the ring and
  /// listens itself. Ends on Accept (the app opens and answers), on the
  /// ring timing out, or after the ring time.
  static Future<void> watchRing(IncomingCall call) async {
    if (!Platform.isAndroid) return;
    final done = Completer<void>();
    StreamSubscription<CallEvent?>? sub;
    sub = FlutterCallkitIncoming.onEvent.listen((event) async {
      if (event == null || done.isCompleted) return;
      String? id;
      if (event is CallEventActionCallDecline) {
        id = event.callKitParams.id;
        if (id == call.sessionId &&
            !await consumeEndedByApp(call.sessionId)) {
          await declineWithoutApp(call.sessionId);
        }
      } else if (event is CallEventActionCallAccept) {
        id = event.callKitParams.id;
      } else if (event is CallEventActionCallTimeout) {
        id = event.id;
      } else if (event is CallEventActionCallEnded) {
        id = event.callKitParams.id;
      }
      if (id == call.sessionId && !done.isCompleted) done.complete();
    });
    await done.future
        .timeout(Duration(seconds: call.expiresIn + 5), onTimeout: () {});
    await sub.cancel();
  }

  /// The "call in progress" notification, like WhatsApp's: it stays while
  /// the call lasts, tapping it returns to the call, and its button hangs
  /// up. It is a foreground service for the microphone and camera too, so
  /// Android keeps the call's audio going while the app is in the
  /// background.
  static Future<void> showOngoing({
    required String sessionId,
    required String peerName,
    required bool isVideo,
  }) async {
    if (!Platform.isAndroid) return;
    try {
      await FlutterCallkitIncoming.startCall(
        CallKitParams(
          id: sessionId,
          nameCaller: peerName.isNotEmpty ? peerName : 'Xaosao',
          appName: 'Xaosao',
          handle: isVideo ? 'ສາຍວິດີໂອ' : 'ສາຍໂທ',
          type: isVideo ? 1 : 0,
          extra: <String, dynamic>{'session_id': sessionId},
          callingNotification: const NotificationParams(
            showNotification: true,
            isShowCallback: true,
            subtitle: 'ກຳລັງໂທ · ແຕະເພື່ອກັບໄປ',
            callbackText: 'ວາງສາຍ',
          ),
          android: const AndroidParams(
            isCustomNotification: false,
            isShowLogo: false,
            backgroundColor: '#1A1A2E',
            actionColor: '#EF4444',
            textColor: '#FFFFFF',
            incomingCallNotificationChannelName: 'Incoming calls',
            missedCallNotificationChannelName: 'Missed calls',
          ),
        ),
      );
      await FlutterCallkitIncoming.setCallConnected(sessionId);
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
