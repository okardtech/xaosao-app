import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../home/components/companion_card.dart';
import 'profile_model.dart';

// ═══════════════════════════════════════════════════════════════
//  ProfilePhotoSlider — photo pageview with dots + counter
// ═══════════════════════════════════════════════════════════════
class ProfilePhotoSlider extends StatefulWidget {
  final CompanionProfile profile;
  final double height;

  const ProfilePhotoSlider({
    super.key,
    required this.profile,
    required this.height,
  });

  @override
  State<ProfilePhotoSlider> createState() => _ProfilePhotoSliderState();
}

class _ProfilePhotoSliderState extends State<ProfilePhotoSlider> {
  final _pageCtrl = PageController();
  int _current = 0;

  int get _count =>
      widget.profile.photoUrls.isEmpty ? 1 : widget.profile.photoUrls.length;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Photos
          PageView.builder(
            controller: _pageCtrl,
            itemCount: _count,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) {
              final urls = widget.profile.photoUrls;
              if (urls.isNotEmpty) {
                return Image.network(
                  urls[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _gradientBg(),
                );
              }
              return _gradientBg();
            },
          ),

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: widget.height * 0.62,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFA050512),
                    Color(0xB2050512),
                    Color(0x1A050512),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.45, 0.75, 1.0],
                ),
              ),
            ),
          ),

          // Dots
          if (_count > 1)
            Positioned(
              top: 14.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_count, (i) {
                  final isOn = i == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    width: isOn ? 16.w : 5.r,
                    height: 5.r,
                    decoration: BoxDecoration(
                      color: isOn
                          ? Colors.white
                          : Colors.white.withOpacity(0.40),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  );
                }),
              ),
            ),

          // Counter chip
          if (_count > 1)
            Positioned(
              bottom: 150.h,
              right: 14.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${_current + 1} / $_count',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.80),
                  ),
                ),
              ),
            ),

          // Profile info overlay (bottom of photo)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ProfileInfoOverlay(profile: widget.profile),
          ),
        ],
      ),
    );
  }

  Widget _gradientBg() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: widget.profile.gradient,
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
//  ProfileInfoOverlay — name + badges + location + stats strip
// ═══════════════════════════════════════════════════════════════
class ProfileInfoOverlay extends StatelessWidget {
  final CompanionProfile profile;
  const ProfileInfoOverlay({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badges row
          Row(
            children: [
              if (profile.isOnline)
                _Badge(
                  label: 'ອອນລາຍ',
                  bg: const Color(0xE022C55E),
                  fg: Colors.white,
                  dot: true,
                ),
              if (profile.isOnline) SizedBox(width: 6.w),
              if (profile.isVip)
                _Badge(
                  label: '★ VIP ELITE',
                  bg: const Color(0xBF1A1A2E),
                  fg: const Color(0xFFF9C846),
                  border: const Color(0x4DF9C846),
                ),
              if (profile.isVip) SizedBox(width: 6.w),
              if (profile.isVerified)
                Icon(
                  Icons.verified_rounded,
                  size: 18.r,
                  color: const Color(0xFF64B5F6),
                ),
            ],
          ),
          SizedBox(height: 8.h),

          // Name
          Text(
            profile.fullName,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),

          // Age + location
          SizedBox(height: 5.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 11.r,
                color: Colors.white.withOpacity(0.55),
              ),
              SizedBox(width: 4.w),
              Text(
                '${profile.formattedDistance} · ${profile.district}, ${profile.city}',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Stats strip
          _StatsStrip(profile: profile),
        ],
      ),
    );
  }
}

// ── Badge ──────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final Color? border;
  final bool dot;

  const _Badge({
    required this.label,
    required this.bg,
    required this.fg,
    this.border,
    this.dot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: border != null ? Border.all(color: border!) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 4.r,
              height: 4.r,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 3.w),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats strip ────────────────────────────────────────────────
class _StatsStrip extends StatelessWidget {
  final CompanionProfile profile;
  const _StatsStrip({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          _StatCell(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFF9C846),
            value: profile.rating.toStringAsFixed(1),
            label: 'ຄະແນນ',
          ),
          _divider(),
          _StatCell(
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFFF06292),
            value: profile.formattedLikes,
            label: 'ຖືກໃຈ',
          ),
          _divider(),
          _StatCell(
            icon: Icons.people_outline_rounded,
            iconColor: Colors.white.withOpacity(0.70),
            value: profile.formattedFollowers,
            label: 'ຕິດຕາມ',
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 0.5,
    height: 44.h,
    color: Colors.white.withOpacity(0.08),
  );
}

class _StatCell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCell({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            Icon(icon, size: 16.r, color: iconColor),
            SizedBox(height: 3.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.40),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ServiceCard — selectable service row
// ═══════════════════════════════════════════════════════════════
class ServiceCard extends StatelessWidget {
  final ServiceType service;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? service.color.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? service.color : Colors.black.withOpacity(0.07),
            width: isSelected ? 1.2 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: service.bgColor,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Icon(service.icon, size: 16.r, color: service.color),
            ),
            SizedBox(width: 10.w),

            // Name + desc
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ],
              ),
            ),

            // Price
            Text(
              '${service.formattedPrice}/ຊມ',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFF06292),
              ),
            ),
            SizedBox(width: 8.w),

            // Check circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF06292)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFF06292)
                      : Colors.black.withOpacity(0.12),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, size: 11.r, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  RatingSection — big number + bar chart + reviews
// ═══════════════════════════════════════════════════════════════
class RatingSection extends StatelessWidget {
  final CompanionProfile profile;
  const RatingSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header card
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: Colors.black.withOpacity(0.07),
              width: 0.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Big rating
              Column(
                children: [
                  Text(
                    profile.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1A2E),
                      letterSpacing: -1,
                    ),
                  ),
                  _Stars(rating: profile.rating, size: 13.r),
                  SizedBox(height: 3.h),
                  Text(
                    '${profile.reviewCount} ລີວິວ',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),

              // Bar chart
              Expanded(
                child: Column(
                  children: [5, 4, 3].map((star) {
                    final pct = profile.ratingBreakdown[star] ?? 0.0;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: Row(
                        children: [
                          Text(
                            '$star',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: const Color(0xFF9B9BAD),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.r),
                              child: LinearProgressIndicator(
                                value: pct,
                                backgroundColor: const Color(0xFFF8F8FC),
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFFF9C846),
                                ),
                                minHeight: 4.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          SizedBox(
                            width: 28.w,
                            child: Text(
                              '${(pct * 100).toInt()}%',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: const Color(0xFF9B9BAD),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),

        // Review cards
        ...profile.reviews.map(
          (r) => Padding(
            padding: EdgeInsets.only(bottom: 7.h),
            child: ReviewCard(review: r),
          ),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: review.avatarColor,
                child: Text(
                  review.userName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      review.timeAgo,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: const Color(0xFFC4C4D0),
                      ),
                    ),
                  ],
                ),
              ),
              _Stars(rating: review.rating, size: 10.r),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            review.text,
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF6B6B80),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stars widget ───────────────────────────────────────────────
class _Stars extends StatelessWidget {
  final double rating;
  final double size;
  const _Stars({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          Icons.star_rounded,
          size: size,
          color: i < rating.floor()
              ? const Color(0xFFF9C846)
              : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PostsGrid — 2×N mini post grid
// ═══════════════════════════════════════════════════════════════
class PostsGrid extends StatelessWidget {
  final List<PostMini> posts;
  const PostsGrid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 7.w,
        mainAxisSpacing: 7.h,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, i) => _PostMiniCard(post: posts[i]),
    );
  }
}

class _PostMiniCard extends StatelessWidget {
  final PostMini post;
  const _PostMiniCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image or gradient
          post.imageUrl != null && post.imageUrl!.isNotEmpty
              ? Image.network(
                  post.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _gradientBg(),
                )
              : _gradientBg(),

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xBF000000), Colors.transparent],
                ),
              ),
            ),
          ),

          // Caption + likes
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    post.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        size: 9.r,
                        color: Colors.white.withOpacity(0.65),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        post.formattedLikes,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.white.withOpacity(0.65),
                        ),
                      ),
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

  Widget _gradientBg() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: post.gradient,
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
//  StickyBookingBar — fixed bottom CTA
// ═══════════════════════════════════════════════════════════════
class StickyBookingBar extends StatelessWidget {
  final CompanionProfile profile;
  final bool enabled;
  final VoidCallback onBook;

  const StickyBookingBar({
    super.key,
    required this.profile,
    required this.enabled,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black.withOpacity(0.07), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ເລີ່ມຕົ້ນ',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: const Color(0xFF9B9BAD),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    profile.formattedMinPrice,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1A2E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'ກີບ/h',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: enabled ? onBook : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              decoration: BoxDecoration(
                color: enabled
                    ? const Color(0xFFF06292)
                    : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Text(
                  'ຈອງດຽວນີ້',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: enabled ? Colors.white : const Color(0xFF9B9BAD),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
