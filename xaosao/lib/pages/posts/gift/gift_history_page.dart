import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/my_gift_history_model.dart';
import 'package:xaosao/pages/posts/gift/getx/gift_history_logic.dart';
import 'package:xaosao/pages/posts/gift/getx/gift_history_state.dart';
import 'package:xaosao/utils/l10n.dart' as g;
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class GiftHistoryPage extends StatefulWidget {
  const GiftHistoryPage({super.key});

  @override
  State<GiftHistoryPage> createState() => _GiftHistoryPageState();
}

class _GiftHistoryPageState extends State<GiftHistoryPage> {
  late final GiftHistoryLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = Get.put(GiftHistoryLogic());
  }

  @override
  void dispose() {
    Get.delete<GiftHistoryLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: l10n.giftHistoryTitle,
        subtitle: l10n.giftHistorySubtitle,
      ),
      body: SafeArea(top: false, child: Obx(() => _buildBody(_logic.state))),
    );
  }

  Widget _buildBody(GiftHistoryState state) {
    return switch (state.status) {
      GiftHistoryStatus.initial || GiftHistoryStatus.loading => _buildShimmer(),
      GiftHistoryStatus.failure => _buildFailure(state.error),
      GiftHistoryStatus.success =>
        state.items.isEmpty ? _buildEmpty() : _buildList(state.items),
    };
  }

  // ── Shimmer ──────────────────────────────────────────────────
  Widget _buildShimmer() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
      child: Column(
        children: [
          _ShimmerHero(),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (_, __) => _ShimmerRow(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Failure ──────────────────────────────────────────────────
  Widget _buildFailure(String? error) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 40.r, color: AppColors.textHint),
          SizedBox(height: 14.h),
          Text(
            error ?? l10n.commonLoadDataFailed,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: _logic.fetch,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                l10n.commonRetry,
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
    );
  }

  // ── Empty ────────────────────────────────────────────────────
  Widget _buildEmpty() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
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
              Icons.card_giftcard_rounded,
              size: 36.r,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.giftHistoryEmptyTitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            l10n.giftHistoryEmptySubtitle,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textHint,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── List ─────────────────────────────────────────────────────
  Widget _buildList(List<MyGiftHistoryModel> items) {
    final l10n = AppLocalizations.of(context)!;
    final total = items.fold<int>(0, (sum, e) => sum + ((e.amount ?? 0)));

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
          // Hero banner
          SliverToBoxAdapter(
            child: _SummaryHero(count: items.length, total: total),
          ),

          // Section label
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 10.h),
            sliver: SliverToBoxAdapter(
              child: Text(
                l10n.giftDetailsTitle,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHint,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Items
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _GiftHistoryTile(item: items[i]),
                ),
                childCount: items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary hero banner ──────────────────────────────────────────
class _SummaryHero extends StatelessWidget {
  final int count;
  final int total;
  const _SummaryHero({required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                    '$count',
                    style: TextStyle(
                      fontSize: 42.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    l10n.giftHistorySentTimes,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    l10n.giftHistorySpent(NumberFormat('#,###').format(total)),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 0.70),
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

// ── Single gift history tile ──────────────────────────────────────
class _GiftHistoryTile extends StatelessWidget {
  final MyGiftHistoryModel item;
  const _GiftHistoryTile({required this.item});

  String _fmtLak(int v) => '${NumberFormat('#,##0', 'en_US').format(v)} ${g.l10n.commonCurrencyKip}';

  String _ago(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return g.l10n.timeJustNowShort;
    if (diff.inHours < 1) return g.l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return g.l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays < 30) return g.l10n.timeDaysAgo(diff.inDays);
    return DateFormat('dd MMM').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gift = item.gift;
    final hasImage = (gift?.image ?? '').isNotEmpty;
    final total = (item.amount ?? 0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gift image
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: AppNetworkImage(
                      imageUrl: gift!.image!,
                      width: 52.r,
                      height: 52.r,
                      fit: BoxFit.cover,
                      accentColor: AppColors.primary,
                    ),
                  )
                : Icon(
                    Icons.card_giftcard_rounded,
                    size: 24.r,
                    color: AppColors.primary,
                  ),
          ),
          SizedBox(width: 12.w),

          // Name + amount badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gift?.name ?? l10n.giftFallback,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      _ago(item.createdAt),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),

          // Total + time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('🎁', style: TextStyle(fontSize: 16.sp)),
              SizedBox(height: 4.h),
              Text(
                _fmtLak(total),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
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

// ═══════════════════════════════════════════════════════════════
//  Shimmer placeholders
// ═══════════════════════════════════════════════════════════════
class _ShimmerHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(24.r),
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bg = Colors.black.withValues(alpha: 0.07);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110.w,
                  height: 13.h,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 70.w,
                  height: 11.h,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 32.w,
            height: 10.h,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
        ],
      ),
    );
  }
}
