import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/widgets/app_network_image.dart';

class CompanionCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final Color badgeColor;
  final int age;
  final int reviewCount;
  final VoidCallback? onTap;

  const CompanionCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.badgeColor,
    required this.age,
    this.reviewCount = 0,
    this.onTap,
  });

  @override
  State<CompanionCard> createState() => _CompanionCardState();
}

class _CompanionCardState extends State<CompanionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _scale = Tween(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 185.w,
          height: 270.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Full bleed photo / placeholder ──────
                _buildPhoto(),

                // ── Deep gradient bottom overlay ─────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 140.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xE6000000), // 90% black
                          Color(0x80000000), // 50%
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                // ── Like button top-right ────────────────
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: GestureDetector(
                    onTap: () => setState(() => _liked = !_liked),
                    child: Container(
                      width: 34.r,
                      height: 34.r,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.30),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.20),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _liked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 16.r,
                        color: _liked ? const Color(0xFFF06292) : Colors.white,
                      ),
                    ),
                  ),
                ),

                // ── Info overlay bottom ───────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Name + verified
                        Text(
                          '${widget.name}, ${widget.age}',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        // Rating row
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 14.r,
                              color: const Color(0xFFFFB800),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              widget.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                '(${widget.reviewCount} reviews)',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white.withOpacity(0.60),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.verified_rounded,
                              size: 16.r,
                              color: const Color(0xFF64B5F6),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    return AppNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      errorWidget: _placeholder(),
    );
  }

  Widget _placeholder() {
    // Moody gradient per card accent color
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [widget.badgeColor.withOpacity(0.6), const Color(0xFF1A1A2E)],
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
