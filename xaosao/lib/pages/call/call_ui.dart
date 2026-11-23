import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_color.dart';
import '../../l10n/app_localizations.dart';
import '../../models/call_models.dart';
import '../../utils/currency_formatter.dart';

/// Shared text and widgets for the call screens.
class CallUi {
  /// Turn a backend refusal into something a person can act on. The
  /// backend's English messages are matched the same way the website does
  /// (xaosao-client `profile.call.tsx`), so both surfaces say the same thing.
  static String errorText(AppLocalizations l10n, String? message) {
    final m = message ?? '';
    if (m.contains('already on a call')) return l10n.callErrorAlreadyOnCall;
    if (m.contains('on another call')) return l10n.callErrorPeerBusy;
    if (m.contains('not online right now')) return l10n.callWentOffline;
    if (m.contains('Calling is not available')) {
      return l10n.callErrorServiceDown;
    }
    if (m.contains('not available')) return l10n.callErrorPeerUnavailable;
    if (m.contains('no longer ringing')) return l10n.callNoLongerRinging;
    if (m.contains('does not take calls')) return l10n.callNotAvailable;
    // "You need at least N LAK to start a call" is already specific.
    return m.isNotEmpty ? m : l10n.callConnectFailed;
  }

  /// One line on how the call ended, from the side reading it.
  static String endedText(
    AppLocalizations l10n,
    String? reason, {
    required bool isCustomer,
    required bool connected,
  }) {
    switch (reason) {
      case 'missed':
        return l10n.callNoAnswer;
      case 'declined':
        return l10n.callDeclined;
      case 'cancelled':
        return l10n.callCancelled;
      case 'no_funds':
        return l10n.callEndedNoFunds;
      case 'max_duration':
        return l10n.callEndedMaxDuration;
      case 'network':
        return l10n.callEndedNetwork;
    }
    if (!connected) {
      return isCustomer ? l10n.callNotConnected : l10n.callNotConnectedModel;
    }
    return l10n.callEnded;
  }

  static String clock(int seconds) {
    final s = seconds < 0 ? 0 : seconds;
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  static String kip(int amount) => '${CurrFormatter.format(amount)} ₭';

  /// The end-of-call sheet. Resolves when it is dismissed.
  static Future<void> showSummary(
    BuildContext context, {
    required CallSummary summary,
    required bool isCustomer,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final connected = summary.billedMinutes > 0 || summary.billedAmount > 0;
    final line = endedText(
      l10n,
      summary.reason,
      isCustomer: isCustomer,
      connected: connected,
    );

    Widget row(String label, String value, {Color? color}) => Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            children: [
              Text(label,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.textHint)),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: color ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );

    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.callEnded,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 6.h),
              Text(
                line,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
              ),
              SizedBox(height: 14.h),
              if (connected) ...[
                row(l10n.callDuration,
                    '${summary.billedMinutes} ${l10n.callMinutes}'),
                if (isCustomer) ...[
                  row(l10n.callCharged, kip(summary.billedAmount)),
                  if (summary.refunded > 0)
                    row(l10n.callReturned, kip(summary.refunded),
                        color: const Color(0xFF16A34A)),
                ] else
                  row(l10n.callYouEarned, kip(summary.modelEarning),
                      color: const Color(0xFF16A34A)),
              ] else if (isCustomer && summary.refunded > 0)
                row(l10n.callReturned, kip(summary.refunded),
                    color: const Color(0xFF16A34A)),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: Size.fromHeight(48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(l10n.callDone,
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A round button used on the call screens.
class CallRoundButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color background;
  final Color foreground;
  final double size;

  const CallRoundButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.background = const Color(0x33FFFFFF),
    this.foreground = Colors.white,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: background,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: size.r,
              height: size.r,
              child: Icon(icon, color: foreground, size: (size * 0.42).r),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(label,
            style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
      ],
    );
  }
}
