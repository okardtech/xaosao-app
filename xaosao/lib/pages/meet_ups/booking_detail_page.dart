import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/models/my_booking_model.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_logic.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/utils/date_time_formatter.dart';
import 'package:xaosao/utils/l10n.dart' as g;
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
    'pending' => g.l10n.walletTxStatusPending,
    'confirmed' => g.l10n.bookingStatusConfirmed,
    'in_progress' => g.l10n.bookingStatusInProgress,
    'awaiting_confirmation' => g.l10n.bookingStatusAwaitingConfirmation,
    'completed' => g.l10n.bookingStatusCompletedFull,
    'cancelled' => g.l10n.bookingStatusCancelledFull,
    'rejected' => g.l10n.bookingStatusRejected,
    'disputed' => g.l10n.bookingStatusDisputed,
    _ => '-',
  };

  static String _paymentLabel(String? s) => switch (s) {
    'paid' => g.l10n.paymentStatusPaid,
    'pending' => g.l10n.paymentStatusPending,
    'released' => g.l10n.paymentStatusReleased,
    'refunded' => g.l10n.paymentStatusRefunded,
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
      appBar: GradientAppBar(
        title: AppLocalizations.of(context)!.bookingDetailTitle,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DetailCard(
                booking: b,
                isCustomer: isCustomer,
                badgeBg: _badgeBg(b.status),
                badgeFg: _badgeFg(b.status),
                statusLabel: _statusLabel(b.status),
                serviceType: _serviceTypeName(b),
                paymentLabel: _paymentLabel(b.paymentStatus),
              ),
              SizedBox(height: 16.h),
              _BottomBar(
                booking: b,
                isCustomer: isCustomer,
                logic: _logic,
              ),
            ],
          ),
        ),
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

    return Stack(
      children: [
        Container(
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
                              ? g.l10n.commonDays(b.dayAmount!)
                              : g.l10n.commonHours(b.hours ?? 0),
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
              SizedBox(height: 8.h),
              // ── Location ───────────────────────────────────────────
              if (b.location != null)
                _CardSection(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          g.l10n.bookingLocation,
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
                          g.l10n.bookingPhone,
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
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 16.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        g.l10n.bookingTip,
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
                              g.l10n.bookingTipReady,
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
                          g.l10n.bookingAttire,
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
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            b.preferredAttire ?? "-",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.flexFg,
                              height: 1.4,
                              // fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ── Booking reference + created at ─────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking ID row
                    Row(
                      children: [
                        Text(
                          g.l10n.bookingId,
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
                    SizedBox(height: 8.h),
                    // Created at row
                    Row(
                      children: [
                        Text(
                          g.l10n.bookingCreatedAt,
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
              // ── Ticket perforation strip (cutouts on both sides
              // + dashed divider between them for the classic receipt
              // look). Sits BEFORE the thank-you footer so it visually
              // separates receipt body from the "signature/support"
              // section below.
              _TicketPerforation(bgColor: const Color(0xFFF8F8FC)),

              // ── Thank you + support footer ─────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.bookingThankYouFor(
                          AppLocalizations.of(context)!.appName,
                        ),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      _SupportCallRow(
                        phone: '020 9108 2600',
                        label: AppLocalizations.of(context)!
                            .bookingSupportContact('020 9108 2600'),
                      ),
                    ],
                  ),
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
//  Ticket perforation — 2 background-colored circles overlapping the
//  card edges + dashed line between them. Creates the classic torn-
//  receipt look that separates the invoice details from the footer.
//  The circles must be painted in the PAGE background color (not
//  Colors.white) or they'll be invisible against the white card.
// ═══════════════════════════════════════════════════════════════
class _TicketPerforation extends StatelessWidget {
  final Color bgColor;
  const _TicketPerforation({required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Left cutout — half of the circle spills off the card edge
          Positioned(
            left: -12.w,
            child: Container(
              width: 24.r,
              height: 24.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
              ),
            ),
          ),
          // Right cutout — mirror of left
          Positioned(
            right: -12.w,
            child: Container(
              width: 24.r,
              height: 24.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
              ),
            ),
          ),
          // Dashed line between the cutouts — visual perforation
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: CustomPaint(
              size: Size.fromHeight(1.h),
              painter: _DashedLinePainter(color: const Color(0xFFE5E7EB)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashGap = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}

// ═══════════════════════════════════════════════════════════════
//  Support call row — tappable pill that shows the support number.
//  Currently a display-only widget; wire onTap → url_launcher's
//  tel: scheme when phone-linking is ready.
// ═══════════════════════════════════════════════════════════════
class _SupportCallRow extends StatelessWidget {
  final String phone;
  final String label;
  const _SupportCallRow({required this.phone, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.support_agent_rounded,
            size: 14.r,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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
    final displayName = nameParts.isEmpty
        ? g.l10n.bookingNoName
        : nameParts.join(' ');

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
                          '· ${g.l10n.commonAgeYears(age)}',
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
                              g.l10n.bookingTipReady,
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
      padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 4.h),
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
              g.l10n.bookingTotalPrice,
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
      title: g.l10n.cancelBookingTitle,
      message: g.l10n.cancelBookingMessage,
      confirmLabel: g.l10n.cancelBookingTitle,
      icon: AppIcons.cancel,
      isDanger: true,
    );
    if (confirmed == true) logic.cancelBooking(id);
  }

  @override
  Widget build(BuildContext context) {
    final actions = _buildActions(context);
    if (actions.isEmpty) return const SizedBox.shrink();

    // Buttons now live inline in the page's scrollable Column
    // (see [BookingDetailPage.build]) — no sticky-bottom container /
    // top shadow needed. The parent Column supplies the 16.h gap
    // between the detail card and this action row.
    return Row(
      children: [
        ...actions.map((w) => Expanded(child: w)),
      ].separated(SizedBox(width: 10.w)),
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
      label: g.l10n.bookingActionChat,
      icon: AppIcons.chatFill,
      style: _BtnStyle.outline,
      onTap: _openChat,
    );

    if (isCustomer) {
      if (status == 'pending') {
        return [
          _Btn(
            label: g.l10n.commonCancel,
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
              label: g.l10n.bookingActionReleasePayment,
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
              label: g.l10n.bookingActionRefund,
              style: _BtnStyle.amber,
              onTap: () => showReason(
                g.l10n.refundReasonTitle,
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
            label: g.l10n.bookingActionReject,
            style: _BtnStyle.red,
            onTap: () => showReason(
              g.l10n.rejectReasonTitle,
              (r) => logic.rejectBooking(id, r),
            ),
          ),
          _Btn(
            label: g.l10n.commonConfirm,
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
              label: g.l10n.bookingActionReceiveMoney,
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
          label: g.l10n.commonDelete,
          icon: AppIcons.delete,
          style: _BtnStyle.red,
          onTap: () async {
            final confirmed = await ConfirmSheet.show(
              context,
              title: g.l10n.deleteItemTitle,
              message: g.l10n.deleteItemMessage,
              confirmLabel: g.l10n.commonDelete,
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
      // Active cancel — matches _Btn.red styling so both cancel-style
      // buttons stand out against the page bg (0xFFF8F8FC) with a
      // red tinted border + soft shadow.
      return GestureDetector(
        onTap: onCancel,
        child: Container(
          height: 42.h,
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: const Color(0xFFDC2626).withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14DC2626),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
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
                g.l10n.cancelBookingTitle,
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

    // Disabled — locked in. White bg + slate border + neutral shadow
    // so it still reads as a button (not blank space) but signals
    // clearly that it's inactive.
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 14.r,
            color: const Color(0xFFB0B0C0),
          ),
          SizedBox(width: 6.w),
          Text(
            g.l10n.cancellationPolicyCanCancel,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFB0B0C0),
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
      AppSnackbar.info(g.l10n.reasonMinLength, title: g.l10n.commonPleaseTitle);
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
        child: SafeArea(
          top: false,
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
                hint: g.l10n.reasonHint,
                accent: AppColors.primary,
                maxLines: 4,
                action: TextInputAction.done,
              ),
              SizedBox(height: 16.h),
              AppPrimaryButton(
                label: g.l10n.commonConfirm,
                loading: _loading,
                onTap: _submit,
              ),
            ],
          ),
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
    // Each style resolves to a bundle of (bg, fg, border, shadow).
    // The page background is `0xFFF8F8FC` (very light gray) — every
    // filled variant needs enough contrast + a soft drop shadow to
    // lift off the page. Light-tint variants (ghost/red/amber) also
    // get a matching border so they don't blend into the page.
    final ({Color bg, Color fg, Border? border, List<BoxShadow> shadow}) v =
        switch (style) {
      _BtnStyle.ghost => (
        bg: Colors.white,
        fg: const Color(0xFF1A1A2E),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        shadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      _BtnStyle.dark => (
        bg: const Color(0xFF1A1A2E),
        fg: Colors.white,
        border: null,
        shadow: const [
          BoxShadow(
            color: Color(0x331A1A2E),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      _BtnStyle.pink => (
        bg: AppColors.primary,
        fg: Colors.white,
        border: null,
        shadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      _BtnStyle.green => (
        bg: const Color(0xFF22C55E),
        fg: Colors.white,
        border: null,
        shadow: const [
          BoxShadow(
            color: Color(0x4022C55E),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      _BtnStyle.red => (
        bg: const Color(0xFFFEF2F2),
        fg: const Color(0xFFDC2626),
        border: Border.all(
          color: const Color(0xFFDC2626).withValues(alpha: 0.25),
          width: 1,
        ),
        shadow: const [
          BoxShadow(
            color: Color(0x14DC2626),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      _BtnStyle.amber => (
        bg: const Color(0xFFFFFBEB),
        fg: const Color(0xFFD97706),
        border: Border.all(
          color: const Color(0xFFD97706).withValues(alpha: 0.25),
          width: 1,
        ),
        shadow: const [
          BoxShadow(
            color: Color(0x14D97706),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      _BtnStyle.outline => (
        bg: Colors.white,
        fg: const Color(0xFF1A1A2E),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        shadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42.h,
        decoration: BoxDecoration(
          color: v.bg,
          borderRadius: BorderRadius.circular(14.r),
          border: v.border,
          boxShadow: v.shadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              AppSvgIcon(
                assetName: icon ?? "",
                width: 17.w,
                height: 17.h,
                color: v.fg,
              ),
              SizedBox(width: 5.w),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: v.fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
