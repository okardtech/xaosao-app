import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

import 'components/meet_ups_detail_model.dart';

// ═══════════════════════════════════════════════════════════════
//  MeetUpsDetailsPage
//  CustomScrollView:
//    SliverAppBar  → hero photo (scroll ລົງ) + appbar pinned
//    SliverList    → sections (countdown · detail · price
//                              timeline · policy/rating)
//  Sticky bottom bar ປ່ຽນຕາມ status
// ═══════════════════════════════════════════════════════════════
class MeetUpsDetailsPage extends StatefulWidget {
  final BookingDetailModel booking;

  const MeetUpsDetailsPage({super.key, required this.booking});

  @override
  State<MeetUpsDetailsPage> createState() => _MeetUpsDetailsPageState();
}

class _MeetUpsDetailsPageState extends State<MeetUpsDetailsPage> {
  static const double _photoH = 320;
  static const double _titleThreshold = 140;

  late final ScrollController _scroll;
  bool _showTitle = false;

  BookingDetailModel get b => widget.booking;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _onScroll() {
    final show = _scroll.offset > _titleThreshold;
    if (show != _showTitle) setState(() => _showTitle = show);
  }

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: Column(children: [
        Expanded(
          child: CustomScrollView(
            controller: _scroll,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // _buildSourceChip(),
                    if (b.status == MeetUpsStatus.upcoming &&
                        b.countdown != null) ...[
                      SizedBox(height: 10.h),
                      _buildCountdown(),
                    ],
                    SizedBox(height: 10.h),
                    _buildDetailCard(),
                    SizedBox(height: 10.h),
                    _buildPriceCard(),
                    SizedBox(height: 10.h),
                    if (b.status == MeetUpsStatus.completed &&
                        b.rating != null)
                      _buildRatingCard(),
                    if (b.status == MeetUpsStatus.completed &&
                        b.rating != null)
                      SizedBox(height: 10.h),
                    _buildTimeline(),
                    SizedBox(height: 10.h),
                    if (b.status == MeetUpsStatus.upcoming)
                      _buildPolicyNote(),
                    if (b.status == MeetUpsStatus.rejected &&
                        b.rejectedReason != null)
                      _buildRejectNote(),
                    SizedBox(height: 80.h),
                  ]),
                ),
              ),
            ],
          ),
        ),
        _buildBottomBar(),
      ]),
    );
  }

  // ── SliverAppBar with hero photo ────────────────────────────
  Widget _buildSliverAppBar() {
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
        background: _buildHero(),
      ),
    );
  }

  Widget _buildHero() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Photo / gradient bg
        b.companionImageUrl != null && b.companionImageUrl!.isNotEmpty
            ? Image.network(
                b.companionImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _gradientBg(),
              )
            : _gradientBg(),

        // Bottom gradient
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            height: 140.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xF5050512), Color(0x88050512), Colors.transparent],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Info overlay
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
                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
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

  Widget _gradientBg() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: b.companionGradient,
          ),
        ),
      );

  // ── Countdown chip ──────────────────────────────────────────
  Widget _buildCountdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: const Color(0xFF3B82F6).withOpacity(0.20)),
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
                fontSize: 10.sp,
                color: const Color(0xFF93C5FD))),
      ]),
    );
  }

  // ── Detail card ─────────────────────────────────────────────
  Widget _buildDetailCard() {
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
          value: '${b.locationName}\n${b.locationSub}',
          trailing: b.status == MeetUpsStatus.upcoming ||
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
  Widget _buildPriceCard() {
    return _Card(
      title: 'ສະຫຼຸບລາຄາ',
      children: [
        ...b.priceBreakdown.entries.map((e) => _PriceRow(
              label: e.key,
              amount: e.value,
              isTotal: false,
            )),
        _PriceRow(
          label: 'ລວມທັງໝົດ',
          amount: b.priceKip,
          isTotal: true,
        ),
      ],
    );
  }

  // ── Rating card (completed) ──────────────────────────────────
  Widget _buildRatingCard() {
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
                      fontSize: 10.sp, color: const Color(0xFF9B9BAD))),
              SizedBox(height: 8.h),
              Row(
                children: List.generate(5, (i) => Padding(
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
  Widget _buildTimeline() {
    return _Card(
      title: 'ຄວາມຄືບໜ້າ',
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(13.w, 10.h, 13.w, 12.h),
          child: Column(
            children: b.timeline.asMap().entries.map((entry) {
              final i     = entry.key;
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
  Widget _buildPolicyNote() {
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
  Widget _buildRejectNote() {
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
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: Colors.black.withOpacity(0.07), width: 0.5)),
      ),
      child: Row(children: _buildActions()),
    );
  }

  List<Widget> _buildActions() {
    switch (b.status) {
      case MeetUpsStatus.upcoming:
        return [
          _BarBtn(label: 'ຍົກເລີກ', icon: Icons.close_rounded,
              style: _BStyle.ghost, onTap: () {}),
          SizedBox(width: 8.w),
          _BarBtn(label: 'ຂໍ້ຄວາມ', icon: Icons.chat_bubble_outline_rounded,
              style: _BStyle.dark, onTap: () {}),
        ];
      case MeetUpsStatus.completed:
        return [
          _BarBtn(label: 'ດາວໂຫຼດໃບເສັດ', icon: Icons.download_outlined,
              style: _BStyle.ghost, onTap: () {}),
          SizedBox(width: 8.w),
          _BarBtn(label: 'ຈອງອີກ', icon: Icons.calendar_month_outlined,
              style: _BStyle.pink, onTap: () {}),
        ];
      case MeetUpsStatus.rejected:
        return [
          _BarBtn(label: 'ຫາຄົນໃໝ່', icon: Icons.search_rounded,
              style: _BStyle.ghost, onTap: () {}),
          SizedBox(width: 8.w),
          _BarBtn(label: 'ຈອງວັນໃໝ່', icon: Icons.calendar_month_outlined,
              style: _BStyle.dark, onTap: () {}),
        ];
      case MeetUpsStatus.cancelled:
        return [
          _BarBtn(label: 'ຈອງໃໝ່ກັບ ${b.companionName.split(' ').first}',
              icon: Icons.repeat_rounded,
              style: _BStyle.dark, onTap: () {}),
        ];
    }
  }

  // ── More bottom sheet ────────────────────────────────────────
  void _showMoreSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
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
            _SheetRow(icon: Icons.share_outlined, label: 'ແຊຣ໌',
                onTap: () => Navigator.pop(context)),
            _SheetRow(icon: Icons.flag_outlined, label: 'ລາຍງານ',
                isRed: true, onTap: () => Navigator.pop(context)),
          ]),
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
        border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
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
            Divider(height: 0, thickness: 0.5,
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
        border: Border(top: BorderSide(
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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

  const _PriceRow({
      required this.label, required this.amount, required this.isTotal});

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
        border: Border(top: BorderSide(
            color: Colors.black.withOpacity(isTotal ? 0.08 : 0.05),
            width: isTotal ? 1 : 0.5)),
      ),
      child: Row(children: [
        Text(label,
            style: TextStyle(
                fontSize: isTotal ? 13.sp : 11.sp,
                fontWeight: isTotal ? FontWeight.w800 : FontWeight.w400,
                color: isTotal
                    ? const Color(0xFF1A1A2E)
                    : const Color(0xFF9B9BAD))),
        const Spacer(),
        Text(_fmt(amount),
            style: TextStyle(
                fontSize: isTotal ? 16.sp : 11.sp,
                fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
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
                    ? [BoxShadow(
                        color: event.dotColor.withOpacity(0.35),
                        blurRadius: 6, spreadRadius: 2)]
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
            padding: EdgeInsets.only(
                bottom: isLast ? 0 : 12.h, top: 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      fontSize: 10.sp, color: const Color(0xFF9B9BAD))),
            ]),
          ),
        ),
      ],
    );
  }
}

enum _BStyle { ghost, dark, pink }

class _BarBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final _BStyle style;
  final VoidCallback onTap;

  const _BarBtn({
    required this.label,
    required this.icon,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (style) {
      _BStyle.ghost => (const Color(0xFFF0F0F5), const Color(0xFF1A1A2E)),
      _BStyle.dark  => (const Color(0xFF1A1A2E), Colors.white),
      _BStyle.pink  => (const Color(0xFFF06292),  Colors.white),
    };
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(
              color: bg, borderRadius: BorderRadius.circular(13.r)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
    final color = isRed ? const Color(0xFFDC2626) : const Color(0xFF1A1A2E);
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