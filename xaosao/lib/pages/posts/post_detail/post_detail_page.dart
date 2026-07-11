import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/models/post_detail_model.dart';
import 'package:xaosao/pages/posts/components/comment_sheet.dart';
import 'package:xaosao/pages/posts/post_detail/getx/post_detail_logic.dart';
import 'package:xaosao/pages/posts/post_detail/getx/post_detail_state.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/app_svg_icon.dart';
import 'package:xaosao/widgets/empty_state.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

import '../../../widgets/app_image_preview.dart';

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
      appBar: const GradientAppBar(title: 'ລາຍລະອຽດໂພສ'),
      body: Obx(() => _buildBody(_logic.state)),
    );
  }

  Widget _buildBody(PostDetailState state) {
    switch (state.status) {
      case PostDetailStatus.initial:
      case PostDetailStatus.loading:
        return _buildLoading();

      case PostDetailStatus.failure:
        return AppEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ',
          subtitle: state.error ?? 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ',
          iconColor: AppColors.primary,
          actionLabel: 'ລອງໃໝ່',
          onAction: _logic.fetch,
        );

      case PostDetailStatus.success:
        return _buildContent(state.data!);
    }
  }

  Widget _buildContent(PostDetailModel data) {
    final post = data.post;
    final author = data.author;
    final images = post?.images ?? [];
    final giftCount = data.giftedUsers?.length ?? 0;
    final interestedCount = data.interestedCount ?? 0;
    final commentCount = post?.interestedCount ?? 0;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          sliver: SliverToBoxAdapter(
            child: _PostCard(
              author: author,
              post: post,
              images: images,
              interestedCount: interestedCount,
              giftCount: giftCount,
              commentCount: commentCount,
              onComment: () => CommentSheet.show(
                context,
                postId: widget.postId,
                commentCount: commentCount,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    final bg = Colors.black.withValues(alpha: 0.07);
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  height: i == 0
                      ? 200.h
                      : i == 1
                      ? 120.h
                      : 60.h,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
              childCount: 3,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _PostCard — single card: author + content + stats
// ═══════════════════════════════════════════════════════════════
class _PostCard extends StatefulWidget {
  final Author? author;
  final Post? post;
  final List<String> images;
  final int interestedCount;
  final int giftCount;
  final int commentCount;
  final VoidCallback onComment;

  const _PostCard({
    this.author,
    this.post,
    required this.images,
    required this.interestedCount,
    required this.giftCount,
    required this.commentCount,
    required this.onComment,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _expanded = false;

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'ໃໝ່ໆ';
    if (d.inHours < 1) return '${d.inMinutes} ນາທີກ່ອນ';
    if (d.inDays < 1) return '${d.inHours} ຊົ່ວໂມງກ່ອນ';
    if (d.inDays < 30) return '${d.inDays} ວັນກ່ອນ';
    return DateFormat('dd MMM yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final author = widget.author;
    final post = widget.post;
    final hasProfile = (author?.profile ?? '').isNotEmpty;
    final name = '${author?.firstName ?? ''} ${author?.lastName ?? ''}'.trim();
    final isModel = post?.authorType == 'model';
    final isActive = post?.status == 'active';
    final content = post?.content ?? '';
    final hasTip = post?.hasTip ?? false;
    final location = post?.location?.toString() ?? '';
    final isLong = content.length > 180;

    // Outer Container carries the shadow; ClipRRect inside clips content
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: ColoredBox(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image carousel (inside card, top) ────────────────
              if (widget.images.isNotEmpty)
                SizedBox(
                  height: 260.h,
                  child: _ImageCarousel(images: widget.images),
                ),

              // ── Author row ────────────────────────────────────────
              GestureDetector(
                onTap: () {
                  final id = author?.id ?? '';
                  if (id.isEmpty) return;
                  if (isModel) {
                    Get.toNamed(AppRoutes.companionProfile, arguments: id);
                  } else {
                    Get.toNamed(AppRoutes.customerProfile, arguments: id);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 50.r,
                        height: 50.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
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
                            : Icon(
                                Icons.person_rounded,
                                size: 24.r,
                                color: Colors.white,
                              ),
                      ),
                      SizedBox(width: 12.w),

                      // Name + role + time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.isEmpty ? 'ຜູ້ໃຊ້' : name,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              _timeAgo(post?.createdAt),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status chip
                      if (post?.status != null) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withValues(alpha: 0.10)
                                : Colors.grey.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            isActive ? 'ກຳລັງເປີດ' : 'ປິດເເລ້ວ',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: isActive ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ), // GestureDetector
              // ── Content section ───────────────────────────────────
              if (content.isNotEmpty || location.isNotEmpty || hasTip) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
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
                          overflow: _expanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
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
                            Icon(
                              Icons.location_on_rounded,
                              size: 14.r,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              location,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (hasTip) ...[
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.volunteer_activism_outlined,
                                  size: 13.r,
                                  color: const Color(0xFFF59E0B),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'ມີທິບໃຫ້ພ້ອມ',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFF59E0B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],

              // ── Stats row ─────────────────────────────────────────
              Container(
                margin: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 12.h),
                padding: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        icon: Icons.favorite_rounded,
                        color: AppColors.primary,
                        count: widget.interestedCount,
                        label: 'ສົນໃຈ',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: Colors.black.withValues(alpha: 0.06),
                    ),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.card_giftcard_rounded,
                        color: const Color(0xFFFF9800),
                        count: widget.giftCount,
                        label: 'ຂອງຂວັນ',
                        iconName: AppIcons.gift,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: Colors.black.withValues(alpha: 0.06),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onComment,
                        behavior: HitTestBehavior.opaque,
                        child: _StatItem(
                          icon: Icons.chat_bubble_rounded,
                          color: Colors.blue,
                          count: widget.commentCount,
                          iconName: AppIcons.comment,
                          label: 'ຄຳເຫັນ',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ), // Column
        ), // ColoredBox
      ), // ClipRRect
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;
  final String label;
  final String? iconName;
  const _StatItem({
    required this.icon,
    required this.color,
    required this.count,
    required this.label,
    this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconName != null) ...[
            Container(
              width: 38.r,
              height: 38.r,
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: AppSvgIcon(
                assetName: iconName ?? "",
                width: 18.w,
                height: 18.h,
                color: color,
              ),
            ),
          ] else
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18.r, color: color),
            ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textHint,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ImageCarousel
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
          itemBuilder: (_, i) => GestureDetector(
            onTap: () =>
                AppImagePreview.show(context, widget.images, initialIndex: i),
            child: AppNetworkImage(
              imageUrl: widget.images[i],
              fit: BoxFit.cover,
              accentColor: AppColors.primary,
            ),
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
        // Bottom fade
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 60.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.bg, AppColors.bg.withValues(alpha: 0)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
