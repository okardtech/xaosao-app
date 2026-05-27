import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Color? iconBgColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.iconBgColor,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary;
    final bgColor =
        iconBgColor ?? AppColors.primary.withValues(alpha: 0.07);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36.r, color: color),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textHint,
                height: 1.5,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 22.h),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.pinkGradient,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    actionLabel!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
