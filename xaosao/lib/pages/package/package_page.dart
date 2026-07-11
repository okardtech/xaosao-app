import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/package_model.dart';
import 'package:xaosao/pages/package/getx/package_logic.dart';
import 'package:xaosao/pages/package/getx/package_state.dart';
import 'package:xaosao/pages/package/subscription_checkout_page.dart';
import 'package:xaosao/pages/wallet/getx/wallet_logic.dart';
import 'package:xaosao/utils/date_time_formatter.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

import '../../widgets/app_svg_icon.dart';

// Gradient palette assigned by card index (cycles if more packages)
const _kGradients = <List<Color>>[
  [AppColors.secondary, AppColors.primary],
  [Color(0xFF1A1A2E), Color(0xFF3C3C6E)],
  [Color(0xFF667eea), Color(0xFF764ba2)],
  [Color(0xFF11998e), Color(0xFF38ef7d)],
];
const _kAccents = <Color>[
  AppColors.primary,
  Color(0xFF22C55E),
  Color(0xFF7C3AED),
  Color(0xFF11998e),
];

String _fmtKip(int? n) => '${NumberFormat.decimalPattern().format(n ?? 0)} ກີບ';

// Shared feature list shown on every package card.
const _kPackageFeatures = <String>[
  'ເຂົ້າເຖິງທຸກຟີເຈີແບບໄຮ້ຂີດຈໍາກັດ',
  'ສົ່ງຂໍ້ຄວາມແຊັດໄດ້ບໍ່ຈໍາກັດ',
  'ນັດໝາຍນໍາຄົນທີ່ເຮົາມັກໄດ້ບໍ່ຈໍາກັດ',
  'ເປີດສິດເຂົ້າເບິ່ງໂປຣໄຟລ໌ VIP ຂອງສາວໆ',
  'ລະບົບຄົ້ນຫາ ແລະ ຄັດກອງແບບຂັ້ນສູງ',
  'ໄດ້ຮັບບໍລິການຊ່ວຍເຫຼືອລະດັບພິເສດຕະຫຼອດ 24/7',
  'ເພີ່ມການເບິ່ງເຫັນໂປຣໄຟລ໌',
];

// Per-card description overrides (Lao). Indexes outside this range fall
// back to the API-provided pkg.description.
const _kPackageDescriptions = <String>[
  'ສຳຫຼວດທຸກຟີເຈີລະດັບພຣີມຽມ ແລະ ເລີ່ມເຊື່ອມຕໍ່ໄດ້ທັນທີ',
  'ທົດລອງບໍລິການ 24 ຊົ່ວໂມງ ດ້ວຍແຊັດ ແລະ ການຈອງແບບບໍ່ຈຳກັດ',
  'ດີລທີ່ຄຸ້ມຄ່າທີ່ສຸດ ສຳລັບການນັດໝາຍໄລຍະຍາວ ແລະ ການເຊື່ອມຕໍ່ທີ່ຈິງໃຈ',
];

String? _descriptionFor(int index, PackageData pkg) {
  if (index >= 0 && index < _kPackageDescriptions.length) {
    return _kPackageDescriptions[index];
  }
  return pkg.description;
}

class PackagePage extends StatefulWidget {
  const PackagePage({super.key});

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  late final PackageLogic _logic;
  late final PageController _pageCtrl;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<PackageLogic>();
    _pageCtrl = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ເລືອກແຜນ',
        subtitle: 'ຍົກລະດັບປະສົບການຂອງທ່ານ',
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.packageHistory),
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 13.r,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'ປະຫວັດ',
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
      body: Column(
        children: [
          Obx(() => _buildHeroOrPlanCard()),
          SizedBox(height: 8.h),
          Expanded(child: Obx(() => _buildBody())),
          SizedBox(height: 14.h),
          Obx(() => _buildDots()),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Text(
              'ຍົກເລີກໄດ້ທຸກເວລາ · ໂອນຄືນຕາມນະໂຍບາຍ',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textDisabled),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero or current plan card ───────────────────────────────
  Widget _buildHeroOrPlanCard() {
    final st = _logic.state;
    if (st.status == PackageStatus.success && st.currentPlan != null) {
      return _buildCurrentPlanCard(st.currentPlan!);
    }
    return _buildHero();
  }

  Widget _buildCurrentPlanCard(CurrentSubscriptionPlan plan) {
    final days = plan.daysRemaining ?? 0;
    final isPending = plan.status == 'pending';
    final isUrgent = !isPending && days > 0 && days <= 7;
    final isExpired = !isPending && days == 0;

    final Color accentColor = isPending
        ? const Color(0xFF8B5CF6)
        : isExpired
        ? const Color(0xFF94A3B8)
        : isUrgent
        ? const Color(0xFFF59E0B)
        : AppColors.primary;

    final String statusLabel = isPending
        ? 'ລໍຖ້າການຢືນຢັນ'
        : isExpired
        ? 'ໝົດອາຍຸແລ້ວ'
        : isUrgent
        ? 'ໃກ້ໝົດອາຍຸ'
        : 'ກຳລັງໃຊ້ງານ';

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.14),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Watermark plan name (background depth layer)
              Positioned(
                bottom: -6,
                right: -2,
                child: Text(
                  plan.name ?? '',
                  style: TextStyle(
                    fontSize: 58.sp,
                    fontWeight: FontWeight.w900,
                    color: accentColor.withValues(alpha: 0.055),
                    height: 1,
                    letterSpacing: -2,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status pill
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 9.h),
                          // Plan name
                          Text(
                            plan.name ?? '',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          // Date / pending message
                          Row(
                            children: [
                              AppSvgIcon(
                                assetName: AppIcons.calendar,
                                width: 12.w,
                                height: 12.h,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                isPending
                                    ? 'ກຳລັງດຳເນີນການຢືນຢັນ...'
                                    : 'ໝົດອາຍຸ ${DateTimeFormatter.laoDate(plan.endDate)}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 14.w),
                    // Right badge
                    if (isPending)
                      Container(
                        width: 54.r,
                        height: 54.r,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.schedule_rounded,
                          size: 24.r,
                          color: accentColor,
                        ),
                      )
                    else
                      Column(
                        children: [
                          Container(
                            width: 62.r,
                            height: 62.r,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$days',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w900,
                                      color: accentColor,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    'ວັນ',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: accentColor.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'ຄົງເຫຼືອ',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textHint,
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
    );
  }

  // ── Hero text ───────────────────────────────────────────────
  Widget _buildHero() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.socialBg,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.socialBd, width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_rounded,
                  size: 12.r,
                  color: AppColors.primary,
                ),
                SizedBox(width: 5.w),
                Text(
                  'ເລືອກແຜນຂອງທ່ານ',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'ຍົກລະດັບປະສົບການ',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'ເລືອກແຜນທີ່ເໝາະສົມ ແລ້ວຊອກຫາຄູ່ໄດ້ທຸກເວລາ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textHint,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Body (shimmer / error / cards) ──────────────────────────
  Widget _buildBody() {
    final st = _logic.state;
    if (st.status == PackageStatus.loading) return _PackageListShimmer();
    if (st.status == PackageStatus.failure) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 40.r,
              color: AppColors.textDisabled,
            ),
            SizedBox(height: 12.h),
            Text(
              st.error ?? 'ໂຫຼດບໍ່ສຳເລັດ',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: _logic.fetchPackages,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'ລອງໃໝ່',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (st.packages.isEmpty) {
      return Center(
        child: Text(
          'ບໍ່ມີ Package',
          style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
        ),
      );
    }

    final isPendingPlan = st.currentPlan?.status == 'pending';
    final pageView = PageView.builder(
      controller: _pageCtrl,
      physics: const BouncingScrollPhysics(),
      itemCount: st.packages.length,
      onPageChanged: (i) => setState(() => _current = i),
      itemBuilder: (_, i) {
        final pkg = st.packages[i];
        final gradIdx = i % _kGradients.length;
        final isCurrent = st.currentPlan?.id == pkg.id;
        return _PackageCard(
          pkg: pkg,
          index: i,
          gradient: _kGradients[gradIdx],
          accent: _kAccents[gradIdx],
          isActive: i == _current,
          isCurrentPlan: isCurrent,
          onSelect: isCurrent ? null : () => _onSelect(pkg, _kAccents[gradIdx]),
        );
      },
    );

    if (isPendingPlan) {
      return Column(
        children: [
          _buildPendingBanner(),
          Expanded(child: pageView),
        ],
      );
    }
    return pageView;
  }

  Widget _buildPendingBanner() {
    const purple = Color(0xFF8B5CF6);
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: purple.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: purple.withValues(alpha: 0.18), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, size: 15.r, color: purple),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'ຄຳຮ້ອງຂໍຂອງທ່ານກຳລັງຖືກດຳເນີນການ · ກະລຸນາລໍຖ້າ',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: purple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Dots indicator ──────────────────────────────────────────
  Widget _buildDots() {
    final st = _logic.state;
    final count = st.packages.isEmpty ? 3 : st.packages.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isOn = i == _current;
        final color = isOn
            ? _kAccents[i % _kAccents.length]
            : AppColors.textDisabled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isOn ? 18.w : 6.r,
          height: 6.r,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }

  // ── Select handler ──────────────────────────────────────────
  void _onSelect(PackageData pkg, Color accent) {
    final balance = Get.find<WalletLogic>().state.wallet?.availableBalance ?? 0;
    final price = pkg.price ?? 0;
    if (balance >= price) {
      Get.toNamed(
        AppRoutes.subscriptionCheckout,
        arguments: SubscriptionCheckoutArgs(
          planId: pkg.id ?? '',
          planName: pkg.name ?? '',
          description: pkg.description,
          price: price,
          durationDays: pkg.durationDays,
          currentPlan: _logic.state.currentPlan,
        ),
      );
    } else {
      Get.toNamed(
        AppRoutes.topupAmount,
        arguments: {'initialAmount': price, 'subscriptionPlanId': pkg.id ?? ''},
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════
//  _PackageCard
// ═══════════════════════════════════════════════════════════════
class _PackageCard extends StatelessWidget {
  final PackageData pkg;
  final int index;
  final List<Color> gradient;
  final Color accent;
  final bool isActive;
  final bool isCurrentPlan;
  final VoidCallback? onSelect;

  const _PackageCard({
    required this.pkg,
    required this.index,
    required this.gradient,
    required this.accent,
    required this.isActive,
    required this.isCurrentPlan,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.0 : 0.94,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            // border: Border.all(
            //   color: isCurrentPlan
            //       ? AppColors.primary
            //       : pkg.isPopular == true && isActive
            //       ? accent
            //       : AppColors.borderMedium,
            //   width: isCurrentPlan ? 2 : pkg.isPopular == true && isActive ? 1.5 : 0.5,
            // ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTop(),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: AppColors.borderMedium,
                ),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -24,
            right: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -36,
            left: -16,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pkg.name ?? '',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.7,
                    height: 1,
                  ),
                ),
                SizedBox(height: 8.h),
                Builder(builder: (_) {
                  final desc = _descriptionFor(index, pkg);
                  if (desc == null || desc.isEmpty) return const SizedBox.shrink();
                  return Text(
                    desc,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.70),
                      height: 1.55,
                    ),
                  );
                }),
                SizedBox(height: 14.h),
                Text(
                  _fmtKip(pkg.price),
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    const feats = _kPackageFeatures;
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 16.h),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feats.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (_, i) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 18.r,
                    height: 18.r,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_rounded, size: 10.r, color: accent),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      feats[i],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          // CTA button
          GestureDetector(
            onTap: onSelect,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 46.h,
              decoration: BoxDecoration(
                color: isCurrentPlan ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(14.r),
                border: isCurrentPlan
                    ? Border.all(color: AppColors.primary, width: 1)
                    : Border.all(color: AppColors.borderMedium, width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCurrentPlan) ...[
                    Icon(
                      Icons.check_rounded,
                      size: 14.r,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 5.w),
                  ],
                  Text(
                    isCurrentPlan ? 'ແພັກເກດປັດຈຸບັນ' : 'ເລືອກແຜນນີ້',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: isCurrentPlan
                          ? Colors.white
                          : AppColors.textPrimary,
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
//  Shimmer
// ═══════════════════════════════════════════════════════════════
class _PackageListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.88),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Shimmer.fromColors(
          baseColor: const Color(0xFFE8E8F0),
          highlightColor: const Color(0xFFF5F5FA),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
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
                Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(18.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                          5,
                          (i) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Container(
                              height: 12.h,
                              width: i % 2 == 0 ? double.infinity : 180.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.10,
                                    ),
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
                        const Spacer(),
                        Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.10,
                                ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
