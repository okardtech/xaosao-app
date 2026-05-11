import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'booking_model.dart';

// ═══════════════════════════════════════════════════════════════
//  BookingCard — redesigned
//  ສີ semantic border ຊ້າຍ + badge + countdown chip + reject note
//    upcoming   → left border blue   · ຍົກເລີກ + ຂໍ້ຄວາມ
//    completed  → left border green  · ດູຂໍ້ມູນ + ຈອງອີກ
//    rejected   → left border amber  · ຫາຄົນໃໝ່ + ຈອງວັນໃໝ່
//    cancelled  → left border grey   · opacity 0.55 · no actions
// ═══════════════════════════════════════════════════════════════
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onCancel;
  final VoidCallback? onMessage;
  final VoidCallback? onRebook;
  final VoidCallback? onViewDetail;
  final VoidCallback? onFindOther;
  final VoidCallback? onNewDate;
  final VoidCallback? onMapTap;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    this.onCancel,
    this.onMessage,
    this.onRebook,
    this.onViewDetail,
    this.onFindOther,
    this.onNewDate,
    this.onMapTap,
    this.onTap,
  });

  // ── Status colors ─────────────────────────────────────────
  static Color _borderColor(BookingStatus s) => switch (s) {
        BookingStatus.upcoming   => const Color(0xFF3B82F6),
        BookingStatus.completed  => const Color(0xFF22C55E),
        BookingStatus.rejected   => const Color(0xFFF59E0B),
        BookingStatus.cancelled  => const Color(0xFFE0E0E0),
      };

  static Color _badgeBg(BookingStatus s) => switch (s) {
        BookingStatus.upcoming   => const Color(0xFFEFF6FF),
        BookingStatus.completed  => const Color(0xFFEDFAF3),
        BookingStatus.rejected   => const Color(0xFFFFFBEB),
        BookingStatus.cancelled  => const Color(0xFFF0F0F5),
      };

  static Color _badgeFg(BookingStatus s) => switch (s) {
        BookingStatus.upcoming   => const Color(0xFF1D4ED8),
        BookingStatus.completed  => const Color(0xFF15803D),
        BookingStatus.rejected   => const Color(0xFF92400E),
        BookingStatus.cancelled  => const Color(0xFF9B9BAD),
      };

  static const _divider = Color(0x0F000000);
  static const _dark    = Color(0xFF1A1A2E);
  static const _hint    = Color(0xFF9B9BAD);
  static const _bg      = Color(0xFFF8F8FC);

  @override
  Widget build(BuildContext context) {
    final b = booking;
    return Opacity(
      opacity: b.status == BookingStatus.cancelled ? 0.55 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: _divider, width: 0.5),
          ),
          // ClipRRect wraps everything so borderRadius ຮັກສາ
          child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Stack(
            children: [
              // White card with uniform border
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: _divider, width: 0.5),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _buildPersonRow(b),
                  _buildMetaRow(b),
                  _buildLocationRow(b),
                  if (b.status == BookingStatus.upcoming && b.countdown != null)
                    _buildCountdown(b),
                  if (b.status == BookingStatus.rejected &&
                      b.rejectedReason != null)
                    _buildRejectNote(b.rejectedReason!),
                  _buildPriceActions(b),
                ]),
              ),
              // Left accent bar — ClipRRect handles corner rounding
              Positioned(
                left: 0, top: 0, bottom: 0,
                child: Container(
                  width: 3.5.w,
                  color: _borderColor(b.status),
                ),
              ),
            ],
          ),   // Stack
          ),   // ClipRRect
        ),     // outer Container
      ),       // GestureDetector
    );         // Opacity
  }

  // ── Person row ─────────────────────────────────────────────
  Widget _buildPersonRow(BookingModel b) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
      child: Row(children: [
        _Avatar(b: b),
        SizedBox(width: 11.w),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${b.companionName}, ${b.companionAge}',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800,
                    color: _dark, letterSpacing: -0.2)),
            SizedBox(height: 2.h),
            Text(b.services.join(' · '),
                style: TextStyle(fontSize: 10.sp, color: _hint)),
            if (b.status == BookingStatus.completed && b.rating != null) ...[
              SizedBox(height: 3.h),
              _StarsRow(rating: b.rating!),
            ],
          ]),
        ),
        _StatusBadge(
          label: b.status.label,
          bg: _badgeBg(b.status),
          fg: _badgeFg(b.status),
        ),
      ]),
    );
  }

  // ── Meta: date + duration ──────────────────────────────────
  Widget _buildMetaRow(BookingModel b) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      decoration: BoxDecoration(
        border: Border(
          top:    BorderSide(color: _divider, width: 0.5),
          bottom: BorderSide(color: _divider, width: 0.5),
        ),
      ),
      child: Row(children: [
        Expanded(
          child: _MetaCell(
            icon: Icons.calendar_month_outlined,
            label: 'ວັນທີ · ເວລາ',
            value: b.formattedDate,
          ),
        ),
        Container(
          width: 0.5, height: 38.h,
          margin: EdgeInsets.symmetric(horizontal: 14.w),
          color: _divider,
        ),
        Expanded(
          child: _MetaCell(
            icon: Icons.access_time_rounded,
            label: 'ໄລຍະເວລາ',
            value: '${b.durationHours} ຊົ່ວໂມງ',
          ),
        ),
      ]),
    );
  }

  // ── Location ────────────────────────────────────────────────
  Widget _buildLocationRow(BookingModel b) {
    final showMap = b.status == BookingStatus.upcoming ||
        b.status == BookingStatus.completed;
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _divider, width: 0.5)),
      ),
      child: Row(children: [
        Icon(Icons.location_on_outlined, size: 13.r, color: _hint),
        SizedBox(width: 7.w),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(b.locationName,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700,
                    color: _dark, height: 1.3)),
            SizedBox(height: 1.h),
            Text(b.locationSub,
                style: TextStyle(fontSize: 10.sp, color: _hint)),
          ]),
        ),
        if (showMap)
          GestureDetector(
            onTap: onMapTap,
            child: Text('ແຜນທີ່ ›',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700,
                    color: const Color(0xFFF06292))),
          ),
      ]),
    );
  }

  // ── Countdown chip (upcoming only) ─────────────────────────
  Widget _buildCountdown(BookingModel b) {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.20)),
      ),
      child: Row(children: [
        Icon(Icons.access_time_rounded, size: 12.r, color: const Color(0xFF3B82F6)),
        SizedBox(width: 7.w),
        Text(b.countdownText,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700,
                color: const Color(0xFF3B82F6))),
        const Spacer(),
        Text(b.countdownDateSub,
            style: TextStyle(fontSize: 10.sp, color: const Color(0xFF93C5FD))),
      ]),
    );
  }

  // ── Reject note ─────────────────────────────────────────────
  Widget _buildRejectNote(String reason) {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.25)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Icon(Icons.info_outline_rounded,
              size: 12.r, color: const Color(0xFFF59E0B)),
        ),
        SizedBox(width: 7.w),
        Expanded(
          child: Text(reason,
              style: TextStyle(fontSize: 10.sp,
                  color: const Color(0xFF78350F), height: 1.5)),
        ),
      ]),
    );
  }

  // ── Price + Actions ─────────────────────────────────────────
  Widget _buildPriceActions(BookingModel b) {
    final isStrike = b.status == BookingStatus.cancelled ||
        b.status == BookingStatus.rejected;

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      child: Row(children: [
        Text(
          b.formattedPrice,
          style: TextStyle(
            fontSize: 17.sp, fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: isStrike ? const Color(0xFFD1D1E0) : _dark,
            decoration: isStrike ? TextDecoration.lineThrough : null,
            decorationColor: const Color(0xFFD1D1E0),
            decorationThickness: 2,
          ),
        ),
        const Spacer(),
        ..._buildActions(b),
      ]),
    );
  }

  List<Widget> _buildActions(BookingModel b) {
    switch (b.status) {
      case BookingStatus.upcoming:
        return [
          _Btn(label: 'ຍົກເລີກ', style: _BtnStyle.ghost, onTap: onCancel),
          SizedBox(width: 6.w),
          _Btn(label: 'ຂໍ້ຄວາມ', icon: Icons.chat_bubble_outline_rounded,
              style: _BtnStyle.dark, onTap: onMessage),
        ];
      case BookingStatus.completed:
        return [
          _Btn(label: 'ດູຂໍ້ມູນ', style: _BtnStyle.ghost, onTap: onViewDetail),
          SizedBox(width: 6.w),
          _Btn(label: 'ຈອງອີກ', style: _BtnStyle.pink, onTap: onRebook),
        ];
      case BookingStatus.rejected:
        return [
          _Btn(label: 'ຫາຄົນໃໝ່', style: _BtnStyle.ghost, onTap: onFindOther),
          SizedBox(width: 6.w),
          _Btn(label: 'ຈອງວັນໃໝ່', style: _BtnStyle.dark, onTap: onNewDate),
        ];
      case BookingStatus.cancelled:
        return [];
    }
  }
}

// ═══════════════════════════════════════════════════════════════
//  Sub-widgets
// ═══════════════════════════════════════════════════════════════

class _Avatar extends StatelessWidget {
  final BookingModel b;
  const _Avatar({required this.b});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.r, height: 46.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: b.companionGradient,
        ),
      ),
      child: b.companionImageUrl != null && b.companionImageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Image.network(b.companionImageUrl!, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox()))
          : null,
    );
  }
}

class _StarsRow extends StatelessWidget {
  final double rating;
  const _StarsRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) => Padding(
        padding: EdgeInsets.only(right: 2.w),
        child: Icon(
          Icons.star_rounded, size: 10.r,
          color: i < rating.floor()
              ? const Color(0xFFF9C846)
              : const Color(0xFFE5E7EB),
        ),
      )),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _StatusBadge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20.r)),
      child: Text(label, style: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w800, color: fg, letterSpacing: 0.1)),
    );
  }
}

class _MetaCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetaCell({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 30.r, height: 30.r,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FC),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Icon(icon, size: 13.r, color: const Color(0xFF1A1A2E)),
      ),
      SizedBox(width: 8.w),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(
              fontSize: 12.sp, fontWeight: FontWeight.w600,
              color: const Color(0xFF9B9BAD), letterSpacing: 0.2)),
          SizedBox(height: 2.h),
          Text(value, style: TextStyle(
              fontSize: 12.sp, fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E), height: 1.25)),
        ]),
      ),
    ]);
  }
}

enum _BtnStyle { ghost, dark, pink }

class _Btn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final _BtnStyle style;
  final VoidCallback? onTap;
  const _Btn({required this.label, this.icon, required this.style, this.onTap});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (style) {
      _BtnStyle.ghost => (const Color(0xFFF0F0F5), const Color(0xFF1A1A2E)),
      _BtnStyle.dark  => (const Color(0xFF1A1A2E), Colors.white),
      _BtnStyle.pink  => (const Color(0xFFF06292),  Colors.white),
    };
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10.r)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, size: 12.r, color: fg),
            SizedBox(width: 4.w),
          ],
          Text(label, style: TextStyle(
              fontSize: 12.sp, fontWeight: FontWeight.w700, color: fg)),
        ]),
      ),
    );
  }
}