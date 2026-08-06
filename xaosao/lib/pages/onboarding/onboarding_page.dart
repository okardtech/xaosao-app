import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/constants/app_image.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/pages/login/login_page.dart';
import 'package:xaosao/pages/onboarding/components/companion_widget.dart';
import 'package:xaosao/services/deep_link_service.dart';
import 'package:xaosao/services/language_service.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/pages/onboarding/components/service_card_large.dart';
import 'package:xaosao/pages/onboarding/getx/onboarding_logic.dart';
import 'package:xaosao/widgets/app_svg_icon.dart';
import 'package:xaosao/widgets/language_selector_sheet.dart';
import '../../models/models_hot.dart';
import '../../utils/age_formatter.dart';
import 'getx/onboarding_state.dart';

// ════════════════════════════════════════════════════════════════
//  XAOSAO – Home Page
//  White background · no fixed bottom bar · companion photo-first
// ════════════════════════════════════════════════════════════════
class XaosaoHomePage extends StatefulWidget {
  const XaosaoHomePage({super.key});

  @override
  State<XaosaoHomePage> createState() => _XaosaoHomePageState();
}

class _XaosaoHomePageState extends State<XaosaoHomePage>
    with TickerProviderStateMixin {
  // ── Two controllers: banner + staggered content ────────────────
  late final AnimationController _bannerCtrl;
  late final AnimationController _staggerCtrl;

  late final Animation<double> _bannerFade;
  late final Animation<Offset> _bannerSlide;

  static const _kSections = 4;
  late final List<Animation<double>> _secFade;
  late final List<Animation<Offset>> _secSlide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Banner – 600 ms
    _bannerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bannerFade = CurvedAnimation(parent: _bannerCtrl, curve: Curves.easeOut);
    _bannerSlide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _bannerCtrl, curve: Curves.easeOut));

    // Stagger – 900 ms total
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _secFade = List.generate(_kSections, (i) {
      final s = (i * 0.20).clamp(0.0, 0.8);
      final e = (s + 0.40).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggerCtrl,
          curve: Interval(s, e, curve: Curves.easeOut),
        ),
      );
    });

    _secSlide = List.generate(_kSections, (i) {
      final s = (i * 0.20).clamp(0.0, 0.8);
      final e = (s + 0.40).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _staggerCtrl,
          curve: Interval(s, e, curve: Curves.easeOut),
        ),
      );
    });

    _bannerCtrl.forward();
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _staggerCtrl.forward(),
    );
  }

  @override
  void dispose() {
    _bannerCtrl.dispose();
    _staggerCtrl.dispose();
    super.dispose();
  }

  // ── Stagger helper ─────────────────────────────────────────────
  Widget _s(int i, Widget child) => FadeTransition(
    opacity: _secFade[i],
    child: SlideTransition(position: _secSlide[i], child: child),
  );

  // ══════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final logic = Get.find<OnboardingLogic>();
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ──────────────────────────────────────────
          SliverAppBar(
            backgroundColor: const Color(0xFFF8F8FC),
            elevation: 0,
            floating: true,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
            ),
            titleSpacing: 20.w,
            title: Row(
              children: [
                Text(
                  'XAOSAO',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1A1A2E),
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  width: 7.r,
                  height: 7.r,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            actions: [
              // ── Debug: simulate a deferred deep-link referral ──
              // Only shown in debug builds — auto-hidden in release.
              // Lets us verify the whole splash → register + banner
              // pipeline without needing Play Store install referrer.
              if (kDebugMode) const _DebugReferralButton(),

              // ── Language switcher ──────────────────────────
              const _LanguageChip(),
              SizedBox(width: 10.w),

              // ── Notification bell (opens login) ────────────
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          size: 20.r,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 7.h,
                      right: 7.w,
                      child: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF8F8FC),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Welcome + Login Banner ────────────────────────────
          SliverToBoxAdapter(child: SizedBox(height: 8.h)),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _bannerFade,
              child: SlideTransition(
                position: _bannerSlide,
                child: _buildWelcomeBanner(),
              ),
            ),
          ),

          // ── Services (unchanged) ──────────────────────────────
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          SliverToBoxAdapter(child: _s(1, _buildServices())),

          // ── Hot Companions (unchanged) ────────────────────────
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          SliverToBoxAdapter(
            child: _s(
              2,
              Obx(() {
                final state = logic.state;
                if (state.status == OnboardingStatus.loading) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: _sectionHeader(
                          l10n.onboardingTopCompanions,
                          subtitle: l10n.onboardingTopCompanionsSubtitle,
                          onViewAll: () {},
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        height: 280.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          itemCount: 4,
                          itemBuilder: (_, __) => Padding(
                            padding: EdgeInsets.only(right: 14.w),
                            child: ShimmerCard(
                              width: 185.w,
                              height: 270.h,
                              borderRadius: 24.r,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return _buildCompanions(state.modelsHot);
              }),
            ),
          ),

          // ── Partner Benefits (single card) ────────────────────
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          SliverToBoxAdapter(child: _s(3, _buildPartnerBenefits())),

          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  WELCOME + LOGIN BANNER  (replaces hero)
  // ──────────────────────────────────────────────────────────────
  Widget _buildWelcomeBanner() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting row ──────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.onboardingWelcome,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF9B9BAD),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      l10n.onboardingFindYourCompanion,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A2E),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ── Login prompt banner ───────────────────────────────
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A2E), Color(0xFF2E1A3A)],
                ),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Row(
                children: [
                  // Icon circle
                  Container(
                    width: 44.r,
                    height: 44.r,
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: AppSvgIcon(
                      assetName: AppIcons.user,
                      width: 22.h,
                      height: 22.h,
                      color: AppColors.primary,
                    ),
                    // child: Icon(
                    //   Icons.person_outline_rounded,
                    //   color: AppColors.primary,
                    //   size: 22.r,
                    // ),
                  ),
                  SizedBox(width: 6.w),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.onboardingLoginOrSignup,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          l10n.onboardingActionsHint,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white.withOpacity(0.50),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // Arrow button
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 9.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.secondary, AppColors.primary],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.40),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.onboardingLogin,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 14.r,
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
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  SERVICES  (unchanged from original)
  // ──────────────────────────────────────────────────────────────
  Widget _buildServices() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(l10n.onboardingOurServices),
          SizedBox(height: 16.h),
          ServiceCardLarge(
            icon: Icons.spa_outlined,
            title: l10n.onboardingMassageTitle,
            subtitle: l10n.onboardingMassageSubtitle,
            accentColor: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: ServiceCardSmall(
                  icon: Icons.local_bar_outlined,
                  title: l10n.homeServiceSocial,
                  subtitle: l10n.onboardingSocialSubtitle,
                  accentColor: AppColors.primary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ServiceCardSmall(
                  icon: Icons.flight_takeoff_outlined,
                  title: l10n.onboardingTravelTitle,
                  subtitle: l10n.onboardingTravelSubtitle,
                  accentColor: AppColors.primary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  HOT COMPANIONS  (unchanged from original)
  // ──────────────────────────────────────────────────────────────
  Widget _buildCompanions(List<ModelsHot> hostList) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: _sectionHeader(
            l10n.onboardingTopCompanions,
            subtitle: l10n.onboardingTopCompanionsSubtitle,
            onViewAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            itemCount: hostList.length,
            itemBuilder: (_, i) {
              final item = hostList[i];
              return Padding(
                padding: EdgeInsets.only(right: 14.w),
                child: GestureDetector(
                  child: CompanionCard(
                    name: '${item.firstName} ${item.lastName ?? ""}',
                    imageUrl: item.profile,
                    rating: (item.rating).toDouble(),
                    badgeColor: AppColors.socialBd,
                    reviewCount: item.totalReview,
                    age: AgeFormatter.ageFormatter(item.dob),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  PARTNER BENEFITS  — everything in ONE card, no Explore CTA
  Widget _buildPartnerBenefits() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.onboardingPartnerBenefits,
                    // 'PARTNER BENEFITS',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9B9BAD),
                      letterSpacing: 0.7,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.onboardingIncreaseIncome,
                        // 'Grow Your\nEarnings',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A2E),
                          height: 1.2,
                          letterSpacing: -0.4,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 3.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            l10n.onboardingJoinNow,
                            // 'JOIN NOW',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Tier strip ────────────────────────────────────
            Container(
              margin: EdgeInsets.only(top: 18.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black.withOpacity(0.06)),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _tierCell(
                        dotColor: AppColors.primary,
                        // name: 'Normal',
                        name: l10n.onboardingLevelGeneral,
                        // condition: 'Register as\ncompanion',
                        condition: l10n.onboardingConditionRegister,
                        earnValue: '10,000',
                        earnUnit: ' KIP',
                        // earnSub: 'per referral · up to 20',
                        earnSub: l10n.onboardingEarnPer20,
                        highlight: false,
                      ),
                    ),
                    _tierDivider(),
                    Expanded(
                      child: _tierCell(
                        dotColor: const Color(0xFF9B9BAD),
                        // name: 'Special',
                        name: l10n.onboardingLevelSpecial,
                        // condition: 'Refer 20\ncompanions',
                        condition: l10n.onboardingCondition20People,
                        earnValue: '2–20',
                        earnUnit: '%',
                        // earnSub: 'commission\n+ referrals',
                        earnSub: l10n.onboardingEarnCommission,
                        highlight: true,
                      ),
                    ),
                    _tierDivider(),
                    Expanded(
                      child: _tierCell(
                        dotColor: const Color(0xFF1A1A2E),
                        // name: 'Partner',
                        name: l10n.onboardingLevelPartner,
                        condition: '2,000,000\nKIP earned',
                        earnValue: '4–40',
                        earnUnit: '%',
                        // earnSub: 'VIP · forever\ncommission',
                        earnSub: l10n.onboardingEarnVipSummary,
                        highlight: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Footer CTA ────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(22.w, 16.h, 22.w, 20.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black.withOpacity(0.06)),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // 'Ready to start earning?',
                          l10n.onboardingReadyToEarn,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          // 'Register now and unlock higher\ntiers by referring companions.',
                          l10n.onboardingRegisterUnlock,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: const Color(0xFF9B9BAD),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 14.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 13.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.secondary, AppColors.primary],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.30),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18.r,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            // 'Get Started',
                            l10n.onboardingGetStarted,
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
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

  Widget _tierCell({
    required Color dotColor,
    required String name,
    required String condition,
    required String earnValue,
    required String earnUnit,
    required String earnSub,
    required bool highlight,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
      color: highlight
          ? const Color(0xFF1A1A2E).withOpacity(0.03)
          : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            condition,
            style: TextStyle(
              fontSize: 9.sp,
              color: const Color(0xFF9B9BAD),
              height: 1.5,
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: earnValue,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1A1A2E),
                    letterSpacing: -0.3,
                  ),
                ),
                TextSpan(
                  text: earnUnit,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            earnSub,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tierDivider() {
    return Container(width: 0.5, color: Colors.black.withOpacity(0.06));
  }

  // ──────────────────────────────────────────────────────────────
  //  SHARED WIDGETS
  // ──────────────────────────────────────────────────────────────
  Widget _sectionHeader(
    String title, {
    String? subtitle,
    VoidCallback? onViewAll,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
                letterSpacing: -0.4,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 3.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF9B9BAD),
                ),
              ),
            ],
          ],
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              l10n.homeSeeAll,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  _LanguageChip
//  Pill button on the app bar that shows the current language flag
//  and code (LO/EN/TH). Tap opens [LanguageSelectorSheet]; the flag
//  swaps reactively once the user picks a new language.
// ══════════════════════════════════════════════════════════════════
class _LanguageChip extends StatelessWidget {
  const _LanguageChip();

  String _flagFor(String code) {
    switch (code) {
      case 'en':
        return AppImage.enFlag;
      case 'th':
        return AppImage.thFlag;
      case 'lo':
      default:
        return AppImage.laFlag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final langService = Get.find<LanguageService>();
    return Obx(() {
      final code = langService.locale.languageCode;
      return GestureDetector(
        onTap: () => LanguageSelectorSheet.show(context),
        child: Container(
          height: 35.r,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: Image.asset(
                  _flagFor(code),
                  width: 22.w,
                  height: 16.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.language_rounded,
                    size: 16.r,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                code.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 2.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16.r,
                color: const Color(0xFF9B9BAD),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ══════════════════════════════════════════════════════════════════
//  _DebugReferralButton — debug-only helper for testing the referral
//  flow WITHOUT needing an AppsFlyer deep link. Simulates the exact
//  callback that AppsFlyer would fire on a deferred install so we can
//  verify: splash fast-path → register push → banner render → storage
//  cleared → reopen goes to onboarding.
//
//  Auto-hidden in release builds via the `kDebugMode` guard at the
//  call site — this widget file compiles in production too, it just
//  never renders.
// ══════════════════════════════════════════════════════════════════
class _DebugReferralButton extends StatelessWidget {
  const _DebugReferralButton();

  static const _testCode = 'XSCC85AB7';

  Future<void> _pick(BuildContext context) async {
    final target = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Simulate: MODEL referral'),
              onTap: () => Navigator.pop(context, 'model'),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Simulate: CUSTOMER referral'),
              onTap: () => Navigator.pop(context, 'customer'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
    if (target == null) return;
    Get.find<DeepLinkService>().captureReferral(
      code: _testCode,
      target: target,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: IconButton(
        tooltip: 'Simulate referral deep link',
        icon: Icon(Icons.bug_report_rounded,
            size: 22.r, color: Colors.redAccent),
        onPressed: () => _pick(context),
      ),
    );
  }
}
