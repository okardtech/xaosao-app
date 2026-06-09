import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/post_detail_model.dart';
import 'package:xaosao/pages/posts/components/comment_sheet.dart';
import 'package:xaosao/pages/posts/post_detail/getx/post_detail_logic.dart';
import 'package:xaosao/pages/posts/post_detail/getx/post_detail_state.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/empty_state.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;
  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late final PostDetailLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = Get.put(PostDetailLogic(postId: widget.postId));
  }

  @override
  void dispose() {
    Get.delete<PostDetailLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        top: false,
        child: Obx(() => _buildBody(_logic.state)),
      ),
    );
  }

  Widget _buildBody(PostDetailState state) {
    switch (state.status) {
      case PostDetailStatus.initial:
      case PostDetailStatus.loading:
        return _buildLoading();

      case PostDetailStatus.failure:
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
          body: AppEmptyState(
            icon: Icons.wifi_off_rounded,
            title: 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ',
            subtitle: state.error ?? 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ',
            iconColor: AppColors.primary,
            actionLabel: 'ລອງໃໝ່',
            onAction: _logic.fetch,
          ),
        );

      case PostDetailStatus.success:
        return _buildContent(state.data!);
    }
  }

  // ── Main content ───────────────────────────────────────────────
  Widget _buildContent(PostDetailModel data) {
    final post = data.post;
    final author = data.author;
    final images = post?.images ?? [];
    final giftedUsers = data.giftedUsers ?? [];
    final interestedCount = data.interestedCount ?? 0;
    final commentCount = post?.interestedCount ?? 0;

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Hero / App Bar ─────────────────────────────────
            SliverAppBar(
              pinned: true,
              expandedHeight: images.isNotEmpty ? 320.h : 0,
              backgroundColor: AppColors.bg,
              elevation: 0,
              leading: _BackButton(),
              flexibleSpace: images.isNotEmpty
                  ? FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: _ImageCarousel(images: images),
                    )
                  : null,
            ),

            // ── Author card ────────────────────────────────────
            SliverToBoxAdapter(
              child: _AuthorCard(author: author, post: post),
            ),

            // ── Content ────────────────────────────────────────
            SliverToBoxAdapter(
              child: _ContentCard(post: post),
            ),

            // ── Stats row ──────────────────────────────────────
            SliverToBoxAdapter(
              child: _StatsRow(
                interestedCount: interestedCount,
                giftCount: giftedUsers.length,
                commentCount: commentCount,
                onComment: () => CommentSheet.show(
                  context,
                  postId: widget.postId,
                  commentCount: commentCount,
                ),
              ),
            ),

            // ── Gifted users ───────────────────────────────────
            if (giftedUsers.isNotEmpty) ...[
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 6.h),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'ຜູ້ສົ່ງຂອງຂວັນ',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHint,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: _GiftedUserRow(user: giftedUsers[i]),
                    ),
                    childCount: giftedUsers.length,
                  ),
                ),
              ),
            ],

            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),

        // ── Floating comment button ─────────────────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _CommentBar(
            postId: widget.postId,
            commentCount: commentCount,
          ),
        ),
      ],
    );
  }

  // ── Loading shimmer ────────────────────────────────────────────
  Widget _buildLoading() {
    final bg = Colors.black.withValues(alpha: 0.07);
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 300.h,
          backgroundColor: AppColors.bg,
          elevation: 0,
          leading: _BackButton(),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(color: bg),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  height: i == 0 ? 72.h : 40.h,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              childCount: 5,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Back button
// ═══════════════════════════════════════════════════════════════
class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        margin: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.r, color: AppColors.primaryVariant),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Image carousel
// ═══════════════════════════════════════════════════════════════
class _ImageCarousel extends StatefulWidget {
  final List<String> images;
  const _ImageCarousel({required this.images});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  final _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          onPageChanged: (i) => setState(() => _current = i),
          itemCount: widget.images.length,
          itemBuilder: (_, i) => AppNetworkImage(
            imageUrl: widget.images[i],
            fit: BoxFit.cover,
            accentColor: AppColors.primary,
          ),
        ),
        if (widget.images.length > 1)
          Positioned(
            bottom: 12.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: _current == i ? 18.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: _current == i
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ),
          ),
        // gradient overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.bg,
                  AppColors.bg.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Author card
// ═══════════════════════════════════════════════════════════════
class _AuthorCard extends StatelessWidget {
  final Author? author;
  final Post? post;
  const _AuthorCard({this.author, this.post});

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'ໃໝ່ໆ';
    if (d.inHours < 1) return '${d.inMinutes} ນາທີ';
    if (d.inDays < 1) return '${d.inHours} ຊ.ມ';
    if (d.inDays < 30) return '${d.inDays} ວັນ';
    return DateFormat('dd MMM yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final hasProfile = (author?.profile ?? '').isNotEmpty;
    final name = '${author?.firstName ?? ''} ${author?.lastName ?? ''}'.trim();
    final isModel = post?.authorType == 'model';

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.secondary, AppColors.primary],
              ),
            ),
            child: hasProfile
                ? ClipOval(
                    child: AppNetworkImage(
                      imageUrl: author!.profile!,
                      fit: BoxFit.cover,
                      accentColor: AppColors.primary,
                    ),
                  )
                : Icon(Icons.person_rounded, size: 24.r, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name.isEmpty ? 'ຜູ້ໃຊ້' : name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: isModel
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        isModel ? 'ໂມເດວ' : 'ລູກຄ້າ',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: isModel ? AppColors.primary : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  _timeAgo(post?.createdAt),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                ),
              ],
            ),
          ),
          if (post?.status != null)
            _StatusChip(status: post!.status!),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        isActive ? 'ເປີດຢູ່' : 'ປິດ',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Content card
// ═══════════════════════════════════════════════════════════════
class _ContentCard extends StatefulWidget {
  final Post? post;
  const _ContentCard({this.post});

  @override
  State<_ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<_ContentCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final content = widget.post?.content ?? '';
    final hasTip = widget.post?.hasTip ?? false;
    final location = widget.post?.location?.toString() ?? '';
    final isLong = content.length > 180;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.isNotEmpty) ...[
            Text(
              content,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryVariant,
                height: 1.6,
              ),
              maxLines: _expanded ? null : 5,
              overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (isLong) ...[
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'ຫຍໍ້ລົງ' : 'ອ່ານເພີ່ມ',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
          if (location.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.location_on_rounded, size: 14.r, color: AppColors.primary),
                SizedBox(width: 4.w),
                Text(
                  location,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                ),
              ],
            ),
          ],
          if (hasTip) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('💰', style: TextStyle(fontSize: 12.sp)),
                  SizedBox(width: 4.w),
                  Text(
                    'ມີທິບ',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Stats row
// ═══════════════════════════════════════════════════════════════
class _StatsRow extends StatelessWidget {
  final int interestedCount;
  final int giftCount;
  final int commentCount;
  final VoidCallback onComment;
  const _StatsRow({
    required this.interestedCount,
    required this.giftCount,
    required this.commentCount,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatItem(
            icon: Icons.favorite_rounded,
            color: AppColors.primary,
            count: interestedCount,
            label: 'ສົນໃຈ',
          ),
          _dividerV(),
          _StatItem(
            icon: Icons.card_giftcard_rounded,
            color: const Color(0xFFFF9800),
            count: giftCount,
            label: 'ຂອງຂວັນ',
          ),
          _dividerV(),
          GestureDetector(
            onTap: onComment,
            behavior: HitTestBehavior.opaque,
            child: _StatItem(
              icon: Icons.chat_bubble_rounded,
              color: Colors.blue,
              count: commentCount,
              label: 'ຄຳເຫັນ',
              tappable: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerV() => Container(
    width: 1,
    height: 36.h,
    color: Colors.black.withValues(alpha: 0.06),
    margin: EdgeInsets.symmetric(horizontal: 8.w),
  );
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;
  final String label;
  final bool tappable;
  const _StatItem({
    required this.icon,
    required this.color,
    required this.count,
    required this.label,
    this.tappable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.r, color: color),
              SizedBox(width: 4.w),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryVariant,
                ),
              ),
              if (tappable) ...[
                SizedBox(width: 2.w),
                Icon(Icons.chevron_right_rounded, size: 14.r, color: AppColors.textHint),
              ],
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Gifted user row
// ═══════════════════════════════════════════════════════════════
class _GiftedUserRow extends StatelessWidget {
  final GiftedUser user;
  const _GiftedUserRow({required this.user});

  @override
  Widget build(BuildContext context) {
    final hasProfile = (user.user?.profile ?? '').isNotEmpty;
    final name = '${user.user?.firstName ?? ''} ${user.user?.lastName ?? ''}'.trim();
    final hasGiftImage = (user.gift?.image ?? '').isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── User avatar ──────────────────────────────────────
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.secondary, AppColors.primary],
              ),
            ),
            child: hasProfile
                ? ClipOval(
                    child: AppNetworkImage(
                      imageUrl: user.user!.profile!,
                      fit: BoxFit.cover,
                      accentColor: AppColors.primary,
                    ),
                  )
                : Icon(Icons.person_rounded, size: 18.r, color: Colors.white),
          ),
          SizedBox(width: 10.w),

          // ── Name ─────────────────────────────────────────────
          Expanded(
            child: Text(
              name.isEmpty ? 'ຜູ້ໃຊ້' : name,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),

          // ── Gift info ─────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: hasGiftImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: AppNetworkImage(
                          imageUrl: user.gift!.image!,
                          fit: BoxFit.cover,
                          accentColor: AppColors.primary,
                        ),
                      )
                    : Icon(Icons.card_giftcard_rounded, size: 14.r, color: AppColors.primary),
              ),
              SizedBox(width: 6.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    user.gift?.name ?? 'ຂອງຂວັນ',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryVariant,
                    ),
                  ),
                  if ((user.amount ?? 0) > 1)
                    Text(
                      '×${user.amount}',
                      style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Floating comment bar at bottom
// ═══════════════════════════════════════════════════════════════
class _CommentBar extends StatelessWidget {
  final String postId;
  final int commentCount;
  const _CommentBar({required this.postId, required this.commentCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => CommentSheet.show(
          context,
          postId: postId,
          commentCount: commentCount,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 18.r,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'ຂຽນຄຳເຫັນ...',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              if (commentCount > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '$commentCount',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
