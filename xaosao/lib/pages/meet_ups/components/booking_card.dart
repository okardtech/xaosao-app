import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/models/my_booking_model.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_logic.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/utils/date_time_formatter.dart';
import 'package:xaosao/utils/l10n.dart' as g;
import 'package:xaosao/utils/service_helper.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/app_text_field.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';

import '../../../constants/app_icons.dart';
import '../../../widgets/app_svg_icon.dart';

class BookingCard extends StatelessWidget {
  final MyBookingModel booking;
  final bool isCustomer;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isCustomer,
    this.onTap,
  });

  MeetUpLogic get _logic => Get.find<MeetUpLogic>();

  void _openChat(MyBookingModel b) {
    final chatLogic = Get.find<ChatLogic>();
    if (isCustomer) {
      final model = b.model;
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
      final customer = b.customer;
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

  static String _serviceTypeName(MyBookingModel b) =>
      ServiceHelper.serviceOriginalName(b.modelService?.service?.name);

  static String? _durationLabel(MyBookingModel b) {
    if (b.dayAmount != null) return g.l10n.commonDays(b.dayAmount!);
    if (b.hours != null) return g.l10n.commonHours(b.hours!);
    return null;
  }

  static const _dark = Color(0xFF1A1A2E);

  // ── Build ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final b = booking;
    final accent = _accentColor(b.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: const Color(0x0F000000),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(b),
                    _buildProfile(b, accent),
                    _buildAppointment(b),
                    _buildInfoSection(b),
                    _buildFooter(context, b),
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

  // ── Header: service type + duration chip + status badge ────────
  Widget _buildHeader(MyBookingModel b) {
    final dur = _durationLabel(b);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    _serviceTypeName(b),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                      color: _dark,
                      letterSpacing: -0.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (dur != null) ...[
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
                      dur,
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
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: _badgeFg(b.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile: avatar + name/age + tip badge ─────────────────────
  Widget _buildProfile(MyBookingModel b, Color accent) {
    final String profileUrl;
    final String displayName;
    final int? age;

    if (isCustomer) {
      final m = b.model;
      final name = [
        m?.firstName,
        m?.lastName,
      ].where((s) => s != null && s.isNotEmpty).join(' ');
      profileUrl = m?.profile ?? '';
      displayName = name.isEmpty ? g.l10n.bookingNoName : name;
      age = m?.age;
    } else {
      final c = b.customer;
      final name = [
        c?.firstName,
        c?.lastName,
      ].where((s) => s != null && s.isNotEmpty).join(' ');
      final fallback = c?.name ?? '';
      profileUrl = c?.profile ?? '';
      displayName = name.isNotEmpty
          ? name
          : (fallback.isNotEmpty ? fallback : g.l10n.bookingNoName);
      age = c?.age;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 14.w, 0),
      child: Row(
        children: [
          ClipOval(
            child: AppNetworkImage(
              imageUrl: profileUrl,
              width: 34.r,
              height: 34.r,
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
                  age != null
                      ? '$displayName · ${g.l10n.commonAgeYears(age)}'
                      : displayName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: _dark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (b.hasTip == true)
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
                          g.l10n.bookingTipReady,
                          style: TextStyle(
                            fontSize: 10.sp,
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
      ),
    );
  }

  // ── Appointment: matches _AppointmentHero style ───────────────
  Widget _buildAppointment(MyBookingModel b) {
    final start = b.startDate;
    final end = b.endDate;

    if (start == null) return const SizedBox.shrink();

    final isStrike = _isCancelled(b.status) || _isRejected(b.status);
    final isConfirmed = b.status == 'confirmed';
    final isCompleted = b.status == 'completed';

    final isSameDay =
        end != null &&
        end.year == start.year &&
        end.month == start.month &&
        end.day == start.day;

    final hasTime = start.hour != 0 || start.minute != 0;
    String? endTimeStr;
    if (isSameDay && (end.hour != 0 || end.minute != 0)) {
      endTimeStr = DateTimeFormatter.laoTime(end);
    }

    // Hero value: time (if available) or date; secondary follows pattern
    final String heroStr = hasTime
        ? DateTimeFormatter.laoTime(start)
        : DateTimeFormatter.laoDate(start);
    final String? heroSecondary = hasTime
        ? endTimeStr
        : (!isSameDay && end != null ? DateTimeFormatter.laoDate(end) : null);

    // Color palette: strike → muted, confirmed → green, completed → teal, other → primary
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
    final secondaryColor = isStrike
        ? const Color(0xFFD1D1E0)
        : (hasTime
              ? const Color(0xFF9B9BAD)
              : AppColors.primary.withValues(alpha: 0.7));
    final arrowColor = isStrike
        ? const Color(0xFFD1D1E0)
        : const Color(0xFF9B9BAD);
    final dateLabelColor = isStrike
        ? const Color(0xFFD1D1E0)
        : const Color(0xFF9B9BAD);

    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasTime) ...[
                  Text(
                    DateTimeFormatter.laoDate(start),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: dateLabelColor,
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      heroStr,
                      style: TextStyle(
                        fontSize: hasTime ? 22.sp : 14.sp,
                        fontWeight: FontWeight.w900,
                        color: heroColor,
                        letterSpacing: hasTime ? -0.5 : -0.3,
                        decoration: isStrike
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: const Color(0xFFD1D1E0),
                        decorationThickness: 2,
                      ),
                    ),
                    if (heroSecondary != null) ...[
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14.r,
                        color: arrowColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        heroSecondary,
                        style: TextStyle(
                          fontSize: hasTime ? 15.sp : 14.sp,
                          fontWeight: FontWeight.w700,
                          color: secondaryColor,
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

  // ── Info section: location + attire + created at ───────────────
  Widget _buildInfoSection(MyBookingModel b) {
    final items = <Widget>[];

    if (b.location != null && b.location!.isNotEmpty) {
      items.add(
        _InfoRow(
          icon: Icons.location_on_outlined,
          iconColor: AppColors.textPrimary,
          text: b.location!,
        ),
      );
    }

    final attire = b.preferredAttire?.toString();
    if (attire != null && attire.isNotEmpty) {
      items.add(_AttireChip(attire: attire));
    }
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1) SizedBox(height: 5.h),
          ],
        ],
      ),
    );
  }

  // ── Footer: price + action buttons ────────────────────────────
  Widget _buildFooter(BuildContext context, MyBookingModel b) {
    final actions = _buildActions(context, b);
    final isStrike = _isCancelled(b.status) || _isRejected(b.status);

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
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
      label: g.l10n.bookingActionChat,
      icon: AppIcons.chatFill,
      style: _BtnStyle.outline,
      onTap: () => _openChat(b),
    );

    void showReason(String title, Future<bool> Function(String) onSubmit) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _ReasonSheet(title: title, onSubmit: onSubmit),
      );
    }

    // Reusable cancel confirm sheet
    Future<void> confirmCancel() async {
      final confirmed = await ConfirmSheet.show(
        context,
        title: g.l10n.cancelBookingTitle,
        message: g.l10n.cancelBookingMessageShort,
        confirmLabel: g.l10n.cancelBookingTitle,
        icon: AppIcons.cancel,
        isDanger: true,
      );
      if (confirmed == true) _logic.cancelBooking(id);
    }

    // Confirmed + booking not yet ended → model sees only message
    if (status == 'confirmed') {
      final bookingEnded = end != null && now.isAfter(end);
      if (!bookingEnded && !isCustomer) {
        return [msgBtn];
      }
    }

    if (isCustomer) {
      if (status == 'pending') {
        return [
          _Btn(label: g.l10n.commonCancel, style: _BtnStyle.ghost, onTap: confirmCancel),
          SizedBox(width: 6.w),
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
              onTap: () => _logic.releasePayment(id),
            ),
            SizedBox(width: 6.w),
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
                (reason) => _logic.disputeBooking(id, reason),
              ),
            ),
            SizedBox(width: 6.w),
            msgBtn,
          ];
        }

        final canCancel =
            start != null &&
            now.isBefore(start.subtract(const Duration(minutes: 30)));

        if (canCancel) {
          return [
            _Btn(
              label: g.l10n.commonCancel,
              style: _BtnStyle.ghost,
              onTap: confirmCancel,
            ),
            SizedBox(width: 6.w),
            msgBtn,
          ];
        }

        return [msgBtn];
      }
    } else {
      if (status == 'pending') {
        return [
          _Btn(
            label: g.l10n.bookingActionReject,
            style: _BtnStyle.red,
            onTap: () => showReason(
              g.l10n.rejectReasonTitle,
              (reason) => _logic.rejectBooking(id, reason),
            ),
          ),
          SizedBox(width: 6.w),
          _Btn(
            label: g.l10n.commonConfirm,
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
              label: g.l10n.bookingActionReceiveMoney,
              style: _BtnStyle.pink,
              onTap: () => _logic.receiveMoney(id),
            ),
          ];
        }
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
            if (confirmed == true) _logic.deleteBooking(id);
          },
        ),
      ];
    }

    return [];
  }
}

// ═══════════════════════════════════════════════════════════════
//  _InfoRow — icon + text row for location / created-at
// ═══════════════════════════════════════════════════════════════
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final bool muted;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.text,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.5.h),
          child: Icon(icon, size: 13.r, color: iconColor),
        ),
        SizedBox(width: 7.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: muted ? const Color(0xFF9B9BAD) : const Color(0xFF1A1A2E),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _AttireChip — indigo badge for preferred attire
// ═══════════════════════════════════════════════════════════════
class _AttireChip extends StatelessWidget {
  final String attire;
  const _AttireChip({required this.attire});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.checkroom_outlined,
          size: 13.r,
          color: AppColors.textPrimary,
        ),
        SizedBox(width: 7.w),
        Flexible(
          child: Text(
            attire,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
              // Icon(icon, size: 12.r, color: fg),
              AppSvgIcon(
                assetName: icon ?? "",
                width: 14.w,
                height: 14.h,
                color: fg,
              ),
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
