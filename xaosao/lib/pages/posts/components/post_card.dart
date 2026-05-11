import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'post_model.dart';

// ═══════════════════════════════════════════════════════════════
//  PostCard — card ສຳລັບ Tab "ທັງໝົດ"
//  Layout:
//    [avatar + name + time + more]
//    [text]
//    [image? ]
//    [stats left | actions right]  ← single row, no scroll
// ═══════════════════════════════════════════════════════════════
class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onGift;
  final VoidCallback? onComment;
  final VoidCallback? onBook;
  final VoidCallback? onMore;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onGift,
    this.onComment,
    this.onBook,
    this.onMore,
    this.onTap,
  });

  static const _dark   = Color(0xFF1A1A2E);
  static const _hint   = Color(0xFF9B9BAD);
  static const _muted  = Color(0xFFC4C4D0);
  static const _pink   = Color(0xFFF06292);
  static const _amber  = Color(0xFFD97706);
  static const _divider = Color(0x0F000000);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: _divider, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildText(),
              if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                _buildImage(),
              if (post.imageUrl == '' ) // placeholder gradient
                _buildImagePlaceholder(),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 10.h),
      child: Row(
        children: [
          _Avatar(gradient: post.authorGradient, imageUrl: post.authorImageUrl),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post.authorName}, ${post.authorAge}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(post.timeAgo,
                    style: TextStyle(fontSize: 10.sp, color: _muted)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onMore,
            child: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.more_vert_rounded, size: 18.r, color: _muted),
            ),
          ),
        ],
      ),
    );
  }

  // ── Text ───────────────────────────────────────────────────
  Widget _buildText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(13.w, 0, 13.w, 10.h),
      child: _HashtagText(text: post.text),
    );
  }

  // ── Image ──────────────────────────────────────────────────
  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Image.network(
        post.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: post.authorGradient,
          ),
        ),
        child: Center(
          child: Icon(Icons.image_outlined,
              size: 32.r, color: Colors.white.withOpacity(0.25)),
        ),
      ),
    );
  }

  // ── Bottom bar: stats + actions ─────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _divider, width: 0.5)),
      ),
      child: Row(
        children: [
          // Stats
          _StatItem(
            icon: post.isLikedByMe
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: post.isLikedByMe ? _pink : _muted,
            count: post.likeCount,
            textColor: post.isLikedByMe ? _pink : _hint,
          ),
          SizedBox(width: 12.w),
          _StatItem(
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: _muted,
            count: post.commentCount,
            textColor: _hint,
          ),
          const Spacer(),
          // Action icons
          _IconAction(
            icon: post.isLikedByMe
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            bg: post.isLikedByMe ? _pink.withOpacity(0.12) : const Color(0xFFF8F8FC),
            iconColor: post.isLikedByMe ? _pink : _muted,
            onTap: onLike,
          ),
          SizedBox(width: 5.w),
          _IconAction(
            icon: Icons.card_giftcard_rounded,
            bg: const Color(0xFFFFFBEB),
            iconColor: _amber,
            onTap: onGift,
          ),
          SizedBox(width: 5.w),
          _IconAction(
            icon: Icons.chat_bubble_outline_rounded,
            bg: const Color(0xFFF8F8FC),
            iconColor: _muted,
            onTap: onComment,
          ),
          SizedBox(width: 5.w),
          // Book button (label)
          _BookBtn(onTap: onBook),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  MyPostCard — card ສຳລັບ Tab "ຂອງຂ້ອຍ"
//  ບໍ່ມີ edit, ມີ ລຶບ🗑 + ປິດ👁
//  Stats 4 ຖັນ: ❤ ຄຳເຫັນ ຂອງຂວັນ ຈອງ
// ═══════════════════════════════════════════════════════════════
class MyPostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onDelete;
  final VoidCallback? onHide;
  final VoidCallback? onTap;

  const MyPostCard({
    super.key,
    required this.post,
    this.onDelete,
    this.onHide,
    this.onTap,
  });

  static const _dark    = Color(0xFF1A1A2E);
  static const _muted   = Color(0xFFC4C4D0);
  static const _divider = Color(0x0F000000);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: _divider, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (post.imageUrl != null)
                _buildImageSection()
              else
                _buildTextSection(),
              if (post.imageUrl != null) _buildTextBelowImage(),
              _buildStatsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Image with overlay buttons ──────────────────────────────
  Widget _buildImageSection() {
    return Stack(
      children: [
        post.imageUrl!.isNotEmpty
            ? AspectRatio(
                aspectRatio: 16 / 7,
                child: Image.network(post.imageUrl!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePh()),
              )
            : _imagePh(),
        // Buttons overlay
        Positioned(
          top: 10.h, right: 10.w,
          child: Row(children: [
            _OverlayBtn(
              icon: Icons.delete_outline_rounded,
              isRed: true,
              onTap: onDelete,
            ),
            SizedBox(width: 6.w),
            _OverlayBtn(
              icon: Icons.visibility_off_outlined,
              onTap: onHide,
            ),
          ]),
        ),
      ],
    );
  }

  Widget _imagePh() {
    return AspectRatio(
      aspectRatio: 16 / 7,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: post.authorGradient,
          ),
        ),
        child: Center(
          child: Icon(Icons.image_outlined,
              size: 28.r, color: Colors.white.withOpacity(0.25)),
        ),
      ),
    );
  }

  // ── Text below image ────────────────────────────────────────
  Widget _buildTextBelowImage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _HashtagText(text: post.text),
        SizedBox(height: 4.h),
        Text(post.timeAgo,
            style: TextStyle(fontSize: 10.sp, color: _muted)),
      ]),
    );
  }

  // ── Text card (no image) with top-right buttons ─────────────
  Widget _buildTextSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 0),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 66.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HashtagText(text: post.text),
                SizedBox(height: 4.h),
                Text(post.timeAgo,
                    style: TextStyle(fontSize: 10.sp, color: _muted)),
              ],
            ),
          ),
          Positioned(
            top: 0, right: 0,
            child: Row(children: [
              _InlineBtn(
                icon: Icons.delete_outline_rounded,
                isRed: true,
                onTap: onDelete,
              ),
              SizedBox(width: 5.w),
              _InlineBtn(
                icon: Icons.visibility_off_outlined,
                onTap: onHide,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // ── Stats 4-col grid ────────────────────────────────────────
  Widget _buildStatsGrid() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _divider, width: 0.5)),
      ),
      child: Row(children: [
        _StatCol(
          iconBg: const Color(0xFFFFF0F6),
          icon: Icons.favorite_rounded,
          iconColor: const Color(0xFFF06292),
          count: post.likeCount,
          label: 'ຖືກໃຈ',
        ),
        _StatCol(
          iconBg: const Color(0xFFF8F8FC),
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: const Color(0xFF9B9BAD),
          count: post.commentCount,
          label: 'ຄຳເຫັນ',
        ),
        _StatCol(
          iconBg: const Color(0xFFFFFBEB),
          icon: Icons.card_giftcard_rounded,
          iconColor: const Color(0xFFD97706),
          count: post.giftCount,
          label: 'ຂອງຂວັນ',
        ),
        _StatCol(
          iconBg: const Color(0xFFF0F0F5),
          icon: Icons.calendar_month_outlined,
          iconColor: _dark,
          count: post.bookCount,
          label: 'ຈອງ',
          isLast: true,
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Shared sub-widgets
// ═══════════════════════════════════════════════════════════════

class _Avatar extends StatelessWidget {
  final List<Color> gradient;
  final String? imageUrl;

  const _Avatar({required this.gradient, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(imageUrl!, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox()))
          : null,
    );
  }
}

class _HashtagText extends StatelessWidget {
  final String text;
  const _HashtagText({required this.text});

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    return Wrap(
      children: words.map((w) {
        final isTag = w.startsWith('#');
        return Text(
          '$w ',
          style: TextStyle(
            fontSize: 12.5.sp,
            color: isTag ? const Color(0xFFF06292) : const Color(0xFF1A1A2E),
            fontWeight: isTag ? FontWeight.w700 : FontWeight.w400,
            height: 1.65,
          ),
        );
      }).toList(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int count;
  final Color textColor;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 13.r, color: iconColor),
      SizedBox(width: 4.w),
      Text('$count',
          style: TextStyle(
              fontSize: 11.sp, fontWeight: FontWeight.w700, color: textColor)),
    ]);
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final VoidCallback? onTap;

  const _IconAction({
    required this.icon,
    required this.bg,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10.r)),
        child: Icon(icon, size: 15.r, color: iconColor),
      ),
    );
  }
}

class _BookBtn extends StatelessWidget {
  final VoidCallback? onTap;
  const _BookBtn({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.pinkGradient
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.calendar_month_rounded, size: 13.r, color: Colors.white),
          SizedBox(width: 5.w),
          Text('ຈອງ',
              style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
        ]),
      ),
    );
  }
}

class _OverlayBtn extends StatelessWidget {
  final IconData icon;
  final bool isRed;
  final VoidCallback? onTap;

  const _OverlayBtn({required this.icon, this.isRed = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.r,
        height: 30.r,
        decoration: BoxDecoration(
          color: isRed
              ? const Color(0xDCDC2626).withOpacity(0.7)
              : Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Icon(icon, size: 14.r, color: Colors.white),
      ),
    );
  }
}

class _InlineBtn extends StatelessWidget {
  final IconData icon;
  final bool isRed;
  final VoidCallback? onTap;

  const _InlineBtn({required this.icon, this.isRed = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.r,
        height: 28.r,
        decoration: BoxDecoration(
          color: isRed ? const Color(0xFFFEF2F2) : const Color(0xFFF8F8FC),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(
            color: isRed
                ? const Color(0xFFEF4444).withOpacity(0.2)
                : Colors.black.withOpacity(0.07),
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          size: 13.r,
          color: isRed ? const Color(0xFFDC2626) : const Color(0xFF9B9BAD),
        ),
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final int count;
  final String label;
  final bool isLast;

  const _StatCol({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.label,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  right: BorderSide(color: Color(0x0F000000), width: 0.5)),
        ),
        child: Column(children: [
          Container(
            width: 24.r,
            height: 24.r,
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(8.r)),
            child: Icon(icon, size: 12.r, color: iconColor),
          ),
          SizedBox(height: 5.h),
          Text('$count',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1A1A2E),
                  height: 1)),
          SizedBox(height: 3.h),
          Text(label,
              style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9B9BAD),
                  letterSpacing: 0.3)),
        ]),
      ),
    );
  }
}