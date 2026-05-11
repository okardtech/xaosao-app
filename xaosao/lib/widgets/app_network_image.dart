import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
 
class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
 
  /// Optional custom placeholder shown while loading.
  /// Defaults to the shimmer effect.
  final Widget? loadingPlaceholder;
 
  /// Optional custom widget shown on error.
  /// Defaults to the moody gradient placeholder.
  final Widget? errorWidget;
 
  /// Accent color used in the default gradient error placeholder.
  final Color accentColor;
 
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.loadingPlaceholder,
    this.errorWidget,
    this.accentColor = const Color(0xFF7C4DFF),
  });
 
  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      // ── imageBuilder gives full control over how the resolved
      //    ImageProvider is rendered — no internal BoxFit wiring needed.
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) =>
          loadingPlaceholder ?? _ShimmerPlaceholder(width: width, height: height),
      errorWidget: (context, url, error) =>
          errorWidget ?? _GradientPlaceholder(accentColor: accentColor),
    );
 
    // ClipRRect is still applied when borderRadius is set, because
    // DecorationImage.borderRadius only clips the image inside the box —
    // child widgets (like shimmer/error) also need to be clipped.
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
 
    return image;
  }
}
 
// ─────────────────────────────────────────────
// Shimmer loading placeholder
// ─────────────────────────────────────────────
 
class _ShimmerPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
 
  const _ShimmerPlaceholder({this.width, this.height});
 
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.textDisabled,
      highlightColor: AppColors.surface,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height,
        color: AppColors.textDisabled,
      ),
    );
  }
}
 
// ─────────────────────────────────────────────
// Gradient fallback on error
// ─────────────────────────────────────────────
 
class _GradientPlaceholder extends StatelessWidget {
  final Color accentColor;
 
  const _GradientPlaceholder({required this.accentColor});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accentColor.withOpacity(0.6), const Color(0xFF1A1A2E)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: 70.r,
          color: Colors.white.withOpacity(0.25),
        ),
      ),
    );
  }
}
 
// ─────────────────────────────────────────────
// Convenience: shimmer for rectangular cards
// ─────────────────────────────────────────────
 
/// A standalone shimmer card — use while a list/grid is still loading
/// before you have image URLs at all.
///
/// ```dart
/// ShimmerCard(width: 185.w, height: 270.h, borderRadius: 24.r)
/// ```
class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
 
  const ShimmerCard({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 24,
  });
 
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.textDisabled,
      highlightColor: AppColors.surface,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.textDisabled,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}