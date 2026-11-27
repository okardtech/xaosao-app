import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart' as ck;
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/call_models.dart';
import '../pages/call/call_room_page.dart';
import '../pages/call/incoming_call_page.dart';
import '../repository/call_repo.dart';
import '../utils/app_snackbar.dart';
import 'android_call_ringer.dart';
import 'chat_socket_service.dart';
import 'notification_service.dart';
import 'storage_service.dart';

/// A call event the backend pushed over the socket.
class CallEvent {
  /// call_answered | call_ended | call_low_balance
  final String type;
  final String sessionId;
  final Map<String, dynamic> data;

  const CallEvent(this.type, this.sessionId, this.data);
}

/// App-wide coordinator for per-minute calls.
///
/// A model is rung over up to three channels — the `incoming_call` socket
/// event, a push with the same payload, and (Android, app closed) the
/// full-screen ringing call the push raises. This service is where they
/// meet, so one ring opens one answer screen however many copies arrive.
///
/// It also relays `call_answered`, `call_ended` and `call_low_balance` to
/// whichever call screen is open, via [events].
class CallService extends GetxService with WidgetsBindingObserver {
  static CallService? get instance =>
      Get.isRegistered<CallService>() ? Get.find<CallService>() : null;

  // Lazy: this service is created at startup, before ApiService (which
  // the repo looks up) has finished registering. Building the repo here
  // would throw and stop the app from starting.
  late final _repo = CallRepo();
  final _events = StreamController<CallEvent>.broadcast();
  Stream<CallEvent> get events => _events.stream;
  StreamSubscription<ck.CallEvent?>? _ringerEvents;

  /// The session a call screen is showing, so a second ring for another
  /// call does not stack a screen on top of a live one.
  String? activeSessionId;

  /// Sessions already shown, so the copies of one ring open one screen.
  final Set<String> _shownRings = {};

  /// A ring that arrived while the app was in the background, kept so it
  /// can still be answered in the app when she comes back to it within
  /// the ring time, rather than being lost.
  IncomingCall? _pendingRing;
  DateTime? _pendingUntil;

  @override
  void onInit() {
    super.onInit();
    ChatSocketService.addHandler('incoming_call', _onIncomingSocket);
    for (final type in const [
      'call_answered',
      'call_ended',
      'call_low_balance',
    ]) {
      ChatSocketService.addHandler(type, (data) => _relay(type, data));
    }
    if (Platform.isAndroid) {
      _ringerEvents = FlutterCallkitIncoming.onEvent.listen(_handleRinger);
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _showPendingRing();
  }

  /// She came back to the app: if a call rang while she was away and is
  /// still ringing, show it now.
  Future<void> _showPendingRing() async {
    final call = _pendingRing;
    final until = _pendingUntil;
    _pendingRing = null;
    _pendingUntil = null;
    if (call == null || until == null || DateTime.now().isAfter(until)) return;
    if (_shownRings.contains(call.sessionId)) return;
    final res = await _repo.state(call.sessionId);
    if (res.data?.status != 'ringing') return;
    // The in-app screen rings now; drop the system ringer for this call
    // so the phone does not ring twice.
    await AndroidCallRinger.end(call.sessionId);
    _showIncoming(call);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    ChatSocketService.removeHandler('incoming_call', _onIncomingSocket);
    _ringerEvents?.cancel();
    _events.close();
    super.onClose();
  }

  bool get _isModel =>
      Get.find<StorageService>().read<String>('role') == 'model';

  void _relay(String type, dynamic data) {
    if (data is! Map) return;
    final map = Map<String, dynamic>.from(data);
    final id = map['session_id']?.toString() ?? '';
    if (id.isEmpty) return;
    // The customer gave up or the ring ran out: stop the Android ringer
    // too, if it is up for this call.
    if (type == 'call_ended') AndroidCallRinger.end(id);
    _events.add(CallEvent(type, id, map));
  }

  void _onIncomingSocket(dynamic data) {
    final call = IncomingCall.tryParse(data);
    if (call != null) _showIncoming(call);
  }

  /// A push (foreground, or tapped from the tray). It may be stale — the
  /// model can tap a notification long after the 45-second ring ended —
  /// so confirm it is still ringing before opening an answer screen.
  Future<void> handlePush(Map<String, dynamic> data) async {
    final call = IncomingCall.tryParse(data);
    if (call == null) return;
    if (_shownRings.contains(call.sessionId)) return;
    final res = await _repo.state(call.sessionId);
    if (res.data?.status != 'ringing') return;
    _showIncoming(call);
  }

  void _showIncoming(IncomingCall call) {
    if (!_isModel) return;
    if (_shownRings.contains(call.sessionId)) return;
    if (activeSessionId != null) return; // already on a call
    // In the background the full-screen Android ringer (raised by the
    // push) is the ring; opening a page behind it would ring twice. Keep
    // the call, though, and show it if she returns while it still rings.
    //
    // `inactive` is NOT background: it is the app still on screen under
    // a system dialog (a permission prompt, the notification shade). A
    // ring then must open the answer screen like any other time.
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle == AppLifecycleState.paused ||
        lifecycle == AppLifecycleState.hidden ||
        lifecycle == AppLifecycleState.detached) {
      _pendingRing = call;
      _pendingUntil = DateTime.now().add(Duration(seconds: call.expiresIn));
      return;
    }
    _shownRings.add(call.sessionId);
    Get.to(
      () => IncomingCallPage(call: call),
      fullscreenDialog: true,
      preventDuplicates: false,
    );
  }

  // ── Android full-screen ringer ──────────────────────────────────

  /// Accept / Decline on the Android ringing screen while the app is alive.
  void _handleRinger(ck.CallEvent? event) {
    if (event is ck.CallEventActionCallAccept) {
      final call = _fromParams(event.callKitParams);
      if (call != null) answerFromRinger(call);
    } else if (event is ck.CallEventActionCallDecline) {
      final id = event.callKitParams.id;
      // The app taking its own ringer down reads as a Decline; only a
      // real press should decline.
      if (AndroidCallRinger.wasEndedByApp(id)) return;
      _repo.decline(id);
    } else if (event is ck.CallEventActionCallEnded) {
      final id = event.callKitParams.id;
      if (AndroidCallRinger.wasEndedByApp(id)) return;
      // Hang up pressed on the "call in progress" notification.
      _events.add(CallEvent('local_hangup', id, const {}));
    }
  }

  IncomingCall? _fromParams(ck.CallKitParams p) => IncomingCall.tryParse(
        p.extra ?? <String, dynamic>{'session_id': p.id},
      );

  /// The model accepted on the ringing screen: answer and join.
  Future<void> answerFromRinger(IncomingCall call) async {
    if (activeSessionId != null) return;
    _shownRings.add(call.sessionId);
    final res = await _repo.answer(call.sessionId);
    await AndroidCallRinger.end(call.sessionId);
    final join = res.data;
    if (join == null) {
      AppSnackbar.error(res.laMessage ?? res.message ?? '');
      return;
    }
    Get.to(
      () => CallRoomPage(
        args: CallRoomArgs(
          join: join,
          isCustomer: false,
          peerName: call.callerName,
        ),
      ),
      fullscreenDialog: true,
      preventDuplicates: false,
    );
  }

  /// Tell the model what happened to the last call push that reached this
  /// phone while the app was closed. It answers the question a missed
  /// call leaves open — did the phone get the call at all?
  Future<void> _reportLastRing() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final raw = prefs.getString(NotificationService.lastCallPushKey);
    if (raw == null) return;
    await prefs.remove(NotificationService.lastCallPushKey);
    final cut = raw.indexOf('|');
    if (cut < 0) return;
    final at = DateTime.tryParse(raw.substring(0, cut));
    if (at == null || DateTime.now().difference(at).inHours >= 12) return;
    final outcome = raw.substring(cut + 1);
    final time = '${at.hour.toString().padLeft(2, '0')}:'
        '${at.minute.toString().padLeft(2, '0')}';
    if (outcome == 'shown') {
      AppSnackbar.info('ສາຍເຂົ້າ $time: ໂທລະສັບໄດ້ຮັບ ແລະ ສະແດງໜ້າຈໍຮັບສາຍແລ້ວ');
    } else {
      AppSnackbar.error(
        'ສາຍເຂົ້າ $time: ໄດ້ຮັບແຕ່ສະແດງບໍ່ໄດ້ ($outcome)',
        title: 'ຮັບສາຍບໍ່ໄດ້',
      );
    }
  }

  Future<void> _registerForCalls() async {
    final ok = await NotificationService.syncTokenToServer(force: true);
    if (ok) return;
    final reason = NotificationService.lastSyncError ?? 'unknown';
    AppSnackbar.error(
      'ໂທລະສັບນີ້ຍັງບໍ່ໄດ້ລົງທະບຽນຮັບສາຍ ($reason)',
      title: 'ຮັບສາຍບໍ່ໄດ້',
    );
  }

  /// Called once the model's dashboard is up: answers a call she accepted
  /// from the ringing screen while the app was closed, and asks (once) for
  /// the Android 14 full-screen permission the ringer needs.
  Future<void> onModelHome() async {
    if (!_isModel || !Platform.isAndroid) return;
    // Her registered phone is what lets customers call her directly and
    // ring it while the app is closed: make sure the server has it, and
    // say so if it could not, since otherwise nothing shows that her
    // phone will never ring.
    unawaited(_registerForCalls());
    unawaited(_reportLastRing());
    final accepted = await AndroidCallRinger.acceptedWhileClosed();
    if (accepted != null) {
      await answerFromRinger(accepted);
      return;
    }
    final storage = Get.find<StorageService>();
    if (storage.read<bool>('asked_full_screen_call') != true) {
      await storage.write('asked_full_screen_call', true);
      await AndroidCallRinger.ensureFullScreenPermission();
    }
  }
}
