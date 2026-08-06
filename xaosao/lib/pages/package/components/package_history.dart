import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/package_history_model.dart';
import 'package:xaosao/pages/package/getx/package_logic.dart';
import 'package:xaosao/utils/l10n.dart' as g;
import 'package:xaosao/widgets/gradient_app_bar.dart';

List<String> get _kLaoMonths => [
  '',
  g.l10n.monthShortJan,
  g.l10n.monthShortFeb,
  g.l10n.monthShortMar,
  g.l10n.monthShortApr,
  g.l10n.monthShortMay,
  g.l10n.monthShortJun,
  g.l10n.monthShortJul,
  g.l10n.monthShortAug,
  g.l10n.monthShortSep,
  g.l10n.monthShortOct,
  g.l10n.monthShortNov,
  g.l10n.monthShortDec,
];

String _fmtDate(DateTime? d) {
  if (d == null) return '—';
  return '${d.day} ${_kLaoMonths[d.month]} ${d.year}';
}

String _fmtKip(int? n) =>
    '${NumberFormat.decimalPattern().format(n ?? 0)} ${g.l10n.commonCurrencyKip}';

// Status helpers
Color _accentColor(String? s) => switch (s) {
  'active' || 'completed' || 'approved' || 'released' => AppColors.online,
  'pending' || 'pending_release' || 'held' => const Color(0xFFF59E0B),
  'canceled' || 'rejected' => const Color(0xFFEF4444),
  'refunded' => const Color(0xFF8B5CF6),
  'expired' => AppColors.textHint,
  'upgraded' => const Color(0xFF3B82F6),
  'superseded' => AppColors.textHint,
  _ => AppColors.textHint,
};

Color _badgeBg(String? s) => switch (s) {
  'active' ||
  'completed' ||
  'approved' ||
  'released' => const Color(0xFFEDFAF3),
  'pending' || 'pending_release' || 'held' => const Color(0xFFFFFBEB),
  'canceled' || 'rejected' => const Color(0xFFFEF2F2),
  'refunded' => const Color(0xFFF5F3FF),
  'expired' => AppColors.surfaceSecondary,
  'upgraded' => const Color(0xFFEFF6FF),
  'superseded' => const Color(0xFFEEF2FF),
  _ => AppColors.surfaceSecondary,
};

Color _badgeFg(String? s) => switch (s) {
  'active' ||
  'completed' ||
  'approved' ||
  'released' => const Color(0xFF15803D),
  'pending' || 'pending_release' || 'held' => const Color(0xFF92400E),
  'canceled' || 'rejected' => const Color(0xFFB91C1C),
  'refunded' => const Color(0xFF6D28D9),
  'expired' => AppColors.textHint,
  'upgraded' => const Color(0xFF1D4ED8),
  'superseded' => AppColors.textHint,
  _ => AppColors.textHint,
};

String _statusLabel(String? s) => switch (s) {
  'active' => g.l10n.packageStatusActive,
  'completed' || 'approved' || 'released' => g.l10n.packageStatusCompleted,
  'pending' => g.l10n.packageStatusPending,
  'pending_release' => g.l10n.packageStatusPendingRelease,
  'canceled' || 'rejected' => g.l10n.packageStatusCanceled,
  'refunded' => g.l10n.packageStatusRefunded,
  'expired' => g.l10n.packageStatusExpired,
  'upgraded' => g.l10n.packageStatusUpgraded,
  'held' => g.l10n.packageStatusHeld,
  'superseded' => g.l10n.packageStatusSuperseded,
  _ => s ?? '—',
};

List<(String, String?)> _buildChips(AppLocalizations l10n) => [
  (l10n.commonAll, null),
  (l10n.packageStatusUpgraded, 'upgraded'),
  (l10n.packageStatusSuperseded, 'superseded'),
  (l10n.packageStatusActive, 'active'),
  (l10n.packageStatusCanceled, 'canceled'),
];

class PackageHistoryPage extends StatefulWidget {
  const PackageHistoryPage({super.key});

  @override
  State<PackageHistoryPage> createState() => _PackageHistoryPageState();
}

class _PackageHistoryPageState extends State<PackageHistoryPage> {
  late final PackageLogic _logic;
  String? _filter;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<PackageLogic>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _logic.fetchHistory(reset: true),
    );
  }

  List<PackageHistoryModel> _filtered(List<PackageHistoryModel> all) =>
      _filter == null ? all : all.where((h) => h.status == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: l10n.packageHistoryTitle,
        subtitle: l10n.packageHistorySubtitle,
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          _buildFilterChips(l10n),
          Expanded(child: Obx(() => _buildList(l10n))),
        ],
      ),
    );
  }

  // ── Filter chips ────────────────────────────────────────────
  Widget _buildFilterChips(AppLocalizations l10n) {
    final chips = _buildChips(l10n);
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: chips.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (_, i) {
          final (label, status) = chips[i];
          final isOn = _filter == status;
          return GestureDetector(
            onTap: () => setState(() => _filter = status),
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isOn ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isOn ? AppColors.primary : AppColors.borderMedium,
                  width: 0.5,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: isOn ? Colors.white : AppColors.textHint,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── List ────────────────────────────────────────────────────
  Widget _buildList(AppLocalizations l10n) {
    final st = _logic.state;
    if (st.loadingHistory && st.history.isEmpty) {
      return _HistoryListShimmer();
    }
    final list = _filtered(st.history);
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48.r,
              color: AppColors.textDisabled,
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.packageHistoryEmpty,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      itemCount: list.length + (st.hasMoreHistory ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, i) {
        if (i == list.length) {
          _logic.fetchHistory();
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          );
        }
        return _HistoryCard(item: list[i]);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _HistoryCard
// ═══════════════════════════════════════════════════════════════
class _HistoryCard extends StatelessWidget {
  final PackageHistoryModel item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = _accentColor(item.status);
    final isExpiredOrCanceled =
        item.status == 'expired' ||
        item.status == 'canceled' ||
        item.status == 'superseded';
    final isActive = item.status == 'active';
    final now = DateTime.now();
    final daysLeft = item.endDate != null && item.endDate!.isAfter(now)
        ? item.endDate!.difference(now).inDays
        : null;
    final progress =
        (item.durationDays != null &&
            item.durationDays! > 0 &&
            daysLeft != null)
        ? (daysLeft / item.durationDays!).clamp(0.0, 1.0)
        : null;

    return Opacity(
      opacity: isExpiredOrCanceled ? 0.65 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: isExpiredOrCanceled ? 0.0 : 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Accent bar ─────────────────────────────────
              Container(
                width: 4.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [accent, accent.withValues(alpha: 0.4)],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 13.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Row 1: name + badge ───────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.planName ?? '—',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (item.durationDays != null) ...[
                                  SizedBox(height: 4.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 7.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      l10n.packageDaysRemaining(
                                        item.durationDays!,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: isExpiredOrCanceled
                                            ? AppColors.textDisabled
                                            : accent,
                                        decoration: isExpiredOrCanceled
                                            ? TextDecoration.lineThrough
                                            : null,
                                        decorationColor: AppColors.textDisabled,
                                        decorationThickness: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: _badgeBg(item.status),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              _statusLabel(item.status),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: _badgeFg(item.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // ── Row 2: date pills ─────────────────
                      Row(
                        children: [
                          _MetaPill(
                            icon: Icons.calendar_month_outlined,
                            iconColor: accent,
                            text: _fmtDate(item.createdAt),
                            tint: accent.withValues(alpha: 0.07),
                          ),
                          if (item.endDate != null) ...[
                            SizedBox(width: 7.w),
                            _MetaPill(
                              icon: Icons.event_outlined,
                              iconColor: AppColors.textHint,
                              text: l10n.packageExpiresShort(
                                _fmtDate(item.endDate),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // ── Row 3: price ──────────────────────
                      Row(
                        children: [
                          Text(
                            l10n.packageAmount,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textHint,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _fmtKip(item.planPrice),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                              color: isExpiredOrCanceled
                                  ? AppColors.textDisabled
                                  : AppColors.textPrimary,
                              letterSpacing: -0.4,
                              decoration: isExpiredOrCanceled
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: AppColors.textDisabled,
                              decorationThickness: 2,
                            ),
                          ),
                        ],
                      ),

                      // ── Active: days remaining progress ───
                      if (isActive && daysLeft != null && progress != null) ...[
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.timelapse_rounded,
                              size: 11.r,
                              color: AppColors.commissionFg,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              l10n.packageDaysRemaining(daysLeft),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.commissionFg,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final Color? tint;
  const _MetaPill({
    required this.icon,
    required this.iconColor,
    required this.text,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: tint ?? AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.r, color: iconColor),
          SizedBox(width: 5.w),
          Text(
            text,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer ─────────────────────────────────────────────────────
class _HistoryListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFFE8E8F0),
        highlightColor: const Color(0xFFF5F5FA),
        child: Container(
          height: 100.h,
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
    );
  }
}
