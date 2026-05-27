import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/my_booking_model.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_logic.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/utils/date_time_formatter.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/app_text_field.dart';

class BookingCard extends StatelessWidget {
  final MyBookingModel booking;
  final bool isCustomer;
  final VoidCallback? onMessage;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isCustomer,
    this.onMessage,
    this.onTap,
  });

  MeetUpLogic get _logic => Get.find<MeetUpLogic>();

  // ── Status helpers ─────────────────────────────────────────────
  static bool _isCancelled(String? s) => s == 'cancelled';
  static bool _isCompleted(String? s) => s == 'completed';
  static bool _isRejected(String? s) => s == 'rejected' || s == 'disputed';

  static Color _accentColor(String? s) {
    const active = {
      'pending',
      'confirmed',
      'in_progress',
      'awaiting_confirmation',
    };
    if (active.contains(s)) return const Color(0xFF3B82F6);
    if (_isCompleted(s)) return const Color(0xFF22C55E);
    if (_isRejected(s)) return const Color(0xFFF59E0B);
    return const Color(0xFFE0E0E0);
  }

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

  static const _divider = Color(0x0F000000);
  static const _dark = Color(0xFF1A1A2E);

  // ── Build ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final b = booking;
    final accent = _accentColor(b.status);

    return Opacity(
      opacity: _isCancelled(b.status) ? 1.0 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: _divider, width: 0.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTop(b, accent),
                    _buildDateRow(b),
                    _buildLocation(b),
                    _buildBottom(context, b),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 3.5.w, color: accent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top ────────────────────────────────────────────────────────
  Widget _buildTop(MyBookingModel b, Color accent) {
    final model = b.model;
    final name = [
      model?.firstName,
      model?.lastName,
    ].where((s) => s != null && s.isNotEmpty).join(' ');
    final displayName = name.isEmpty ? 'ບໍ່ມີຊື່' : name;
    final age = model?.age;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 4.h),
      // decoration: BoxDecoration(color: accent.withOpacity(0.04)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _serviceTypeName(b),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                    color: _dark,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: _badgeBg(b.status),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _statusLabel(b.status),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: _badgeFg(b.status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              ClipOval(
                child: AppNetworkImage(
                  imageUrl: model?.profile ?? '',
                  width: 32.r,
                  height: 32.r,
                  accentColor: accent == const Color(0xFFE0E0E0)
                      ? AppColors.primary
                      : accent,
                ),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      age != null ? '$displayName · $age ປີ' : displayName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (b.hasTip == true) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
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
                              size: 10.r,
                              color: const Color(0xFFF59E0B),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'ມີທິບໃຫ້ພ້ອມ',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFF59E0B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Date row ───────────────────────────────────────────────────
  Widget _buildDateRow(MyBookingModel b) {
    final start = DateTimeFormatter.dateFormatter(b.startDate) ?? '-';
    final end = DateTimeFormatter.dateFormatter(b.endDate);
    final dateStr = (end != null && end != start) ? '$start → $end' : start;

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0.h),
      // decoration: const BoxDecoration(
      //   border: Border(top: BorderSide(color: _divider, width: 0.5)),
      // ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 14.r,
            color: const Color(0xFF3B82F6),
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              dateStr,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: _dark,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── Location ───────────────────────────────────────────────────
  Widget _buildLocation(MyBookingModel b) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Icon(
              Icons.location_on_outlined,
              size: 14.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              b.location ?? '-',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: _dark,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom: price + actions ────────────────────────────────────
  Widget _buildBottom(BuildContext context, MyBookingModel b) {
    final actions = _buildActions(context, b);
    final isStrike = _isCancelled(b.status) || _isRejected(b.status);

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
      // decoration: const BoxDecoration(
      //   border: Border(top: BorderSide(color: _divider, width: 0.5)),
      // ),
      child: Row(
        children: [
          Text(
            b.price != null ? CurrFormatter.kip(b.price!) : '-',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
              color: isStrike ? const Color(0xFFD1D1E0) : AppColors.primary,
              decoration: isStrike ? TextDecoration.lineThrough : null,
              decorationColor: const Color(0xFFD1D1E0),
              decorationThickness: 2,
            ),
          ),
          const Spacer(),
          ...actions,
        ],
      ),
    );
  }

  // ── Action buttons ─────────────────────────────────────────────
  List<Widget> _buildActions(BuildContext context, MyBookingModel b) {
    
    final now = DateTime.now();
    final start = b.startDate;
    final end = b.endDate;
    final status = b.status;
    final id = b.id ?? '';
    final msgBtn = _Btn(
      label: 'ຂໍ້ຄວາມ',
      icon: Icons.chat_bubble_outline_rounded,
      style: _BtnStyle.outline,
      onTap: onMessage,
    );

    void showReason(String title, Future<bool> Function(String) onSubmit) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _ReasonSheet(title: title, onSubmit: onSubmit),
      );
    }

    final callBtn = _Btn(
      label: 'ໂທ',
      icon: Icons.phone_outlined,
      style: _BtnStyle.dark,
      onTap: onMessage,
    );

    // ── Confirmed + booking not yet ended — both roles ────────────
    if (status == 'confirmed') {
      final bookingEnded = end != null && now.isAfter(end);
      if (!bookingEnded) {
        return [callBtn, SizedBox(width: 6.w), msgBtn];
      }
    }

    if (isCustomer) {
      // ── CUSTOMER ──────────────────────────────────────────────
      if (status == 'pending') {
        return [
          _Btn(
            label: 'ຍົກເລີກ',
            style: _BtnStyle.ghost,
            onTap: () => _logic.cancelBooking(id),
          ),
          SizedBox(width: 6.w),
          msgBtn,
        ];
      }

      if (status == 'confirmed') {
        final inDisputeWindow =
            start != null &&
            now.isAfter(start) &&
            now.isBefore(start.add(const Duration(minutes: 30)));

        final canCancel =
            start != null &&
            now.isBefore(start.subtract(const Duration(minutes: 30)));

        if (inDisputeWindow) {
          return [
            _Btn(
              label: 'ເງິນຄືນ',
              style: _BtnStyle.amber,
              onTap: () => showReason(
                'ເຫດຜົນການຮ້ອງຂໍເງິນຄືນ',
                (reason) => _logic.disputeBooking(id, reason),
              ),
            ),
            SizedBox(width: 6.w),
            msgBtn,
          ];
        }

        if (canCancel) {
          return [
            _Btn(
              label: 'ຍົກເລີກ',
              style: _BtnStyle.ghost,
              onTap: () => _logic.cancelBooking(id),
            ),
            SizedBox(width: 6.w),
            msgBtn,
          ];
        }

        return [
          _Btn(
            label: 'ປ່ອຍເງີນ',
            style: _BtnStyle.green,
            onTap: () => _logic.releasePayment(id),
          ),
          SizedBox(width: 6.w),
          msgBtn,
        ];
      }
    } else {
      
      // ── MODEL ──────────────────────────────────────────────────
      if (status == 'pending') {
        return [
          _Btn(
            label: 'ປະຕິເສດ',
            style: _BtnStyle.red,
            onTap: () => showReason(
              'ເຫດຜົນການປະຕິເສດ',
              (reason) => _logic.rejectBooking(id, reason),
            ),
          ),
          SizedBox(width: 6.w),
          _Btn(
            label: 'ຢືນຢັນ',
            style: _BtnStyle.green,
            onTap: () => _logic.confirmBooking(id),
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
              onTap: () => _logic.receiveMoney(id),
            ),
          ];
        }
      }
    }

    // ── DELETE — completed / cancelled / rejected ────────────────
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
            if (confirmed == true) _logic.deleteBooking(id);
          },
        ),
      ];
    }

    return [];
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
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10.r),
          border: border,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12.r, color: fg),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
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
