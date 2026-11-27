import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/app_color.dart';
import '../../l10n/app_localizations.dart';
import '../../models/call_models.dart';
import '../../repository/call_repo.dart';
import '../../services/android_call_ringer.dart';
import '../../services/call_service.dart';
import '../../services/call_sounds.dart';
import '../../utils/app_snackbar.dart';
import 'call_ui.dart';

class CallRoomArgs {
  final CallJoin join;
  final bool isCustomer;
  final String peerName;
  final String? peerPhoto;

  const CallRoomArgs({
    required this.join,
    required this.isCustomer,
    required this.peerName,
    this.peerPhoto,
  });
}

/// The in-call screen, for both sides.
///
/// Joins the LiveKit room straight away (the customer joins before the
/// model answers, as the backend expects), then shows what the server
/// says: ringing → connecting → active with a running clock and cost.
/// Every figure comes from `GET calls/:id`; nothing here decides money.
class CallRoomPage extends StatefulWidget {
  final CallRoomArgs args;
  const CallRoomPage({super.key, required this.args});

  @override
  State<CallRoomPage> createState() => _CallRoomPageState();
}

class _CallRoomPageState extends State<CallRoomPage> {
  final _repo = CallRepo();

  Room? _room;
  EventsListener<RoomEvent>? _listener;
  StreamSubscription<CallEvent>? _events;
  Timer? _poll;
  Timer? _tick;

  late String _status = widget.args.isCustomer ? 'ringing' : 'connecting';
  int _elapsed = 0;
  int _remaining = 0;
  int _spent = 0;
  int _commission = 0;
  bool _lowBalance = false;

  bool _micOn = true;
  late bool _speakerOn = widget.args.join.isVideo;
  late bool _camOn = widget.args.join.isVideo;
  CameraPosition _cameraPosition = CameraPosition.front;
  VideoTrack? _remoteVideo;
  LocalVideoTrack? _localVideo;

  bool _ending = false;
  bool _finished = false;
  int _reconnects = 0;

  String get _sessionId => widget.args.join.sessionId;
  bool get _isCustomer => widget.args.isCustomer;
  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    CallService.instance?.activeSessionId = _sessionId;
    _events = CallService.instance?.events
        .where((e) => e.sessionId == _sessionId)
        .listen(_onEvent);
    _poll = Timer.periodic(const Duration(seconds: 2), (_) => _refresh());
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _status != 'active') return;
      setState(() {
        _elapsed++;
        if (_remaining > 0) _remaining--;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    _syncRingback();
  }

  /// The customer hears a ringback tone while her phone rings, and it
  /// stops the moment she answers or the call ends.
  void _syncRingback() {
    if (_isCustomer && _status == 'ringing' && !_finished) {
      CallSounds.playRingback();
    } else {
      CallSounds.stop();
    }
  }

  @override
  void dispose() {
    CallSounds.stop();
    _poll?.cancel();
    _tick?.cancel();
    _events?.cancel();
    _listener?.dispose();
    _room?.disconnect();
    _room?.dispose();
    final service = CallService.instance;
    if (service?.activeSessionId == _sessionId) service?.activeSessionId = null;
    // Leaving without hanging up (the route was removed underneath us)
    // must not leave the customer's money held until the sweep notices.
    if (!_finished) _repo.hangup(_sessionId);
    AndroidCallRinger.end(_sessionId);
    super.dispose();
  }

  // ── Joining ──────────────────────────────────────────────────

  Future<void> _start() async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) {
      AppSnackbar.error(_l10n.callMicDenied);
      await _hangUp();
      return;
    }
    if (widget.args.join.isVideo) {
      final cam = await Permission.camera.request();
      if (!cam.isGranted && mounted) setState(() => _camOn = false);
    }
    await _connect(widget.args.join);
  }

  Future<void> _connect(CallJoin join) async {
    try {
      _listener?.dispose();
      await _room?.dispose();

      final room = Room(
        roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
      );
      _room = room;
      _listener = room.createListener()
        ..on<TrackSubscribedEvent>((e) {
          if (_status == 'ringing' && mounted) {
            setState(() => _status = 'connecting');
            _syncRingback();
          }
          if (e.track is VideoTrack && mounted) {
            setState(() => _remoteVideo = e.track as VideoTrack);
          }
        })
        ..on<TrackUnsubscribedEvent>((e) {
          if (e.track == _remoteVideo && mounted) {
            setState(() => _remoteVideo = null);
          }
        })
        ..on<RoomDisconnectedEvent>((_) {
          if (!_finished && !_ending) _reconnect();
        });

      await room.connect(join.serverUrl, join.token);
      if (_reconnects == 0) {
        AndroidCallRinger.showOngoing(
          sessionId: _sessionId,
          peerName: widget.args.peerName,
          isVideo: join.isVideo,
        );
      }
      final local = room.localParticipant;
      await local?.setMicrophoneEnabled(_micOn);
      if (widget.args.join.isVideo && _camOn) {
        await local?.setCameraEnabled(true);
        _localVideo = local?.videoTrackPublications.firstOrNull?.track;
      }
      await Hardware.instance.setSpeakerphoneOn(_speakerOn);
      if (mounted) setState(() {});
    } catch (_) {
      if (_finished || _ending) return;
      if (_reconnects < 3) {
        _reconnect();
      } else {
        AppSnackbar.error(_l10n.callConnectFailed);
        await _hangUp();
      }
    }
  }

  /// The backend ends a call after 30 seconds without a participant, so
  /// rejoin straight away with a fresh token rather than asking first.
  Future<void> _reconnect() async {
    if (_reconnects >= 3) return;
    _reconnects++;
    await Future.delayed(Duration(seconds: _reconnects));
    if (_finished || _ending) return;
    final res = await _repo.token(_sessionId);
    if (res.data != null) {
      await _connect(res.data!);
    } else {
      await _refresh(); // likely ended; the poll settles it
    }
  }

  // ── Server state ─────────────────────────────────────────────

  Future<void> _refresh() async {
    if (_finished) return;
    final res = await _repo.state(_sessionId);
    final s = res.data;
    if (s == null || !mounted || _finished) return;
    if (s.isEnded) {
      _finish(CallSummary.fromState(s));
      return;
    }
    setState(() {
      _status = s.status;
      _elapsed = s.elapsedSeconds;
      _remaining = s.remainingSeconds;
      _spent = s.spentSoFar;
      _commission = s.commissionRate;
    });
    _syncRingback();
  }

  void _onEvent(CallEvent e) {
    switch (e.type) {
      case 'call_answered':
        if (mounted && _status == 'ringing') {
          setState(() => _status = 'connecting');
          _syncRingback();
        }
        break;
      case 'call_low_balance':
        if (mounted) setState(() => _lowBalance = true);
        break;
      case 'call_ended':
        _finish(CallSummary.fromJson(e.data));
        break;
      case 'local_hangup':
        // Hang up from the "call in progress" notification.
        _hangUp();
        break;
    }
  }

  // ── Ending ───────────────────────────────────────────────────

  Future<void> _hangUp() async {
    if (_ending || _finished) return;
    setState(() => _ending = true);
    final res = await _repo.hangup(_sessionId);
    if (res.data != null) {
      _finish(res.data!);
      return;
    }
    // Already ended elsewhere ("This call has ended"): read how.
    final state = await _repo.state(_sessionId);
    _finish(state.data != null
        ? CallSummary.fromState(state.data!)
        : const CallSummary(
            billedMinutes: 0, billedAmount: 0, modelEarning: 0, refunded: 0));
  }

  Future<void> _finish(CallSummary summary) async {
    if (_finished) return;
    _finished = true;
    CallSounds.stop();
    AndroidCallRinger.end(_sessionId);
    _poll?.cancel();
    _tick?.cancel();
    try {
      await _room?.disconnect();
    } catch (_) {}
    if (!mounted) return;
    await CallUi.showSummary(context, summary: summary, isCustomer: _isCustomer);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _confirmHangUp() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_l10n.callEndConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(_l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(_l10n.callHangUp,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true) _hangUp();
  }

  // ── Controls ─────────────────────────────────────────────────

  Future<void> _toggleMic() async {
    CallSounds.toggleFeedback();
    setState(() => _micOn = !_micOn);
    await _room?.localParticipant?.setMicrophoneEnabled(_micOn);
  }

  Future<void> _toggleSpeaker() async {
    setState(() => _speakerOn = !_speakerOn);
    await Hardware.instance.setSpeakerphoneOn(_speakerOn);
  }

  Future<void> _toggleCamera() async {
    final next = !_camOn;
    if (next && !(await Permission.camera.request()).isGranted) return;
    setState(() {
      _camOn = next;
      if (next) _cameraPosition = CameraPosition.front;
    });
    final local = _room?.localParticipant;
    await local?.setCameraEnabled(next);
    if (mounted) {
      setState(() => _localVideo =
          next ? local?.videoTrackPublications.firstOrNull?.track : null);
    }
  }

  Future<void> _flipCamera() async {
    final track = _localVideo;
    if (track is! LocalVideoTrack) return;
    final next = _cameraPosition.switched();
    try {
      await track.setCameraPosition(next);
      if (mounted) setState(() => _cameraPosition = next);
    } catch (_) {}
  }

  // ── UI ───────────────────────────────────────────────────────

  String get _statusLine {
    switch (_status) {
      case 'ringing':
        return _l10n.callRinging;
      case 'connecting':
        return _l10n.callConnecting;
      case 'active':
        return CallUi.clock(_elapsed);
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = widget.args.join.isVideo;
    // A voice call can become video, so show her picture whenever she
    // sends one, whatever the call started as.
    final showRemoteVideo = _remoteVideo != null;
    final earning = _spent - (_spent * _commission / 100).round();

    return PopScope(
      canPop: _finished,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmHangUp();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: Stack(
          children: [
            if (showRemoteVideo)
              Positioned.fill(
                child: VideoTrackRenderer(
                  _remoteVideo!,
                  fit: VideoViewFit.cover,
                ),
              )
            else
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2D1B3D), Color(0xFF1A1A2E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            if (_localVideo != null && _camOn)
              Positioned(
                top: MediaQuery.of(context).padding.top + 12.h,
                right: 12.w,
                width: 100.w,
                height: 140.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: VideoTrackRenderer(
                    _localVideo!,
                    fit: VideoViewFit.cover,
                  ),
                ),
              ),
            SafeArea(
              child: showRemoteVideo
                  ? _videoOverlay(isVideo, earning)
                  : Column(
                      children: [
                        SizedBox(height: 60.h),
                        _avatar(),
                        SizedBox(height: 16.h),
                        Text(
                          widget.args.peerName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          _statusLine,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        SizedBox(height: 14.h),
                        if (_status == 'active') _meter(earning),
                        if (_isCustomer && _lowBalance) _lowBalanceBanner(),
                        const Spacer(),
                        _controls(isVideo),
                        SizedBox(height: 24.h),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// The layout over the other person's video: nothing in the middle of
  /// the picture. Name and timer sit top-left, clear of her own preview in
  /// the top-right corner, and the money is a small pill above the buttons.
  Widget _videoOverlay(bool isVideo, int earning) {
    const shadow = [Shadow(color: Colors.black54, blurRadius: 6)];
    return Column(
      children: [
        Padding(
          // Keep clear of the 100-wide self preview on the right.
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 124.w, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.args.peerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    shadows: shadow,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _statusLine,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    shadows: shadow,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        if (_status == 'active') _meterPill(earning),
        if (_isCustomer && _lowBalance) _lowBalanceBanner(),
        SizedBox(height: 14.h),
        _controls(isVideo),
        SizedBox(height: 24.h),
      ],
    );
  }

  /// The money and time left, small, for over a video picture.
  Widget _meterPill(int earning) {
    final label = _isCustomer ? _l10n.callCostSoFar : _l10n.callEarningSoFar;
    final value = _isCustomer ? _spent : earning;
    final left = _isCustomer && _remaining > 0
        ? ' · ${_l10n.callTimeLeft(CallUi.clock(_remaining))}'
        : '';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        '$label ${CallUi.kip(value)}$left',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  Widget _avatar() {
    final photo = widget.args.peerPhoto;
    return CircleAvatar(
      radius: 56.r,
      backgroundColor: Colors.white24,
      backgroundImage:
          photo != null && photo.isNotEmpty ? NetworkImage(photo) : null,
      child: photo == null || photo.isEmpty
          ? Icon(Icons.person, size: 56.r, color: Colors.white70)
          : null,
    );
  }

  Widget _meter(int earning) {
    final label = _isCustomer ? _l10n.callCostSoFar : _l10n.callEarningSoFar;
    final value = _isCustomer ? _spent : earning;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: Colors.white60, fontSize: 12.sp)),
                Text(CallUi.kip(value),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          if (_isCustomer && _remaining > 0)
            Text(_l10n.callTimeLeft(CallUi.clock(_remaining)),
                style: TextStyle(color: Colors.white60, fontSize: 12.sp)),
        ],
      ),
    );
  }

  Widget _lowBalanceBanner() => Container(
        margin: EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 0),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(_l10n.callLowBalance,
            textAlign: TextAlign.center,
            style:
                TextStyle(color: const Color(0xFFFCD34D), fontSize: 13.sp)),
      );

  Widget _controls(bool isVideo) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CallRoundButton(
              icon: _micOn ? Icons.mic : Icons.mic_off,
              label: _l10n.callMute,
              background: _micOn ? const Color(0x33FFFFFF) : Colors.white,
              foreground: _micOn ? Colors.white : AppColors.textPrimary,
              onTap: _toggleMic,
            ),
            CallRoundButton(
              icon: _speakerOn ? Icons.volume_up : Icons.volume_down,
              label: _l10n.callSpeaker,
              background: _speakerOn ? Colors.white : const Color(0x33FFFFFF),
              foreground: _speakerOn ? AppColors.textPrimary : Colors.white,
              onTap: _toggleSpeaker,
            ),
            // Always offered: a voice call can turn into a video call and
            // back, as on the website.
            CallRoundButton(
              icon: _camOn ? Icons.videocam : Icons.videocam_off,
              label: _l10n.callCamera,
              background: _camOn ? Colors.white : const Color(0x33FFFFFF),
              foreground: _camOn ? AppColors.textPrimary : Colors.white,
              onTap: _toggleCamera,
            ),
            if (_camOn)
              CallRoundButton(
                icon: Icons.cameraswitch,
                label: _l10n.callFlipCamera,
                onTap: _flipCamera,
              ),
          ],
        ),
        SizedBox(height: 24.h),
        CallRoundButton(
          icon: Icons.call_end,
          label: _l10n.callHangUp,
          background: const Color(0xFFEF4444),
          size: 70,
          onTap: _ending ? null : _hangUp,
        ),
      ],
    );
  }
}
