import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// ── Shared shimmer base color ──────────────────────────────────────────────────
const _base = Color(0xFFE8E8F0);
const _highlight = Color(0xFFF5F5FA);

Widget _box({double? w, double? h, double radius = 10}) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: _base,
        borderRadius: BorderRadius.circular(radius),
      ),
    );

// ═══════════════════════════════════════════════════════════════════════════════
//  Online section — horizontal list of large cards
// ═══════════════════════════════════════════════════════════════════════════════
class OnlineLoadingShimmer extends StatelessWidget {
  const OnlineLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      child: SizedBox(
        height: 340.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          itemCount: 3,
          itemBuilder: (_, __) => Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: _LargeCardShimmer(),
          ),
        ),
      ),
    );
  }
}

class _LargeCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        width: 210.w,
        color: _base,
        child: Stack(
          children: [
            // Bottom info block
            Positioned(
              bottom: 14.h,
              left: 14.w,
              right: 14.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _box(w: 120.w, h: 16.h),
                  SizedBox(height: 6.h),
                  _box(w: 90.w, h: 11.h),
                  SizedBox(height: 8.h),
                  _box(w: 160.w, h: 11.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Recommended section — 2-column grid of small cards
// ═══════════════════════════════════════════════════════════════════════════════
class RecommendedLoadingShimmer extends StatelessWidget {
  final int count;
  const RecommendedLoadingShimmer({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    final itemW = (MediaQuery.of(context).size.width - 48.w) / 2;
    return Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.78,
          ),
          itemCount: count,
          itemBuilder: (_, __) => _SmallCardShimmer(width: itemW),
        ),
      ),
    );
  }
}

class _SmallCardShimmer extends StatelessWidget {
  final double width;
  const _SmallCardShimmer({required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: width,
        color: _base,
        child: Stack(
          children: [
            Positioned(
              bottom: 12.h,
              left: 10.w,
              right: 10.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _box(w: 80.w, h: 13.h),
                  SizedBox(height: 5.h),
                  _box(w: 60.w, h: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Load-more spinner — shown at bottom of recommended grid
// ═══════════════════════════════════════════════════════════════════════════════
class LoadMoreIndicator extends StatelessWidget {
  const LoadMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Color(0xFFF06292),
          ),
        ),
      ),
    );
  }
}
