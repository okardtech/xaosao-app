import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/models/gift_post_model.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/package/components/subscription_banner.dart';
import 'package:xaosao/pages/posts/gift/getx/gifted_posts_logic.dart';
import 'package:xaosao/pages/posts/gift/getx/gifted_posts_state.dart';
import 'package:xaosao/repository/package_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/app_svg_icon.dart';
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

  Future<void> _startChat(Customer? customer) async {
    if (customer?.id == null || customer!.id!.isEmpty) return;
    final isClient =
        Get.find<StorageService>().read<String>('role') == 'customer';
    if (isClient) {
      final activeRes = await PackageRepo().packageActive();
      if (!mounted) return;
      final active = activeRes.data;
      if (active?.neverSubscribed == true) {
        final hourRes = await PackageRepo().packageHour();
        if (hourRes.data == null) return;
        showSubscriptionBanner(context, hourRes.data!);
        return;
      }
      if (active?.hasPendingSubscription == true) {
        showPendingSubscriptionBanner(context);
        return;
      }
      if (active?.hasActiveSubscription != true) {
        showNoSubscriptionBanner(context);
        return;
      }
    }
    final hint = ConversationParticipant(
      id: customer.id!,
      firstName: customer.firstName,
      lastName: customer.lastName,
      profileImage: customer.profile,
    );
    await Get.find<ChatLogic>().startConversation(
      customer.id!,
      partnerHint: hint,
    );
  }

  void _openProfile(Customer? customer) {
    final id = customer?.id ?? '';
    if (id.isEmpty) return;
    Get.toNamed(AppRoutes.customerProfile, arguments: id);
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
        final gifts = state.data?.gifts ?? [];
        if (gifts.isEmpty) {
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

  Widget _buildLoading() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
      child: Column(
        children: [
          const _ShimmerHero(),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (_, __) => const _ShimmerCard(),
            ),
          ),
        ],
      ),
    );
  }

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
          SliverToBoxAdapter(child: _GiftHeroBanner(total: total)),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 12.h),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.secondary, AppColors.primary],
                      ),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'ຜູ້ສົ່ງຂອງຂວັນ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _GiftCard(
                    element: gifts[i],
                    onChat: () => _startChat(gifts[i].customer),
                    onProfile: () => _openProfile(gifts[i].customer),
                  ),
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
//  Gift card — gifter header + gift detail footer
// ═══════════════════════════════════════════════════════════════
class _GiftCard extends StatelessWidget {
  final GiftElement element;
  final VoidCallback? onChat;
  final VoidCallback? onProfile;

  const _GiftCard({required this.element, this.onChat, this.onProfile});

  String _fmtLak(int v) => '${NumberFormat('#,##0', 'en_US').format(v)} ກີບ';

  String _ago(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'ຫາກໍ່';
    if (diff.inHours < 1) return '${diff.inMinutes} ນາທີກ່ອນ';
    if (diff.inDays < 1) return '${diff.inHours} ຊົ່ວໂມງກ່ອນ';
    if (diff.inDays < 30) return '${diff.inDays} ວັນກ່ອນ';
    return DateFormat('dd MMM').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _GifterHeader(
            customer: element.customer,
            timeAgo: _ago(element.createdAt),
            onChat: onChat,
            onProfile: onProfile,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: _DashedDivider(),
          ),
          _GiftDetailRow(
            gift: element.gift,
            amountLabel: _fmtLak(element.amount ?? 0),
          ),
        ],
      ),
    );
  }
}

// ── Gifter header (avatar + name + time + chat) ────────────────
class _GifterHeader extends StatelessWidget {
  final Customer? customer;
  final String timeAgo;
  final VoidCallback? onChat;
  final VoidCallback? onProfile;

  const _GifterHeader({
    required this.customer,
    required this.timeAgo,
    this.onChat,
    this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final fullName = [
      customer?.firstName,
      customer?.lastName,
    ].where((s) => s != null && s.isNotEmpty).join(' ');

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onProfile,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipOval(
                        child: AppNetworkImage(
                          imageUrl: customer?.profile ?? '',
                          width: 46.r,
                          height: 46.r,
                          fit: BoxFit.cover,
                          accentColor: AppColors.primary,
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 20.r,
                          height: 20.r,
                          padding: EdgeInsets.all(3.r),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: AppSvgIcon(
                            assetName: AppIcons.gift,
                            width: 11.w,
                            height: 11.h,
                            color: Colors.white,
                          ),
                          // child: Icon(
                          //   Icons.card_giftcard_rounded,
                          //   size: 11.r,
                          //   color: Colors.white,
                          // ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isEmpty ? 'ຜູ້ໃຊ້' : fullName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          '$timeAgo',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textHint,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onChat,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.22),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSvgIcon(
                    assetName: AppIcons.chatFill,
                    width: 14.w,
                    height: 14.h,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'ແຊັດ',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gift detail row (image + name + amount) ────────────────────
class _GiftDetailRow extends StatelessWidget {
  final GiftSummaryGift? gift;
  final String amountLabel;

  const _GiftDetailRow({required this.gift, required this.amountLabel});

  @override
  Widget build(BuildContext context) {
    final hasImage = (gift?.image ?? '').isNotEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondary.withValues(alpha: 0.12),
                  AppColors.primary.withValues(alpha: 0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(13.r),
                    child: AppNetworkImage(
                      imageUrl: gift!.image!,
                      fit: BoxFit.cover,
                      accentColor: AppColors.primary,
                    ),
                  )
                : Icon(
                    Icons.card_giftcard_rounded,
                    size: 22.r,
                    color: AppColors.primary,
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ຂອງຂວັນ',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHint,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 2.h),
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
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎁', style: TextStyle(fontSize: 12.sp)),
              SizedBox(width: 4.w),
              Text(
                amountLabel,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Dashed divider ─────────────────────────────────────────────
class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashSpace = 3.0;
        final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.06),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Shimmer placeholders
// ═══════════════════════════════════════════════════════════════
class _ShimmerHero extends StatelessWidget {
  const _ShimmerHero();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEEE),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        height: 118.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFEEEEEE);
    return Shimmer.fromColors(
      baseColor: bg,
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
              child: Row(
                children: [
                  Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 120.w, height: 12.h, color: bg),
                        SizedBox(height: 8.h),
                        Container(width: 80.w, height: 10.h, color: bg),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 56.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: bg),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
              child: Row(
                children: [
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 60.w, height: 10.h, color: bg),
                        SizedBox(height: 6.h),
                        Container(width: 100.w, height: 12.h, color: bg),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 70.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
