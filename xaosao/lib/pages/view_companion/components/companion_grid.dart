import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'companion_model.dart';

class CompanionGridCard extends StatefulWidget {
  final Companion companion;
  final int index;
  final VoidCallback? onTap;

  const CompanionGridCard({
    super.key,
    required this.companion,
    required this.index,
    this.onTap,
  });

  @override
  State<CompanionGridCard> createState() => _CompanionGridCardState();
}

class _CompanionGridCardState extends State<CompanionGridCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _liked = false;

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

  List<Color> get _gradient =>
      cardGradients[widget.index % cardGradients.length];

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
            border: Border.all(color: Colors.black.withOpacity(0.05), width: 0.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Photo area ──────────────────────────────
                _buildPhoto(c),
                // ── Footer ──────────────────────────────────
                _buildFooter(c),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto(Companion c) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          c.imageUrl.isNotEmpty
              ? Image.network(c.imageUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _gradientBg())
              : _gradientBg(),

          // Bottom gradient
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 110.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.82),
                    Colors.black.withOpacity(0.30),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Top badges
          Positioned(
            top: 8.h, left: 8.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (c.isOnline) _onlineBadge(),
                if (c.isVip) ...[SizedBox(height: 4.h), _vipBadge()],
                if (c.isNew && !c.isVip) ...[SizedBox(height: 4.h), _newBadge()],
              ],
            ),
          ),

          // Like button
          Positioned(
            top: 8.h, right: 8.w,
            child: GestureDetector(
              onTap: () => setState(() => _liked = !_liked),
              child: Container(
                width: 28.r, height: 28.r,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.28),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.18)),
                ),
                child: Icon(
                  _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: 13.r,
                  color: _liked ? const Color(0xFFF06292) : Colors.white,
                ),
              ),
            ),
          ),

          // Service dots
          Positioned(
            bottom: 46.h, left: 9.w,
            child: Row(
              children: c.services.map((s) => Container(
                width: 6.r, height: 6.r,
                margin: EdgeInsets.only(right: 4.w),
                decoration: BoxDecoration(
                  color: s.color, shape: BoxShape.circle,
                ),
              )).toList(),
            ),
          ),

          // Name / location / rating
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${c.name}, ${c.age}',
                    style: TextStyle(
                      fontSize: 13.sp, fontWeight: FontWeight.w800,
                      color: Colors.white, letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.location_on_rounded,
                            size: 9.r, color: Colors.white.withOpacity(0.65)),
                        SizedBox(width: 2.w),
                        Text(c.formattedDistance,
                            style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.white.withOpacity(0.65))),
                      ]),
                      Row(children: [
                        Icon(Icons.star_rounded,
                            size: 10.r, color: const Color(0xFFF9C846)),
                        SizedBox(width: 2.w),
                        Text(c.rating.toStringAsFixed(1),
                            style: TextStyle(
                                fontSize: 9.sp, fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(Companion c) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 4.w, runSpacing: 4.h,
              children: c.services.map((s) => Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: s.bgColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(s.label,
                    style: TextStyle(
                        fontSize: 8.sp, fontWeight: FontWeight.w700,
                        color: s.color)),
              )).toList(),
            ),
          ),
          SizedBox(width: 6.w),
          Row(children: [
            Icon(Icons.favorite_rounded,
                size: 9.r, color: const Color(0xFFF06292)),
            SizedBox(width: 2.w),
            Text(c.formattedLikes,
                style: TextStyle(
                    fontSize: 9.sp, fontWeight: FontWeight.w700,
                    color: const Color(0xFFF06292))),
          ]),
        ],
      ),
    );
  }

  Widget _gradientBg() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _gradient,
          ),
        ),
      );

  Widget _onlineBadge() => Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: const Color(0xFF22C55E).withOpacity(0.88),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 4.r, height: 4.r,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle)),
          SizedBox(width: 3.w),
          Text('Online', style: TextStyle(
              fontSize: 8.sp, fontWeight: FontWeight.w800, color: Colors.white)),
        ]),
      );

  Widget _vipBadge() => Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text('★ VIP', style: TextStyle(
            fontSize: 8.sp, fontWeight: FontWeight.w800,
            color: const Color(0xFFF9C846), letterSpacing: 0.3)),
      );

  Widget _newBadge() => Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF06292).withOpacity(0.88),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text('NEW', style: TextStyle(
            fontSize: 8.sp, fontWeight: FontWeight.w800, color: Colors.white)),
      );
}