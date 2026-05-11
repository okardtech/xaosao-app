import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../home/components/companion_card.dart';

// ═══════════════════════════════════════════════════════════════
//  MatchCard  — modern full-bleed card
//  Photo → Stats row → Action bar
// ═══════════════════════════════════════════════════════════════
class MatchCard extends StatefulWidget {
  final CompanionModel companion;
  final int? counter;
  final int? total;
  final VoidCallback? onMessage;
  final VoidCallback? onBook;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.companion,
    this.counter,
    this.total,
    this.onMessage,
    this.onBook,
    this.onTap,
  });

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween(begin: 1.0, end: 0.975)
        .animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.companion;
    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.forward(),
      onTapUp: (_) {
        _scaleCtrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _scaleCtrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPhoto(c),
                _buildStatsRow(c),
                _buildActionBar(c),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  PHOTO  — full-width, tall, with layered overlays
  // ═══════════════════════════════════════════════════════════════
  Widget _buildPhoto(CompanionModel c) {
    return SizedBox(
      height: 300.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background ───────────────────────────────────────
          _buildBg(c),

          // ── Top vignette ─────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 120.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom gradient ───────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 160.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xF5000000),
                    Color(0x88000000),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // ── Top-left: status stack ────────────────────────────
          Positioned(
            top: 14.h,
            left: 14.w,
            child: _buildStatusStack(c),
          ),

          // ── Top-right: counter + like ─────────────────────────
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Like button
                _LikeButton(
                  liked: _liked,
                  onTap: () => setState(() => _liked = !_liked),
                ),
                if (widget.counter != null && widget.total != null) ...[
                  SizedBox(height: 6.h),
                  _pill(
                    child: Text(
                      '${widget.counter} / ${widget.total}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.90),
                      ),
                    ),
                    bg: Colors.black.withOpacity(0.38),
                    border: Colors.white.withOpacity(0.18),
                  ),
                ],
              ],
            ),
          ),

          // ── Bottom info ───────────────────────────────────────
          Positioned(
            bottom: 16.h, left: 16.w, right: 16.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Service chips
                Wrap(
                  spacing: 5.w,
                  runSpacing: 5.h,
                  children: c.services.map(_svcChip).toList(),
                ),
                SizedBox(height: 10.h),

                // Name row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        '${c.name}, ${c.age}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          height: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Verified icon only
                    Icon(
                      Icons.verified_rounded,
                      size: 18.r,
                      color: const Color(0xFF64B5F6),
                    ),
                  ],
                ),
                SizedBox(height: 7.h),

                // Location + rating row
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 12.r,
                        color: Colors.white.withOpacity(0.60)),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        '${c.distanceKm}km · ${c.district}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.60),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Rating pill
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.32),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                            width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              size: 12.r,
                              color: const Color(0xFFFFB800)),
                          SizedBox(width: 3.w),
                          Text(
                            c.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  STATS ROW  — reviews · likes · (divider)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildStatsRow(CompanionModel c) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
              color: const Color(0xFF1A1A2E).withOpacity(0.06), width: 1),
        ),
      ),
      child: Row(
        children: [
          _statItem(
            icon: Icons.rate_review_outlined,
            iconColor: const Color(0xFF42A5F5),
            value: '${c.reviewCount}',
            label: 'ຄຳຄິດເຫັນ',
          ),
          _vertDivider(),
          _statItem(
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFFF06292),
            value: _fmtNum(c.likeCount),
            label: 'ຖືກໃຈ',
          ),
          _vertDivider(),
          _statItem(
            icon: Icons.workspace_premium_rounded,
            iconColor: const Color(0xFFFFB800),
            value: c.isVipElite ? 'VIP' : 'STD',
            label: c.isVipElite ? 'Elite' : 'ທຳມະດາ',
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16.r, color: iconColor),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              color: const Color(0xFF9B9BAD),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _vertDivider() => Container(
        width: 1,
        height: 36.h,
        color: const Color(0xFF1A1A2E).withOpacity(0.07),
      );

  // ═══════════════════════════════════════════════════════════════
  //  ACTION BAR
  // ═══════════════════════════════════════════════════════════════
  Widget _buildActionBar(CompanionModel c) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      child: Row(
        children: [
          // ── ຂໍ້ຄວາມ ─────────────────────────────────────────
          _ActionBtn(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'ຂໍ້ຄວາມ',
            bgColor: const Color(0xFFF4F4FB),
            fgColor: const Color(0xFF1A1A2E),
            bordered: true,
            onTap: widget.onMessage ?? () {},
          ),
          SizedBox(width: 10.w),
          // ── ຈອງດຽວນີ້ ───────────────────────────────────────
          Expanded(
            child: _ActionBtn(
              icon: Icons.calendar_month_rounded,
              label: 'ຈອງດຽວນີ້',
              bgColor: const Color(0xFFF06292),
              fgColor: Colors.white,
              glowColor: const Color(0xFFF06292),
              onTap: widget.onBook ?? () {},
              expanded: true,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  STATUS STACK  (online + vip/new)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildStatusStack(CompanionModel c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Online / Offline
        _pill(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  color: c.isOnline
                      ? const Color(0xFF4CAF50)
                      : Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                c.isOnline ? 'ອອນລາຍ' : 'ອອຟລາຍ',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          bg: Colors.black.withOpacity(0.42),
        ),

        // VIP badge
        if (c.isVipElite) ...[
          SizedBox(height: 5.h),
          _pill(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded,
                    size: 10.r, color: const Color(0xFFFFB800)),
                SizedBox(width: 4.w),
                Text(
                  'VIP ELITE',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFB800),
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
            bg: Colors.black.withOpacity(0.55),
            border: const Color(0xFFFFB800).withOpacity(0.60),
          ),
        ],

        // NEW badge
        if (c.isNew && !c.isVipElite) ...[
          SizedBox(height: 5.h),
          _pill(
            child: Text(
              'ໃໝ່ ✦',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.4,
              ),
            ),
            bg: const Color(0xFF4CAF50).withOpacity(0.90),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  SERVICE CHIP
  // ═══════════════════════════════════════════════════════════════
  Widget _svcChip(ServiceType s) {
    late Color bg, fg, bd;
    switch (s) {
      case ServiceType.social:
        bg = const Color(0xFFF06292).withOpacity(0.20);
        fg = const Color(0xFFFFCDD2);
        bd = const Color(0xFFF06292).withOpacity(0.40);
        break;
      case ServiceType.massage:
        bg = const Color(0xFF42A5F5).withOpacity(0.20);
        fg = const Color(0xFFBBDEFB);
        bd = const Color(0xFF42A5F5).withOpacity(0.40);
        break;
      case ServiceType.travel:
        bg = const Color(0xFFAB47BC).withOpacity(0.20);
        fg = const Color(0xFFE1BEE7);
        bd = const Color(0xFFAB47BC).withOpacity(0.40);
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: bd, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 9.r, color: fg),
          SizedBox(width: 4.w),
          Text(
            s.label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════
  Widget _pill({
    required Widget child,
    required Color bg,
    Color? border,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: border != null ? Border.all(color: border, width: 1) : null,
      ),
      child: child,
    );
  }

  Widget _buildBg(CompanionModel c) {
    final url = c.imageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : _gradientBg(c),
        errorBuilder: (_, __, ___) => _gradientBg(c),
      );
    }
    return _gradientBg(c);
  }

  Widget _gradientBg(CompanionModel c) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: c.gradientColors,
          ),
        ),
      );

  String _fmtNum(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

// ═══════════════════════════════════════════════════════════════
//  _LikeButton  — animated heart with glow
// ═══════════════════════════════════════════════════════════════
class _LikeButton extends StatefulWidget {
  final bool liked;
  final VoidCallback onTap;

  const _LikeButton({required this.liked, required this.onTap});

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 180),
        lowerBound: 0.85,
        upperBound: 1.0,
        value: 1.0);
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() {
    _ctrl.reverse().then((_) => _ctrl.forward());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: widget.liked
                ? const Color(0xFFF06292)
                : Colors.black.withOpacity(0.35),
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.liked
                  ? const Color(0xFFF06292)
                  : Colors.white.withOpacity(0.25),
              width: 1.2,
            ),
            boxShadow: widget.liked
                ? [
                    BoxShadow(
                      color: const Color(0xFFF06292).withOpacity(0.50),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Icon(
            widget.liked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            size: 18.r,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ActionBtn  — tap-scale action button
// ═══════════════════════════════════════════════════════════════
class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color fgColor;
  final bool bordered;
  final bool expanded;
  final Color? glowColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.fgColor,
    required this.onTap,
    this.bordered = false,
    this.expanded = false,
    this.glowColor,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.93)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final btn = GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(14.r),
            border: widget.bordered
                ? Border.all(
                    color: Colors.black.withOpacity(0.09), width: 1)
                : null,
            boxShadow: widget.glowColor != null
                ? [
                    BoxShadow(
                      color: widget.glowColor!.withOpacity(0.40),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 15.r, color: widget.fgColor),
              SizedBox(width: 7.w),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: widget.fgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return widget.expanded ? btn : btn;
  }
}