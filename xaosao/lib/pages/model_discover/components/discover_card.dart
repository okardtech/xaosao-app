import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/Recommended_model.dart';
import 'package:xaosao/utils/age_formatter.dart';
import 'package:xaosao/widgets/app_like_button.dart';
import 'package:xaosao/widgets/app_network_image.dart';

class DiscoverCard extends StatefulWidget {
  final RecommendedModel model;
  final VoidCallback onTap;
  final VoidCallback? onLikeTap;

  const DiscoverCard({
    super.key,
    required this.model,
    required this.onTap,
    this.onLikeTap,
  });

  @override
  State<DiscoverCard> createState() => _DiscoverCardState();
}

class _DiscoverCardState extends State<DiscoverCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.model;
    final age = AgeFormatter.ageFormatter(m.dob ?? DateTime.now());
    final photo = (m.images?.isNotEmpty == true) ? m.images!.first : m.profile;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Photo ─────────────────────────────────────────
              photo != null
                  ? AppNetworkImage(
                      imageUrl: photo,
                      fit: BoxFit.cover,
                      errorWidget: _gradientFallback(m),
                    )
                  : _gradientFallback(m),

              // ── Bottom gradient ────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 130.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xEE050512),
                        Color(0x99050512),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // ── Top row: badge left + like right ──────────────
              Positioned(
                top: 10.h,
                left: 10.w,
                right: 10.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (m.isVip)
                      _vipBadge()
                    else if (m.online)
                      _onlineDot(),
                    const Spacer(),
                    AppLikeButton(
                      initialLiked: m.isLiked,
                      size: 30,
                      iconSize: 15,
                      onToggle: widget.onLikeTap != null
                          ? () async {
                              widget.onLikeTap!();
                              return true;
                            }
                          : null,
                    ),
                  ],
                ),
              ),

              // ── Bottom info ────────────────────────────────────
              Positioned(
                bottom: 10.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      m.dob != null
                          ? '${m.firstName ?? ''}, $age'
                          : (m.firstName ?? 'ຜູ້ໃຊ້'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 10.r,
                          color: Colors.white60,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'ໃກ້ທ່ານ',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white60,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.star_rounded,
                          size: 11.r,
                          color: const Color(0xFFFFB800),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          (m.rating ?? 0).toStringAsFixed(1),
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
    );
  }

  Widget _vipBadge() => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'VIP',
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _onlineDot() => Container(
        width: 10.r,
        height: 10.r,
        decoration: BoxDecoration(
          color: const Color(0xFF22C55E),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      );

  Widget _gradientFallback(RecommendedModel m) {
    final colors = m.online
        ? [const Color(0xFF22C55E), const Color(0xFF166534)]
        : [AppColors.secondary, AppColors.primary];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Text(
          (m.firstName?.isNotEmpty == true)
              ? m.firstName![0].toUpperCase()
              : '?',
          style: TextStyle(
            fontSize: 48.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white.withValues(alpha: 0.60),
          ),
        ),
      ),
    );
  }
}
