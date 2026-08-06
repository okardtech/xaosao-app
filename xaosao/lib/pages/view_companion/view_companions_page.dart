import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/Recommended_model.dart';
import 'package:xaosao/pages/view_companion/components/companion_discover_card.dart';
import 'package:xaosao/pages/view_companion/components/companion_discover_shimmer.dart';
import 'package:xaosao/pages/view_companion/getx/view_companion_logic.dart';
import 'package:xaosao/pages/view_companion/getx/view_companion_state.dart';
import 'package:xaosao/widgets/empty_state.dart';

class ViewAllCompanionsPage extends StatefulWidget {
  const ViewAllCompanionsPage({super.key});

  @override
  State<ViewAllCompanionsPage> createState() => _ViewAllCompanionsPageState();
}

class _ViewAllCompanionsPageState extends State<ViewAllCompanionsPage> {
  late final ViewCompanionLogic _logic;
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  // label → API filter value. Built at build-time so labels follow locale.
  List<(String, String?)> _buildFilters(AppLocalizations l10n) => [
        (l10n.commonAll, 'all'),
        ('★ VIP', 'vip'),
        (l10n.viewCompanionFilterLikedByMe, 'liked-by-me'),
        (l10n.viewCompanionFilterWhoLikedMe, 'who-liked-me'),
        (l10n.viewCompanionFilterNearby, 'nearby'),
        (l10n.viewCompanionFilterNew, 'new'),
        (l10n.viewCompanionFilterPopular, 'popular'),
      ];

  @override
  void initState() {
    super.initState();
    _logic = Get.put(ViewCompanionLogic());
    _searchCtrl.addListener(() => _logic.onSearchChanged(_searchCtrl.text));
    _scrollCtrl.addListener(_onScroll);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    Get.delete<ViewCompanionLogic>();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      _logic.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildSearchBar(),
              _buildFilterChips(),
              Expanded(
                child: Obx(() {
                  final state = _logic.state;
                  final list = state.companions;
                  final isLoading =
                      state.status == ViewCompanionStatus.loading && list.isEmpty;

                  if (isLoading) return _buildShimmerGrid();

                  if (state.status == ViewCompanionStatus.failure &&
                      list.isEmpty) {
                    final l10n = AppLocalizations.of(context)!;
                    return AppEmptyState(
                      icon: Icons.wifi_off_rounded,
                      title: l10n.commonLoadDataFailed,
                      subtitle: state.error ?? l10n.commonPleaseRetry,
                      iconColor: AppColors.primary,
                      actionLabel: l10n.commonRetry,
                      onAction: _logic.retry,
                    );
                  }

                  if (state.status == ViewCompanionStatus.success &&
                      list.isEmpty) {
                    final l10n = AppLocalizations.of(context)!;
                    return AppEmptyState(
                      icon: Icons.search_off_rounded,
                      title: l10n.viewCompanionEmptyTitle,
                      subtitle: l10n.viewCompanionEmptySubtitle,
                      iconColor: AppColors.primary,
                    );
                  }

                  return _buildGrid(state, list);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08), width: 0.5),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15.r, color: AppColors.textPrimary),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            AppLocalizations.of(context)!.viewCompanionPageTitle,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
              color: Colors.black.withValues(alpha: 0.08), width: 0.5),
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
            Icon(Icons.search_rounded, size: 16.r, color: AppColors.textHint),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                style:
                    TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)!.viewCompanionSearchHint,
                  hintStyle: TextStyle(
                      fontSize: 13.sp, color: AppColors.textDisabled),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchCtrl.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchCtrl.clear();
                  _logic.onSearchChanged('');
                },
                child: Icon(Icons.close_rounded,
                    size: 16.r, color: AppColors.textHint),
              ),
          ],
        ),
      ),
    );
  }

  // ── Filter chips ───────────────────────────────────────
  Widget _buildFilterChips() {
    final filters = _buildFilters(AppLocalizations.of(context)!);
    return Obx(() {
      final selected = _logic.state.filter;
      return SizedBox(
        height: 34.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: filters.length,
          separatorBuilder: (_, __) => SizedBox(width: 7.w),
          itemBuilder: (_, i) {
            final (label, value) = filters[i];
            final isActive = selected == value;
            return GestureDetector(
              onTap: () => _logic.filterBy(value),
              child: AnimatedContainer(
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 160),
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : AppColors.textHint,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // ── Grid ───────────────────────────────────────────────
  Widget _buildGrid(
      ViewCompanionState state, List<RecommendedModel> list) {
    return GridView.builder(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.68,
      ),
      itemCount: list.length +
          (state.status == ViewCompanionStatus.loading ? 2 : 0),
      itemBuilder: (_, i) {
        if (i >= list.length) return const CompanionDiscoverShimmer();
        final m = list[i];
        return CompanionDiscoverCard(
          companion: m,
          onTap: () => _logic.openProfile(m),
          onLikeTap: () => _logic.toggleLike(m.id ?? ''),
        );
      },
    );
  }

  // ── Initial shimmer ────────────────────────────────────
  Widget _buildShimmerGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 24.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.68,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const CompanionDiscoverShimmer(),
    );
  }
}
