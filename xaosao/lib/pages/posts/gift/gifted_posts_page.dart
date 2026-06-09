import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/gift_post_model.dart';
import 'package:xaosao/pages/posts/gift/getx/gifted_posts_logic.dart';
import 'package:xaosao/pages/posts/gift/getx/gifted_posts_state.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/empty_state.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class GiftedPostsPage extends StatefulWidget {
  final String postId;
  const GiftedPostsPage({super.key, required this.postId});

  @override
  State<GiftedPostsPage> createState() => _GiftedPostsPageState();
}

class _GiftedPostsPageState extends State<GiftedPostsPage> {
  late final GiftedPostsLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = Get.put(GiftedPostsLogic(postId: widget.postId));
  }

  @override
  void dispose() {
    Get.delete<GiftedPostsLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ຂອງຂວັນ',
        subtitle: 'ຂອງຂວັນທີ່ທ່ານໄດ້ຮັບ',
      ),
      body: SafeArea(top: false, child: Obx(() => _buildBody(_logic.state))),
    );
  }

  Widget _buildBody(GiftedPostsState state) {
    switch (state.status) {
      case GiftedPostsStatus.initial:
      case GiftedPostsStatus.loading:
        return _buildLoading();

      case GiftedPostsStatus.failure:
        return AppEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ',
          subtitle: state.error ?? 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ',
          iconColor: AppColors.primary,
          actionLabel: 'ລອງໃໝ່',
          onAction: _logic.fetch,
        );

      case GiftedPostsStatus.success:
        final summaries = state.data?.gifts ?? [];
        if (summaries.isEmpty) {
          return AppEmptyState(
            icon: Icons.card_giftcard_rounded,
            title: 'ຍັງບໍ່ມີຂອງຂວັນ',
            subtitle: 'ຂອງຂວັນທີ່ຄົນສົ່ງໃຫ້ຈະສະແດງທີ່ນີ້',
            iconColor: AppColors.primary,
          );
        }
        return _buildContent(state);
    }
  }

  // ── Loading shimmer ────────────────────────────────────────────
  Widget _buildLoading() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
      child: Column(
        children: [
          _ShimmerHero(),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (_, __) => _ShimmerRow(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Loaded content ─────────────────────────────────────────────
  Widget _buildContent(GiftedPostsState state) {
    final total = state.data?.totalGifts ?? 0;
    final gifts = state.data?.gifts ?? [];

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      onRefresh: _logic.fetch,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // ── Hero banner ──────────────────────────────────────
          SliverToBoxAdapter(child: _GiftHeroBanner(total: total)),

          // ── Section label ────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 10.h),
            sliver: SliverToBoxAdapter(
              child: Text(
                'ລາຍລະອຽດຂອງຂວັນ',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHint,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // ── Gift list ────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _GiftRow(element: gifts[i]),
                ),
                childCount: gifts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Hero banner — total gift count
// ═══════════════════════════════════════════════════════════════
class _GiftHeroBanner extends StatelessWidget {
  final int total;
  const _GiftHeroBanner({required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 26.h, horizontal: 22.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.secondary, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.38),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 66.r,
              height: 66.r,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Text('🎁', style: TextStyle(fontSize: 30.sp)),
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$total',
                    style: TextStyle(
                      fontSize: 42.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'ຂອງຂວັນທີ່ໄດ້ຮັບທັງໝົດ',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('✨', style: TextStyle(fontSize: 20.sp)),
                SizedBox(height: 6.h),
                Text('💝', style: TextStyle(fontSize: 16.sp)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Gift row (list item — one GiftElement per row)
// ═══════════════════════════════════════════════════════════════
class _GiftRow extends StatelessWidget {
  final GiftElement element;
  const _GiftRow({required this.element});

  String _fmtLak(int v) => NumberFormat('#,##0', 'en_US').format(v) + ' ₭';

  String _ago(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'ຫາກໍ່';
    if (diff.inHours < 1) return '${diff.inMinutes} ນາທີ';
    if (diff.inDays < 1) return '${diff.inHours} ຊ.ມ';
    if (diff.inDays < 30) return '${diff.inDays} ວັນ';
    return DateFormat('dd MMM').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final gift = element.gift;
    final hasImage = (gift?.image ?? '').isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Gift image ───────────────────────────────────────
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: AppNetworkImage(
                      imageUrl: gift!.image!,
                      fit: BoxFit.cover,
                      accentColor: AppColors.primary,
                    ),
                  )
                : Icon(
                    Icons.card_giftcard_rounded,
                    size: 24.r,
                    color: AppColors.primary,
                  ),
          ),
          SizedBox(width: 12.w),

          // ── Name + price ─────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gift?.name ?? 'ຂອງຂວັນ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        _fmtLak(gift?.price ?? 0),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),

          // ── Time ago ─────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('🎁', style: TextStyle(fontSize: 16.sp)),
              SizedBox(height: 4.h),
              Text(
                _ago(element.createdAt),
                style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Shimmer placeholders
// ═══════════════════════════════════════════════════════════════
class _ShimmerHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(24.r),
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bg = Colors.black.withValues(alpha: 0.07);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110.w,
                  height: 13.h,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 70.w,
                  height: 11.h,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 32.w,
            height: 10.h,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
        ],
      ),
    );
  }
}
