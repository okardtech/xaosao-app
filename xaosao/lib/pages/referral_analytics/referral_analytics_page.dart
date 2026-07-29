import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/referral_mdoel.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';
import '../../widgets/app_svg_icon.dart';
import 'getx/referral_analytics_logic.dart';
import 'getx/referral_analytics_state.dart';

class ReferralAnalyticsPage extends StatelessWidget {
  const ReferralAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<ReferralAnalyticsLogic>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: l10n.analyticsTitle,
        subtitle: l10n.analyticsSubtitle,
        actions: [
          Obx(() {
            if (logic.state.status == ReferralStatus.loading) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: logic.fetch,
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Icon(
                  Icons.refresh_rounded,
                  size: 22.r,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        final st = logic.state;

        if (st.status == ReferralStatus.loading) {
          return const _AnalyticsShimmer();
        }

        if (st.status == ReferralStatus.failure || st.data == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.signal_wifi_off_rounded,
                  size: 48.r,
                  color: AppColors.textDisabled,
                ),
                SizedBox(height: 12.h),
                Text(
                  l10n.analyticsLoadFailed,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: logic.fetch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(l10n.analyticsRetry),
                ),
              ],
            ),
          );
        }

        final d = st.data!;
        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: Colors.white,
          strokeWidth: 2.5,
          onRefresh: logic.fetch,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 48.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _ProfileCard(data: d),
                // SizedBox(height: 14.h),
                _EarningsHero(stats: d.stats),
                SizedBox(height: 14.h),
                _SectionLabel(l10n.analyticsReferralStats),
                SizedBox(height: 10.h),
                _StatsGrid(stats: d.stats),
                SizedBox(height: 14.h),
                _SectionLabel(l10n.analyticsReferrals),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _DonutCard(
                        title: l10n.analyticsModels,
                        approved: d.stats?.approvedReferredModels ?? 0,
                        pending: d.stats?.pendingReferredModels ?? 0,
                        total: d.stats?.totalReferredModels ?? 0,
                        approvedLabel: l10n.analyticsApproved,
                        pendingLabel: l10n.analyticsPending,
                        approvedColor: const Color(0xFF22C55E),
                        pendingColor: AppColors.commissionFg,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _DonutCard(
                        title: l10n.analyticsCustomers,
                        approved: d.stats?.activeReferredCustomers ?? 0,
                        pending:
                            (d.stats?.totalReferredCustomers ?? 0) -
                            (d.stats?.activeReferredCustomers ?? 0),
                        total: d.stats?.totalReferredCustomers ?? 0,
                        approvedLabel: l10n.analyticsActive,
                        pendingLabel: l10n.analyticsInactive,
                        approvedColor: AppColors.primary,
                        pendingColor: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                _SectionLabel(l10n.analyticsEarnings),
                SizedBox(height: 10.h),
                _EarningsBarChart(stats: d.stats),
                SizedBox(height: 14.h),
                _SectionLabel(l10n.analyticsTierProgress),
                SizedBox(height: 10.h),
                _TierProgressCard(
                  data: d,
                  tierName: l10n.shareTierSpecial,
                  tierIcon: Icons.star_rounded,
                  tierColor: AppColors.commissionFg,
                  description: l10n.analyticsSpecialCondition(
                      d.upgradeProgress?.modelThreshold ?? 5),
                  current: d.upgradeProgress?.currentApprovedModels ?? 0,
                  target: d.upgradeProgress?.modelThreshold ?? 5,
                  canUpgrade: d.upgradeProgress?.canUpgradeToSpecial ?? false,
                ),
                SizedBox(height: 10.h),
                _PartnerTierCard(data: d),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Earnings hero
// ─────────────────────────────────────────────────────────────────
class _EarningsHero extends StatelessWidget {
  final Stats? stats;
  const _EarningsHero({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = stats?.totalEarnings ?? 0;
    final modelEarnings = stats?.modelReferralEarnings ?? 0;
    final commission = stats?.totalCommissionEarnings ?? 0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFBF0), Color(0xFFFFF0C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        // border: Border.all(
        //   color: AppColors.commissionFg.withValues(alpha: 0.3),
        // ),
        boxShadow: [
          BoxShadow(
            color: AppColors.commissionFg.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppColors.commissionFg.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: AppSvgIcon(
                  assetName: AppIcons.wallet,
                  width: 14.r,
                  height: 14.r,
                  color: AppColors.commissionFg,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                l10n.analyticsTotalEarnings,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF92400E),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            CurrFormatter.kip(total),
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.commissionFg,
              letterSpacing: -0.5,
              height: 1,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              _MiniStat(
                label: l10n.analyticsModelEarnings,
                value: CurrFormatter.kip(modelEarnings),
                color: const Color(0xFF22C55E),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 1.w,
                height: 28.h,
                color: AppColors.commissionFg.withValues(alpha: 0.2),
              ),
              SizedBox(width: 8.w),
              _MiniStat(
                label: l10n.analyticsCommission,
                value: CurrFormatter.kip(commission),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFFB45309)),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Stats grid
// ─────────────────────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final Stats? stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cells = [
      (
        icon: AppIcons.userGroup,
        label: l10n.analyticsAllModels,
        value: '${stats?.totalReferredModels ?? 0}',
        color: const Color(0xFF8B5CF6),
      ),
      (
        icon: AppIcons.verify,
        label: l10n.analyticsApprovedModels,
        value: '${stats?.approvedReferredModels ?? 0}',
        color: const Color(0xFF22C55E),
      ),
      (
        icon: AppIcons.user,
        label: l10n.analyticsAllCustomers,
        value: '${stats?.totalReferredCustomers ?? 0}',
        color: AppColors.primary,
      ),
      (
        icon: AppIcons.bolt,
        label: l10n.analyticsActiveCustomers,
        value: '${stats?.activeReferredCustomers ?? 0}',
        color: const Color(0xFF3B82F6),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10.w,
      mainAxisSpacing: 10.h,
      childAspectRatio: 2.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cells
          .map(
            (c) => _StatCell(
              icon: c.icon,
              label: c.label,
              value: c.value,
              color: c.color,
            ),
          )
          .toList(),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: AppSvgIcon(
              assetName: icon,
              width: 14.r,
              height: 14.r,
              color: color,
            ),
            // child: Icon(icon, size: 16.r, color: color),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Donut chart card
// ─────────────────────────────────────────────────────────────────
class _DonutCard extends StatelessWidget {
  final String title;
  final int approved;
  final int pending;
  final int total;
  final String approvedLabel;
  final String pendingLabel;
  final Color approvedColor;
  final Color pendingColor;

  const _DonutCard({
    required this.title,
    required this.approved,
    required this.pending,
    required this.total,
    required this.approvedLabel,
    required this.pendingLabel,
    required this.approvedColor,
    required this.pendingColor,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = total == 0;
    final sections = isEmpty
        ? [
            PieChartSectionData(
              value: 1,
              color: AppColors.bg,
              radius: 26.r,
              showTitle: false,
            ),
          ]
        : [
            if (approved > 0)
              PieChartSectionData(
                value: approved.toDouble(),
                color: approvedColor,
                radius: 26.r,
                showTitle: false,
              ),
            if (pending > 0)
              PieChartSectionData(
                value: pending.toDouble(),
                color: pendingColor,
                radius: 26.r,
                showTitle: false,
              ),
          ];

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 90.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: isEmpty ? 0 : 2,
                    centerSpaceRadius: 28.r,
                    sections: sections,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$total',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        height: 1,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.analyticsTotal,
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
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(
                color: approvedColor,
                label: '$approvedLabel ($approved)',
              ),
              SizedBox(width: 8.w),
              _Legend(color: pendingColor, label: '$pendingLabel ($pending)'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Earnings bar chart
// ─────────────────────────────────────────────────────────────────
class _EarningsBarChart extends StatelessWidget {
  final Stats? stats;
  const _EarningsBarChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modelE = (stats?.modelReferralEarnings ?? 0).toDouble();
    final bookingE = (stats?.bookingCommissionEarnings ?? 0).toDouble();
    final subE = (stats?.subscriptionCommissionEarnings ?? 0).toDouble();
    final maxY = [modelE, bookingE, subE, 1.0].reduce((a, b) => a > b ? a : b);

    final barColors = [
      const Color(0xFF22C55E),
      AppColors.primary,
      const Color(0xFF8B5CF6),
    ];
    final labels = [
      l10n.analyticsModels,
      l10n.analyticsBookings,
      l10n.analyticsSubscriptions,
    ];
    final values = [modelE, bookingE, subE];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.analyticsEarningsByType,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 140.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY * 1.25,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.textPrimary,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        CurrFormatter.kip(rod.toY.toInt()),
                        TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, meta) => Text(
                        labels[v.toInt()],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: AppColors.bg, strokeWidth: 1),
                ),
                barGroups: List.generate(3, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i] == 0 ? 0 : values[i],
                        color: barColors[i],
                        width: 28.w,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6.r),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY * 1.25,
                          color: barColors[i].withValues(alpha: 0.07),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Value labels
          Row(
            children: List.generate(3, (i) {
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 10.r,
                      height: 10.r,
                      decoration: BoxDecoration(
                        color: barColors[i],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      CurrFormatter.kip(values[i].toInt()),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Tier progress card (Special)
// ─────────────────────────────────────────────────────────────────
class _TierProgressCard extends StatelessWidget {
  final ReferralModel data;
  final String tierName;
  final IconData tierIcon;
  final Color tierColor;
  final String description;
  final int current;
  final int target;
  final bool canUpgrade;

  const _TierProgressCard({
    required this.data,
    required this.tierName,
    required this.tierIcon,
    required this.tierColor,
    required this.description,
    required this.current,
    required this.target,
    required this.canUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = target == 0 ? 1.0 : (current / target).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: canUpgrade
            ? Border.all(color: tierColor.withValues(alpha: 0.5))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(tierIcon, size: 16.r, color: tierColor),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.shareTierBadge(tierName),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              if (canUpgrade)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: tierColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    l10n.analyticsReady,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: tierColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.analyticsApprovedModels,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$current / $target',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: tierColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7.h,
              backgroundColor: tierColor.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(tierColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Partner tier card (dual progress)
// ─────────────────────────────────────────────────────────────────
class _PartnerTierCard extends StatelessWidget {
  final ReferralModel data;
  const _PartnerTierCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final up = data.upgradeProgress;
    final modelProg = ((up?.partnerModelProgress ?? 0) / 100.0).clamp(0.0, 1.0);
    final earningsProg = ((up?.partnerEarningsProgress ?? 0) / 100.0).clamp(
      0.0,
      1.0,
    );
    final canUpgrade = up?.canUpgradeToPartner ?? false;
    const color = Color(0xFF6366F1);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: canUpgrade
            ? Border.all(color: color.withValues(alpha: 0.5))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  size: 16.r,
                  color: color,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.shareTierBadge(l10n.shareTierPartner),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      l10n.analyticsPartnerCondition,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              if (canUpgrade)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    l10n.analyticsReady,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          _ProgressRow(
            label: l10n.analyticsModels,
            sublabel:
                '${up?.currentApprovedModels ?? 0} / ${up?.modelThreshold ?? 5}',
            progress: modelProg,
            color: color,
          ),
          SizedBox(height: 10.h),
          _ProgressRow(
            label: l10n.analyticsEarnings,
            sublabel:
                '${CurrFormatter.kip(up?.currentCommissionEarnings ?? 0)} / ${CurrFormatter.kip(up?.earningsThreshold ?? 1000000)}',
            progress: earningsProg,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String sublabel;
  final double progress;
  final Color color;
  const _ProgressRow({
    required this.label,
    required this.sublabel,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6.h,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Section label
// ─────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Shimmer skeleton
// ─────────────────────────────────────────────────────────────────
class _AnalyticsShimmer extends StatelessWidget {
  const _AnalyticsShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            _ShimmerBox(height: 84.h, radius: 20.r),
            SizedBox(height: 14.h),
            _ShimmerBox(height: 110.h, radius: 20.r),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: _ShimmerBox(height: 46.h, radius: 14.r),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _ShimmerBox(height: 46.h, radius: 14.r),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: _ShimmerBox(height: 46.h, radius: 14.r),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _ShimmerBox(height: 46.h, radius: 14.r),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: _ShimmerBox(height: 160.h, radius: 16.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _ShimmerBox(height: 160.h, radius: 16.r),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            _ShimmerBox(height: 200.h, radius: 16.r),
            SizedBox(height: 14.h),
            _ShimmerBox(height: 110.h, radius: 16.r),
            SizedBox(height: 10.h),
            _ShimmerBox(height: 130.h, radius: 16.r),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double height;
  final double radius;
  const _ShimmerBox({required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
