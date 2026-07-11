import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/Recommended_model.dart';
import 'package:xaosao/models/review_model.dart';
import 'package:xaosao/pages/package/components/subscription_banner.dart';
import 'package:xaosao/pages/package/getx/package_logic.dart';
import 'package:xaosao/pages/wallet/getx/wallet_logic.dart';
import 'package:xaosao/repository/package_repo.dart';
import 'package:xaosao/repository/review_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/utils/deep_link_share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/widgets/app_image_preview.dart';
import 'package:xaosao/widgets/app_like_button.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import '../../constants/app_icons.dart';
import '../../models/model_available.dart';
import '../../utils/service_helper.dart';
import '../../widgets/app_svg_icon.dart';
import '../booking/booking_args.dart';
import 'getx/companion_logic.dart';
import 'getx/companion_state.dart';

class CompanionProfilePage extends StatefulWidget {
  final String modelId;
  const CompanionProfilePage({super.key, required this.modelId});

  @override
  State<CompanionProfilePage> createState() => _CompanionProfilePageState();
}

class _CompanionProfilePageState extends State<CompanionProfilePage> {
  late final CompanionLogic _logic;
  late final ScrollController _scrollCtrl;
  bool _showTitle = false;
  bool _scrolledToService = false;
  final GlobalKey _serviceKey = GlobalKey();

  static const double _photoHeight = 340;
  static const double _titleThreshold = 200;

  String get _tag => widget.modelId;

  @override
  void initState() {
    super.initState();
    _logic = Get.put(CompanionLogic(modelId: widget.modelId), tag: _tag);
    _scrollCtrl = ScrollController()..addListener(_onScroll);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    Get.delete<CompanionLogic>(tag: _tag, force: true);
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollCtrl.offset > _titleThreshold;
    if (show != _showTitle) setState(() => _showTitle = show);

    if (!_scrollCtrl.hasClients) return;
    final remaining =
        _scrollCtrl.position.maxScrollExtent - _scrollCtrl.position.pixels;
    if (remaining < 300) _logic.loadReviews();
  }

  List<String> _photos(RecommendedModel model) {
    final imgs = model.images ?? [];
    if (imgs.isNotEmpty) return imgs;
    if (model.profile != null) return [model.profile!];
    return [];
  }

  int _age(RecommendedModel model) {
    final dob = model.dob;
    if (dob == null) return 0;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: Column(
        children: [
          Expanded(child: _buildScrollView()),
          Obx(
            () => _BookingBar(
              selectedService: _logic.selectedService,
              onBook: _onBook,
            ),
          ),
        ],
      ),
    );
  }

  // ── CustomScrollView ──────────────────────────────────────────
  Widget _buildScrollView() {
    return CustomScrollView(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── SliverAppBar with photo ──────────────────────────────
        SliverAppBar(
          expandedHeight: _photoHeight,
          pinned: true,
          stretch: true,
          backgroundColor: AppColors.primary,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Obx(() {
              final status = _logic.state.profileStatus;
              final profile = _logic.state.profile;
              if (status == CompanionLoadStatus.initial ||
                  status == CompanionLoadStatus.loading ||
                  profile == null) {
                return _PhotoShimmer(height: _photoHeight);
              }
              return _PhotoSlider(
                photos: _photos(profile),
                height: _photoHeight,
                model: profile,
                age: _age(profile),
              );
            }),
          ),
          leading: _AppBarIcon(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
          title: AnimatedOpacity(
            opacity: _showTitle ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Obx(() {
              final profile = _logic.state.profile;
              if (profile == null) return const SizedBox.shrink();
              final age = _age(profile);
              return Text(
                '${profile.firstName ?? ''}, $age',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              );
            }),
          ),
          actions: [
            Obx(() {
              final profile = _logic.state.profile;
              if (profile == null) return const SizedBox.shrink();
              return AppLikeButton(
                initialLiked: profile.isLiked,
                size: 34,
                iconSize: 16,
                unlikedBg: Colors.black.withValues(alpha: 0.25),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                margin: EdgeInsets.symmetric(vertical: 8.h),
                onToggle: () async {
                  final isClient =
                      Get.find<StorageService>().read<String>('role') ==
                      'customer';
                  final res = await ReviewRepo().addLike(
                    isClient: isClient,
                    id: profile.id ?? '',
                  );
                  return res.success;
                },
              );
            }),
            SizedBox(width: 6.w),
            Obx(() {
              final profile = _logic.state.profile;
              return _AppBarIcon(
                icon: Icons.share_outlined,
                onTap: () {
                  final id = profile?.id;
                  if (id == null || id.isEmpty) return;
                  DeepLinkShare.shareCompanion(
                    companionId: id,
                    displayName: profile?.firstName,
                  );
                },
              );
            }),
            SizedBox(width: 12.w),
          ],
        ),

        // ── Body sections ────────────────────────────────────────
        SliverToBoxAdapter(
          child: Obx(() {
            final status = _logic.state.profileStatus;
            final profile = _logic.state.profile;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildActionRow(),
                if (status == CompanionLoadStatus.initial ||
                    status == CompanionLoadStatus.loading ||
                    profile == null)
                  _Section(title: 'ຂໍ້ມູນສ່ວນຕົວ', child: _ProfileInfoShimmer())
                else
                  _Section(
                    title: 'ຂໍ້ມູນສ່ວນຕົວ',
                    child: _buildInfoGrid(profile),
                  ),
                _Section(
                  key: _serviceKey,
                  title: 'ເລືອກບໍລິການ',
                  child: Obx(() => _buildServicesSection()),
                ),
                _Section(
                  title: 'ຄະແນນ ແລະ ລີວິວ',
                  child: Obx(() => _buildReviewSection()),
                ),
                SizedBox(height: 24.h),
              ],
            );
          }),
        ),
      ],
    );
  }

  // ── Info grid ─────────────────────────────────────────────────
  Widget _buildInfoGrid(RecommendedModel profile) {
    final age = _age(profile);
    final memberSince = profile.createdAt != null
        ? DateFormat('MMM yyyy').format(profile.createdAt!)
        : '—';
    final isAvailable = profile.status == 'active';
    final statusLabel = isAvailable ? 'ໃຊ້ງານຢູ່' : 'ບໍ່ໄດ້ໃຊ້ງານ';
    final statusColor = isAvailable ? AppColors.online : AppColors.primary;
    final address = profile.address != null ? '${profile.address}' : '—';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── 3-stat strip ────────────────────────────────────────
          IntrinsicHeight(
            child: Row(
              children: [
                _StatStrip(label: 'ອາຍຸ', value: age > 0 ? '$age ປີ' : '—'),
                _StatStripDivider(),
                _StatStrip(label: 'ສະມາຊິກຕັ້ງແຕ່', value: memberSince),
                _StatStripDivider(),
                _StatStrip(
                  label: 'ສະຖານະ',
                  value: statusLabel,
                  valueColor: statusColor,
                ),
              ],
            ),
          ),
          // ── address ─────────────────────────────────────────────
          Divider(
            height: 1,
            thickness: 0.5,
            endIndent: 10.w,
            indent: 10.w,
            color: Colors.black.withValues(alpha: 0.06),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 13.r,
                  color: AppColors.textHint,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ທີ່ຢູ່',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        address,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToService() {
    final ctx = _serviceKey.currentContext;
    if (ctx == null || !_scrollCtrl.hasClients) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      alignment: 0.0,
    );
  }

  // ── Services section ──────────────────────────────────────────
  Widget _buildServicesSection() {
    final st = _logic.state;

    if (st.servicesStatus == CompanionLoadStatus.initial ||
        st.servicesStatus == CompanionLoadStatus.loading) {
      return _ServicesShimmer();
    }

    if (st.servicesStatus == CompanionLoadStatus.failure) {
      return _RetryCard(onRetry: _logic.loadServices);
    }

    if (!_scrolledToService) {
      _scrolledToService = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToService());
    }

    if (st.services.isEmpty) {
      return _EmptyCard(
        icon: Icons.spa_outlined,
        message: 'ບໍ່ມີບໍລິການໃນຂະນະນີ້',
      );
    }

    return Column(
      children: List.generate(st.services.length, (i) {
        final svc = st.services[i];
        final isSelected = st.selectedServiceId == svc.id;
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _ServiceCard(
            service: svc,
            index: i,
            isSelected: isSelected,
            onTap: () => _logic.selectService(svc.id ?? ""),
          ),
        );
      }),
    );
  }

  // ── Review section ────────────────────────────────────────────
  Widget _buildReviewSection() {
    final st = _logic.state;
    final isLoading =
        st.reviewStatus == ReviewLoadStatus.initial ||
        st.reviewStatus == ReviewLoadStatus.loading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRatingHeader(st.profile),
        SizedBox(height: 10.h),
        if (isLoading) ...[
          _ReviewShimmer(),
          SizedBox(height: 6.h),
          _ReviewShimmer(),
        ] else if (st.reviewStatus == ReviewLoadStatus.failure) ...[
          _RetryCard(onRetry: () => _logic.loadReviews(refresh: true)),
        ] else if (st.reviews.isEmpty) ...[
          _EmptyCard(
            icon: Icons.star_border_rounded,
            message: 'ຍັງບໍ່ມີລີວິວ ເປັນຄົນທຳອິດ!',
          ),
        ] else ...[
          ...st.reviews.map(
            (r) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _ReviewCard(review: r),
            ),
          ),
          if (st.reviewStatus == ReviewLoadStatus.loadingMore)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          if (st.reviewHasMore && st.reviewStatus == ReviewLoadStatus.success)
            GestureDetector(
              onTap: () => _logic.loadReviews(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.30),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'ໂຫຼດລີວິວເພີ່ມ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  // ── Rating header card ────────────────────────────────────────
  Widget _buildRatingHeader(RecommendedModel? profile) {
    final rating = profile?.rating ?? 0.0;
    final totalReviews = profile?.totalReview ?? 0;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.07),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              _Stars(rating: rating, size: 14.r),
              SizedBox(height: 4.h),
              Text(
                '$totalReviews ລີວິວ',
                style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.addReview,
              arguments: {
                'modelId': profile?.id ?? '',
                'companionName': profile?.firstName ?? '',
                'tag': _tag,
              },
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.pinkGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_rounded, size: 13.r, color: Colors.white),
                  SizedBox(width: 5.w),
                  Text(
                    'ຂຽນລີວິວ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  // ── Action row ────────────────────────────────────────────────
  Widget _buildActionRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              final loading = _logic.chatLoading.value;
              return GestureDetector(
                onTap: loading ? null : _startChat,
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13.r),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.08),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: loading
                      ? Center(
                          child: SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppSvgIcon(
                              assetName: AppIcons.chatFill,
                              width: 12.w,
                              height: 12.h,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'ເເຊັດ',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            }),
          ),
          SizedBox(width: 8.w),
          Obx(() {
            final profile = _logic.state.profile;
            final loading = _logic.friendLoading.value;
            final isFriend = profile?.isFriend ?? false;
            return GestureDetector(
              onTap: (loading || profile == null) ? null : _logic.toggleFriend,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 44.h,
                width: 44.h,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: isFriend
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(13.r),
                  border: Border.all(
                    color: isFriend
                        ? AppColors.primary.withValues(alpha: 0.30)
                        : Colors.black.withValues(alpha: 0.08),
                    width: isFriend ? 1.0 : 0.5,
                  ),
                ),
                child: loading
                    ? Center(
                        child: SizedBox(
                          width: 16.r,
                          height: 16.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : AppSvgIcon(
                        assetName: isFriend
                            ? AppIcons.userCheck
                            : AppIcons.userAdd,
                        width: 18.w,
                        height: 18.h,
                        color: isFriend
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                // : Icon(
                //     isFriend
                //         ? Icons.person_rounded
                //         : Icons.person_add_alt_1_rounded,
                //     size: 18.r,
                //     color: isFriend
                //         ? AppColors.primary
                //         : AppColors.textPrimary,
                //   ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _startChat() async {
    if (_logic.chatLoading.value) return;
    _logic.chatLoading.value = true;
    try {
      final activeRes = await PackageRepo().packageActive();
      if (!mounted) return;

      final active = activeRes.data;

      if (active?.neverSubscribed == true) {
        final hourRes = await PackageRepo().packageHour();
        if (hourRes.data == null) {
          return;
        }
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

      final profile = _logic.state.profile;
      final hint = profile == null
          ? null
          : ConversationParticipant(
              id: profile.id ?? '',
              firstName: profile.firstName,
              lastName: profile.lastName,
              profileImage: profile.profile,
              isOnline: profile.online,
            );
      await Get.find<ChatLogic>().startConversation(
        profile?.id ?? '',
        partnerHint: hint,
      );
    } finally {
      _logic.chatLoading.value = false;
    }
  }

  Future<void> _onBook() async {
    final svc = _logic.selectedService;
    if (svc == null) return;
    final profile = _logic.state.profile;
    if (profile == null) return;

    // 1. Check subscription status first
    final activeRes = await PackageRepo().packageActive();
    if (!mounted) return;

    final active = activeRes.data;

    if (active?.neverSubscribed == true) {
      final hourRes = await PackageRepo().packageHour();
      if (hourRes.data == null) {
        return;
      }
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

    // 2. Check wallet balance
    final wallet = (Get.find<WalletLogic>().state.wallet?.availableBalance ?? 0)
        .toDouble();
    final serviceRate = _serviceRate(svc);

    if (wallet < serviceRate) {
      showInsufficientWalletBanner(
        context,
        walletBalance: wallet,
        serviceRate: serviceRate,
      );
      return;
    }

    // 3. Navigate to booking
    final name = [
      profile.firstName,
      profile.lastName,
    ].where((s) => s != null && s.isNotEmpty).join(' ');
    Get.toNamed(
      AppRoutes.booking,
      arguments: BookingArgs(
        service: svc,
        companionId: profile.id ?? '',
        companionName: name.isEmpty ? 'Unknown' : name,
        companionPhoto: profile.profile,
      ),
    );
  }

  double _serviceRate(ModelAvailable svc) {
    final isMassage = svc.name?.toLowerCase().contains('massage') ?? false;
    if (isMassage) {
      final vs = svc.variants;
      if (vs != null && vs.isNotEmpty) {
        final prices = vs
            .map((v) => v.pricePerHour)
            .whereType<double>()
            .toList();
        if (prices.isNotEmpty) return prices.reduce((a, b) => a < b ? a : b);
      }
    }
    return svc.effectiveRate ?? 0.0;
  }
}

// ═══════════════════════════════════════════════════════════════
//  _PhotoSlider — pageview with overlay
// ═══════════════════════════════════════════════════════════════
class _PhotoSlider extends StatefulWidget {
  final List<String> photos;
  final double height;
  final RecommendedModel model;
  final int age;

  const _PhotoSlider({
    required this.photos,
    required this.height,
    required this.model,
    required this.age,
  });

  @override
  State<_PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<_PhotoSlider>
    with TickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _current = 0;

  // One-time "tap to expand" hint
  bool _showHint = true;

  // Press-feedback scale for the tapped photo
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  // Pulse animation for the expand affordance chip
  late final AnimationController _pulseCtrl;

  int get _count => widget.photos.isEmpty ? 1 : widget.photos.length;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Auto-fade the hint after a few seconds.
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) setState(() => _showHint = false);
    });

    // Warm the cache for neighboring photos so swipe-then-tap is instant.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.photos.isEmpty) return;
      for (final i in [1, 2]) {
        if (i >= widget.photos.length) break;
        precacheImage(
          NetworkImage(widget.photos[i]),
          context,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _pressCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _openPreview(int i) {
    if (widget.photos.isEmpty) return;
    AppImagePreview.show(context, widget.photos, initialIndex: i);
    if (_showHint) setState(() => _showHint = false);
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
            itemBuilder: (context, i) {
              if (widget.photos.isEmpty) return _gradientFallback();
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => _pressCtrl.forward(),
                onTapCancel: () => _pressCtrl.reverse(),
                onTapUp: (_) => _pressCtrl.reverse(),
                onTap: () => _openPreview(i),
                child: ScaleTransition(
                  scale: _pressScale,
                  child: Hero(
                    tag: 'preview_${widget.photos[i]}_$i',
                    child: AppNetworkImage(
                      imageUrl: widget.photos[i],
                      fit: BoxFit.cover,
                      errorWidget: _gradientFallback(),
                    ),
                  ),
                ),
              );
            },
          ),

          // Bottom gradient — wrap in IgnorePointer so taps reach the photo.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
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
          ),

          // Page dots
          if (_count > 1)
            Positioned(
              top: 14.h,
              left: 0,
              right: 0,
              child: IgnorePointer(
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
                            : Colors.white.withValues(alpha: 0.40),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    );
                  }),
                ),
              ),
            ),

          // Expand affordance — combines counter + zoom hint, with pulse.
          if (widget.photos.isNotEmpty)
            Positioned(
              bottom: 150.h,
              right: 14.w,
              child: GestureDetector(
                onTap: () => _openPreview(_current),
                child: _ExpandAffordance(
                  pulse: _pulseCtrl,
                  label: _count > 1
                      ? '${_current + 1} / $_count'
                      : 'ເບິ່ງຮູບ',
                ),
              ),
            ),

          // One-time floating hint near the top.
          if (widget.photos.isNotEmpty)
            Positioned(
              top: 70.h,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: AnimatedSlide(
                  offset: _showHint ? Offset.zero : const Offset(0, -0.4),
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: _showHint ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 320),
                    child: Center(child: _TapHintChip()),
                  ),
                ),
              ),
            ),

          // Info overlay — wrap with IgnorePointer so the photo stays tappable.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: _InfoOverlay(model: widget.model, age: widget.age),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientFallback() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: AppColors.pinkGradient,
      ),
    ),
  );
}

// ── Expand affordance chip ─────────────────────────────────────
class _ExpandAffordance extends StatelessWidget {
  final Animation<double> pulse;
  final String label;
  const _ExpandAffordance({required this.pulse, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, child) {
        final t = pulse.value;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.10 + 0.18 * t),
                blurRadius: 10 + 6 * t,
                spreadRadius: 0.4 * t,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.zoom_out_map_rounded,
              size: 12.r,
              color: Colors.white.withValues(alpha: 0.95),
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── One-time "tap to zoom" hint chip ───────────────────────────
class _TapHintChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.touch_app_rounded, size: 13.r, color: Colors.white),
          SizedBox(width: 6.w),
          Text(
            'ກົດທີ່ຮູບເພື່ອຂະຫຍາຍ',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _InfoOverlay — name, badges, stats strip
// ═══════════════════════════════════════════════════════════════
class _InfoOverlay extends StatelessWidget {
  final RecommendedModel model;
  final int age;
  const _InfoOverlay({required this.model, required this.age});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badges
          Row(
            children: [
              if (model.online)
                _Badge(
                  label: 'ອອນລາຍ',
                  bg: const Color(0xE022C55E),
                  fg: Colors.white,
                  dot: true,
                ),
              if (model.online) SizedBox(width: 6.w),
              if (model.isVip)
                _Badge(
                  label: '★ VIP',
                  bg: const Color(0xBF1A1A2E),
                  fg: AppColors.vipGold,
                  border: AppColors.vipGold.withValues(alpha: 0.30),
                ),
            ],
          ),
          SizedBox(height: 8.h),

          // Name + age
          Text(
            '${model.firstName ?? ''} ${model.lastName ?? ''}'.trim() +
                (age > 0 ? ', $age' : ''),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),

          // Bio snippet
          if (model.bio != null && model.bio!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              model.bio!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white.withValues(alpha: 0.60),
              ),
            ),
          ],
          SizedBox(height: 12.h),

          // Stats strip
          _StatsStrip(model: model),
        ],
      ),
    );
  }
}

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

class _StatsStrip extends StatelessWidget {
  final RecommendedModel model;
  const _StatsStrip({required this.model});

  @override
  Widget build(BuildContext context) {
    final rating = model.rating ?? 0.0;
    final likes = model.likeCount ?? 0;
    final friends = model.friendsCount ?? 0;
    final reviews = model.totalReview ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatCell(
            icon: Icons.star_rounded,
            iconColor: AppColors.vipGold,
            value: rating.toStringAsFixed(1),
            label: 'ຄະແນນ',
          ),
          _vDivider(),
          _StatCell(
            icon: Icons.rate_review_outlined,
            iconColor: Colors.white.withValues(alpha: 0.70),
            value: _fmt(reviews),
            label: 'ລີວິວ',
          ),
          _vDivider(),
          _StatCell(
            icon: Icons.favorite_rounded,
            iconColor: AppColors.primary,
            value: _fmt(likes),
            label: 'ຖືກໃຈ',
          ),
          _vDivider(),
          _StatCell(
            icon: Icons.people_outline_rounded,
            iconColor: Colors.white.withValues(alpha: 0.70),
            value: _fmt(friends),
            label: 'ຕິດຕາມ',
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
    width: 0.5,
    height: 44.h,
    color: Colors.white.withValues(alpha: 0.08),
  );

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
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
                color: Colors.white.withValues(alpha: 0.40),
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
//  _Section — titled wrapper
// ═══════════════════════════════════════════════════════════════
class _Section extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _Section({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(width: 6.w),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ServiceCard — single-select service row
// ═══════════════════════════════════════════════════════════════
final _serviceIconData = [
  Icons.people_alt_outlined,
  Icons.spa_outlined,
  Icons.flight_takeoff_outlined,
  Icons.nightlife_outlined,
  Icons.local_cafe_outlined,
  Icons.sports_esports_outlined,
];

final _serviceFgColors = [
  AppColors.socialFg,
  AppColors.massageFg,
  AppColors.travelFg,
  const Color(0xFFAB47BC),
  const Color(0xFFFF8A65),
  const Color(0xFF26C6DA),
];

final _serviceBgColors = [
  AppColors.socialBg,
  AppColors.massageBg,
  AppColors.travelBg,
  const Color(0xFFF3F0FF),
  const Color(0xFFFFF3EF),
  const Color(0xFFE0F7FA),
];

class _ServiceCard extends StatelessWidget {
  final ModelAvailable service;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  double? get _variantMinPrice {
    final vs = service.variants;
    if (vs == null || vs.isEmpty) return null;
    final prices = vs.map((v) => v.pricePerHour).whereType<double>().toList();
    if (prices.isEmpty) return null;
    return prices.reduce((a, b) => a < b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final i = index % _serviceIconData.length;
    final fgColor = _serviceFgColors[i];
    final bgColor = _serviceBgColors[i];
    final icon = _serviceIconData[i];

    final price = service.effectiveRate ?? _variantMinPrice;
    final priceStr = price != null ? CurrFormatter.format(price.toInt()) : '—';
    final billing = ServiceHelper.serviceName(service.billingType);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: isSelected ? fgColor.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? fgColor : Colors.black.withValues(alpha: 0.07),
            width: isSelected ? 1.5 : 0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: fgColor.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(icon, size: 19.r, color: fgColor),
            ),
            SizedBox(width: 12.w),

            // Name + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ServiceHelper.serviceOriginalName(service.name),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // Price + billing
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$priceStr ກີບ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: fgColor,
                  ),
                ),
                if (billing.isNotEmpty)
                  Text(
                    billing,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
            SizedBox(width: 10.w),

            // Selection circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                color: isSelected ? fgColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? fgColor
                      : Colors.black.withValues(alpha: 0.12),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, size: 12.r, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ReviewCard — individual review
// ═══════════════════════════════════════════════════════════════
class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final isAnon = review.isAnonymous == true;
    final firstName = review.customer?.firstName ?? '';
    final lastName = review.customer?.lastName ?? '';
    final name = isAnon
        ? 'ນິລະນາມ'
        : '$firstName $lastName'.trim().ifBlank('ຜູ້ໃຊ້');
    final initial = name[0].toUpperCase();
    final dateStr = review.createdAt != null
        ? DateFormat('dd MMM yyyy').format(review.createdAt!)
        : '';
    final avatarUrl = isAnon ? null : review.customer?.profile;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null
                    ? Text(
                        initial,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: const Color(0xFFC4C4D0),
                      ),
                    ),
                  ],
                ),
              ),
              _Stars(rating: (review.rating ?? 0).toDouble(), size: 11.r),
            ],
          ),
          if (review.title != null && review.title!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              review.title!,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
          if (review.reviewText != null && review.reviewText!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              review.reviewText!,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _BookingBar — sticky CTA at bottom
// ═══════════════════════════════════════════════════════════════
class _BookingBar extends StatelessWidget {
  final ModelAvailable? selectedService;
  final VoidCallback onBook;

  const _BookingBar({required this.selectedService, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final svc = selectedService;
    final hasService = svc != null;
    final price = svc?.customRate ?? svc?.customHourlyRate;
    final priceStr = price != null ? CurrFormatter.format(price.toInt()) : '0';
    final billing = svc?.billingType ?? '';

    return Container(
      padding: EdgeInsets.fromLTRB(
        16.w,
        10.h,
        16.w,
        16.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.07),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: price or prompt
          if (hasService)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ລາຄາ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      priceStr,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'kip${ServiceHelper.serviceName(billing)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ກະລຸນາ',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'ເລືອກບໍລິການ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),

          const Spacer(),

          // Book button
          GestureDetector(
            onTap: hasService ? onBook : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              decoration: BoxDecoration(
                gradient: hasService
                    ? const LinearGradient(
                        colors: AppColors.pinkGradient,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: hasService ? null : const Color(0xFFE5E5EF),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: hasService
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon(
                  //   Icons.calendar_today_rounded,
                  //   size: 14.r,
                  //   color: hasService ? Colors.white : AppColors.textHint,
                  // ),
                  AppSvgIcon(
                    assetName: AppIcons.calendar,
                    width: 14.w,
                    height: 14.h,
                    color: hasService ? Colors.white : AppColors.textHint,
                  ),
                  SizedBox(width: 7.w),
                  Text(
                    'ຈອງດຽວນີ້',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: hasService ? Colors.white : AppColors.textHint,
                      letterSpacing: 0.2,
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

// ═══════════════════════════════════════════════════════════════
//  _AppBarIcon — glass circle button
// ═══════════════════════════════════════════════════════════════
class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AppBarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.r),
        width: 34.r,
        height: 34.r,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.25),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, size: 15.r, color: Colors.white),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _Stars — read-only star row
// ═══════════════════════════════════════════════════════════════
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
              ? AppColors.vipGold
              : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Skeleton / placeholder widgets
// ═══════════════════════════════════════════════════════════════
class _PhotoShimmer extends StatelessWidget {
  final double height;
  const _PhotoShimmer({required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFD0D0DC),
      highlightColor: const Color(0xFFE8E8F4),
      child: Container(height: height, color: Colors.white),
    );
  }
}

class _ServicesShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (i) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Container(
            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

class _RetryCard extends StatelessWidget {
  final VoidCallback onRetry;
  const _RetryCard({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.wifi_off_rounded, size: 28.r, color: AppColors.textHint),
          SizedBox(height: 8.h),
          Text(
            'ໂຫຼດຂໍ້ມູນບໍ່ໄດ້',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'ລອງໃໝ່',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyCard({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32.r, color: const Color(0xFFD1D1DC)),
          SizedBox(height: 8.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ProfileInfoShimmer — shown while profile loads
// ═══════════════════════════════════════════════════════════════
class _ProfileInfoShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEF4),
      highlightColor: const Color(0xFFF8F8FC),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.10),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // 3-stat strip skeleton
            IntrinsicHeight(
              child: Row(
                children: [
                  _ShimmerStat(),
                  Container(width: 0.5, color: Colors.black12),
                  _ShimmerStat(),
                  Container(width: 0.5, color: Colors.black12),
                  _ShimmerStat(),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              indent: 10.w,
              endIndent: 10.w,
              color: Colors.black.withValues(alpha: 0.06),
            ),
            // Address row skeleton
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
              child: Row(
                children: [
                  Container(
                    width: 13.r,
                    height: 13.r,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.10),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        width: 160.w,
                        height: 13.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.10),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
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
      ),
    );
  }
}

class _ShimmerStat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              width: 36.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
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

extension _StringExt on String {
  String ifBlank(String fallback) => trim().isEmpty ? fallback : this;
}

// ═══════════════════════════════════════════════════════════════
//  _StatStrip — single column in the 3-stat strip
// ═══════════════════════════════════════════════════════════════
class _StatStrip extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _StatStrip({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: valueColor ?? AppColors.textPrimary,
                height: 1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatStripDivider extends StatelessWidget {
  const _StatStripDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      color: Colors.black.withValues(alpha: 0.07),
    );
  }
}
