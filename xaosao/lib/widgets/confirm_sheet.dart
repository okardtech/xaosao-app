import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/widgets/app_button.dart';

class ConfirmSheet {
  ConfirmSheet._();

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    IconData icon = Icons.help_outline_rounded,
    Color? iconColor,
    bool isDanger = false,
    String cancelLabel = 'ຍົກເລີກ',
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => _ConfirmSheetContent(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        icon: icon,
        iconColor:
            iconColor ??
            (isDanger ? const Color(0xFFDC2626) : AppColors.primary),
        isDanger: isDanger,
        cancelLabel: cancelLabel,
      ),
    );
  }
}

class _ConfirmSheetContent extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final IconData icon;
  final Color iconColor;
  final bool isDanger;
  final String cancelLabel;

  const _ConfirmSheetContent({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.icon,
    required this.iconColor,
    required this.isDanger,
    required this.cancelLabel,
  });

  static const _dangerGradient = [Color(0xFFEF4444), Color(0xFFDC2626)];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.10),
              ),
              child: Icon(icon, size: 30.r, color: iconColor),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF6B7280),
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 28.h),
            Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    label: cancelLabel,
                    onTap: () => Navigator.pop(context, false),
                  ),
                ),
                SizedBox(width: 10.h),
                Expanded(
                  child: AppPrimaryButton(
                    label: confirmLabel,
                    onTap: () => Navigator.pop(context, true),
                    gradient: isDanger
                        ? _dangerGradient
                        : AppColors.pinkGradient,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
