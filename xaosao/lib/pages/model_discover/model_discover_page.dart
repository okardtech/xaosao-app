import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/widgets/app_search_field.dart';
import 'package:xaosao/widgets/empty_state.dart';
import 'components/discover_card.dart';
import 'components/discover_shimmer_card.dart';
import 'getx/model_discover_logic.dart';
import 'getx/model_discover_state.dart';
import 'model_detail_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Tab definition
// ─────────────────────────────────────────────────────────────────────────────
class _Tab {
  final String label;
  final IconData icon;
  final String? filter;

  const _Tab({required this.label, required this.icon, this.filter});
}

const _tabs = [
  _Tab(label: 'ທັງໝົດ', icon: Icons.grid_view_rounded, filter: null),
  _Tab(label: 'ສຳລັບທ່ານ', icon: Icons.auto_awesome_rounded, filter: 'for-you'),
  _Tab(label: 'ຖືກໃຈຂ້ອຍ', icon: Icons.favorite_rounded, filter: 'who-like-me'),
  _Tab(label: 'ຂ້ອຍຖືກໃຈ', icon: Icons.star_rounded, filter: 'i-liked'),
];

const _emptyData = [
  (
    Icons.search_off_rounded,
    'ບໍ່ພົບຜູ້ໃຊ້',
    'ລອງປ່ຽນຕົວກອງ ຫຼື ຄົ້ນຫາໃໝ່ອີກຄັ້ງ',
  ),
  (
    Icons.auto_awesome_rounded,
    'ຍັງບໍ່ມີຄຳແນະນຳ',
    'ລະບົບຈະຊອກຫາຜູ້ທີ່ເໝາະສົມໃຫ້ທ່ານ',
  ),
  (
    Icons.favorite_border_rounded,
    'ຍັງບໍ່ມີໃຜຖືກໃຈທ່ານ',
    'ສ້າງໂປຣໄຟລ໌ທີ່ດີເພື່ອດຶງດູດ',
  ),
  (
    Icons.star_border_rounded,
    'ທ່ານຍັງບໍ່ໄດ້ຖືກໃຈໃຜ',
    'ຄົ້ນຫາແລ້ວກົດ ♥ ເພື່ອສະແດງຄວາມສົນໃຈ',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
//  ModelDiscoverPage
// ─────────────────────────────────────────────────────────────────────────────
class ModelDiscoverPage extends StatefulWidget {
  const ModelDiscoverPage({super.key});

  @override
  State<ModelDiscoverPage> createState() => _ModelDiscoverPageState();
}

class _ModelDiscoverPageState extends State<ModelDiscoverPage> {
  late final ModelDiscoverLogic _logic;
  late final ScrollController _scrollCtrl;
  late final TextEditingController _searchCtrl;
  late final StreamSubscription<bool> _searchSub;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<ModelDiscoverLogic>();
    _scrollCtrl = ScrollController()..addListener(_onScroll);
    _searchCtrl = TextEditingController();
    _searchSub = _logic.searchOpen.listen((open) {
      if (!open) _searchCtrl.clear();
    });
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    _searchCtrl.dispose();
    _searchSub.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final remaining =
        _scrollCtrl.position.maxScrollExtent - _scrollCtrl.position.pixels;
    if (remaining < 400) _logic.loadModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchField(),
            _buildTabBar(),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: Colors.white,
                onRefresh: () => _logic.loadModels(refresh: true),
                child: Obx(() => _buildContent(_logic.state)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 16.w, 4.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ຄົ້ນພົບ',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.6,
                  ),
                ),
                Text(
                  'ຄົ້ນຫາຜູ້ໃຊ້ທີ່ທ່ານໃຈ',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                ),
              ],
            ),
          ),
          Obx(
            () => _HeaderBtn(
              icon: _logic.searchOpen.value
                  ? Icons.close_rounded
                  : Icons.search_rounded,
              onTap: _logic.toggleSearch,
              active: _logic.searchOpen.value,
            ),
          ),
          SizedBox(width: 4.w),
        ],
      ),
    );
  }

  // ── Collapsible search bar ────────────────────────────────────
  Widget _buildSearchField() {
    return Obx(() {
      final open = _logic.searchOpen.value;
      return AnimatedOpacity(
        opacity: open ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: open ? 48.h : 0,
          margin: open
              ? EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h)
              : EdgeInsets.zero,
          child: open
              ? AppSearchField(
                  controller: _searchCtrl,
                  onChanged: _logic.onSearchChanged,
                  hintText: 'ຄົ້ນຫາດ້ວຍຊື່...',
                  autofocus: true,
                )
              : const SizedBox.shrink(),
        ),
      );
    });
  }

  // ── Tab bar — underline style matching GenderTabBar ──────────
  Widget _buildTabBar() {
    return Obx(() {
      final tabIdx = _logic.tabIndex.value;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 10.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black.withValues(alpha: 0.07),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final isActive = tabIdx == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _logic.selectTab(i, _tabs[i].filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isActive
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: Text(
                      _tabs[i].label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: isActive
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.primaryVariant,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }

  // ── Content ───────────────────────────────────────────────────
  Widget _buildContent(ModelDiscoverState st) {
    final isLoading =
        st.status == DiscoverStatus.initial ||
        st.status == DiscoverStatus.loading;

    if (isLoading) return _buildShimmerGrid();

    if (st.status == DiscoverStatus.failure && st.models.isEmpty) {
      return AppEmptyState(
        icon: Icons.wifi_off_rounded,
        title: 'ໂຫຼດຂໍ້ມູນບໍ່ໄດ້',
        subtitle: 'ກວດສອບການເຊື່ອມຕໍ່ແລ້ວລອງໃໝ່',
        iconColor: const Color(0xFFDC2626),
        iconBgColor: const Color(0xFFFFF0F0),
        actionLabel: 'ລອງໃໝ່',
        onAction: () => _logic.loadModels(refresh: true),
      );
    }

    if (st.models.isEmpty) {
      final idx = _logic.tabIndex.value.clamp(0, _emptyData.length - 1);
      final (icon, title, subtitle) = _emptyData[idx];
      return AppEmptyState(icon: icon, title: title, subtitle: subtitle);
    }

    return GridView.builder(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.70,
      ),
      itemCount:
          st.models.length + (st.status == DiscoverStatus.loadingMore ? 2 : 0),
      itemBuilder: (_, i) {
        if (i >= st.models.length) return const DiscoverShimmerCard();
        return DiscoverCard(
          model: st.models[i],
          onLikeTap: () => _logic.toggleLike(st.models[i].id ?? ''),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ModelDetailPage(model: st.models[i]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.70,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const DiscoverShimmerCard(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _HeaderBtn  (local — tightly coupled to this page's header)
// ═══════════════════════════════════════════════════════════════
class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _HeaderBtn({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: active
                ? AppColors.primary.withValues(alpha: 0.30)
                : Colors.black.withValues(alpha: 0.07),
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          size: 18.r,
          color: active ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
    );
  }
}
