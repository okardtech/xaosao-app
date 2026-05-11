import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/login/login_page.dart';
import 'package:xaosao/pages/onboarding/components/companion_widget.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/pages/onboarding/components/service_card_large.dart';
import 'package:xaosao/pages/onboarding/getx/onboarding_logic.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

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

  // ── Static data ────────────────────────────────────────────────
  // static const _companions = [
  //   {
  //     'name': 'Alexandra',
  //     'imageUrl':
  //         'https://thechicsavvy.com/wp-content/uploads/2025/04/Korean-Hairstyle7.webp',
  //     'rating': 4.9,
  //     'badge': 'TOP RATED',
  //     'badgeColor': 0xFFF06292,
  //     'specialty': 'Wellness · Events',
  //     'reviews': 128,
  //   },
  //   {
  //     'name': 'Elena',
  //     'imageUrl':
  //         'https://i.pinimg.com/originals/a0/3e/86/a03e869effc6cec27a1b00719593cd77.jpg',
  //     'rating': 4.8,
  //     'badge': 'NEW ARRIVAL',
  //     'badgeColor': 0xFF42A5F5,
  //     'specialty': 'Travel · Dining',
  //     'reviews': 46,
  //   },
  //   {
  //     'name': 'Sophie',
  //     'imageUrl':
  //         'https://upload.wikimedia.org/wikipedia/commons/8/80/Korean_girl_with_artificial_flower_headband.jpg',
  //     'rating': 4.7,
  //     'badge': 'POPULAR',
  //     'badgeColor': 0xFFAB47BC,
  //     'specialty': 'Social · Massage',
  //     'reviews': 89,
  //   },
  // ];

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
              // ── Notification bell only (no login) ──────────
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Stack(
                  children: [
                    Container(
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
                          'ເພື່ອນແນະນຳຍອດນິຍົມ',
                          subtitle: 'ຄົ້ນພົບຜູ້ໃຫ້ບໍລິການທີ່ໄດ້ຮັບຄະແນນສູງ',
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
                      'ຍິນດີຕ້ອນຮັບ 👋',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF9B9BAD),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'ຊອກຫາເພື່ອນຂອງທ່ານ',
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
          GestureDetector(
            onTap: () {
              // TODO: navigate to login page
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
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                      size: 22.r,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ເຂົ້າສູ່ລະບົບ / ສ້າງບັນຊີ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'ເບິ່ງໂປຣໄຟລ໌ · ສົ່ງຂໍ້ຄວາມ · ຈອງໄດ້ທັນທີ',
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Container(
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
                            'ເຂົ້າສູ່ລະບົບ',
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('ບໍລິການຂອງພວກເຮົາ'),
          SizedBox(height: 16.h),
          ServiceCardLarge(
            icon: Icons.spa_outlined,
            title: 'ບໍລິການນວດ',
            subtitle: 'ບໍລິການນວດສຸຂະພາບໂດຍຜູ້ໃຫ້ບໍລິການມືອາຊີບ ສະດວກຮອດບ້ານ',
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
                  title: 'ເພື່ອນສັງຄົມ',
                  subtitle:
                      'ຄູ່ຮ່ວມງານສຳລັບງານສັງຄົມ ເພື່ອເພີ່ມຄວາມມ່ວນຊື່ນ ແລະ ຄວາມປະທັບໃຈ',
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
                  title: 'ເພື່ອນທ່ອງທ່ຽວ',
                  subtitle:
                      'ຄູ່ຮ່ວມທ່ອງທ່ຽວທີ່ພ້ອມພາເຈົ້າຄົ້ນພົບປະສົບການໃໝ່ ທັງໃນ ແລະ ຕ່າງປະເທດ',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: _sectionHeader(
            'ເພື່ອນແນະນຳຍອດນິຍົມ',
            subtitle: 'ຄົ້ນພົບຜູ້ໃຫ້ບໍລິການທີ່ໄດ້ຮັບຄະແນນສູງ',
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
                child: CompanionCard(
                  name: '${item.firstName} ${item.lastName ?? ""}',
                  imageUrl: item.profile,
                  rating: (item.rating).toDouble(),
                  badgeColor: AppColors.socialBd,
                  reviewCount: item.totalReview,
                  age: AgeFormatter.ageFormatter(item.dob),
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
                    "ສິດປະໂຫຍດພາກຮ່ວມ",
                    // 'PARTNER BENEFITS',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9B9BAD),
                      letterSpacing: 1.8,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ເພີ່ມລາຍຮັບຂອງທ່ານ",
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
                            "ເຂົ້າຮ່ວມເລີຍ",
                            // 'JOIN NOW',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 1.0,
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
                        name: 'ທົ່ວໄປ',
                        // condition: 'Register as\ncompanion',
                        condition: "ລົງທະບຽນເປັນຄູ່ຮ່ວມ",
                        earnValue: '10,000',
                        earnUnit: ' KIP',
                        // earnSub: 'per referral · up to 20',
                        earnSub: "ຕໍ່ 1 ຄົນທີ່ແນະນຳ · ສູງສຸດ 20 ຄົນ",
                        highlight: false,
                      ),
                    ),
                    _tierDivider(),
                    Expanded(
                      child: _tierCell(
                        dotColor: const Color(0xFF9B9BAD),
                        // name: 'Special',
                        name: "ພິເສດ",
                        // condition: 'Refer 20\ncompanions',
                        condition: "ແນະນຳຄູ່ຮ່ວມ 20 ຄົນ",
                        earnValue: '2–20',
                        earnUnit: '%',
                        // earnSub: 'commission\n+ referrals',
                        earnSub: "ຄ່າຄອມມິຊັນ ແລະ ຈຳນວນແນະນຳ",
                        highlight: true,
                      ),
                    ),
                    _tierDivider(),
                    Expanded(
                      child: _tierCell(
                        dotColor: const Color(0xFF1A1A2E),
                        // name: 'Partner',
                        name: 'ພາກຮ່ວມ',
                        condition: '2,000,000\nKIP earned',
                        earnValue: '4–40',
                        earnUnit: '%',
                        // earnSub: 'VIP · forever\ncommission',
                        earnSub: "ສະຫຼຸບ VIP ແລະ ຄ່າຄອມມິຊັນໃນເວລາ",
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
                          "ພ້ອມເລີ່ມຫາລາຍຮັບບໍ?",
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
                          "ລົງທະບຽນຕອນນີ້ ແລະ ປົດລັອກລະດັບທີ່ສູງຂຶ້ນ ໂດຍການແນະນຳຜູ້ອື່ນ",
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
                      // TODO: navigate to partner signup
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
                            "ເລີ່ມຕົ້ນ",
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
              fontSize: 11.sp,
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
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1A1A2E),
                    letterSpacing: -0.3,
                  ),
                ),
                TextSpan(
                  text: earnUnit,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9B9BAD),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            earnSub,
            style: TextStyle(
              fontSize: 8.5.sp,
              color: const Color(0xFF9B9BAD),
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
              'ເບິ່ງທັງໝົດ',
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
