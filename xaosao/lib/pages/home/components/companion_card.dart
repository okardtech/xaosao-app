import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/utils/currency_formatter.dart';

// ── Service type enum ─────────────────────────────────────────────────────────
enum ServiceType { social, massage, travel }

extension ServiceTypeExt on ServiceType {
  String get label {
    switch (this) {
      case ServiceType.social:
        return 'ເພື່ອນສັງຄົມ';
      case ServiceType.massage:
        return 'ນວດ';
      case ServiceType.travel:
        return 'ທ່ອງທ່ຽວ';
    }
  }

  IconData get icon {
    switch (this) {
      case ServiceType.social:
        return Icons.people_alt_outlined;
      case ServiceType.massage:
        return Icons.spa_outlined;
      case ServiceType.travel:
        return Icons.flight_takeoff_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ServiceType.social:
        return const Color(0xFFF06292);
      case ServiceType.massage:
        return const Color(0xFF9C6FDE);
      case ServiceType.travel:
        return const Color(0xFF42A5F5);
    }
  }

  String get description {
    switch (this) {
      case ServiceType.social:
        return 'ທ່ຽວ, ງານລ້ຽງ, ທຸກໂອກາດ';
      case ServiceType.massage:
        return 'ນວດສຸຂະພາບໂດຍມືອາຊີບ';
      case ServiceType.travel:
        return 'Guide ໃນ ແລະ ຕ່າງປະເທດ';
    }
  }

  int get pricePerHour {
    switch (this) {
      case ServiceType.social:
        return 150000;
      case ServiceType.massage:
        return 180000;
      case ServiceType.travel:
        return 200000;
    }
  }

  Color get bgColor {
    switch (this) {
      case ServiceType.social:
        return const Color(0xFFFFF0F6);
      case ServiceType.massage:
        return const Color(0xFFF0F7FF);
      case ServiceType.travel:
        return const Color(0xFFF3F0FF);
    }
  }

  String get formattedPrice {
    final n = pricePerHour;
    return '${CurrFormatter.format(n)}kip';
  }
}

// ── Companion model ───────────────────────────────────────────────────────────
class CompanionModel {
  final String id;
  final String name;
  final int age;
  final String imageUrl;
  final String district;
  final double distanceKm;
  final double rating;
  final int reviewCount;
  final int likeCount;
  final List<ServiceType> services; // max 3
  final bool isOnline;
  final bool isVipElite;
  final bool isNew;
  final String gender; // 'male' | 'female'
  final List<Color> gradientColors; // placeholder gradient

  const CompanionModel({
    required this.id,
    required this.name,
    required this.age,
    this.imageUrl = '',
    required this.district,
    required this.distanceKm,
    required this.rating,
    this.reviewCount = 0,
    this.likeCount = 0,
    required this.services,
    this.isOnline = false,
    this.isVipElite = false,
    this.isNew = false,
    required this.gender,
    required this.gradientColors,
  });
}

// ── Large featured card (horizontal scroll) ───────────────────────────────────
class CompanionCardLarge extends StatefulWidget {
  final CompanionModel companion;
  final VoidCallback? onTap;

  const CompanionCardLarge({super.key, required this.companion, this.onTap});

  @override
  State<CompanionCardLarge> createState() => _CompanionCardLargeState();
}

class _CompanionCardLargeState extends State<CompanionCardLarge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
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
          width: 210.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            // boxShadow: [
            //   BoxShadow(
            //     color: c.gradientColors.last.withOpacity(0.30),
            //     blurRadius: 18,
            //     offset: const Offset(0, 7),
            //   ),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Background photo / gradient ──────────
                _buildBackground(c),

                // ── Bottom gradient ──────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 170.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xDD000000),
                          Color(0x88000000),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ),

                // ── Top badges ───────────────────────────
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: Row(
                    children: [
                      _onlineBadge(c.isOnline),
                      SizedBox(width: 6.w),
                      if (c.isVipElite) _vipBadge(),
                      if (c.isNew && !c.isVipElite) _newBadge(),
                      const Spacer(),
                      _likeButton(),
                    ],
                  ),
                ),

                // ── Bottom info ──────────────────────────
                Positioned(
                  bottom: 14.h,
                  left: 14.w,
                  right: 14.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Service chips
                      // Wrap(
                      //   spacing: 5.w,
                      //   runSpacing: 4.h,
                      //   children: c.services
                      //       .map((s) => _serviceChip(s))
                      //       .toList(),
                      // ),
                      // SizedBox(height: 8.h),
                      // Name + age
                      Text(
                        '${c.name}, ${c.age}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.h),
                      // Location + rating row
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 12.r,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              '${c.distanceKm}km · ${c.district}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      // Rating + likes
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 13.r,
                            color: const Color(0xFFFFB800),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            c.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${c.reviewCount} reviews',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white54,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.favorite_rounded,
                            size: 12.r,
                            color: const Color(0xFFF06292),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            _formatLikes(c.likeCount),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
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

  Widget _buildBackground(CompanionModel c) {
    if (c.imageUrl.isNotEmpty) {
      return Image.network(
        c.imageUrl,
        fit: BoxFit.cover,
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

  Widget _onlineBadge(bool online) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: online
          ? const Color(0xFF1A1A2E).withOpacity(0.85)
          : Colors.black45,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7.r,
          height: 7.r,
          decoration: BoxDecoration(
            color: online ? const Color(0xFF4CAF50) : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          online ? 'Online' : 'Offline',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );

  Widget _vipBadge() => Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A2E).withOpacity(0.88),
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: const Color(0xFFFFB800).withOpacity(0.6)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 10.r, color: const Color(0xFFFFB800)),
        SizedBox(width: 3.w),
        Text(
          'VIP ELITE',
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFFFB800),
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );

  Widget _newBadge() => Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: const Color(0xFF4CAF50),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      'NEW',
      style: TextStyle(
        fontSize: 9.sp,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _likeButton() => GestureDetector(
    onTap: () => setState(() => _liked = !_liked),
    child: Container(
      width: 34.r,
      height: 34.r,
      decoration: BoxDecoration(
        color: _liked
            ? const Color(0xFFF06292)
            : Colors.black.withOpacity(0.30),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.20)),
      ),
      child: Icon(
        _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        size: 16.r,
        color: Colors.white,
      ),
    ),
  );

  Widget _serviceChip(ServiceType s) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: s.color.withOpacity(0.25),
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: s.color.withOpacity(0.50)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(s.icon, size: 10.r, color: Colors.white),
        SizedBox(width: 4.w),
        Text(
          s.label,
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );

  String _formatLikes(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

// ── Small grid card (nearby / featured grid) ──────────────────────────────────
class CompanionCardSmall extends StatefulWidget {
  final CompanionModel companion;
  final VoidCallback? onTap;

  const CompanionCardSmall({super.key, required this.companion, this.onTap});

  @override
  State<CompanionCardSmall> createState() => _CompanionCardSmallState();
}

class _CompanionCardSmallState extends State<CompanionCardSmall>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              c.imageUrl.isNotEmpty
                  ? Image.network(
                      c.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _gradient(c),
                    )
                  : _gradient(c),

              // Bottom gradient
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 110.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xEE000000), Colors.transparent],
                    ),
                  ),
                ),
              ),

              // Top row: service dots + like/bell
              Positioned(
                top: 10.h,
                left: 10.w,
                right: 10.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Service color dots
                    // ...c.services.map((s) => Padding(
                    //       padding: EdgeInsets.only(right: 4.w),
                    //       child: Container(
                    //         width: 8.r,
                    //         height: 8.r,
                    //         decoration: BoxDecoration(
                    //           color: s.color,
                    //           shape: BoxShape.circle,
                    //           boxShadow: [
                    //             BoxShadow(
                    //                 color: s.color.withOpacity(0.6),
                    //                 blurRadius: 4)
                    //           ],
                    //         ),
                    //       ),
                    //     )),
                    // const Spacer(),
                    // Notification / like icon
                    GestureDetector(
                      onTap: () => setState(() => _liked = !_liked),
                      child: Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.28),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _liked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 14.r,
                          color: _liked
                              ? const Color(0xFFF06292)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom info
              Positioned(
                bottom: 10.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${c.name}, ${c.age}',
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
                          '${c.distanceKm}km',
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
                          c.rating.toStringAsFixed(1),
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

              // Online dot
              // if (c.isOnline)
              // Positioned(
              //   top: 10.h,
              //   left: c.services.length * 12.w + 10.w,
              //   child: Container(
              //     width: 8.r,
              //     height: 8.r,
              //     decoration: BoxDecoration(
              //       color: const Color(0xFF4CAF50),
              //       shape: BoxShape.circle,
              //       border:
              //           Border.all(color: Colors.white, width: 1.5),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gradient(CompanionModel c) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: c.gradientColors,
      ),
    ),
  );
}
