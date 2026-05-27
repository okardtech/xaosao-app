import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/my_booking_model.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_logic.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/utils/date_time_formatter.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/app_text_field.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';

class BookingDetailPage extends StatelessWidget {
  final MyBookingModel booking;
  final bool isCustomer;
  final VoidCallback? onMessage;

  const BookingDetailPage({
    super.key,
    required this.booking,
    required this.isCustomer,
    this.onMessage,
  });

  MeetUpLogic get _logic => Get.find<MeetUpLogic>();

  // ── Status helpers ────────────────────────────────────────────────────
  static bool _isCompleted(String? s) => s == 'completed';
  static bool _isRejected(String? s) => s == 'rejected' || s == 'disputed';

  static Color _accentColor(String? s) {
    const active = {'pending', 'confirmed', 'in_progress', 'awaiting_confirmation'};
    if (active.contains(s)) return const Color(0xFF3B82F6);
    if (_isCompleted(s)) return const Color(0xFF22C55E);
    if (_isRejected(s)) return const Color(0xFFF59E0B);
    return const Color(0xFFE0E0E0);
  }

  static Color _badgeBg(String? s) {
    const active = {'pending', 'confirmed', 'in_progress', 'awaiting_confirmation'};
    if (active.contains(s)) return const Color(0xFFEFF6FF);
    if (_isCompleted(s)) return const Color(0xFFEDFAF3);
    if (_isRejected(s)) return const Color(0xFFFFFBEB);
    return const Color(0xFFF0F0F5);
  }

  static Color _badgeFg(String? s) {
    const active = {'pending', 'confirmed', 'in_progress', 'awaiting_confirmation'};
    if (active.contains(s)) return const Color(0xFF1D4ED8);
    if (_isCompleted(s)) return const Color(0xFF15803D);
    if (_isRejected(s)) return const Color(0xFF92400E);
    return const Color(0xFF9B9BAD);
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
    _ => '-',
  };

  static String _paymentLabel(String? s) => switch (s) {
    'paid' => 'ຊຳລະແລ້ວ',
    'pending' => 'ລໍຖ້າຊຳລະ',
    'released' => 'ປ່ອຍເງີນແລ້ວ',
    'refunded' => 'ຄືນເງີນແລ້ວ',
    _ => s ?? '-',
  };

  static String _serviceTypeName(MyBookingModel b) {
    final svc = b.modelService;
    if (svc != null) {
      if (svc.customRate != null) return 'ບໍລິການລາຍວັນ';
      if (svc.customHourlyRate != null) return 'ບໍລິການລາຍຊົ່ວໂມງ';
      if (svc.customOneTimePrice != null) return 'ບໍລິການຄັ້ງດຽວ';
      if (svc.customOneNightPrice != null) return 'ບໍລິການຄືນດຽວ';
      if (svc.customMinuteRate != null) return 'ບໍລິການລາຍນາທີ';
    }
    if (b.dayAmount != null) return 'ບໍລິການລາຍວັນ';
    if (b.hours != null) return 'ບໍລິການລາຍຊົ່ວໂມງ';
    return 'ບໍລິການ';
  }

  static const _dark = Color(0xFF1A1A2E);

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final model = b.model;
    final nameParts = [model?.firstName, model?.lastName]
        .where((s) => s != null && s.isNotEmpty);
    final displayName = nameParts.isEmpty ? 'ບໍ່ມີຊື່' : nameParts.join(' ');
    final accent = _accentColor(b.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero SliverAppBar ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            backgroundColor: _dark,
            foregroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha:0.35),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.r,
                  color: Colors.white,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _HeroBackground(
                photoUrl: model?.profile ?? '',
                displayName: displayName,
                age: model?.age,
                hasTip: b.hasTip,
                accent: accent,
                serviceType: _serviceTypeName(b),
                badgeBg: _badgeBg(b.status),
                badgeFg: _badgeFg(b.status),
                statusLabel: _statusLabel(b.status),
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick stats row
                  _StatsRow(booking: b),
                  SizedBox(height: 14.h),

                  // Schedule
                  _InfoCard(
                    icon: Icons.calendar_month_outlined,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'ຕາຕະລາງ',
                    child: _ScheduleContent(booking: b),
                  ),
                  SizedBox(height: 10.h),

                  // Location
                  _InfoCard(
                    icon: Icons.location_on_outlined,
                    iconColor: AppColors.primary,
                    title: 'ສະຖານທີ',
                    child: Text(
                      b.location ?? '-',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: _dark,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Payment
                  _InfoCard(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: const Color(0xFF22C55E),
                    title: 'ການຊຳລະ',
                    child: _PaymentContent(
                      booking: b,
                      paymentLabel: _paymentLabel(b.paymentStatus),
                    ),
                  ),

                  if (b.preferredAttire != null &&
                      b.preferredAttire!.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    _InfoCard(
                      icon: Icons.checkroom_outlined,
                      iconColor: const Color(0xFF8B5CF6),
                      title: 'ການແຕ່ງກາຍ',
                      child: Text(
                        b.preferredAttire!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: _dark,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 10.h),

                  // Booking ID & created-at
                  _BookingIdRow(id: b.id, createdAt: b.createdAt),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        booking: b,
        isCustomer: isCustomer,
        onMessage: onMessage,
        logic: _logic,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Hero background
// ═══════════════════════════════════════════════════════════════
class _HeroBackground extends StatelessWidget {
  final String photoUrl;
  final String displayName;
  final int? age;
  final bool? hasTip;
  final Color accent;
  final String serviceType;
  final Color badgeBg;
  final Color badgeFg;
  final String statusLabel;

  const _HeroBackground({
    required this.photoUrl,
    required this.displayName,
    required this.age,
    required this.hasTip,
    required this.accent,
    required this.serviceType,
    required this.badgeBg,
    required this.badgeFg,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AppNetworkImage(
          imageUrl: photoUrl,
          fit: BoxFit.cover,
          accentColor: AppColors.primary,
        ),
        // Gradient
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha:0.25),
                Colors.black.withValues(alpha:0.78),
              ],
              stops: const [0.35, 0.6, 1.0],
            ),
          ),
        ),
        // Info overlay
        Positioned(
          left: 20.w,
          right: 20.w,
          bottom: 20.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha:0.22),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: accent.withValues(alpha:0.55),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      serviceType,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: badgeFg,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                displayName,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
              if (age != null)
                Text(
                  '$age ປີ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha:0.72),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (hasTip == true)
                Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.volunteer_activism_outlined,
                        size: 12.r,
                        color: const Color(0xFFF59E0B),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'ມີທິບໃຫ້ພ້ອມ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Quick stats row — 3 cells
// ═══════════════════════════════════════════════════════════════
class _StatsRow extends StatelessWidget {
  final MyBookingModel booking;

  const _StatsRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final priceStr =
        b.price != null ? CurrFormatter.kip(b.price!) : '-';

    String durationStr = '-';
    if (b.dayAmount != null) {
      durationStr = '${b.dayAmount} ວັນ';
    } else if (b.hours != null) {
      durationStr = '${b.hours} ຊົ່ວໂມງ';
    }

    final dateStr = DateTimeFormatter.dateFormatter(b.startDate) ?? '-';

    return Row(
      children: [
        Expanded(
          child: _StatCell(
            icon: Icons.payments_outlined,
            iconColor: AppColors.primary,
            label: 'ລາຄາ',
            value: priceStr,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatCell(
            icon: Icons.schedule_outlined,
            iconColor: const Color(0xFF8B5CF6),
            label: 'ໄລຍະ',
            value: durationStr,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatCell(
            icon: Icons.event_outlined,
            iconColor: const Color(0xFF3B82F6),
            label: 'ວັນທີ',
            value: dateStr,
          ),
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCell({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 14.r, color: iconColor),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xFF9B9BAD),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Info card (icon + title + content)
// ═══════════════════════════════════════════════════════════════
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, size: 14.r, color: iconColor),
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Schedule content
// ═══════════════════════════════════════════════════════════════
class _ScheduleContent extends StatelessWidget {
  final MyBookingModel booking;

  const _ScheduleContent({required this.booking});

  static const _dark = Color(0xFF1A1A2E);
  static const _grey = Color(0xFF9B9BAD);

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final start = DateTimeFormatter.dateFormatter(b.startDate);
    final end = DateTimeFormatter.dateFormatter(b.endDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Row(label: 'ເລີ່ມ', value: start ?? '-'),
        if (end != null && end != start) ...[
          SizedBox(height: 6.h),
          _Row(label: 'ສິ້ນສຸດ', value: end),
        ],
        if (b.dayAmount != null) ...[
          SizedBox(height: 6.h),
          _Row(label: 'ຈຳນວນວັນ', value: '${b.dayAmount} ວັນ'),
        ],
        if (b.hours != null) ...[
          SizedBox(height: 6.h),
          _Row(label: 'ຈຳນວນຊົ່ວໂມງ', value: '${b.hours} ຊົ່ວໂມງ'),
        ],
      ],
    );
  }

  Widget _Row({required String label, required String value}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: _grey),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: _dark,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Payment content
// ═══════════════════════════════════════════════════════════════
class _PaymentContent extends StatelessWidget {
  final MyBookingModel booking;
  final String paymentLabel;

  const _PaymentContent({
    required this.booking,
    required this.paymentLabel,
  });

  static const _dark = Color(0xFF1A1A2E);
  static const _grey = Color(0xFF9B9BAD);

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final isStrike =
        b.status == 'cancelled' || b.status == 'rejected' || b.status == 'disputed';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('ລາຄາທັງໝົດ', style: TextStyle(fontSize: 13.sp, color: _grey)),
            const Spacer(),
            Text(
              b.price != null ? CurrFormatter.kip(b.price!) : '-',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: isStrike ? const Color(0xFFD1D1E0) : AppColors.primary,
                decoration: isStrike ? TextDecoration.lineThrough : null,
                decorationColor: const Color(0xFFD1D1E0),
                decorationThickness: 2,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Text(
              'ສະຖານະຊຳລະ',
              style: TextStyle(fontSize: 13.sp, color: _grey),
            ),
            const Spacer(),
            Text(
              paymentLabel,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: _dark,
              ),
            ),
          ],
        ),
        if (b.hasTip == true)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.volunteer_activism_outlined,
                    size: 13.r,
                    color: const Color(0xFFF59E0B),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'ມີທິບໃຫ້ພ້ອມ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Booking ID row
// ═══════════════════════════════════════════════════════════════
class _BookingIdRow extends StatelessWidget {
  final String? id;
  final DateTime? createdAt;

  const _BookingIdRow({this.id, this.createdAt});

  @override
  Widget build(BuildContext context) {
    final shortId = (id ?? '').length > 8 ? id!.substring(0, 8).toUpperCase() : (id ?? '-');
    final createdStr = DateTimeFormatter.dateFormatter(createdAt);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: const Color(0xFF9B9BAD).withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 14.r,
              color: const Color(0xFF9B9BAD),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ລະຫັດການຈອງ',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF9B9BAD),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '#$shortId',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A2E),
                    letterSpacing: 0.5,
                  ),
                ),
                if (createdStr != null)
                  Text(
                    createdStr,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
              ],
            ),
          ),
          if (id != null)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: id!));
                AppSnackbar.info('ຄັດລອກແລ້ວ', title: 'Copied');
              },
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FC),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.copy_rounded,
                  size: 15.r,
                  color: const Color(0xFF9B9BAD),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Bottom action bar
// ═══════════════════════════════════════════════════════════════
class _BottomBar extends StatelessWidget {
  final MyBookingModel booking;
  final bool isCustomer;
  final VoidCallback? onMessage;
  final MeetUpLogic logic;

  const _BottomBar({
    required this.booking,
    required this.isCustomer,
    required this.onMessage,
    required this.logic,
  });

  static bool _isCancelled(String? s) => s == 'cancelled';
  static bool _isCompleted(String? s) => s == 'completed';
  static bool _isRejected(String? s) => s == 'rejected' || s == 'disputed';

  @override
  Widget build(BuildContext context) {
    final actions = _buildActions(context);
    if (actions.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          ...actions.map((w) => Expanded(child: w)).toList(),
        ].separated(SizedBox(width: 10.w)),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final b = booking;
    final now = DateTime.now();
    final start = b.startDate;
    final end = b.endDate;
    final status = b.status;
    final id = b.id ?? '';

    void showReason(String title, Future<bool> Function(String) onSubmit) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _ReasonSheet(title: title, onSubmit: onSubmit),
      );
    }

    final msgBtn = _Btn(
      label: 'ຂໍ້ຄວາມ',
      icon: Icons.chat_bubble_outline_rounded,
      style: _BtnStyle.outline,
      onTap: onMessage,
    );

    final callBtn = _Btn(
      label: 'ໂທ',
      icon: Icons.phone_outlined,
      style: _BtnStyle.dark,
      onTap: onMessage,
    );

    if (status == 'confirmed') {
      final bookingEnded = end != null && now.isAfter(end);
      if (!bookingEnded) return [callBtn, msgBtn];
    }

    if (isCustomer) {
      if (status == 'pending') {
        return [
          _Btn(
            label: 'ຍົກເລີກ',
            style: _BtnStyle.ghost,
            onTap: () => logic.cancelBooking(id),
          ),
          msgBtn,
        ];
      }

      if (status == 'confirmed') {
        final inDisputeWindow = start != null &&
            now.isAfter(start) &&
            now.isBefore(start.add(const Duration(minutes: 30)));
        final canCancel = start != null &&
            now.isBefore(start.subtract(const Duration(minutes: 30)));

        if (inDisputeWindow) {
          return [
            _Btn(
              label: 'ເງິນຄືນ',
              style: _BtnStyle.amber,
              onTap: () => showReason(
                'ເຫດຜົນການຮ້ອງຂໍເງິນຄືນ',
                (r) => logic.disputeBooking(id, r),
              ),
            ),
            msgBtn,
          ];
        }

        if (canCancel) {
          return [
            _Btn(
              label: 'ຍົກເລີກ',
              style: _BtnStyle.ghost,
              onTap: () => logic.cancelBooking(id),
            ),
            msgBtn,
          ];
        }

        return [
          _Btn(
            label: 'ປ່ອຍເງີນ',
            style: _BtnStyle.green,
            onTap: () => logic.releasePayment(id),
          ),
          msgBtn,
        ];
      }
    } else {
      if (status == 'pending') {
        return [
          _Btn(
            label: 'ປະຕິເສດ',
            style: _BtnStyle.red,
            onTap: () => showReason(
              'ເຫດຜົນການປະຕິເສດ',
              (r) => logic.rejectBooking(id, r),
            ),
          ),
          _Btn(
            label: 'ຢືນຢັນ',
            style: _BtnStyle.green,
            onTap: () => logic.confirmBooking(id),
          ),
        ];
      }

      if (status == 'confirmed') {
        final bookingEnded = end != null && now.isAfter(end);
        if (bookingEnded) {
          return [
            _Btn(
              label: 'ຮັບເງີນ',
              style: _BtnStyle.pink,
              onTap: () => logic.receiveMoney(id),
            ),
          ];
        }
      }
    }

    if (_isCompleted(status) || _isCancelled(status) || _isRejected(status)) {
      return [
        _Btn(
          label: 'ລຶບ',
          icon: Icons.delete_outline_rounded,
          style: _BtnStyle.red,
          onTap: () async {
            final confirmed = await ConfirmSheet.show(
              context,
              title: 'ລຶບລາຍການ',
              message: 'ທ່ານຕ້ອງການລຶບລາຍການນີ້ແທ້ບໍ່?',
              confirmLabel: 'ລຶບ',
              icon: Icons.delete_outline_rounded,
              isDanger: true,
            );
            if (confirmed == true) {
              logic.deleteBooking(id);
              if (context.mounted) Navigator.of(context).pop();
            }
          },
        ),
      ];
    }

    return [];
  }
}

// ── List extension for separator ──────────────────────────────
extension _SeparatedList on List<Widget> {
  List<Widget> separated(Widget sep) {
    if (length <= 1) return this;
    final result = <Widget>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) result.add(sep);
    }
    return result;
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ReasonSheet
// ═══════════════════════════════════════════════════════════════
class _ReasonSheet extends StatefulWidget {
  final String title;
  final Future<bool> Function(String reason) onSubmit;
  const _ReasonSheet({required this.title, required this.onSubmit});

  @override
  State<_ReasonSheet> createState() => _ReasonSheetState();
}

class _ReasonSheetState extends State<_ReasonSheet> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  bool _loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _ctrl.text.trim();
    if (reason.length < 10) {
      AppSnackbar.info('ເຫດຜົນຕ້ອງມີຢ່າງໜ້ອຍ 10 ຕົວອັກສອນ', title: 'ກະລຸນາ');
      return;
    }
    setState(() => _loading = true);
    final success = await widget.onSubmit(reason);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _ctrl,
              focusNode: _focus,
              hint: 'ກະລຸນາລະບຸເຫດຜົນ (ຢ່າງໜ້ອຍ 10 ຕົວອັກສອນ)',
              accent: AppColors.primary,
              maxLines: 4,
              action: TextInputAction.done,
            ),
            SizedBox(height: 16.h),
            AppPrimaryButton(
              label: 'ຢືນຢັນ',
              loading: _loading,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Button primitives
// ═══════════════════════════════════════════════════════════════
enum _BtnStyle { ghost, dark, pink, green, red, amber, outline }

class _Btn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final _BtnStyle style;
  final VoidCallback? onTap;

  const _Btn({
    required this.label,
    this.icon,
    required this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (style) {
      _BtnStyle.ghost => (const Color(0xFFF0F0F5), const Color(0xFF1A1A2E), null),
      _BtnStyle.dark => (const Color(0xFF1A1A2E), Colors.white, null),
      _BtnStyle.pink => (AppColors.primary, Colors.white, null),
      _BtnStyle.green => (const Color(0xFF22C55E), Colors.white, null),
      _BtnStyle.red => (const Color(0xFFFEF2F2), const Color(0xFFDC2626), null),
      _BtnStyle.amber => (const Color(0xFFFFFBEB), const Color(0xFFD97706), null),
      _BtnStyle.outline => (
        Colors.transparent,
        const Color(0xFF1A1A2E),
        Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46.h,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14.r),
          border: border,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14.r, color: fg),
              SizedBox(width: 5.w),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
