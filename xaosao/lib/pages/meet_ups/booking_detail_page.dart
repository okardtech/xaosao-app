import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/models/my_booking_model.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_logic.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/utils/date_time_formatter.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/app_svg_icon.dart';
import 'package:xaosao/widgets/app_text_field.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';

import '../../constants/app_routes.dart';
import '../../utils/service_helper.dart';
import '../../widgets/gradient_app_bar.dart';

class BookingDetailPage extends StatelessWidget {
  final MyBookingModel booking;
  final bool isCustomer;
  final VoidCallback? onRefresh;

  const BookingDetailPage({
    super.key,
    required this.booking,
    required this.isCustomer,
    this.onRefresh,
  });

  MeetUpLogic get _logic => Get.find<MeetUpLogic>();

  // ── Status helpers ────────────────────────────────────────────────────
  static bool _isCompleted(String? s) => s == 'completed';
  static bool _isRejected(String? s) => s == 'rejected' || s == 'disputed';

  static Color _badgeBg(String? s) {
    const active = {
      'pending',
      'confirmed',
      'in_progress',
      'awaiting_confirmation',
    };
    if (active.contains(s)) return const Color(0xFFEFF6FF);
    if (_isCompleted(s)) return const Color(0xFFEDFAF3);
    if (_isRejected(s)) return const Color(0xFFFFFBEB);
    return const Color(0xFFF0F0F5);
  }

  static Color _badgeFg(String? s) {
    const active = {
      'pending',
      'confirmed',
      'in_progress',
      'awaiting_confirmation',
    };
    if (active.contains(s)) return const Color(0xFF1D4ED8);
    if (_isCompleted(s)) return const Color(0xFF16A34A);
    if (_isRejected(s)) return const Color(0xFF92400E);
    return const Color(0xFF9B9BAD);
  }

  static String _statusLabel(String? s) => switch (s) {
    'pending' => 'ລໍຖ້າ',
    'confirmed' => 'ຢືນຢັນ',
    'in_progress' => 'ກຳລັງດຳເນີນ',
    'awaiting_confirmation' => 'ລໍຢືນຢັນ',
    'completed' => 'ສຳເລັດເເລ້ວ',
    'cancelled' => 'ຍົກເລີກເເລ້ວ',
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
    return ServiceHelper.serviceOriginalName(svc?.service?.name);
  }

  @override
  Widget build(BuildContext context) {
    final b = booking;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: GradientAppBar(title: 'ລາຍລະອຽດການຈອງ'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 32.h),
          child: _DetailCard(
            booking: b,
            isCustomer: isCustomer,
            badgeBg: _badgeBg(b.status),
            badgeFg: _badgeFg(b.status),
            statusLabel: _statusLabel(b.status),
            serviceType: _serviceTypeName(b),
            paymentLabel: _paymentLabel(b.paymentStatus),
          ),
        ),
      ),
      bottomNavigationBar: _BottomBar(
        booking: b,
        isCustomer: isCustomer,
        logic: _logic,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Unified detail card
// ═══════════════════════════════════════════════════════════════
class _DetailCard extends StatelessWidget {
  final MyBookingModel booking;
  final bool isCustomer;
  final Color badgeBg;
  final Color badgeFg;
  final String statusLabel;
  final String serviceType;
  final String paymentLabel;

  const _DetailCard({
    required this.booking,
    required this.isCustomer,
    required this.badgeBg,
    required this.badgeFg,
    required this.statusLabel,
    required this.serviceType,
    required this.paymentLabel,
  });

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final shortId = (b.id ?? '').length > 8
        ? b.id!.substring(0, 8).toUpperCase()
        : (b.id ?? '-');

    return Container(
      padding: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Profile header ─────────────────────────────────────
          _ProfileHeader(
            booking: b,
            isCustomer: isCustomer,
            badgeBg: badgeBg,
            badgeFg: badgeFg,
            statusLabel: statusLabel,
          ),

          // ── Service type ────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 4.h),
            child: Row(
              children: [
                Text(
                  serviceType,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                if (b.dayAmount != null || b.hours != null) ...[
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      b.dayAmount != null
                          ? '${b.dayAmount} ວັນ'
                          : '${b.hours} ຊົ່ວໂມງ',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Schedule ───────────────────────────────────────────
          _CardSection(
            // title: 'ເວລານັດ',
            // icon: Icons.schedule_outlined,
            child: _ScheduleContent(booking: b),
          ),

          // ── Location ───────────────────────────────────────────
          if (b.location != null)
            _CardSection(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'ສະຖານທີ່',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      b.location ?? '-',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Payment ────────────────────────────────────────────
          _CardSection(
            // title: 'ການຊຳລະເງິນ',
            // icon: Icons.payments_outlined,
            child: _PaymentContent(booking: b, paymentLabel: paymentLabel),
          ),
          if (b.model != null && b.model?.whatsapp != null)
            _CardSection(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'ເບີໂທລະສັບ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    '${b.model?.whatsapp}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          if (b.hasTip == true)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ທິບ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(20.r),
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
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // ── Attire (show when available) ────────────────────────
          if (b.preferredAttire != null && b.preferredAttire!.isNotEmpty)
            _CardSection(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'ການເເຕ່ງກາຍ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                        horizontal: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.massageOverlayFg.withAlpha(50),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        b.preferredAttire ?? "-",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.flexFg,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Booking reference + created at ─────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Booking ID row
                Row(
                  children: [
                    Text(
                      'ລະຫັດການຈອງ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '#$shortId',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                // Created at row
                Row(
                  children: [
                    Text(
                      'ເວລາຈອງ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateTimeFormatter.laoDateTime(b.createdAt),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Profile header — circular avatar + name + badges
// ═══════════════════════════════════════════════════════════════
class _ProfileHeader extends StatelessWidget {
  final MyBookingModel booking;
  final bool isCustomer;
  final Color badgeBg;
  final Color badgeFg;
  final String statusLabel;

  const _ProfileHeader({
    required this.booking,
    required this.isCustomer,
    required this.badgeBg,
    required this.badgeFg,
    required this.statusLabel,
  });

  void _openProfile() {
    if (isCustomer) {
      final id = booking.model?.id ?? '';
      if (id.isNotEmpty) Get.toNamed(AppRoutes.companionProfile, arguments: id);
    } else {
      final id = booking.customer?.id ?? '';
      if (id.isNotEmpty) Get.toNamed(AppRoutes.customerProfile, arguments: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = booking;
    // Customer sees the model; model sees the customer
    final profileImage = isCustomer
        ? b.model?.profile ?? ''
        : b.customer?.profile ?? '';
    final firstName = isCustomer ? b.model?.firstName : b.customer?.firstName;
    final lastName = isCustomer ? b.model?.lastName : b.customer?.lastName;
    final age = isCustomer ? b.model?.age : b.customer?.age;

    final nameParts = [
      firstName,
      lastName,
    ].where((s) => s != null && s.isNotEmpty);
    final displayName = nameParts.isEmpty ? 'ບໍ່ມີຊື່' : nameParts.join(' ');

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Avatar (tappable) ────────────────────────────────────
          GestureDetector(
            onTap: _openProfile,
            child: Container(
              width: 62.r,
              height: 62.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: AppNetworkImage(
                  imageUrl: profileImage,
                  width: 62.r,
                  height: 62.r,
                  fit: BoxFit.cover,
                  accentColor: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),

          // ── Name + date (tappable) ───────────────────────────────
          Expanded(
            child: GestureDetector(
              onTap: _openProfile,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1A1A2E),
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (age != null) ...[
                        SizedBox(width: 6.w),
                        Text(
                          '· $age ປີ',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF9B9BAD),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (b.hasTip == true)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(20.r),
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
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFF59E0B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Status badge (right) ─────────────────────────────────
          SizedBox(width: 10.w),
          _MiniChip(label: statusLabel, bg: badgeBg, fg: badgeFg),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _MiniChip({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  final Widget child;

  const _CardSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Schedule content — hero datetime + countdown
// ═══════════════════════════════════════════════════════════════
class _ScheduleContent extends StatelessWidget {
  final MyBookingModel booking;

  const _ScheduleContent({required this.booking});

  @override
  Widget build(BuildContext context) {
    final b = booking;
    return _AppointmentHero(
      startDate: b.startDate,
      endDate: b.endDate,
      status: b.status,
    );
  }
}

// ── Appointment date/time hero ──────────────────────────────────
class _AppointmentHero extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  const _AppointmentHero({this.startDate, this.endDate, this.status});

  @override
  Widget build(BuildContext context) {
    if (startDate == null) {
      return Text(
        '-',
        style: TextStyle(fontSize: 13.sp, color: const Color(0xFF9B9BAD)),
      );
    }

    final isStrike =
        status == 'cancelled' || status == 'rejected' || status == 'disputed';
    final isConfirmed = status == 'confirmed';
    final isCompleted = status == 'completed';

    final timeStr = DateTimeFormatter.laoTime(startDate);
    final endTimeStr = endDate != null && endDate!.day == startDate!.day
        ? DateTimeFormatter.laoTime(endDate)
        : null;

    final bgColor = isStrike
        ? const Color(0xFFF5F5F7)
        : isConfirmed
        ? const Color(0xFFF5F5F7)
        : isCompleted
        ? const Color(0xFFF5F5F7)
        : AppColors.primary.withValues(alpha: 0.04);
    final iconBg = isStrike
        ? const Color(0xFFE8E8EF)
        : isConfirmed
        ? const Color(0xFFE8E8EF)
        : isCompleted
        ? const Color(0xFFE8E8EF)
        : AppColors.primary.withValues(alpha: 0.10);
    final iconColor = isStrike
        ? const Color(0xFFD1D1E0)
        : isConfirmed
        ? const Color(0xFFD1D1E0)
        : isCompleted
        ? const Color(0xFFD1D1E0)
        : AppColors.primary;
    final heroColor = isStrike
        ? const Color(0xFFD1D1E0)
        : isConfirmed
        ? const Color(0xFF16A34A)
        : isCompleted
        ? const Color(0xFF16A34A)
        : AppColors.primary;
    final dateLabelColor = isStrike
        ? const Color(0xFFD1D1E0)
        : const Color(0xFF9B9BAD);
    final arrowColor = isStrike
        ? const Color(0xFFD1D1E0)
        : const Color(0xFF9B9BAD);
    final endTimeColor = isStrike
        ? const Color(0xFFD1D1E0)
        : const Color(0xFF9B9BAD);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: AppSvgIcon(assetName: AppIcons.calendar, color: iconColor),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateTimeFormatter.laoDate(startDate),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: dateLabelColor,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: heroColor,
                        letterSpacing: -0.5,
                        decoration: isStrike
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: const Color(0xFFD1D1E0),
                        decorationThickness: 2,
                      ),
                    ),
                    if (endTimeStr != null) ...[
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14.r,
                        color: arrowColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        endTimeStr,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: endTimeColor,
                          decoration: isStrike
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: const Color(0xFFD1D1E0),
                          decorationThickness: 2,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Payment content
// ═══════════════════════════════════════════════════════════════
class _PaymentContent extends StatelessWidget {
  final MyBookingModel booking;
  final String paymentLabel;

  const _PaymentContent({required this.booking, required this.paymentLabel});

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final isStrike =
        b.status == 'cancelled' ||
        b.status == 'rejected' ||
        b.status == 'disputed';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'ລາຄາທັງໝົດ',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
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
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Bottom action bar
// ═══════════════════════════════════════════════════════════════
class _BottomBar extends StatelessWidget {
  final MyBookingModel booking;
  final bool isCustomer;
  final MeetUpLogic logic;

  const _BottomBar({
    required this.booking,
    required this.isCustomer,
    required this.logic,
  });

  void _openChat() {
    final chatLogic = Get.find<ChatLogic>();
    if (isCustomer) {
      final model = booking.model;
      final id = model?.id;
      if (id == null || id.isEmpty) return;
      chatLogic.startConversation(
        id,
        partnerHint: ConversationParticipant(
          id: id,
          firstName: model?.firstName,
          lastName: model?.lastName,
          profileImage: model?.profile,
        ),
      );
    } else {
      final customer = booking.customer;
      final id = customer?.id;
      if (id == null || id.isEmpty) return;
      chatLogic.startConversation(
        id,
        partnerHint: ConversationParticipant(
          id: id,
          firstName: customer?.firstName,
          lastName: customer?.lastName,
          profileImage: customer?.profile,
        ),
      );
    }
  }

  static bool _isCancelled(String? s) => s == 'cancelled';
  static bool _isCompleted(String? s) => s == 'completed';
  static bool _isRejected(String? s) => s == 'rejected' || s == 'disputed';

  Future<void> _confirmCancel(BuildContext context, String id) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: 'ຍົກເລີກການຈອງ',
      message:
          'ທ່ານຕ້ອງການຍົກເລີກການຈອງນີ້ແທ້ບໍ່?\nການຍົກເລີກນີ້ບໍ່ສາມາດຖືກຄືນໄດ້.',
      confirmLabel: 'ຍົກເລີກການຈອງ',
      icon: AppIcons.cancel,
      isDanger: true,
    );
    if (confirmed == true) logic.cancelBooking(id);
  }

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
            color: Colors.black.withValues(alpha: 0.06),
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
      label: 'ເເຊັດ',
      icon: AppIcons.chatFill,
      style: _BtnStyle.outline,
      onTap: _openChat,
    );

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
        final bookingEnded = end != null && now.isAfter(end);

        if (bookingEnded) {
          return [
            _Btn(
              label: 'ປ່ອຍເງີນ',
              style: _BtnStyle.green,
              onTap: () => logic.releasePayment(id),
            ),
            msgBtn,
          ];
        }

        final bookingStarted = start != null && now.isAfter(start);
        final inDisputeWindow =
            bookingStarted &&
            now.isBefore(start.add(const Duration(minutes: 30)));

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

        final canCancel =
            start != null &&
            now.isBefore(start.subtract(const Duration(minutes: 30)));

        return [
          _CancelBookingBtn(
            canCancel: canCancel,
            onCancel: () => _confirmCancel(context, id),
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
        return [msgBtn];
      }
    }

    if (_isCompleted(status) || _isCancelled(status) || _isRejected(status)) {
      return [
        _Btn(
          label: 'ລຶບ',
          icon: AppIcons.delete,
          style: _BtnStyle.red,
          onTap: () async {
            final confirmed = await ConfirmSheet.show(
              context,
              title: 'ລຶບລາຍການ',
              message: 'ທ່ານຕ້ອງການລຶບລາຍການນີ້ແທ້ບໍ່?',
              confirmLabel: 'ລຶບ',
              icon: AppIcons.delete,
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
//  _CancelBookingBtn — enabled/disabled cancel button
// ═══════════════════════════════════════════════════════════════
class _CancelBookingBtn extends StatelessWidget {
  final bool canCancel;
  final VoidCallback onCancel;

  const _CancelBookingBtn({required this.canCancel, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    if (canCancel) {
      return GestureDetector(
        onTap: onCancel,
        child: Container(
          height: 46.h,
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: const Color(0xFFEF4444).withValues(alpha: 0.25),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cancel_outlined,
                size: 15.r,
                color: const Color(0xFFDC2626),
              ),
              SizedBox(width: 6.w),
              Text(
                'ຍົກເລີກການຈອງ',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Disabled — locked in
    return Container(
      height: 46.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 14.r,
            color: const Color(0xFFD1D1E0),
          ),
          SizedBox(width: 6.w),
          Text(
            'ຍົກເລີກໄດ້',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFD1D1E0),
            ),
          ),
        ],
      ),
    );
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
  final String? icon;
  final _BtnStyle style;
  final VoidCallback? onTap;

  const _Btn({required this.label, this.icon, required this.style, this.onTap});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (style) {
      _BtnStyle.ghost => (
        const Color(0xFFF0F0F5),
        const Color(0xFF1A1A2E),
        null,
      ),
      _BtnStyle.dark => (const Color(0xFF1A1A2E), Colors.white, null),
      _BtnStyle.pink => (AppColors.primary, Colors.white, null),
      _BtnStyle.green => (const Color(0xFF22C55E), Colors.white, null),
      _BtnStyle.red => (const Color(0xFFFEF2F2), const Color(0xFFDC2626), null),
      _BtnStyle.amber => (
        const Color(0xFFFFFBEB),
        const Color(0xFFD97706),
        null,
      ),
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
              // Icon(icon, size: 14.r, color: fg),
              AppSvgIcon(
                assetName: icon ?? "",
                width: 17.w,
                height: 17.h,
                color: fg,
              ),
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
