import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/my_booking_model.dart';
import 'package:xaosao/pages/meet_ups/booking_detail_page.dart';
import 'package:xaosao/pages/meet_ups/components/booking_card.dart';
import 'package:xaosao/pages/meet_ups/components/cancellation_policy.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_logic.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_state.dart';
import 'package:xaosao/widgets/empty_state.dart';

class MeetUpsPage extends StatefulWidget {
  const MeetUpsPage({super.key});

  @override
  State<MeetUpsPage> createState() => _MeetUpsPageState();
}

class _MeetUpsPageState extends State<MeetUpsPage> {
  late final MeetUpLogic _logic;

  // Chip definitions — label + API status value
  static const _chips = <(String, String?)>[
    ('ທັງໝົດ', null),
    ('ລໍຖ້າ', 'pending'),
    ('ຢືນຢັນ', 'confirmed'),
    ('ກຳລັງດຳເນີນ', 'in_progress'),
    ('ລໍຢືນຢັນ', 'awaiting_confirmation'),
    ('ສຳເລັດ', 'completed'),
    ('ຍົກເລີກ', 'cancelled'),
    ('ຖືກປະຕິເສດ', 'rejected'),
    ('ຂໍ້ຂັດແຍ້ງ', 'disputed'),
  ];

  // Count items in the loaded list matching a given status chip
  int _countFor(String? status, List<MyBookingModel> all) {
    if (status == null) return all.length;
    return all.where((b) => b.status == status).length;
  }

  @override
  void initState() {
    super.initState();
    _logic = Get.find<MeetUpLogic>();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Obx(() {
          final state = _logic.state;
          final all = state.myBooking;
          final selectedStatus = state.selectedStatus;
          final isLoading = state.status == MeetUpStatus.loading && all.isEmpty;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── 1. Header + summary strip + policy ──────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(all.length, selectedStatus),
                      SizedBox(height: 14.h),

                      const CancellationPolicyBanner(initiallyExpanded: false),
                    ],
                  ),
                ),
              ),

              // ── 2. Filter chips — pinned ─────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterChipsDelegate(
                  selectedStatus: selectedStatus,
                  chips: _chips,
                  countFor: (s) => _countFor(s, all),
                  onSelect: (s) => _logic.filterBy(s),
                  height: 12 + 34 + 8,
                ),
              ),

              // ── 3. Loading shimmer ───────────────────────────────
              if (isLoading)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 0),
                  sliver: SliverList.separated(
                    itemCount: 4,
                    separatorBuilder: (_, __) => SizedBox(height: 14.h),
                    itemBuilder: (_, __) => const _ShimmerCard(),
                  ),
                ),

              // ── 4. Error state ───────────────────────────────────
              if (!isLoading && state.status == MeetUpStatus.failure)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    icon: Icons.wifi_off_rounded,
                    title: 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ',
                    subtitle: state.error ?? 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ',
                    iconColor: AppColors.primary,
                    actionLabel: 'ລອງໃໝ່',
                    onAction: () => _logic.filterBy(selectedStatus),
                  ),
                ),

              // ── 5. Empty state ───────────────────────────────────
              if (!isLoading &&
                  state.status == MeetUpStatus.success &&
                  all.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    icon: Icons.calendar_today_outlined,
                    title: 'ບໍ່ມີລາຍການ',
                    subtitle: 'ລາຍການຈອງຈະສະແດງທີ່ນີ້',
                    iconColor: AppColors.primary,
                  ),
                ),

              // ── 6. Booking cards ─────────────────────────────────
              if (!isLoading && all.isNotEmpty)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 80.h),
                  sliver: SliverList.separated(
                    itemCount: all.length,
                    separatorBuilder: (_, __) => SizedBox(height: 14.h),
                    itemBuilder: (_, i) => BookingCard(
                      booking: all[i],
                      isCustomer: _logic.isClient,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingDetailPage(
                            booking: all[i],
                            isCustomer: _logic.isClient,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // ── 7. Load more ─────────────────────────────────────
              if (!isLoading && all.isNotEmpty && state.hasMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: TextButton(
                        onPressed: _logic.loadMore,
                        child: Text(
                          'ໂຫຼດເພີ່ມ',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTitle(int count, String? selectedStatus) {
    final sub = selectedStatus == null
        ? 'ປະຫວັດການຈອງທັງໝົດ'
        : '$count ລາຍການ · ${_statusLabel(selectedStatus)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ນັດພົບ',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1A1A2E),
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          sub,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF9B9BAD)),
        ),
      ],
    );
  }

  static String _statusLabel(String? s) => switch (s) {
    'pending' => 'ລໍຖ້າ',
    'confirmed' => 'ຢືນຢັນ',
    'in_progress' => 'ກຳລັງດຳເນີນ',
    'awaiting_confirmation' => 'ລໍຢືນຢັນ',
    'completed' => 'ສຳເລັດ',
    'cancelled' => 'ຍົກເລີກ',
    'rejected' => 'ຖືກປະຕິເສດ',
    'disputed' => 'ຂໍ້ຂັດແຍ້ງ',
    _ => 'ທັງໝົດ',
  };
}

// ═══════════════════════════════════════════════════════════════
//  _FilterChipsDelegate — pinned filter chips
// ═══════════════════════════════════════════════════════════════
class _FilterChipsDelegate extends SliverPersistentHeaderDelegate {
  final String? selectedStatus;
  final List<(String, String?)> chips;
  final int Function(String?) countFor;
  final ValueChanged<String?> onSelect;
  final double height;

  static Color _accentFor(String? s) => switch (s) {
    'pending' => const Color(0xFF3B82F6),
    'confirmed' => const Color(0xFF8B5CF6),
    'in_progress' => const Color(0xFFF59E0B),
    'awaiting_confirmation' => const Color(0xFFF97316),
    'completed' => const Color(0xFF22C55E),
    'cancelled' => const Color(0xFF9B9BAD),
    'rejected' => const Color(0xFFEF4444),
    'disputed' => const Color(0xFFEC4899),
    _ => const Color(0xFF1A1A2E),
  };

  const _FilterChipsDelegate({
    required this.selectedStatus,
    required this.chips,
    required this.countFor,
    required this.onSelect,
    required this.height,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(_FilterChipsDelegate old) =>
      old.selectedStatus != selectedStatus;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FC),
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: chips.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (_, i) {
          final (label, status) = chips[i];
          final isActive = selectedStatus == status;

          return GestureDetector(
            onTap: () => onSelect(status),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isActive
                      ? AppColors.primary
                      : Colors.black.withOpacity(0.09),
                  width: 0.5,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : const Color(0xFF9B9BAD),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ShimmerCard
// ═══════════════════════════════════════════════════════════════
class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: Colors.black.withOpacity(0.06), width: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _box(46.r, 46.r, radius: 14.r),
                SizedBox(width: 11.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(12.h, 120.w),
                      SizedBox(height: 6.h),
                      _box(10.h, 80.w),
                    ],
                  ),
                ),
                _box(24.h, 60.w, radius: 20.r),
              ],
            ),
            SizedBox(height: 14.h),
            _box(12.h, double.infinity),
            SizedBox(height: 8.h),
            _box(12.h, 160.w),
          ],
        ),
      ),
    );
  }

  static Widget _box(double h, double w, {double radius = 6}) {
    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
