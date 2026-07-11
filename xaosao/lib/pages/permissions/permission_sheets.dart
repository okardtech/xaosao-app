import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/widgets/app_button.dart';

// ═══════════════════════════════════════════════════════════════
//  permission_sheets.dart
//  Custom bottom sheet shown by [PermissionCoordinator] when a
//  permission is denied (either at first OS dialog or hard-denied
//  in Settings). The OS dialog is always tried first — this sheet
//  is the re-engagement / recovery path.
//
//  `show(...)` returns Future<bool> — true when the user taps the
//  primary CTA, false when they dismiss or tap "ປິດ".
// ═══════════════════════════════════════════════════════════════

class SettingsReminderSheet {
  SettingsReminderSheet._();

  static Future<bool> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    String primaryLabel = 'ໄປຫາການຕັ້ງຄ່າ',
    String secondaryLabel = 'ປິດ',
  }) async {
    HapticFeedback.lightImpact();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      isDismissible: true,
      enableDrag: true,
      builder: (_) => _SettingsCard(
        icon: icon,
        title: title,
        message: message,
        primaryLabel: primaryLabel,
        secondaryLabel: secondaryLabel,
      ),
    );
    return result ?? false;
  }
}

// ═══════════════════════════════════════════════════════════════
//  Internal — settings-reminder card
// ═══════════════════════════════════════════════════════════════
class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String primaryLabel;
  final String secondaryLabel;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.secondaryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 18.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Soft brand-primary icon disc
              Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.10),
                ),
                child: Icon(
                  icon,
                  size: 34.r,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 18.h),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
              SizedBox(height: 24.h),

              AppPrimaryButton(
                label: primaryLabel,
                onTap: () => Navigator.pop(context, true),
                gradient: const [AppColors.primary, AppColors.primary],
              ),
              SizedBox(height: 6.h),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 44.h),
                  ),
                  child: Text(
                    secondaryLabel,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
