import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/booking/booking_args.dart';
import 'package:xaosao/pages/booking/components/per_day_form.dart';
import 'package:xaosao/pages/booking/components/per_hour_form.dart';
import 'package:xaosao/pages/booking/getx/booking_logic.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

// ═══════════════════════════════════════════════════════════════
//  BookingPage — creates GetX logic + routes to correct form
// ═══════════════════════════════════════════════════════════════
class BookingPage extends StatefulWidget {
  final BookingArgs args;
  const BookingPage({super.key, required this.args});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late final BookingLogic _logic;

  String get _tag => widget.args.service.id ?? "";

  @override
  void initState() {
    super.initState();
    _logic = Get.put(BookingLogic(args: widget.args), tag: _tag);
  }

  @override
  void dispose() {
    Get.delete<BookingLogic>(tag: _tag, force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDay =
        widget.args.service.billingType == 'per_day' ||
        widget.args.service.billingType == 'per_night';
    if (isDay)
      return PerDayForm(logic: _logic, modelName: widget.args.companionName);
    return PerHourForm(logic: _logic,modelName: widget.args.companionName,);
  }
}

// ═══════════════════════════════════════════════════════════════
//  Shared UI components
// ═══════════════════════════════════════════════════════════════

// ── App bar ───────────────────────────────────────────────────
PreferredSizeWidget bookingAppBar(BookingLogic logic) {
  return GradientAppBar(
    title: logic.args.service.name ?? "no name",
    subtitle: logic.args.companionName,
  );
}

// ── Picker box (white only, thin border) ─────────────────────
class BookingPickerBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;
  final bool showInternalLabel;

  const BookingPickerBox({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.showInternalLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: filled
                ? AppColors.primary.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: showInternalLabel
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: 12.r,
                        color: filled ? AppColors.primary : AppColors.textHint,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: filled
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    filled ? value! : placeholder,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: filled
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Icon(
                    icon,
                    size: 15.r,
                    color: filled ? AppColors.primary : AppColors.textHint,
                  ),
                  SizedBox(width: 7.w),
                  Text(
                    filled ? value! : placeholder,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: filled
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Section mini label ────────────────────────────────────────
class BookingSectionLabel extends StatelessWidget {
  final String text;
  const BookingSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textHint,
        letterSpacing: 0.6,
      ),
    );
  }
}

// ── Card divider ──────────────────────────────────────────────
class BookingDivider extends StatelessWidget {
  const BookingDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.black.withValues(alpha: 0.06),
      height: 1,
      thickness: 1,
    );
  }
}

// ── Summary rows ──────────────────────────────────────────────
class BookingSummary extends StatelessWidget {
  final String rateLabel;
  final String rateValue;
  final String countLabel;
  final String countValue;
  final double total;

  const BookingSummary({
    super.key,
    required this.rateLabel,
    required this.rateValue,
    required this.countLabel,
    required this.countValue,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(rateLabel, rateValue),
        SizedBox(height: 8.h),
        _row(countLabel, countValue),
        SizedBox(height: 14.h),
        const BookingDivider(),
        SizedBox(height: 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ລວມທັງໝົດ',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              CurrFormatter.kip(total),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _row(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    ],
  );
}

// ── Bottom action bar ─────────────────────────────────────────
class BookingBottomBar extends StatelessWidget {
  final bool canBook;
  final VoidCallback onBook;

  const BookingBottomBar({
    super.key,
    required this.canBook,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: AppPrimaryButton(
        label: 'ຈອງດຽວນີ້',
        trailingIcon: Icons.check_rounded,
        enabled: canBook,
        onTap: onBook,
      ),
    );
  }
}
