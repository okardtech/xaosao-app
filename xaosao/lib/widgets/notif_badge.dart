import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/services/notification_service.dart';

class NotifBadge extends StatelessWidget {
  final Widget child;
  const NotifBadge({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = NotificationService.unreadCount.value;
      if (count == 0) return child;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              constraints: BoxConstraints(minWidth: 16.r, minHeight: 16.r),
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
