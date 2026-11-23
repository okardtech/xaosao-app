import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/checkin_model.dart';
import 'package:xaosao/pages/checkin/getx/checkin_logic.dart';
import 'package:xaosao/pages/checkin/getx/checkin_state.dart';
import 'package:xaosao/utils/currency_formatter.dart';

/// Daily check-in.
///
/// One tap a day pays the model whatever an admin set for that weekday.
/// The strip shows the week so far: ticked days are taken, today is
/// live, past days without a tick are gone. The countdown runs to the
/// next Lao midnight, which is when the next check-in opens.
///
/// Every rule is enforced in xs_backend. Nothing here decides whether a
/// claim is allowed — it only draws what the server says, and a phone
/// with a wrong clock shows a wrong countdown but still cannot claim
/// early.
///
/// Mirrors xaosao-client's `CheckinCard` so a model sees the same thing
/// on the website and in the app.
class CheckinCard extends StatelessWidget {
  const CheckinCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final logic = Get.put(CheckinLogic(), permanent: false);

    return Obx(() {
      final state = logic.state;
      final info = state.info;

      // Customers have no check-in, and a model with nothing configured
      // should see nothing rather than an empty promise of a reward.
      if (!logic.isModel || info == null || info.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        // No horizontal margin: this sits inside the profile's own
        // 16.w padding, and padding it again would inset it from
        // everything around it.
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFF1F1F5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(l10n, info),
            _summary(l10n, info),
            _strip(l10n, info),
            _action(context, l10n, logic, state, info),
          ],
        ),
      );
    });
  }

  // ── Title and streak ──────────────────────────────────────────
  Widget _header(AppLocalizations l10n, CheckinInfo info) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 11.h, 14.w, 11.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.checkinTitle,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                size: 16.sp,
                color: const Color(0xFFF59E0B),
              ),
              SizedBox(width: 3.w),
              Text(
                l10n.checkinStreak(info.streak),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Countdown and today's amount ──────────────────────────────
  Widget _summary(AppLocalizations l10n, CheckinInfo info) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F5))),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _CountdownColumn(
                targetMs: info.nextAtMs,
                label: l10n.checkinNextIn,
                hint: l10n.checkinNextHint,
              ),
            ),
            const VerticalDivider(width: 1, color: Color(0xFFF1F1F5)),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                child: Column(
                  children: [
                    Text(
                      l10n.checkinTodayPays,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text.rich(
                      TextSpan(
                        text: CurrFormatter.format(info.todayAmount),
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        children: [
                          TextSpan(
                            text: ' ₭',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      l10n.checkinTodayHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── The week ──────────────────────────────────────────────────
  Widget _strip(AppLocalizations l10n, CheckinInfo info) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 11.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: info.days
            .map((day) => Expanded(child: _DayCell(day: day, l10n: l10n)))
            .toList(),
      ),
    );
  }

  // ── Claim, or why not ─────────────────────────────────────────
  Widget _action(
    BuildContext context,
    AppLocalizations l10n,
    CheckinLogic logic,
    CheckinPageState state,
    CheckinInfo info,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
      child: Column(
        children: [
          if (info.canClaim)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: state.claiming ? null : logic.claim,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.6,
                  ),
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 11.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                ),
                icon: state.claiming
                    ? SizedBox(
                        width: 15.sp,
                        height: 15.sp,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Icon(Icons.card_giftcard_rounded, size: 17.sp),
                label: Text(
                  l10n.checkinClaim(CurrFormatter.format(info.todayAmount)),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FC),
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: Text(
                // Three different reasons, and a model deserves to know
                // which one: already taken, all gone, or not a payday.
                info.alreadyClaimed
                    ? l10n.checkinDoneToday
                    : info.capReached
                    ? l10n.checkinFinished
                    : l10n.checkinClosedToday,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          if (state.justClaimed != null) ...[
            SizedBox(height: 7.h),
            Text(
              l10n.checkinClaimed(
                CurrFormatter.format(state.justClaimed!.amount),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF059669),
              ),
            ),
          ],
          if (state.error != null) ...[
            SizedBox(height: 7.h),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.sp, color: Colors.red.shade600),
            ),
          ],
        ],
      ),
    );
  }
}

/// One day of the week: ticked, live, missed or still to come.
class _DayCell extends StatelessWidget {
  final CheckinDay day;
  final AppLocalizations l10n;

  const _DayCell({required this.day, required this.l10n});

  String get _label {
    switch (day.weekday) {
      case 1:
        return l10n.checkinMon;
      case 2:
        return l10n.checkinTue;
      case 3:
        return l10n.checkinWed;
      case 4:
        return l10n.checkinThu;
      case 5:
        return l10n.checkinFri;
      case 6:
        return l10n.checkinSat;
      default:
        return l10n.checkinSun;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isToday = day.status == CheckinDayStatus.today;
    final isClaimed = day.status == CheckinDayStatus.claimed;

    return Column(
      children: [
        Container(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isClaimed
                ? const Color(0xFFFBBF24)
                : isToday
                ? Colors.white
                : const Color(0xFFF3F4F6),
            border: isToday
                ? Border.all(color: const Color(0xFFFBBF24), width: 2)
                : null,
          ),
          child: Icon(
            isClaimed ? Icons.check_rounded : Icons.card_giftcard_rounded,
            size: 16.sp,
            color: isClaimed
                ? Colors.white
                : isToday
                ? const Color(0xFFF59E0B)
                : day.status == CheckinDayStatus.missed
                ? const Color(0xFFD1D5DB)
                : const Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          _label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
            color: isToday
                ? const Color(0xFFF59E0B)
                : AppColors.textSecondary,
          ),
        ),
        if (day.amount > 0)
          Text(
            CurrFormatter.format(day.amount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8.sp,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
          ),
      ],
    );
  }
}

/// Time left until [targetMs], as HH:MM:SS.
///
/// Its own widget so the per-second rebuild stays inside it rather than
/// redrawing the whole card once a second.
class _CountdownColumn extends StatefulWidget {
  final int targetMs;
  final String label;
  final String hint;

  const _CountdownColumn({
    required this.targetMs,
    required this.label,
    required this.hint,
  });

  @override
  State<_CountdownColumn> createState() => _CountdownColumnState();
}

class _CountdownColumnState extends State<_CountdownColumn> {
  Timer? _timer;
  String _left = '--:--:--';

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void didUpdateWidget(covariant _CountdownColumn old) {
    super.didUpdateWidget(old);
    if (old.targetMs != widget.targetMs) _tick();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (!mounted) return;
    final target = widget.targetMs;
    if (target <= 0) {
      setState(() => _left = '--:--:--');
      return;
    }
    final ms = target - DateTime.now().millisecondsSinceEpoch;
    final left = ms < 0 ? 0 : ms;
    final h = left ~/ 3600000;
    final m = (left % 3600000) ~/ 60000;
    final s = (left % 60000) ~/ 1000;
    final text = [
      h,
      m,
      s,
    ].map((n) => n.toString().padLeft(2, '0')).join(':');
    if (text != _left) setState(() => _left = text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      child: Column(
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _left,
            style: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF59E0B),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            widget.hint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
