import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';

// ── Shared shimmer wrapper ─────────────────────────────────────
class _Shimmer extends StatelessWidget {
  final Widget child;
  const _Shimmer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8F0),
      highlightColor: const Color(0xFFF5F5FA),
      child: child,
    );
  }
}

// ── Shimmer for the wallet card ────────────────────────────────
class WalletCardShimmer extends StatelessWidget {
  const WalletCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        width: double.infinity,
        height: 190.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // label row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Box(w: 90.w, h: 12.h, r: 6.r),
                _Box(w: 30.r, h: 30.r, r: 9.r),
              ],
            ),
            SizedBox(height: 8.h),
            _Box(w: 160.w, h: 10.h, r: 5.r),
            SizedBox(height: 6.h),
            // balance
            _Box(w: 180.w, h: 28.h, r: 8.r),
            SizedBox(height: 10.h),
            // stat pills row
            Row(
              children: [
                Expanded(child: _Box(h: 46.h, r: 12.r)),
                SizedBox(width: 8.w),
                Expanded(child: _Box(h: 46.h, r: 12.r)),
              ],
            ),
            SizedBox(height: 10.h),
            // top-up button
            _Box(w: double.infinity, h: 38.h, r: 12.r),
          ],
        ),
      ),
    );
  }
}

// ── Shimmer for a single transaction row ───────────────────────
class TransactionItemShimmer extends StatelessWidget {
  const TransactionItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        child: Row(
          children: [
            // icon box
            _Box(w: 40.r, h: 40.r, r: 12.r),
            SizedBox(width: 11.w),
            // title + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Box(w: 110.w, h: 12.h, r: 5.r),
                  SizedBox(height: 6.h),
                  _Box(w: 80.w, h: 10.h, r: 4.r),
                ],
              ),
            ),
            // amount + badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _Box(w: 80.w, h: 14.h, r: 5.r),
                SizedBox(height: 5.h),
                _Box(w: 52.w, h: 18.h, r: 20.r),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shimmer list (5 rows) ──────────────────────────────────────
class TransactionListShimmer extends StatelessWidget {
  const TransactionListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Column(
        children: List.generate(
          5,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: const TransactionItemShimmer(),
          ),
        ),
      ),
    );
  }
}

// ── Reusable shimmer box ───────────────────────────────────────
class _Box extends StatelessWidget {
  final double? w;
  final double h;
  final double r;
  const _Box({this.w, required this.h, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(r),
      ),
    );
  }
}
