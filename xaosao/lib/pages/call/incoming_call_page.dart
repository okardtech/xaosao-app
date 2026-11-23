import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../l10n/app_localizations.dart';
import '../../models/call_models.dart';
import '../../repository/call_repo.dart';
import '../../services/android_call_ringer.dart';
import '../../services/call_service.dart';
import '../../services/call_sounds.dart';
import '../../utils/app_snackbar.dart';
import 'call_room_page.dart';
import 'call_ui.dart';

/// The model's "someone is calling" screen.
///
/// Closes itself when the ring runs out (45 s), when the customer gives
/// up (`call_ended`), or when she declines. Answering swaps it for the
/// in-call screen with her own room credentials.
class IncomingCallPage extends StatefulWidget {
  final IncomingCall call;
  const IncomingCallPage({super.key, required this.call});

  @override
  State<IncomingCallPage> createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {
  final _repo = CallRepo();
  Timer? _expiry;
  Timer? _buzz;
  StreamSubscription<CallEvent>? _events;
  bool _busy = false;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    _expiry = Timer(Duration(seconds: widget.call.expiresIn), _close);
    CallSounds.playRingtone();
    // Vibrate with the ring, the way a phone call does.
    _buzz = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      HapticFeedback.heavyImpact();
    });
    HapticFeedback.heavyImpact();
    _events = CallService.instance?.events
        .where((e) =>
            e.sessionId == widget.call.sessionId && e.type == 'call_ended')
        .listen((_) => _close());
  }

  @override
  void dispose() {
    CallSounds.stop();
    _expiry?.cancel();
    _buzz?.cancel();
    _events?.cancel();
    super.dispose();
  }

  void _close() {
    if (_closed || !mounted) return;
    _closed = true;
    _buzz?.cancel();
    CallSounds.stop();
    AndroidCallRinger.end(widget.call.sessionId);
    Navigator.of(context).pop();
  }

  Future<void> _decline() async {
    if (_busy) return;
    setState(() => _busy = true);
    await _repo.decline(widget.call.sessionId);
    _close();
  }

  Future<void> _answer() async {
    if (_busy) return;
    setState(() => _busy = true);
    _buzz?.cancel();
    await CallSounds.stop();
    AndroidCallRinger.end(widget.call.sessionId);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final res = await _repo.answer(widget.call.sessionId);
    if (!mounted) return;
    final join = res.data;
    if (join == null) {
      AppSnackbar.error(CallUi.errorText(l10n, res.message));
      _close();
      return;
    }
    _closed = true;
    _expiry?.cancel();
    Get.off(
      () => CallRoomPage(
        args: CallRoomArgs(
          join: join,
          isCustomer: false,
          peerName: _name(l10n),
        ),
      ),
      preventDuplicates: false,
    );
  }

  String _name(AppLocalizations l10n) => widget.call.callerName.isNotEmpty
      ? widget.call.callerName
      : l10n.callSomeone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final call = widget.call;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _decline();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B1F3F), Color(0xFF1A1A2E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 70.h),
                  Text(
                    l10n.callIncoming,
                    style: TextStyle(color: Colors.white70, fontSize: 15.sp),
                  ),
                  SizedBox(height: 24.h),
                  CircleAvatar(
                    radius: 56.r,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 56.r, color: Colors.white70),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    _name(l10n),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(call.isVideo ? Icons.videocam : Icons.call,
                          color: Colors.white60, size: 16.r),
                      SizedBox(width: 6.w),
                      Text(
                        '${call.isVideo ? l10n.callVideo : l10n.callVoice}'
                        '${call.ratePerMinute > 0 ? ' · ${CallUi.kip(call.ratePerMinute)} ${l10n.callPerMinute}' : ''}',
                        style:
                            TextStyle(color: Colors.white60, fontSize: 14.sp),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CallRoundButton(
                        icon: Icons.call_end,
                        label: l10n.callDecline,
                        background: const Color(0xFFEF4444),
                        size: 70,
                        onTap: _busy ? null : _decline,
                      ),
                      CallRoundButton(
                        icon: call.isVideo ? Icons.videocam : Icons.call,
                        label: l10n.callAnswer,
                        background: const Color(0xFF22C55E),
                        size: 70,
                        onTap: _busy ? null : _answer,
                      ),
                    ],
                  ),
                  SizedBox(height: 48.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
