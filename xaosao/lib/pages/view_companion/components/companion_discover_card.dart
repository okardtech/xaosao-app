import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/Recommended_model.dart';
import 'package:xaosao/widgets/app_like_button.dart';
import 'package:xaosao/widgets/app_network_image.dart';

class CompanionDiscoverCard extends StatefulWidget {
  final RecommendedModel companion;
  final VoidCallback? onTap;
  final Future<bool> Function()? onLikeTap;

  const CompanionDiscoverCard({
    super.key,
    required this.companion,
    this.onTap,
    this.onLikeTap,
  });

  @override
  State<CompanionDiscoverCard> createState() => _CompanionDiscoverCardState();
}

class _CompanionDiscoverCardState extends State<CompanionDiscoverCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _scale = Tween(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.companion;
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.05),
              width: 0.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Background photo ─────────────────────
                AppNetworkImage(
                  imageUrl: c.profile ?? '',
                  fit: BoxFit.cover,
                  errorWidget: _gradientBg(c),
                ),

                // ── Bottom gradient ──────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 150.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xF0000000), Colors.transparent],
                      ),
                    ),
                  ),
                ),

                // ── Top row: badge + like ────────────────
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  right: 10.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (c.isVip)
                        _vipBadge()
                      else if (c.online)
                        _onlineDot(),
                      const Spacer(),
                      AppLikeButton(
                        initialLiked: c.isLiked,
                        size: 28,
                        iconSize: 13,
                        onToggle: widget.onLikeTap,
                      ),
                    ],
                  ),
                ),

                // ── Bottom info ──────────────────────────
                Positioned(
                  bottom: 10.h,
                  left: 12.w,
                  right: 12.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        c.fullName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 10.r, color: Colors.white60),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              _location(c),
                              style: TextStyle(
                                  fontSize: 10.sp, color: Colors.white60),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.star_rounded,
                              size: 11.r, color: AppColors.star),
                          SizedBox(width: 2.w),
                          Text(
                            (c.rating ?? 0).toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────

  static String _location(RecommendedModel c) {
    if ((c.distanceKm ?? 0) > 0) {
      final km = c.distanceKm!;
      return km < 1 ? '${(km * 1000).toInt()}m' : '${km.toStringAsFixed(1)}km';
    }
    return c.address ?? '';
  }

  Widget _vipBadge() => Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          '★ VIP',
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.vipGold,
            letterSpacing: 0.3,
          ),
        ),
      );

  Widget _onlineDot() => Container(
        width: 10.r,
        height: 10.r,
        decoration: BoxDecoration(
          color: AppColors.online,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      );

  Widget _gradientBg(RecommendedModel c) {
    final idx = (c.id?.hashCode ?? 0).abs() % _gradients.length;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradients[idx],
        ),
      ),
    );
  }

  static const _gradients = <List<Color>>[
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFFfa709a), Color(0xFFfee140)],
    [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    [Color(0xFF4facfe), Color(0xFF00f2fe)],
    [Color(0xFFf093fb), Color(0xFFf5576c)],
    [Color(0xFF30cfd0), Color(0xFF667eea)],
    [Color(0xFF43e97b), Color(0xFF38f9d7)],
    [Color(0xFFffecd2), Color(0xFFfcb69f)],
  ];
}
