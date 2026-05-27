import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';

class _Shimmer extends StatelessWidget {
  final Widget child;
  const _Shimmer({required this.child});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: const Color(0xFFE8E8F0),
        highlightColor: const Color(0xFFF5F5FA),
        child: child,
      );
}

class _Box extends StatelessWidget {
  final double? w;
  final double h;
  final double r;
  const _Box({this.w, required this.h, required this.r});

  @override
  Widget build(BuildContext context) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(r),
        ),
      );
}

// ── Model wallet card shimmer ─────────────────────────────────
class ModelWalletCardShimmer extends StatelessWidget {
  const ModelWalletCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        width: double.infinity,
        height: 210.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Box(w: 90.w, h: 12.h, r: 6.r),
                _Box(w: 30.r, h: 30.r, r: 9.r),
              ],
            ),
            SizedBox(height: 8.h),
            _Box(w: 180.w, h: 28.h, r: 8.r),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(child: _Box(h: 44.h, r: 10.r)),
                SizedBox(width: 6.w),
                Expanded(child: _Box(h: 44.h, r: 10.r)),
                SizedBox(width: 6.w),
                Expanded(child: _Box(h: 44.h, r: 10.r)),
              ],
            ),
            SizedBox(height: 10.h),
            _Box(w: double.infinity, h: 38.h, r: 12.r),
          ],
        ),
      ),
    );
  }
}

// ── Bank account card shimmer ─────────────────────────────────
class BankAccountShimmer extends StatelessWidget {
  const BankAccountShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        width: 150.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.all(12.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Box(w: 100.r, h: 100.r, r: 10.r),
            SizedBox(height: 8.h),
            _Box(w: 80.w, h: 10.h, r: 5.r),
            SizedBox(height: 4.h),
            _Box(w: 50.w, h: 8.h, r: 4.r),
          ],
        ),
      ),
    );
  }
}

// ── 3 bank cards shimmer row ──────────────────────────────────
class BankAccountListShimmer extends StatelessWidget {
  const BankAccountListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (_, __) => const BankAccountShimmer(),
      ),
    );
  }
}
