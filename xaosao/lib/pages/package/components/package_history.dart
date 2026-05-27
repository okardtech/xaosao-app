import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/package_history_model.dart';
import 'package:xaosao/pages/package/getx/package_logic.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

const _kLaoMonths = [
  '',
  'ມ.ກ',
  'ກ.ພ',
  'ມ.ນ',
  'ມ.ສ',
  'ພ.ພ',
  'ມ.ຖ',
  'ກ.ລ',
  'ສ.ຫ',
  'ກ.ຍ',
  'ຕ.ລ',
  'ພ.ຈ',
  'ທ.ວ',
];

String _fmtDate(DateTime? d) {
  if (d == null) return '—';
  return '${d.day} ${_kLaoMonths[d.month]} ${d.year}';
}

String _fmtKip(int? n) => '${NumberFormat.decimalPattern().format(n ?? 0)} ກີບ';

// Status helpers
Color _accentColor(String? s) => switch (s) {
  'active' => AppColors.online,
  'completed' => AppColors.online,
  'pending' => const Color(0xFFF59E0B),
  'canceled' => const Color(0xFFEF4444),
  'expired' => AppColors.textHint,
  'upgraded' => const Color(0xFF3B82F6),
  _ => AppColors.textHint,
};

Color _badgeBg(String? s) => switch (s) {
  'active' || 'completed' => const Color(0xFFEDFAF3),
  'pending' => const Color(0xFFFFFBEB),
  'canceled' => const Color(0xFFFEF2F2),
  'expired' => AppColors.surfaceSecondary,
  'upgraded' => const Color(0xFFEFF6FF),
  _ => AppColors.surfaceSecondary,
};

Color _badgeFg(String? s) => switch (s) {
  'active' || 'completed' => const Color(0xFF15803D),
  'pending' => const Color(0xFF92400E),
  'canceled' => const Color(0xFFB91C1C),
  'expired' => AppColors.textHint,
  'upgraded' => const Color(0xFF1D4ED8),
  _ => AppColors.textHint,
};

String _statusLabel(String? s) => switch (s) {
  'active' => 'ກຳລັງໃຊ້',
  'completed' => 'ສຳເລັດ',
  'pending' => 'ລໍຖ້າ',
  'canceled' => 'ຍົກເລີກ',
  'expired' => 'ໝົດອາຍຸ',
  'upgraded' => 'ອັບເກຣດ',
  _ => s ?? '—',
};

const _kChips = <(String, String?)>[
  ('ທັງໝົດ', null),
  ('ລໍຖ້າ', 'pending'),
  ('ກຳລັງໃຊ້', 'active'),
  ('ໝົດອາຍຸ', 'expired'),
  ('ຍົກເລີກ', 'canceled'),
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
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ປະຫວັດ Package',
        subtitle: 'ລາຍການຊື້ທັງໝົດ',
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          _buildFilterChips(),
          Expanded(child: Obx(() => _buildList())),
        ],
      ),
    );
  }

  // ── Filter chips ────────────────────────────────────────────
  Widget _buildFilterChips() {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _kChips.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (_, i) {
          final (label, status) = _kChips[i];
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
  Widget _buildList() {
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
              'ບໍ່ມີລາຍການ',
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
    final accent = _accentColor(item.status);
    final isExpiredOrCanceled =
        item.status == 'expired' || item.status == 'canceled';
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
                                      '${item.durationDays} ວັນ',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: accent,
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
                              horizontal: 9.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: _badgeBg(item.status),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5.r,
                                  height: 5.r,
                                  decoration: BoxDecoration(
                                    color: _badgeFg(item.status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  _statusLabel(item.status),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: _badgeFg(item.status),
                                  ),
                                ),
                              ],
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
                              text: 'ໝົດ ${_fmtDate(item.endDate)}',
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // ── Row 3: price ──────────────────────
                      Row(
                        children: [
                          Text(
                            'ຈຳນວນ',
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
                              'ຍັງເຫຼືອ $daysLeft ວັນ',
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
          ),
        ),
      ),
    );
  }
}
