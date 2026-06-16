import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/models/interest_model.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/package/components/subscription_banner.dart';
import 'package:xaosao/pages/posts/getx/interest_logic.dart';
import 'package:xaosao/pages/posts/getx/interest_state.dart';
import 'package:xaosao/repository/package_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

import '../../constants/app_icons.dart';
import '../../widgets/app_svg_icon.dart';

class PostInterestPage extends StatefulWidget {
  final String postId;
  const PostInterestPage({super.key, required this.postId});

  @override
  State<PostInterestPage> createState() => _PostInterestPageState();
}

class _PostInterestPageState extends State<PostInterestPage> {
  late final InterestLogic _logic;
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _logic = Get.put(InterestLogic(postId: widget.postId));
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    Get.delete<InterestLogic>();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 80) {
      _logic.loadMore();
    }
  }

  Future<void> _startChat(User? user) async {
    if (user?.id == null || user!.id!.isEmpty) return;
    final isClient =
        Get.find<StorageService>().read<String>('role') == 'customer';
    if (isClient) {
      final activeRes = await PackageRepo().packageActive();
      if (!mounted) return;
      final active = activeRes.data;
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
      id: user.id!,
      firstName: user.firstName,
      lastName: user.lastName,
      profileImage: user.profile,
    );
    await Get.find<ChatLogic>().startConversation(user.id!, partnerHint: hint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: GradientAppBar(
        title: 'ຜູ້ສົນໃຈ',
        subtitle: 'ລາຍຊື່ຜູ້ທີ່ສົນໃຈໂພສຂອງທ່ານ',
      ),
      body: SafeArea(top: false, child: Obx(() => _buildBody(_logic.state))),
    );
  }

  Widget _buildBody(InterestState state) {
    return CustomScrollView(
      controller: _scrollCtrl,
      slivers: [
        switch (state.status) {
          InterestStatus.initial || InterestStatus.loading => _ShimmerSliver(),
          InterestStatus.failure => _FailureSliver(
            onRetry: () => _logic.fetch(refresh: true),
          ),
          _ => state.items.isEmpty ? _EmptySliver() : _buildList(state),
        },
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 20.h),
        ),
      ],
    );
  }

  Widget _buildList(InterestState state) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _InterestTile(
                item: state.items[i],
                onChat: () => _startChat(state.items[i].user),
                onProfile: () {
                  final id = state.items[i].user?.id ?? '';
                  if (id.isEmpty) return;
                  final isModel = state.items[i].userType == 'model';
                  if (isModel) {
                    Get.toNamed(AppRoutes.companionProfile, arguments: id);
                  } else {
                    Get.toNamed(AppRoutes.customerProfile, arguments: id);
                  }
                },
              ),
              childCount: state.items.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: state.status == InterestStatus.loadingMore
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: Center(
                    child: SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ── Single interest row ─────────────────────────────────────────
class _InterestTile extends StatelessWidget {
  final InterestModel item;
  final VoidCallback? onChat;
  final VoidCallback? onProfile;
  const _InterestTile({required this.item, this.onChat, this.onProfile});

  String _ago(DateTime? dt) {
    if (dt == null) return '';
    final d = DateTime.now().difference(dt);
    if (d.inSeconds < 60) return 'ໃໝ່ໆ';
    if (d.inMinutes < 60) return '${d.inMinutes} ນາທີກ່ອນ';
    if (d.inHours < 24) return '${d.inHours} ຊົ່ວໂມງກ່ອນ';
    if (d.inDays < 7) return '${d.inDays} ວັນກ່ອນ';
    return '${(d.inDays / 7).floor()} ອາທິດກ່ອນ';
  }

  @override
  Widget build(BuildContext context) {
    final user = item.user;
    final fullName = [
      user?.firstName,
      user?.lastName,
    ].where((s) => s != null && s.isNotEmpty).join(' ');

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar + name (tappable → profile)
            GestureDetector(
              onTap: onProfile,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipOval(
                        child: AppNetworkImage(
                          imageUrl: user?.profile ?? '',
                          width: 46.r,
                          height: 46.r,
                          fit: BoxFit.cover,
                          accentColor: AppColors.primary,
                        ),
                      ),
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                          width: 20.r,
                          height: 20.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 10.r,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                ],
              ),
            ),

            // Name + time
            Expanded(
              child: GestureDetector(
              onTap: onProfile,
              behavior: HitTestBehavior.opaque,
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
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 10.r,
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        _ago(item.createdAt),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),  // GestureDetector
            ),    // Expanded
            SizedBox(width: 10.w),

            GestureDetector(
              onTap: onChat,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shimmer loading ─────────────────────────────────────────────
class _ShimmerSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFEEEEEE),
              highlightColor: const Color(0xFFF8F8F8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46.r,
                      height: 46.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEEEE),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12.h,
                            width: 120.w,
                            color: const Color(0xFFEEEEEE),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            height: 10.h,
                            width: 70.w,
                            color: const Color(0xFFEEEEEE),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          childCount: 8,
        ),
      ),
    );
  }
}

// ── Failure state ───────────────────────────────────────────────
class _FailureSliver extends StatelessWidget {
  final VoidCallback onRetry;
  const _FailureSliver({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 40.r, color: AppColors.textHint),
            SizedBox(height: 14.h),
            Text(
              'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'ລອງໃໝ່',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ─────────────────────────────────────────────────
class _EmptySliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 36.r,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'ຍັງບໍ່ມີຜູ້ສົນໃຈ',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'ເມື່ອມີຜູ້ກົດໃຈໂພສນີ້,\nຊື່ຂອງພວກເຂົາຈະສະແດງຢູ່ນີ້',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textHint,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
