import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/Recommended_model.dart';
import 'package:xaosao/models/service_model.dart';
import 'package:xaosao/pages/home/components/companion_card.dart';
import 'package:xaosao/utils/service_helper.dart';
import 'package:xaosao/pages/home/components/companion_filter.dart';
import 'package:xaosao/pages/home/components/home_shimmer.dart';
import 'package:xaosao/pages/home/getx/home_logic.dart';
import 'package:xaosao/pages/home/getx/home_state.dart';
import 'package:xaosao/services/location_manager.dart';
import 'package:xaosao/utils/location_utils.dart';
import 'package:xaosao/widgets/app_search_field.dart';
import 'package:xaosao/widgets/notif_badge.dart';

import 'package:xaosao/constants/app_routes.dart';
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
  late final TextEditingController _searchCtrl;
  late final FocusNode _searchFocusNode;
  late final StreamSubscription<bool> _searchSub;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<HomeLogic>();
    _scrollCtrl = ScrollController()..addListener(_onScroll);
    _searchCtrl = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchSub = _logic.searchOpen.listen((open) {
      if (!open) _searchCtrl.clear();
    });
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
    _searchCtrl.dispose();
    _searchFocusNode.dispose();
    _searchSub.cancel();
    super.dispose();
  }

  // Trigger load-more when within 300px of the bottom
  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final remaining =
        _scrollCtrl.position.maxScrollExtent - _scrollCtrl.position.pixels;
    if (remaining < 300) _logic.loadMoreRecommended();
  }

  // Gender handler disabled together with the [GenderTabBar] in the
  // filter bar. Re-enable both when the API supports gender filtering.
  // void _onGenderChanged(String gender) => _logic.setGender(gender);

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
            _buildSearchField(),
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
                AppLocalizations.of(context)!.homeSearch,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.homeFindCompanion,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF9B9BAD),
                ),
              ),
            ],
          ),
          const Spacer(),
          NotifBadge(
            child: _iconBtn(
              Icons.notifications_outlined,
              () => Get.toNamed(AppRoutes.notifications),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(
            () => _iconBtn(
              _logic.searchOpen.value
                  ? Icons.close_rounded
                  : Icons.search_rounded,
              _logic.toggleSearch,
              active: _logic.searchOpen.value,
            ),
          ),
        ],
      ),
    );
  }

  // ── Collapsible search bar + filter button ─────────────────────────────────
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
              ? EdgeInsets.fromLTRB(18.w, 0, 18.w, 8.h)
              : EdgeInsets.zero,
          child: open
              ? Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        controller: _searchCtrl,
                        focusNode: _searchFocusNode,
                        onChanged: _logic.onSearchChanged,
                        hintText: AppLocalizations.of(context)!.homeSearchHint,
                        autofocus: true,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Obx(
                      () => _iconBtn(
                        Icons.tune_rounded,
                        _showFilterSheet,
                        active: _logic.state.serviceId != null,
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      );
    });
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, {bool active = false}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFF43F5E).withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(13.r),
          border: active
              ? Border.all(
                  color: const Color(0xFFF43F5E).withValues(alpha: 0.30),
                  width: 0.5,
                )
              : null,
          boxShadow: active
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Icon(
          icon,
          size: 20.r,
          color: active ? const Color(0xFFF43F5E) : const Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  // ── Filter bar — reactive only to gender ──────────────────────────────────
  Widget _buildFilterBar() {
    return Obx(() {
      // Gender tab hidden — matching the disabled gender filter in
      // [HomeLogic] (API endpoint currently ignores gender). Kept in
      // code (not deleted) so we can re-enable together when the API
      // is ready.
      // final gender = _logic.state.gender;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gender tabs on white bg so the underline border is visible
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 18.w),
          //   child: GenderTabBar(selected: gender, onChanged: _onGenderChanged),
          // ),
          // SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: CategoryPillRow(
              selected: _logic.state.sort,
              onChanged: _logic.setSort,
            ),
          ),
          SizedBox(height: 10.h),
        ],
      );
    });
  }

  // ── Online section — reactive only to online data ──────────────────────────
  Widget _buildOnlineSection() {
    return Obx(() {
      final st = _logic.state;
      final isLoading =
          st.onlineStatus == HomeStatus.loading ||
          st.onlineStatus == HomeStatus.initial;
      if (isLoading) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              icon: Icons.fiber_new_rounded,
              iconColor: const Color(0xFF4CAF50),
              title: AppLocalizations.of(context)!.homeOnlineNow,
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
            title: AppLocalizations.of(context)!.homeOnlineNow,
            onViewAll: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ViewAllCompanionsPage()),
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
      final isLoading =
          st.recommendedStatus == HomeStatus.loading ||
          st.recommendedStatus == HomeStatus.initial;
      if (isLoading) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              icon: Icons.star_rounded,
              iconColor: const Color(0xFFFFB800),
              title: AppLocalizations.of(context)!.homeRecommended,
            ),
            RecommendedLoadingShimmer(count: 4),
          ],
        );
      }

      if (st.recommended.isEmpty) {
        final onlineIdle =
            st.onlineStatus != HomeStatus.loading &&
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
            title: AppLocalizations.of(context)!.homeRecommended,
            onViewAll: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ViewAllCompanionsPage()),
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
              itemCount:
                  st.recommended.length +
                  (st.recommendedStatus == HomeStatus.loadingMore ? 1 : 0),
              itemBuilder: (_, i) {
                if (i >= st.recommended.length) {
                  return const _LoadMoreCell();
                }
                final m = st.recommended[i];
                return CompanionCardSmall(
                  companion: _toCompanionModel(m),
                  onTap: () => _logic.openProfile(m),
                  onLikeTap: () => _logic.toggleLike(m.id ?? ''),
                );
              },
            ),
          ),
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
              onTap: () => _logic.openProfile(m),
              onLikeTap: () => _logic.toggleLike(m.id ?? ''),
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

    // Calculate distance from current position; fall back to server value
    double? dist;
    try {
      final pos = Get.find<LocationManager>().position.value;
      if (pos != null && m.latitude != null && m.longitude != null) {
        dist = distanceKmBetween(
          pos.latitude,
          pos.longitude,
          m.latitude!,
          m.longitude!,
        );
      } else {
        dist = m.distanceKm;
      }
    } catch (_) {
      dist = m.distanceKm;
    }

    return CompanionModel(
      id: m.id ?? '',
      name: '${m.firstName ?? ''} ${m.lastName ?? ''}'.trim(),
      age: age,
      imageUrl: m.profile ?? '',
      district: m.address ?? '',
      distanceKm: dist,
      rating: (m.rating ?? 0).toDouble(),
      reviewCount: m.totalReview ?? 0,
      isOnline: m.availableStatus == 'online',
      isVipElite: m.vip ?? false,
      gender: m.gender ?? 'male',
      gradientColors: const [Color(0xFF5C6BC0), Color(0xFF1A1A2E)],
      services: const [],
      isLiked: m.isLiked,
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
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.homeSeeAll,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12.sp,
                    color: AppColors.primary,
                  ),
                ],
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
          Icon(
            Icons.search_off_rounded,
            size: 60.r,
            color: const Color(0xFFD1D1E0),
          ),
          SizedBox(height: 14.h),
          Text(
            AppLocalizations.of(context)!.homeNoResults,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9B9BAD),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppLocalizations.of(context)!.homeTryFilter,
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFFBBBBCC)),
          ),
        ],
      ),
    );
  }

  // ── Filter bottom sheet ────────────────────────────────────────────────────
  void _showFilterSheet() {
    // Dismiss the search field's keyboard first so it doesn't fight the
    // sheet for screen space. Unfocus the field's own node directly —
    // more reliable than the ambient FocusScope call alone — then fall
    // back to the scope call in case focus is elsewhere.
    _searchFocusNode.unfocus();
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => _ServiceFilterSheet(
        services: _logic.state.services,
        initialSelectedId: _logic.state.serviceId,
        onApply: _logic.setServiceId,
      ),
    );
  }
}

// ── In-grid load-more shimmer cell ────────────────────────────────────────────
class _LoadMoreCell extends StatelessWidget {
  const _LoadMoreCell();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFF06292),
          strokeWidth: 2,
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  _ServiceFilterSheet — single-select Service filter bottom sheet
//  (the API accepts exactly one serviceId, so this must stay single-select)
// ═════════════════════════════════════════════════════════════════════════════
class _ServiceFilterSheet extends StatefulWidget {
  final List<ServiceModel> services;
  final String? initialSelectedId;
  final ValueChanged<String?> onApply;

  const _ServiceFilterSheet({
    required this.services,
    required this.initialSelectedId,
    required this.onApply,
  });

  @override
  State<_ServiceFilterSheet> createState() => _ServiceFilterSheetState();
}

class _ServiceFilterSheetState extends State<_ServiceFilterSheet> {
  late String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelectedId;
  }

  void _select(String? id) {
    if (id == null || id.isEmpty) return;
    setState(() {
      // Tapping the already-selected service deselects it (back to "All");
      // tapping any other service replaces the current selection — only
      // one serviceId can ever be sent to the API.
      _selected = _selected == id ? null : id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 2.h),
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.textDisabled,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.homeFilters,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (_selected != null)
                    GestureDetector(
                      onTap: () {
                        // Clear commits immediately (not staged behind
                        // Apply) — leaving a filter applied with no
                        // visible selection would be a stuck/confusing
                        // state.
                        setState(() => _selected = null);
                        widget.onApply(null);
                      },
                      child: Text(
                        l10n.homeClearFilter,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 10.h),
              child: Text(
                l10n.homeFilterByService,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Flexible(
              child: widget.services.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 36.h),
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
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 4.h),
                      shrinkWrap: true,
                      itemCount: widget.services.length,
                      itemBuilder: (_, i) {
                        final svc = widget.services[i];
                        return _ServiceFilterRow(
                          service: svc,
                          index: i,
                          selected: _selected != null && _selected == svc.id,
                          onTap: () => _select(svc.id),
                        );
                      },
                    ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 14.h),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_selected);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.homeApplyFilter,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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

// ── Service row — icon · translated name · checkbox indicator ──────────────
class _ServiceFilterRow extends StatelessWidget {
  final ServiceModel service;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  const _ServiceFilterRow({
    required this.service,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visual = _serviceVisual(service.name, index);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? visual.fg.withValues(alpha: 0.06)
              : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? visual.fg : Colors.transparent,
            width: 1.3,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: visual.bg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(visual.icon, size: 18.r, color: visual.fg),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                ServiceHelper.serviceOriginalName(service.name),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            // Circular radio indicator — a single choice among services,
            // not an independent on/off checkbox.
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                color: selected ? visual.fg : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? visual.fg : AppColors.textDisabled,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Icon(Icons.check_rounded, size: 14.r, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Icon + color pairing for a service row, keyed by its backend name ───────
class _ServiceVisual {
  final IconData icon;
  final Color fg;
  final Color bg;
  const _ServiceVisual(this.icon, this.fg, this.bg);
}

const _serviceVisualCycleIcons = [
  Icons.people_alt_outlined,
  Icons.spa_outlined,
  Icons.flight_takeoff_outlined,
];
const _serviceVisualCycleFg = [
  AppColors.socialFg,
  AppColors.massageFg,
  AppColors.travelFg,
];
const _serviceVisualCycleBg = [
  AppColors.socialBg,
  AppColors.massageBg,
  AppColors.travelBg,
];

_ServiceVisual _serviceVisual(String? name, int index) {
  switch (name) {
    case 'drinkingFriend':
      return const _ServiceVisual(
        Icons.people_alt_outlined,
        AppColors.socialFg,
        AppColors.socialBg,
      );
    case 'massage':
      return const _ServiceVisual(
        Icons.spa_outlined,
        AppColors.massageFg,
        AppColors.massageBg,
      );
    case 'travelingFriend':
      return const _ServiceVisual(
        Icons.flight_takeoff_outlined,
        AppColors.travelFg,
        AppColors.travelBg,
      );
    default:
      final i = index % _serviceVisualCycleIcons.length;
      return _ServiceVisual(
        _serviceVisualCycleIcons[i],
        _serviceVisualCycleFg[i],
        _serviceVisualCycleBg[i],
      );
  }
}
