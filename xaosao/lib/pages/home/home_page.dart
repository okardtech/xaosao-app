import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/models/Recommended_model.dart';
import 'package:xaosao/pages/home/components/companion_card.dart';
import 'package:xaosao/pages/home/components/companion_filter.dart';
import 'package:xaosao/pages/home/components/home_shimmer.dart';
import 'package:xaosao/pages/home/getx/home_logic.dart';
import 'package:xaosao/pages/home/getx/home_state.dart';

import '../companion_profile/companion_profile_page.dart';
import '../companion_profile/components/profile_model.dart';
import '../view_companion/view_companions_page.dart';

// ═════════════════════════════════════════════════════════════════════════════
//  Explore Page
// ═════════════════════════════════════════════════════════════════════════════
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final HomeLogic _logic;
  late final ScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<HomeLogic>();
    _scrollCtrl = ScrollController()..addListener(_onScroll);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  // Trigger load-more when within 300px of the bottom
  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final remaining =
        _scrollCtrl.position.maxScrollExtent - _scrollCtrl.position.pixels;
    if (remaining < 300) _logic.loadMoreRecommended();
  }

  void _onGenderChanged(String gender) => _logic.setGender(gender);

  Future<void> _onRefresh() => Future.wait([
        _logic.fetchRecommended(refresh: true),
        _logic.fetchOnline(refresh: true),
      ]);

  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: const Color(0xFFF06292),
                backgroundColor: Colors.white,
                child: CustomScrollView(
                  controller: _scrollCtrl,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(child: _buildFilterBar()),
                    SliverToBoxAdapter(child: _buildOnlineSection()),
                    SliverToBoxAdapter(child: _buildRecommendedSection()),
                    SliverToBoxAdapter(child: _buildBottomPadding()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top App Bar ────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ຄົ້ນຫາ',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'ຄົ້ນພົບຜູ້ຮ່ວມທາງຂອງທ່ານ',
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9B9BAD)),
              ),
            ],
          ),
          const Spacer(),
          _iconBtn(Icons.search_rounded, () {}),
          SizedBox(width: 10.w),
          _iconBtn(Icons.tune_rounded, _showFilterSheet),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: 20.r, color: const Color(0xFF1A1A2E)),
      ),
    );
  }

  // ── Filter bar — reactive only to gender ──────────────────────────────────
  Widget _buildFilterBar() {
    return Obx(() {
      final gender = _logic.state.gender;
      return Container(
        color: const Color(0xFFF8F8FC),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          children: [
            GenderTabBar(selected: gender, onChanged: _onGenderChanged),
            SizedBox(height: 12.h),
            CategoryPillRow(selected: 'new', onChanged: (_) {}),
            SizedBox(height: 10.h),
          ],
        ),
      );
    });
  }

  // ── Online section — reactive only to online data ──────────────────────────
  Widget _buildOnlineSection() {
    return Obx(() {
      final st = _logic.state;
      final isLoading = st.onlineStatus == HomeStatus.loading ||
          st.onlineStatus == HomeStatus.initial;
      if (isLoading) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              icon: Icons.fiber_new_rounded,
              iconColor: const Color(0xFF4CAF50),
              title: 'ອອນລາຍດຽວນີ້',
            ),
            const OnlineLoadingShimmer(),
            SizedBox(height: 28.h),
          ],
        );
      }
      if (st.online.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.fiber_new_rounded,
            iconColor: const Color(0xFF4CAF50),
            title: 'ອອນລາຍດຽວນີ້',
            onViewAll: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const ViewAllCompanionsPage(title: 'ອອນລາຍດຽວນີ້'),
              ),
            ),
          ),
          _buildOnlineList(st.online),
          SizedBox(height: 28.h),
        ],
      );
    });
  }

  // ── Recommended section — reactive only to recommended data ───────────────
  Widget _buildRecommendedSection() {
    return Obx(() {
      final st = _logic.state;
      final isLoading = st.recommendedStatus == HomeStatus.loading ||
          st.recommendedStatus == HomeStatus.initial;

      if (isLoading) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              icon: Icons.star_rounded,
              iconColor: const Color(0xFFFFB800),
              title: 'ແນະນຳ',
            ),
            RecommendedLoadingShimmer(count: 4),
          ],
        );
      }

      if (st.recommended.isEmpty) {
        final onlineIdle = st.onlineStatus != HomeStatus.loading &&
            st.onlineStatus != HomeStatus.initial;
        if (st.online.isEmpty && onlineIdle) return _buildEmpty();
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFFB800),
            title: 'ແນະນຳ',
            onViewAll: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ViewAllCompanionsPage(title: 'ແນະນຳ'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.78,
              ),
              itemCount: st.recommended.length,
              itemBuilder: (_, i) => CompanionCardSmall(
                companion: _toCompanionModel(st.recommended[i]),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CompanionProfilePage(profile: mockKaiProfile),
                  ),
                ),
              ),
            ),
          ),
          if (st.recommendedStatus == HomeStatus.loadingMore)
            const LoadMoreIndicator(),
        ],
      );
    });
  }

  Widget _buildBottomPadding() => SizedBox(height: 20.h);

  // ── Online horizontal list ─────────────────────────────────────────────────
  Widget _buildOnlineList(List<RecommendedModel> items) {
    return SizedBox(
      height: 340.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final m = items[i];
          return Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: CompanionCardLarge(
              companion: _toCompanionModel(m),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CompanionProfilePage(profile: mockKaiProfile),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Map API model → UI model ───────────────────────────────────────────────
  CompanionModel _toCompanionModel(RecommendedModel m) {
    final dob = m.dob;
    final age = dob != null
        ? (DateTime.now().difference(dob).inDays ~/ 365)
        : 0;
    return CompanionModel(
      id: m.id ?? '',
      name: '${m.firstName ?? ''} ${m.lastName ?? ''}'.trim(),
      age: age,
      imageUrl: m.profile ?? '',
      district: '',
      distanceKm: 0,
      rating: (m.rating ?? 0).toDouble(),
      reviewCount: m.totalReview ?? 0,
      isOnline: m.availableStatus == 'online',
      isVipElite: m.vip ?? false,
      gender: m.gender ?? 'male',
      gradientColors: const [Color(0xFF5C6BC0), Color(0xFF1A1A2E)],
      services: const [],
    );
  }

  // ── Section header ─────────────────────────────────────────────────────────
  Widget _sectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    VoidCallback? onViewAll,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 12.h),
      child: Row(
        children: [
          Icon(icon, size: 18.r, color: iconColor),
          SizedBox(width: 7.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'ເບິ່ງທັງໝົດ ›',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF06292),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Empty states ───────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded,
              size: 60.r, color: const Color(0xFFD1D1E0)),
          SizedBox(height: 14.h),
          Text(
            'ບໍ່ພົບຜົນໄດ້ຮັບ',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9B9BAD),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'ລອງປ່ຽນ filter ໃໝ່',
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFFBBBBCC)),
          ),
        ],
      ),
    );
  }


  // ── Filter bottom sheet ────────────────────────────────────────────────────
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'ຕົວກອງ',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'ໄລຍະທາງສູງສຸດ',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF555570),
              ),
            ),
            SizedBox(height: 8.h),
            _distanceChips(),
            SizedBox(height: 28.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF06292),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'ນຳໃຊ້ Filter',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _distanceChips() {
    final opts = <Map<String, dynamic>>[
      {'label': '< 5km', 'value': 5.0},
      {'label': '< 10km', 'value': 10.0},
      {'label': '< 30km', 'value': 30.0},
      {'label': 'ທັງໝົດ', 'value': 200.0},
    ];
    return Obx(() {
      final current = _logic.state.maxDistanceKm;
      return Wrap(
        spacing: 8.w,
        children: opts.map((o) {
          final val = o['value'] as double;
          final selected = current == val;
          return FilterChip(
            label: Text(o['label'] as String),
            selected: selected,
            onSelected: (_) {
              _logic.setMaxDistance(val);
              Navigator.pop(context);
            },
            backgroundColor: const Color(0xFFF8F8FC),
            selectedColor: const Color(0xFFF06292).withValues(alpha: 0.15),
            labelStyle: TextStyle(
              fontSize: 12.sp,
              color: selected
                  ? const Color(0xFFF06292)
                  : const Color(0xFF555570),
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w400,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          );
        }).toList(),
      );
    });
  }
}
