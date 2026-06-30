import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/models/my_booking_model.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_text_field.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';

import '../../constants/app_icons.dart';
import 'components/meet_ups_detail_model.dart';
import 'getx/meet_ups_details_logic.dart';
import 'getx/meet_ups_details_state.dart';

// ═══════════════════════════════════════════════════════════════
//  MeetUpsDetailsPage
//  CustomScrollView:
//    SliverAppBar  → hero photo (scroll ລົງ) + appbar pinned
//    SliverList    → sections (countdown · detail · price
//                              timeline · policy/rating)
//  Sticky bottom bar ປ່ຽນຕາມ status
// ═══════════════════════════════════════════════════════════════
class MeetUpsDetailsPage extends StatefulWidget {
  final String bookingId;
  final bool isCustomer;

  const MeetUpsDetailsPage({
    super.key,
    required this.bookingId,
    required this.isCustomer,
  });

  @override
  State<MeetUpsDetailsPage> createState() => _MeetUpsDetailsPageState();
}

class _MeetUpsDetailsPageState extends State<MeetUpsDetailsPage> {
  static const double _photoH = 320;
  static const double _titleThreshold = 140;

  late final MeetUpsDetailsLogic _logic;
  late final ScrollController _scroll;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _logic = Get.put(MeetUpsDetailsLogic(
      bookingId: widget.bookingId,
      isCustomer: widget.isCustomer,
    ));
    _scroll = ScrollController()..addListener(_onScroll);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    Get.delete<MeetUpsDetailsLogic>();
    super.dispose();
  }

  void _onScroll() {
    final show = _scroll.offset > _titleThreshold;
    if (show != _showTitle) setState(() => _showTitle = show);
  }

  // ── Chat helper ───────────────────────────────────────────────
  void _openChat(MyBookingModel m) {
    try {
      final chatLogic = Get.find<ChatLogic>();
      if (widget.isCustomer) {
        final model = m.model;
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
        final customer = m.customer;
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
    } catch (_) {}
  }

  // ── Map API model → UI model ──────────────────────────────────
  BookingDetailModel _toUiModel(MyBookingModel m) {
    final nameParts = widget.isCustomer
        ? [m.model?.firstName, m.model?.lastName]
        : [m.customer?.firstName, m.customer?.lastName];
    final joined =
        nameParts.where((s) => s != null && s.isNotEmpty).join(' ');
    final companionName = joined.isEmpty ? 'ບໍ່ມີຊື່' : joined;
    final companionImageUrl =
        widget.isCustomer ? m.model?.profile : m.customer?.profile;

    final uiStatus = switch (m.status) {
      'completed' => MeetUpsStatus.completed,
      'cancelled' => MeetUpsStatus.cancelled,
      'rejected' || 'disputed' => MeetUpsStatus.rejected,
      _ => MeetUpsStatus.upcoming,
    };

    final durationHours = m.hours ?? ((m.dayAmount ?? 1) * 24);

    Duration? countdown;
    final start = m.startDate;
    if (uiStatus == MeetUpsStatus.upcoming &&
        start != null &&
        start.isAfter(DateTime.now())) {
      countdown = start.difference(DateTime.now());
    }

    final svcName = m.modelService?.service?.name ?? 'ບໍລິການ';
    final price = m.price ?? 0;
    final String durationLabel;
    if (m.dayAmount != null) {
      durationLabel = '$svcName × ${m.dayAmount} ວັນ';
    } else if (m.hours != null) {
      durationLabel = '$svcName × ${m.hours} ຊົ່ວໂມງ';
    } else {
      durationLabel = svcName;
    }

    return BookingDetailModel(
      id: m.id ?? '',
      companionName: companionName,
      companionImageUrl: companionImageUrl,
      companionGradient: [const Color(0xFF5C6BC0), const Color(0xFF1A1A2E)],
      services: [svcName],
      status: uiStatus,
      dateTime: start ?? DateTime.now(),
      durationHours: durationHours,
      locationName: m.location ?? '-',
      locationSub: '',
      priceKip: price,
      countdown: countdown,
      timeline: _buildTimelineEvents(m),
      priceBreakdown: {durationLabel: price},
    );
  }

  List<BookingTimelineEvent> _buildTimelineEvents(MyBookingModel m) {
    final events = <BookingTimelineEvent>[];
    final created = m.createdAt ?? DateTime.now();

    events.add(BookingTimelineEvent(
      title: 'ສ້າງການຈອງ',
      timestamp: created,
      dotColor: const Color(0xFF22C55E),
    ));

    switch (m.status) {
      case 'pending':
        events.add(BookingTimelineEvent(
          title: 'ລໍຖ້າ Companion ຢືນຢັນ',
          timestamp: created.add(const Duration(seconds: 1)),
          dotColor: const Color(0xFF3B82F6),
          isCurrent: true,
        ));
      case 'confirmed':
        events.add(BookingTimelineEvent(
          title: 'Companion ຢືນຢັນ',
          timestamp: m.updatedAt ?? created,
          dotColor: const Color(0xFF22C55E),
        ));
        if (m.startDate != null) {
          events.add(BookingTimelineEvent(
            title: 'ລໍຖ້ານັດພົບ',
            timestamp: m.startDate!,
            dotColor: const Color(0xFF3B82F6),
            isCurrent: true,
          ));
        }
      case 'in_progress':
        events.add(BookingTimelineEvent(
          title: 'Companion ຢືນຢັນ',
          timestamp: m.updatedAt ?? created,
          dotColor: const Color(0xFF22C55E),
        ));
        if (m.startDate != null) {
          events.add(BookingTimelineEvent(
            title: 'ກຳລັງດຳເນີນ',
            timestamp: m.startDate!,
            dotColor: const Color(0xFFF59E0B),
            isCurrent: true,
          ));
        }
      case 'awaiting_confirmation':
        events.add(BookingTimelineEvent(
          title: 'Companion ຢືນຢັນ',
          timestamp: m.updatedAt ?? created,
          dotColor: const Color(0xFF22C55E),
        ));
        events.add(BookingTimelineEvent(
          title: 'ລໍຢືນຢັນ',
          timestamp: m.endDate ?? m.updatedAt ?? created,
          dotColor: const Color(0xFFF59E0B),
          isCurrent: true,
        ));
      case 'completed':
        events.add(BookingTimelineEvent(
          title: 'Companion ຢືນຢັນ',
          timestamp: m.updatedAt ?? created,
          dotColor: const Color(0xFF22C55E),
        ));
        if (m.startDate != null) {
          events.add(BookingTimelineEvent(
            title: 'ດຳເນີນນັດພົບ',
            timestamp: m.startDate!,
            dotColor: const Color(0xFF22C55E),
          ));
        }
        events.add(BookingTimelineEvent(
          title: 'ສຳເລັດ',
          timestamp: m.endDate ?? m.updatedAt ?? created,
          dotColor: const Color(0xFF22C55E),
        ));
      case 'cancelled':
        events.add(BookingTimelineEvent(
          title: 'ຍົກເລີກ',
          timestamp: m.updatedAt ?? created,
          dotColor: const Color(0xFF9B9BAD),
          isCurrent: true,
        ));
      case 'rejected':
        events.add(BookingTimelineEvent(
          title: 'ຖືກປະຕິເສດ',
          timestamp: m.updatedAt ?? created,
          dotColor: const Color(0xFFF59E0B),
          isCurrent: true,
        ));
      case 'disputed':
        events.add(BookingTimelineEvent(
          title: 'ຂໍ້ຂັດແຍ້ງ',
          timestamp: m.updatedAt ?? created,
          dotColor: const Color(0xFFF59E0B),
          isCurrent: true,
        ));
    }

    return events;
  }

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: Obx(() {
        final s = _logic.state;

        if (s.status == MeetUpsDetailsStatus.initial ||
            s.status == MeetUpsDetailsStatus.loading) {
          return _buildLoading();
        }

        if (s.status == MeetUpsDetailsStatus.failure) {
          return _buildError(s.error ?? 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ');
        }

        final raw = s.booking!;
        final b = _toUiModel(raw);

        return Column(children: [
          Expanded(
            child: CustomScrollView(
              controller: _scroll,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(b),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (b.status == MeetUpsStatus.upcoming &&
                          b.countdown != null) ...[
                        SizedBox(height: 10.h),
                        _buildCountdown(b),
                      ],
                      SizedBox(height: 10.h),
                      _buildDetailCard(b),
                      SizedBox(height: 10.h),
                      _buildPriceCard(b),
                      SizedBox(height: 10.h),
                      if (b.status == MeetUpsStatus.completed &&
                          b.rating != null)
                        _buildRatingCard(b),
                      if (b.status == MeetUpsStatus.completed &&
                          b.rating != null)
                        SizedBox(height: 10.h),
                      _buildTimeline(b),
                      SizedBox(height: 10.h),
                      if (b.status == MeetUpsStatus.upcoming)
                        _buildPolicyNote(b),
                      if (b.status == MeetUpsStatus.rejected &&
                          b.rejectedReason != null)
                        _buildRejectNote(b),
                      SizedBox(height: 80.h),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomBar(raw, context),
        ]);
      }),
    );
  }

  // ── Loading / error states ────────────────────────────────────
  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildError(String error) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _GlassBtn(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48.r, color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              error,
              style: TextStyle(
                  fontSize: 14.sp, color: const Color(0xFF9B9BAD)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            TextButton(
              onPressed: _logic.fetch,
              child: Text(
                'ລອງໃໝ່',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── SliverAppBar with hero photo ────────────────────────────
  Widget _buildSliverAppBar(BookingDetailModel b) {
    return SliverAppBar(
      expandedHeight: _photoH,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: _GlassBtn(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.pop(context),
      ),
      title: AnimatedOpacity(
        opacity: _showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(b.companionName,
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
      ),
      actions: [
        _GlassBtn(
          icon: Icons.more_vert_rounded,
          onTap: _showMoreSheet,
        ),
        SizedBox(width: 6.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _buildHero(b),
      ),
    );
  }

  Widget _buildHero(BookingDetailModel b) {
    return Stack(
      fit: StackFit.expand,
      children: [
        b.companionImageUrl != null && b.companionImageUrl!.isNotEmpty
            ? Image.network(
                b.companionImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _gradientBg(b),
              )
            : _gradientBg(b),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            height: 140.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xF5050512),
                  Color(0x88050512),
                  Colors.transparent
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(b.companionName,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.4,
                        height: 1.15)),
                SizedBox(height: 3.h),
                Text(b.services.join(' · '),
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white.withOpacity(0.55))),
                SizedBox(height: 7.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: b.status.badgeBg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(b.status.label,
                      style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                          color: b.status.badgeFg)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _gradientBg(BookingDetailModel b) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: b.companionGradient,
          ),
        ),
      );

  // ── Countdown chip ──────────────────────────────────────────
  Widget _buildCountdown(BookingDetailModel b) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.20)),
      ),
      child: Row(children: [
        Icon(Icons.access_time_rounded,
            size: 14.r, color: const Color(0xFF3B82F6)),
        SizedBox(width: 8.w),
        Text(b.countdownText,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF3B82F6))),
        const Spacer(),
        Text(b.countdownSub,
            style: TextStyle(
                fontSize: 10.sp, color: const Color(0xFF93C5FD))),
      ]),
    );
  }

  // ── Detail card ─────────────────────────────────────────────
  Widget _buildDetailCard(BookingDetailModel b) {
    return _Card(
      title: 'ລາຍລະອຽດການຈອງ',
      children: [
        _InfoRow(
          iconBg: b.status == MeetUpsStatus.completed
              ? const Color(0xFFEDFAF3)
              : const Color(0xFFEFF6FF),
          icon: Icons.calendar_month_outlined,
          iconColor: b.status == MeetUpsStatus.completed
              ? const Color(0xFF22C55E)
              : const Color(0xFF3B82F6),
          label: 'ວັນທີ ແລະ ເວລາ',
          value: b.formattedDateRange,
        ),
        _InfoRow(
          iconBg: const Color(0xFFF8F8FC),
          icon: Icons.location_on_outlined,
          iconColor: const Color(0xFF9B9BAD),
          label: 'ສະຖານທີ່ນັດພົບ',
          value: b.locationName,
          trailing:
              b.status == MeetUpsStatus.upcoming ||
                      b.status == MeetUpsStatus.completed
                  ? GestureDetector(
                      onTap: () {},
                      child: Text('ແຜນທີ່ ›',
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFF06292))),
                    )
                  : null,
        ),
        _InfoRow(
          iconBg: const Color(0xFFF8F8FC),
          icon: Icons.favorite_border_rounded,
          iconColor: const Color(0xFF9B9BAD),
          label: 'ບໍລິການ',
          value: b.services.join(' · '),
        ),
      ],
    );
  }

  // ── Price card ──────────────────────────────────────────────
  Widget _buildPriceCard(BookingDetailModel b) {
    return _Card(
      title: 'ສະຫຼຸບລາຄາ',
      children: [
        ...b.priceBreakdown.entries.map((e) => _PriceRow(
              label: e.key,
              amount: e.value,
              isTotal: false,
            )),
        _PriceRow(label: 'ລວມທັງໝົດ', amount: b.priceKip, isTotal: true),
      ],
    );
  }

  // ── Rating card (completed) ──────────────────────────────────
  Widget _buildRatingCard(BookingDetailModel b) {
    return _Card(
      title: 'ຄຳຕິຊົມຂອງທ່ານ',
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(13.w, 10.h, 13.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ທ່ານໃຫ້ຄະແນນ ${b.companionName.split(' ').first}',
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF9B9BAD))),
              SizedBox(height: 8.h),
              Row(
                children: List.generate(
                    5,
                    (i) => Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: Icon(
                            Icons.star_rounded,
                            size: 22.r,
                            color: i < (b.rating ?? 0).floor()
                                ? const Color(0xFFF9C846)
                                : const Color(0xFFE5E7EB),
                          ),
                        )),
              ),
              if (b.reviewText != null) ...[
                SizedBox(height: 9.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8FC),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: Colors.black.withOpacity(0.06),
                        width: 0.5),
                  ),
                  child: Text('"${b.reviewText}"',
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF6B6B80),
                          height: 1.55)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ── Timeline ─────────────────────────────────────────────────
  Widget _buildTimeline(BookingDetailModel b) {
    return _Card(
      title: 'ຄວາມຄືບໜ້າ',
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(13.w, 10.h, 13.w, 12.h),
          child: Column(
            children: b.timeline.asMap().entries.map((entry) {
              final i = entry.key;
              final event = entry.value;
              final isLast = i == b.timeline.length - 1;
              return _TimelineRow(event: event, isLast: isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Policy note (upcoming) ───────────────────────────────────
  Widget _buildPolicyNote(BookingDetailModel b) {
    return _Card(
      title: 'ນະໂຍບາຍຍົກເລີກ',
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(13.w, 9.h, 13.w, 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26.r, height: 26.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDFAF3),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.check_rounded,
                    size: 13.r, color: const Color(0xFF22C55E)),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF6B6B80),
                        height: 1.55),
                    children: [
                      const TextSpan(text: 'ຍົກເລີກກ່ອນ '),
                      TextSpan(
                        text: b.cancelDeadline,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E)),
                      ),
                      const TextSpan(text: ' ຈະໄດ້ຄືນ '),
                      const TextSpan(
                        text: '100%',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF15803D)),
                      ),
                      const TextSpan(text: ' ພາຍໃນ 24 ຊ.ມ.'),
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

  // ── Reject note ──────────────────────────────────────────────
  Widget _buildRejectNote(BookingDetailModel b) {
    return _Card(
      title: 'ເຫດຜົນການປະຕິເສດ',
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(13.w, 9.h, 13.w, 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26.r, height: 26.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.info_outline_rounded,
                    size: 13.r, color: const Color(0xFFF59E0B)),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Text(b.rejectedReason!,
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF6B6B80),
                        height: 1.55)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Bottom action bar ────────────────────────────────────────
  Widget _buildBottomBar(MyBookingModel m, BuildContext context) {
    final actions = _buildActions(m, context);
    if (actions.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(
                color: Colors.black.withOpacity(0.07), width: 0.5)),
      ),
      child: Row(children: actions),
    );
  }

  List<Widget> _buildActions(MyBookingModel m, BuildContext context) {
    final now = DateTime.now();
    final start = m.startDate;
    final end = m.endDate;
    final status = m.status;

    void showReason(
        String title, Future<bool> Function(String) onSubmit) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _ReasonSheet(title: title, onSubmit: onSubmit),
      );
    }

    final msgBtn = _BarBtn(
      label: 'ຂໍ້ຄວາມ',
      icon: Icons.chat_bubble_outline_rounded,
      style: _BStyle.ghost,
      onTap: () => _openChat(m),
    );

    // Confirmed + booking not yet ended → call & message for both roles
    if (status == 'confirmed') {
      final bookingEnded = end != null && now.isAfter(end);
      if (!bookingEnded) {
        return [
          _BarBtn(
            label: 'ໂທ',
            icon: Icons.phone_outlined,
            style: _BStyle.dark,
            onTap: () => _openChat(m),
          ),
          SizedBox(width: 8.w),
          msgBtn,
        ];
      }
    }

    if (widget.isCustomer) {
      if (status == 'pending') {
        return [
          _BarBtn(
            label: 'ຍົກເລີກ',
            icon: Icons.close_rounded,
            style: _BStyle.ghost,
            onTap: () => _logic.cancel(),
          ),
          SizedBox(width: 8.w),
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
            _BarBtn(
              label: 'ເງິນຄືນ',
              icon: Icons.reply_rounded,
              style: _BStyle.amber,
              onTap: () => showReason(
                'ເຫດຜົນການຮ້ອງຂໍເງິນຄືນ',
                (r) => _logic.dispute(r),
              ),
            ),
            SizedBox(width: 8.w),
            msgBtn,
          ];
        }

        if (canCancel) {
          return [
            _BarBtn(
              label: 'ຍົກເລີກ',
              icon: Icons.close_rounded,
              style: _BStyle.ghost,
              onTap: () => _logic.cancel(),
            ),
            SizedBox(width: 8.w),
            msgBtn,
          ];
        }

        return [
          _BarBtn(
            label: 'ປ່ອຍເງີນ',
            icon: Icons.send_rounded,
            style: _BStyle.green,
            onTap: () => _logic.releasePayment(),
          ),
          SizedBox(width: 8.w),
          msgBtn,
        ];
      }
    } else {
      // Companion role
      if (status == 'pending') {
        return [
          _BarBtn(
            label: 'ປະຕິເສດ',
            icon: Icons.close_rounded,
            style: _BStyle.red,
            onTap: () => showReason(
              'ເຫດຜົນການປະຕິເສດ',
              (r) => _logic.reject(r),
            ),
          ),
          SizedBox(width: 8.w),
          _BarBtn(
            label: 'ຢືນຢັນ',
            icon: Icons.check_rounded,
            style: _BStyle.green,
            onTap: () => _logic.confirm(),
          ),
        ];
      }

      if (status == 'confirmed') {
        final bookingEnded = end != null && now.isAfter(end);
        if (bookingEnded) {
          return [
            _BarBtn(
              label: 'ຮັບເງີນ',
              icon: Icons.payments_rounded,
              style: _BStyle.pink,
              onTap: () => _logic.receiveMoney(),
            ),
          ];
        }
      }
    }

    // Terminal states → delete
    if (status == 'completed' ||
        status == 'cancelled' ||
        status == 'rejected' ||
        status == 'disputed') {
      return [
        _BarBtn(
          label: 'ລຶບ',
          icon: Icons.delete_outline_rounded,
          style: _BStyle.ghost,
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
              final ok = await _logic.delete();
              if (ok && context.mounted) Navigator.of(context).pop();
            }
          },
        ),
      ];
    }

    return [];
  }

  // ── More bottom sheet ────────────────────────────────────────
  void _showMoreSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 36.w, height: 4.h,
              decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r)),
            ),
            SizedBox(height: 20.h),
            _SheetRow(
                icon: Icons.share_outlined,
                label: 'ແຊຣ໌',
                onTap: () => Navigator.pop(context)),
            _SheetRow(
                icon: Icons.flag_outlined,
                label: 'ລາຍງານ',
                isRed: true,
                onTap: () => Navigator.pop(context)),
          ]),
        ),
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
      AppSnackbar.info('ເຫດຜົນຕ້ອງມີຢ່າງໜ້ອຍ 10 ຕົວອັກສອນ',
          title: 'ກະລຸນາ');
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
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
        child: SafeArea(
          top: false,
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w, height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 18.h),
            Text(widget.title,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A2E))),
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
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Sub-widgets
// ═══════════════════════════════════════════════════════════════

class _Card extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Card({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border:
            Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(13.w, 11.h, 13.w, 8.h),
              child: Text(title,
                  style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E))),
            ),
            Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.black.withOpacity(0.06)),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoRow({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: Colors.black.withOpacity(0.05), width: 0.5)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 28.r, height: 28.r,
          decoration: BoxDecoration(
              color: iconBg, borderRadius: BorderRadius.circular(8.r)),
          child: Icon(icon, size: 12.r, color: iconColor),
        ),
        SizedBox(width: 9.w),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9B9BAD))),
                SizedBox(height: 2.h),
                Text(value,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A2E),
                        height: 1.35)),
              ]),
        ),
        if (trailing != null) ...[SizedBox(width: 8.w), trailing!],
      ]),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final int amount;
  final bool isTotal;

  const _PriceRow(
      {required this.label, required this.amount, required this.isTotal});

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '${buf.toString()} ກີບ';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: isTotal ? const Color(0xFFF8F8FC) : Colors.transparent,
        border: Border(
            top: BorderSide(
                color: Colors.black.withOpacity(isTotal ? 0.08 : 0.05),
                width: isTotal ? 1 : 0.5)),
      ),
      child: Row(children: [
        Text(label,
            style: TextStyle(
                fontSize: isTotal ? 13.sp : 11.sp,
                fontWeight:
                    isTotal ? FontWeight.w800 : FontWeight.w400,
                color: isTotal
                    ? const Color(0xFF1A1A2E)
                    : const Color(0xFF9B9BAD))),
        const Spacer(),
        Text(_fmt(amount),
            style: TextStyle(
                fontSize: isTotal ? 16.sp : 11.sp,
                fontWeight:
                    isTotal ? FontWeight.w900 : FontWeight.w700,
                color: const Color(0xFF1A1A2E),
                letterSpacing: isTotal ? -0.5 : 0)),
      ]),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final BookingTimelineEvent event;
  final bool isLast;

  const _TimelineRow({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20.r,
          child: Column(children: [
            Container(
              width: 10.r, height: 10.r,
              decoration: BoxDecoration(
                color: event.dotColor,
                shape: BoxShape.circle,
                boxShadow: event.isCurrent
                    ? [
                        BoxShadow(
                            color: event.dotColor.withOpacity(0.35),
                            blurRadius: 6,
                            spreadRadius: 2)
                      ]
                    : null,
              ),
            ),
            if (!isLast)
              Container(
                width: 1.5.w,
                height: 30.h,
                color: Colors.black.withOpacity(0.08),
                margin: EdgeInsets.symmetric(vertical: 3.h),
              ),
          ]),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: event.isCurrent
                              ? event.dotColor
                              : const Color(0xFF1A1A2E))),
                  SizedBox(height: 1.h),
                  Text(event.formattedTime,
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xFF9B9BAD))),
                ]),
          ),
        ),
      ],
    );
  }
}

enum _BStyle { ghost, dark, pink, green, red, amber }

class _BarBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final _BStyle style;
  final VoidCallback? onTap;

  const _BarBtn({
    required this.label,
    required this.icon,
    required this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (style) {
      _BStyle.ghost => (const Color(0xFFF0F0F5), const Color(0xFF1A1A2E)),
      _BStyle.dark  => (const Color(0xFF1A1A2E), Colors.white),
      _BStyle.pink  => (const Color(0xFFF06292), Colors.white),
      _BStyle.green => (const Color(0xFF22C55E), Colors.white),
      _BStyle.red   => (const Color(0xFFFEF2F2), const Color(0xFFDC2626)),
      _BStyle.amber => (const Color(0xFFFFFBEB), const Color(0xFFD97706)),
    };
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(
              color: bg, borderRadius: BorderRadius.circular(13.r)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 14.r, color: fg),
            SizedBox(width: 5.w),
            Text(label,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: fg)),
          ]),
        ),
      ),
    );
  }
}

class _GlassBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.r),
        width: 34.r, height: 34.r,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Icon(icon, size: 15.r, color: Colors.white),
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isRed;
  final VoidCallback onTap;

  const _SheetRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isRed ? const Color(0xFFDC2626) : const Color(0xFF1A1A2E);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        child: Row(children: [
          Icon(icon, size: 18.r, color: color),
          SizedBox(width: 14.w),
          Text(label,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ]),
      ),
    );
  }
}
