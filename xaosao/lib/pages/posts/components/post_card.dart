import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/fee_model.dart';
import 'package:xaosao/models/my_post_model.dart';
import 'package:xaosao/widgets/app_network_image.dart';

// ─────────────────────────────────────────────────────────────
//  Colors not in AppColors — named here so no bare hex in file
// ─────────────────────────────────────────────────────────────

// Amber family (gift / tip)
const _amber = Color(0xFFD97706);
const _amberLight = Color(0xFFF59E0B);
const _tipBg = Color(0xFFFFF7ED);

// Danger / destructive
const _dangerColor = Color(0xFFDC2626);

// Neutral divider (black 5%)
const _dividerColor = Color(0x0D000000);

// ─────────────────────────────────────────────────────────────
//  Helpers
// ─────────────────────────────────────────────────────────────

/// Format large numbers: 1200 → 1.2K, 12000 → 12K, 1200000 → 1.2M
String _fmtCount(int n) {
  if (n >= 1000000) {
    final v = n / 1000000;
    return '${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1)}M';
  }
  if (n >= 1000) {
    final v = n / 1000;
    return '${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1)}K';
  }
  return '$n';
}

String _ago(DateTime? dt) {
  if (dt == null) return '';
  final d = DateTime.now().difference(dt);
  if (d.inSeconds < 60) return 'ໃໝ່ໆ';
  if (d.inMinutes < 60) return '${d.inMinutes} ນາທີກ່ອນ';
  if (d.inHours < 24) return '${d.inHours} ຊົ່ວໂມງກ່ອນ';
  if (d.inDays < 7) return '${d.inDays} ວັນ';
  return '${(d.inDays / 7).floor()} ອທ.';
}

(Color fg, Color bg) _serviceChip(String? name) {
  if (name == null) return (AppColors.textHint, AppColors.surfaceSecondary);
  final n = name.toLowerCase();
  if (n.contains('ນວດ') || n.contains('massage'))
    return (AppColors.massageFg, AppColors.massageBg);
  if (n.contains('ທ່ຽວ') || n.contains('travel'))
    return (AppColors.travelFg, AppColors.travelBg);
  return (AppColors.socialFg, AppColors.socialBg);
}

String _statusLabel(String? s) => switch (s) {
  'active' => 'ກຳລັງໃຊ້',
  'expired' => 'ໝົດອາຍຸ',
  'hidden' => 'ຊ່ອນ',
  'fulfilled' => 'ປິດໃຊ້ງານເເລ້ວ',
  _ => s ?? '',
};

Color _statusColor(String? s) => switch (s) {
  'active' => AppColors.online,
  'expired' => AppColors.textHint,
  'hidden' => _amberLight,
  _ => AppColors.textHint,
};

// ═══════════════════════════════════════════════════════════════
//  PostCard — Feed card (FeeModel)
// ═══════════════════════════════════════════════════════════════
class PostCard extends StatelessWidget {
  final FeeModel post;
  final VoidCallback? onInterest;
  final VoidCallback? onGift;
  final VoidCallback? onBook;
  final VoidCallback? onMessage;
  final VoidCallback? onMore;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onInterest,
    this.onGift,
    this.onBook,
    this.onMessage,
    this.onMore,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = (post.images != null && post.images!.isNotEmpty)
        ? post.images![0]
        : null;
    final authorName = [
      post.author?.firstName,
      post.author?.lastName,
    ].where((s) => s != null && s.isNotEmpty).join(' ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(authorName),
              _buildBody(),
              if (imageUrl != null) _buildImage(imageUrl),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header: avatar · name+status · time (clean — no button) ──
  Widget _buildHeader(String authorName) {
    final status = post.status;
    final statusColor = status != null
        ? _statusColor(status)
        : AppColors.textDisabled;

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _AuthorAvatar(imageUrl: post.author?.profile),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + tip badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        authorName.isEmpty ? 'ຜູ້ໂພສ' : authorName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (post.hasTip == true) ...[
                      SizedBox(width: 6.w),
                      const _TipBadge(),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                // Status dot + label + time — all on one line
                Row(
                  children: [
                    if (status != null && status.isNotEmpty) ...[
                      Container(
                        width: 5.r,
                        height: 5.r,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _statusLabel(status),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 2.r,
                        height: 2.r,
                        decoration: BoxDecoration(
                          color: AppColors.textDisabled,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                    ],
                    Text(
                      _ago(post.createdAt),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textDisabled,
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

  // ── Body: content text + info chips ───────────────────────
  Widget _buildBody() {
    final content = post.content ?? '';
    final gender = post.targetGender;
    final location = post.location;
    final serviceName = post.service?.name;

    final hasContent = content.isNotEmpty;
    final hasChips =
        (gender != null && gender.isNotEmpty) ||
        (location != null && location.isNotEmpty) ||
        (serviceName != null && serviceName.isNotEmpty);

    if (!hasContent && !hasChips) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasContent) _HashtagText(text: content),
          if (hasChips) ...[
            if (hasContent) SizedBox(height: 10.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                if (gender != null && gender.isNotEmpty)
                  _InfoChip(
                    icon: gender == 'female'
                        ? Icons.female_rounded
                        : Icons.male_rounded,
                    label: _genderLabel(gender),
                    fg: gender == 'female'
                        ? AppColors.socialFg
                        : AppColors.massageFg,
                    bg: gender == 'female'
                        ? AppColors.socialBg
                        : AppColors.massageBg,
                  ),
                if (location != null && location.isNotEmpty)
                  _InfoChip(
                    icon: Icons.location_on_rounded,
                    label: location,
                    fg: AppColors.textHint,
                    bg: AppColors.surfaceSecondary,
                  ),
                if (serviceName != null && serviceName.isNotEmpty)
                  _InfoChip(
                    icon: Icons.spa_outlined,
                    label: serviceName,
                    fg: _serviceChip(serviceName).$1,
                    bg: _serviceChip(serviceName).$2,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Image ──────────────────────────────────────────────────
  Widget _buildImage(String url) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: AppNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        accentColor: AppColors.primary,
      ),
    );
  }

  // ── Footer: icon + count only (social-app style) ──────────
  Widget _buildFooter() {
    final isOn = post.isInterested ?? false;
    final isModelPost = post.authorType == 'model';
    final count = post.interestedCount ?? 0;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _dividerColor, width: 0.5)),
      ),
      child: Row(
        children: [
          // ❤ interest count
          _ActionBtn(
            icon: isOn
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            count: _fmtCount(count),
            color: isOn ? AppColors.primary : AppColors.textHint,
            onTap: onInterest,
          ),
          SizedBox(width: 18.w),
          // 💬 comment count
          _ActionBtn(
            icon: Icons.chat_bubble_outline_rounded,
            count: _fmtCount(post.commentCount ?? 0),
            color: AppColors.textHint,
            onTap: onMessage,
          ),
          if (isModelPost) ...[
            SizedBox(width: 18.w),
            // 🎁 gift count (model posts only — customers can tip models)
            _ActionBtn(
              icon: Icons.card_giftcard_rounded,
              count: _fmtCount(post.giftCount ?? 0),
              color: _amber,
              onTap: onGift,
            ),
          ],
          const Spacer(),
          // ── Book CTA — right-aligned, only on model posts ──
          if (isModelPost) _BookBtn(onTap: onBook),
        ],
      ),
    );
  }
}

String _genderLabel(String? g) => switch (g) {
  'male' => 'ຊາຍ',
  'female' => 'ຍິງ',
  'any' => 'ທຸກເພດ',
  _ => g ?? '',
};

// ═══════════════════════════════════════════════════════════════
//  MyPostCard — My posts tab (MyPostModel)
// ═══════════════════════════════════════════════════════════════
class MyPostCard extends StatelessWidget {
  final MyPostModel post;
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

  String? get _firstImage {
    final imgs = post.images;
    if (imgs == null || imgs.isEmpty) return null;
    final first = imgs[0];
    if (first is String && first.isNotEmpty) return first;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _firstImage;
    final interests = post.counts?.interests ?? 0;
    final comments = post.counts?.comments ?? 0;
    final gifts = post.counts?.gifts ?? 0;
    final hasContent = (post.content ?? '').isNotEmpty;
    final hasLocation =
        post.location != null && post.location!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.05),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Header: status + tip badges only ────────
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 0),
                child: Row(
                  children: [
                    if (post.status != null && post.status!.isNotEmpty)
                      _MyStatusChip(status: post.status!),
                    if (post.hasTip == true) ...[
                      SizedBox(width: 6.w),
                      const _TipBadge(),
                    ],
                  ],
                ),
              ),

              // ── 2. Content + meta ──────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasContent) _HashtagText(text: post.content!),
                    SizedBox(height: hasContent ? 10.h : 0),
                    // Meta: location · time
                    Row(
                      children: [
                        if (hasLocation) ...[
                          Icon(Icons.location_on_outlined,
                              size: 11.r, color: AppColors.textHint),
                          SizedBox(width: 3.w),
                          Flexible(
                            child: Text(
                              post.location!,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textHint,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 6.w),
                            child: Container(
                              width: 2.r,
                              height: 2.r,
                              decoration: BoxDecoration(
                                color: AppColors.textDisabled,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                        Icon(Icons.access_time_outlined,
                            size: 11.r, color: AppColors.textHint),
                        SizedBox(width: 3.w),
                        Text(
                          _ago(post.createdAt),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── 3. Image (edge-to-edge) ────────────────────
              if (imageUrl != null)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: AppNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    accentColor: AppColors.primary,
                  ),
                ),

              // ── 4. Footer: stats (left) · actions (right) ──
              Container(
                padding: EdgeInsets.fromLTRB(14.w, 10.h, 10.w, 10.h),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: _dividerColor, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    _QuickStat(
                      icon: Icons.favorite_rounded,
                      count: interests,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 16.w),
                    _QuickStat(
                      icon: Icons.chat_bubble_outline_rounded,
                      count: comments,
                      color: AppColors.textHint,
                    ),
                    SizedBox(width: 16.w),
                    _QuickStat(
                      icon: Icons.card_giftcard_rounded,
                      count: gifts,
                      color: _amber,
                    ),
                    const Spacer(),
                    _InlineBtn(
                      icon: Icons.visibility_off_outlined,
                      onTap: onHide,
                    ),
                    SizedBox(width: 6.w),
                    _InlineBtn(
                      icon: Icons.delete_outline_rounded,
                      isRed: true,
                      onTap: onDelete,
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
}

// ═══════════════════════════════════════════════════════════════
//  PostCardShimmer
// ═══════════════════════════════════════════════════════════════
class PostCardShimmer extends StatelessWidget {
  final bool withImage;
  const PostCardShimmer({super.key, this.withImage = false});

  static const _shimmerBase = Color(0xFFEEEEEE);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _shimmerBase,
      highlightColor: AppColors.surfaceSecondary,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
              child: Row(
                children: [
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: const BoxDecoration(
                      color: _shimmerBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12.h,
                          width: 110.w,
                          color: _shimmerBase,
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          height: 9.h,
                          width: 65.w,
                          color: _shimmerBase,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Text lines
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 11.h,
                    width: double.infinity,
                    color: _shimmerBase,
                  ),
                  SizedBox(height: 6.h),
                  Container(height: 11.h, width: 200.w, color: _shimmerBase),
                ],
              ),
            ),
            if (withImage)
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(color: _shimmerBase),
              ),
            // Footer
            Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: _dividerColor, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(height: 10.h, width: 40.w, color: _shimmerBase),
                  const Spacer(),
                  _box(28, 28, 9),
                  SizedBox(width: 6.w),
                  _box(28, 28, 9),
                  SizedBox(width: 6.w),
                  _box(28, 56, 9),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _box(double h, double w, double r) => Container(
    height: h,
    width: w,
    decoration: BoxDecoration(
      color: _shimmerBase,
      borderRadius: BorderRadius.circular(r),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
//  Shared sub-widgets
// ═══════════════════════════════════════════════════════════════

class _AuthorAvatar extends StatelessWidget {
  final String? imageUrl;
  const _AuthorAvatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: AppNetworkImage(
        imageUrl: imageUrl ?? '',
        width: 36.r,
        height: 36.r,
        fit: BoxFit.cover,
        accentColor: AppColors.primary,
      ),
    );
  }
}

class _TipBadge extends StatelessWidget {
  const _TipBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: _tipBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.volunteer_activism_outlined,
            size: 10.r,
            color: _amberLight,
          ),
          SizedBox(width: 3.w),
          Text(
            'ມີທິບພ້ອມ',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: _amberLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _MyStatusChip extends StatelessWidget {
  final String status;
  const _MyStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            _statusLabel(status),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color fg;
  final Color bg;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.fg,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.r, color: fg),
          SizedBox(width: 3.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _HashtagText extends StatelessWidget {
  final String text;
  const _HashtagText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: text.split(' ').map((w) {
        final isTag = w.startsWith('#');
        return Text(
          '$w ',
          style: TextStyle(
            fontSize: 14.sp,
            color: isTag ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isTag ? FontWeight.w700 : FontWeight.w400,
            height: 1.6,
          ),
        );
      }).toList(),
    );
  }
}

// ── _ActionBtn: animated icon + optional count (no text labels) ──
class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final String? count; // null = icon only
  final Color color;
  final VoidCallback? onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    this.count,
    this.onTap,
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
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.78).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.onTap == null) return;
    _ctrl.forward(from: 0).then((_) => _ctrl.reverse());
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scale,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 18.r, color: widget.color),
            if (widget.count != null) ...[
              SizedBox(width: 4.w),
              Text(
                widget.count!,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: widget.color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── _QuickStat: compact icon + formatted count (MyPostCard row) ──
class _QuickStat extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;

  const _QuickStat({
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.r, color: color),
        SizedBox(width: 5.w),
        Text(
          _fmtCount(count),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _BookBtn extends StatefulWidget {
  final VoidCallback? onTap;
  const _BookBtn({this.onTap});

  @override
  State<_BookBtn> createState() => _BookBtnState();
}

class _BookBtnState extends State<_BookBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.91).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.onTap == null) return;
    _ctrl.forward(from: 0).then((_) => _ctrl.reverse());
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.08),
                AppColors.primary.withValues(alpha: 0.13),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.28),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 11.r,
                color: AppColors.primary,
              ),
              SizedBox(width: 5.w),
              Text(
                'ຈອງ',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
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
        width: 30.r,
        height: 30.r,
        decoration: BoxDecoration(
          color: isRed
              ? _dangerColor.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.04),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 13.r,
          color: isRed ? _dangerColor : AppColors.textHint,
        ),
      ),
    );
  }
}

// model show icon message and contract
// customer show icon like, gift, message and check if Author != null please show booking button
