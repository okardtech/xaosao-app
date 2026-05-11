import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

// ═══════════════════════════════════════════════════════════════
//  utils/app_button.dart
//
//  Widgets:
//    AppPrimaryButton  — gradient CTA
//    AppOutlineButton  — outline / secondary
// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
//  AppPrimaryButton
// ═══════════════════════════════════════════════════════════════
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;
  final List<Color> gradient;
  final double? height;
  final IconData? trailingIcon;
  final IconData? leadingIcon;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.loading = false,
    this.gradient = AppColors.pinkGradient,
    this.height,
    this.trailingIcon,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && !loading ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: (height ?? 48).h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: enabled
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient)
              : null,
          color: enabled ? null : const Color(0xFFE0E0E0),
          boxShadow: enabled
              ? [BoxShadow(
                  color: gradient.last.withOpacity(0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 5))]
              : null,
        ),
        child: Center(
          child: loading
              ? SizedBox(
                  width: 22.r, height: 22.r,
                  child: const CircularProgressIndicator(
                      strokeWidth: 2.5, color: Colors.white))
              : Row(mainAxisSize: MainAxisSize.min, children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: 14.r,
                        color: enabled ? Colors.white : const Color(0xFF9B9BAD)),
                    SizedBox(width: 6.w),
                  ],
                  Text(label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: enabled ? Colors.white : const Color(0xFF9B9BAD),
                      )),
                  if (trailingIcon != null) ...[
                    SizedBox(width: 6.w),
                    Icon(trailingIcon, size: 13.r,
                        color: enabled ? Colors.white : const Color(0xFF9B9BAD)),
                  ],
                ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  AppOutlineButton
// ═══════════════════════════════════════════════════════════════
class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? borderColor;
  final Color? textColor;
  final double? height;

  const AppOutlineButton({
    super.key,
    required this.label,
    required this.onTap,
    this.leadingIcon,
    this.trailingIcon,
    this.borderColor,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? const Color(0xFF1A1A2E);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: (height ?? 48).h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
              color: borderColor ?? Colors.black.withOpacity(0.12),
              width: 0.8),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 13.r, color: color),
            SizedBox(width: 5.w),
          ],
          Text(label,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: color)),
          if (trailingIcon != null) ...[
            SizedBox(width: 5.w),
            Icon(trailingIcon, size: 13.r, color: color),
          ],
        ]),
      ),
    );
  }
}