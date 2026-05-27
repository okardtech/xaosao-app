import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GradientAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.actions = const [],
    this.expandedHeight = 80.0,
    this.showBack = true,
    this.centerTitle = false,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;

  /// Optional action widgets shown on the right side (e.g. IconButton)
  final List<Widget> actions;

  final double expandedHeight;
  final bool showBack;
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(expandedHeight.h);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final double topPad = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: expandedHeight.h + topPad,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // ── 1. Gradient background ────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.pinkGradient, // [secondary, primary]
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),

          // ── 2. Circle ຂວາເທິງ (ໃຫຍ່) ─────────────────────────────────
          Positioned(
            top: -40.r,
            right: -40.r,
            child: Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),

          // ── 3. Circle ຊ້າຍລຸ່ມ (ນ້ອຍ) ────────────────────────────────
          Positioned(
            bottom: -30.r,
            left: -30.r,
            child: Container(
              width: 110.r,
              height: 110.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
          ),

          // ── 4. Back button + Title + Subtitle + Actions ───────────────
          Positioned(
            left: 16.w,
            right: 8.w,
            bottom: 16.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Back button ─────────────────────────────────────────
                if (showBack) ...[
                  GestureDetector(
                    onTap: onBack ?? () => Get.back(),
                    child: Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],

                // ── Title + Subtitle ────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: centerTitle
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      if (subtitle != null) ...[
                        Text(
                          subtitle!,
                          textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // ── Actions (optional) ──────────────────────────────────
                if (actions.isNotEmpty) ...[SizedBox(width: 4.w), ...actions],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
