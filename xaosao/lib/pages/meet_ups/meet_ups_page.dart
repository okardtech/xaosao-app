import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/meet_ups/components/booking_card.dart';
import 'package:xaosao/pages/meet_ups/components/booking_model.dart';
import 'package:xaosao/pages/meet_ups/components/cancellation_policy.dart';

import '../meet_ups_details/components/meet_ups_detail_model.dart';
import '../meet_ups_details/meet_ups_details_page.dart';

// ═══════════════════════════════════════════════════════════════
//  MeetUpsPage — ນັດພົບ
//
//  CustomScrollView layout:
//    SliverToBoxAdapter  → header + policy banner
//    SliverPersistentHeader (pinned) → filter chips ຄ້າງເທິງ
//    SliverList          → booking cards
//
//  ຜົນ: scroll ໝົດໜ້າ, filter chips ຄ້າງ top ເວລາ scroll ລົງ
// ═══════════════════════════════════════════════════════════════
class MeetUpsPage extends StatefulWidget {
  const MeetUpsPage({super.key});

  @override
  State<MeetUpsPage> createState() => _MeetUpsPageState();
}

class _MeetUpsPageState extends State<MeetUpsPage> {
  BookingStatus? _filter;

  // ── Chip counts ────────────────────────────────────────────
  int _countFor(BookingStatus? status) {
    if (status == null) return mockBookings.length;
    if (status == BookingStatus.cancelled) {
      return mockBookings
          .where(
            (b) =>
                b.status == BookingStatus.cancelled ||
                b.status == BookingStatus.rejected,
          )
          .length;
    }
    return mockBookings.where((b) => b.status == status).length;
  }

  List<BookingModel> get _filtered {
    if (_filter == null) return mockBookings;
    if (_filter == BookingStatus.cancelled) {
      return mockBookings
          .where(
            (b) =>
                b.status == BookingStatus.cancelled ||
                b.status == BookingStatus.rejected,
          )
          .toList();
    }
    return mockBookings.where((b) => b.status == _filter).toList();
  }

  // chip colour per status
  Color _chipActiveColor(BookingStatus? status) => switch (status) {
    BookingStatus.upcoming => const Color(0xFF3B82F6),
    BookingStatus.completed => const Color(0xFF22C55E),
    BookingStatus.cancelled => const Color(0xFF9B9BAD),
    BookingStatus.rejected => const Color(0xFFF59E0B),
    null => const Color(0xFF1A1A2E),
  };

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── 1. Header + Policy banner (scrolls away) ────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    SizedBox(height: 14.h),
                    const CancellationPolicyBanner(initiallyExpanded: false),
                  ],
                ),
              ),
            ),

            // ── 2. Filter chips — pinned ─────────────────────────
            // ໃຊ້ SliverToBoxAdapter + LayoutBuilder ເພື່ອ pin
            // ດ້ວຍ SliverPersistentHeader ທີ່ height ຄຳນວນໄວ້ກ່ອນ
            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterChipsDelegate(
                filter: _filter,
                countFor: _countFor,
                activeColor: _chipActiveColor,
                onSelect: (status) => setState(() => _filter = status),
                // ຄຳນວນ height ໃນ build context ທີ່ ScreenUtil ພ້ອມແລ້ວ
                height: 12 + 34 + 8, // top pad + chip + bottom pad (logical px)
              ),
            ),

            // ── 3. Empty state ───────────────────────────────────
            if (filtered.isEmpty)
              SliverFillRemaining(hasScrollBody: false, child: _buildEmpty()),

            // ── 4. Booking cards ─────────────────────────────────
            if (filtered.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 80.h),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14.h),
                  itemBuilder: (_, i) => BookingCard(
                    booking: filtered[i],
                    onCancel: () {},
                    onMessage: () {},
                    onRebook: () {},
                    onViewDetail: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MeetUpsDetailsPage(
                          booking: mockBookingDetailUpcoming,
                        ),
                      ),
                    ),
                    onFindOther: () {},
                    onNewDate: () {},
                    onMapTap: () {},
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MeetUpsDetailsPage(
                          booking: mockBookingDetailUpcoming,
                        ),
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

  // ── Title block ─────────────────────────────────────────────
  Widget _buildTitle() {
    final count = _filtered.length;
    final sub = _filter == null
        ? 'ປະຫວັດການຈອງທັງໝົດ'
        : '$count ລາຍການ · ${_filter!.label}';

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

  // ── Empty state ─────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48.r,
            color: const Color(0xFFD1D1E0),
          ),
          SizedBox(height: 14.h),
          Text(
            'ບໍ່ມີລາຍການ',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9B9BAD),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'ລາຍການຈອງຈະສະແດງທີ່ນີ້',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFFC4C4D0)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _FilterChipsDelegate — SliverPersistentHeader delegate
//  ຄ້າງ filter chips ໄວ້ດ້ານເທິງ ເວລາ scroll ລົງ
// ═══════════════════════════════════════════════════════════════
class _FilterChipsDelegate extends SliverPersistentHeaderDelegate {
  final BookingStatus? filter;
  final int Function(BookingStatus?) countFor;
  final Color Function(BookingStatus?) activeColor;
  final ValueChanged<BookingStatus?> onSelect;

  // chip definitions
  static const _chips = <(String, BookingStatus?)>[
    ('ທັງໝົດ', null),
    ('ກຳລັງມາ', BookingStatus.upcoming),
    ('ສຳເລັດ', BookingStatus.completed),
    ('ຍົກເລີກ', BookingStatus.cancelled),
    ('ຖືກປະຕິເສດ', BookingStatus.rejected),
  ];

  const _FilterChipsDelegate({
    required this.filter,
    required this.countFor,
    required this.activeColor,
    required this.onSelect,
    required this.height,
  });

  final double height;

  // minExtent == maxExtent → ບໍ່ shrink, ບໍ່ expand (fixed height)
  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(_FilterChipsDelegate old) => old.filter != filter;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: height, // ໃຊ້ logical height ດຽວກັນກັບ minExtent/maxExtent
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
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8), // logical px
      child: _buildChips(),
    );
  }

  Widget _buildChips() {
    // Horizontal scroll pill chips — each is its own card, no bg wrapper
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _chips.length,
      separatorBuilder: (_, __) => SizedBox(width: 6.w),
      itemBuilder: (_, i) {
        final (label, status) = _chips[i];
        final isActive = filter == status;
        final accent = activeColor(status);
        final count = countFor(status);

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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : const Color(0xFF9B9BAD),
                  ),
                ),
                SizedBox(width: 5.w),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isActive ? accent : Colors.black.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: isActive ? Colors.white : const Color(0xFF9B9BAD),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
