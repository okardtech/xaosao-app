import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/notification_item_model.dart';
import 'package:xaosao/utils/date_time_formatter.dart';

// ═══════════════════════════════════════════════════════════════
//  AnnouncementPage
//
//  Detail view for admin broadcasts (`is_admin == true`).
//
//  These notifications carry no target entity — there is no booking,
//  post or profile to deep-link into, only a title and a message. So
//  instead of the type-based routing used for user-to-user events,
//  they open here and the text IS the destination.
//
//  Deliberately shows NO sender data: an admin broadcast comes from
//  Xaosao itself, not from a person. Identity is expressed through
//  the official badge, never through a sender name or avatar.
//
//  Layout
//    ┌──────────────────────────────┐
//    │  gradient header (fixed)     │  back · badge · title · date
//    ├──────────────────────────────┤
//    │  white card (scrolls)        │  the message body
//    ├──────────────────────────────┤
//    │  CTA footer                  │  "Got it" → pop
//    └──────────────────────────────┘
//
//  The header stays put while only the body scrolls, so a long
//  announcement never buries what it is about.
// ═══════════════════════════════════════════════════════════════
class AnnouncementPage extends StatefulWidget {
  final NotificationItemModel? notification;

  const AnnouncementPage({super.key, this.notification});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage>
    with TickerProviderStateMixin {
  /// Staggered entrance for header → card → footer.
  late final AnimationController _enterCtrl;

  /// Endless soft pulse behind the megaphone badge.
  late final AnimationController _pulseCtrl;

  late final Animation<double> _badgeScale;
  late final Animation<double> _chipFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _metaFade;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    Animation<double> fade(double begin, double end) =>
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _enterCtrl,
            curve: Interval(begin, end, curve: Curves.easeOut),
          ),
        );

    Animation<Offset> rise(double begin, double end, double from) =>
        Tween<Offset>(begin: Offset(0, from), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _enterCtrl,
            curve: Interval(begin, end, curve: Curves.easeOutCubic),
          ),
        );

    _badgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _chipFade = fade(0.20, 0.55);
    _titleFade = fade(0.28, 0.68);
    _titleSlide = rise(0.28, 0.72, 0.22);
    _metaFade = fade(0.42, 0.80);
    _cardFade = fade(0.45, 0.95);
    _cardSlide = rise(0.45, 1.0, 0.16);
    _footerFade = fade(0.65, 1.0);

    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  /// The API ships English in `title`/`message` and Lao in
  /// `la_title`/`la_message`. Pick the field matching the active locale and
  /// fall back to the other one so the page is never blank.
  /// (`th` has no dedicated field — it falls back to English.)
  String _localized(String? en, String? la) {
    final isLao = Localizations.localeOf(context).languageCode == 'lo';
    final preferred = isLao ? la : en;
    final fallback = isLao ? en : la;
    if (preferred != null && preferred.trim().isNotEmpty) return preferred;
    if (fallback != null && fallback.trim().isNotEmpty) return fallback;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notif = widget.notification;
    final title = _localized(notif?.title, notif?.laTitle);
    final message = _localized(notif?.message, notif?.laMessage);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _Header(
            title: title.isEmpty ? l10n.announcementTitle : title,
            badgeLabel: l10n.announcementBadge,
            fromLabel: l10n.announcementFrom,
            date: notif?.createdAt,
            pulse: _pulseCtrl,
            badgeScale: _badgeScale,
            chipFade: _chipFade,
            titleFade: _titleFade,
            titleSlide: _titleSlide,
            metaFade: _metaFade,
            onBack: () => Navigator.of(context).maybePop(),
          ),

          // ── Message body ──────────────────────────────────────
          Expanded(
            child: FadeTransition(
              opacity: _cardFade,
              child: SlideTransition(
                position: _cardSlide,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
                  child: _MessageCard(
                    message: message,
                    fromLabel: l10n.announcementFrom,
                  ),
                ),
              ),
            ),
          ),

          // ── CTA ───────────────────────────────────────────────
          FadeTransition(
            opacity: _footerFade,
            child: _Footer(
              label: l10n.announcementGotIt,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Header — gradient hero holding the identity + title + date
// ═══════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  final String title;
  final String badgeLabel;
  final String fromLabel;
  final DateTime? date;
  final Animation<double> pulse;
  final Animation<double> badgeScale;
  final Animation<double> chipFade;
  final Animation<double> titleFade;
  final Animation<Offset> titleSlide;
  final Animation<double> metaFade;
  final VoidCallback onBack;

  const _Header({
    required this.title,
    required this.badgeLabel,
    required this.fromLabel,
    required this.date,
    required this.pulse,
    required this.badgeScale,
    required this.chipFade,
    required this.titleFade,
    required this.titleSlide,
    required this.metaFade,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final topPad = MediaQuery.of(context).padding.top;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, topPad + 8.h, 16.w, 24.h),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.pinkGradient,
          ),
        ),
        child: Stack(
          children: [
            // Soft drifting orbs — depth without distracting from the text.
            Positioned.fill(
              child: AnimatedBuilder(
                animation: pulse,
                builder: (_, _) =>
                    CustomPaint(painter: _OrbPainter(pulse.value)),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GlassBackButton(onTap: onBack),
                SizedBox(height: 14.h),

                // Megaphone badge with pulse ring
                Center(
                  child: ScaleTransition(
                    scale: badgeScale,
                    child: _PulsingBadge(pulse: pulse),
                  ),
                ),
                SizedBox(height: 16.h),

                // Official badge chip
                Center(
                  child: FadeTransition(
                    opacity: chipFade,
                    child: _OfficialChip(label: badgeLabel),
                  ),
                ),
                SizedBox(height: 14.h),

                // Title
                FadeTransition(
                  opacity: titleFade,
                  child: SlideTransition(
                    position: titleSlide,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.35,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),

                if (date != null) ...[
                  SizedBox(height: 10.h),
                  FadeTransition(
                    opacity: metaFade,
                    child: Center(child: _DatePill(date: date!)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Glass back button ─────────────────────────────────────────────────────
class _GlassBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GlassBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 0.8,
            ),
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            size: 19.r,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ── Megaphone badge + pulse ring ──────────────────────────────────────────
class _PulsingBadge extends StatelessWidget {
  final Animation<double> pulse;
  const _PulsingBadge({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108.r,
      height: 108.r,
      child: AnimatedBuilder(
        animation: pulse,
        builder: (_, child) {
          final t = pulse.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Expanding ring — fades out as it grows.
              Transform.scale(
                scale: 0.82 + t * 0.34,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.32 * (1 - t)),
                      width: 1.4,
                    ),
                  ),
                ),
              ),
              child!,
            ],
          );
        },
        child: Container(
          width: 84.r,
          height: 84.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.38),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          // Emoji rather than a Material glyph - the icon font is
          // tree-shaken and cannot ride a Shorebird patch. welcome_page.dart
          // already uses this approach for its celebration badge.
          child: Center(
            child: Text('📣', style: TextStyle(fontSize: 38.sp)),
          ),
        ),
      ),
    );
  }
}

// ── "Official announcement" chip ──────────────────────────────────────────
class _OfficialChip extends StatelessWidget {
  final String label;
  const _OfficialChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.40),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 14.r, color: Colors.white),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date pill ─────────────────────────────────────────────────────────────
class _DatePill extends StatelessWidget {
  final DateTime date;
  const _DatePill({required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 13.r,
          color: Colors.white.withValues(alpha: 0.75),
        ),
        SizedBox(width: 6.w),
        Text(
          DateTimeFormatter.laoDateTime(date),
          style: TextStyle(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Message card — the announcement body
// ═══════════════════════════════════════════════════════════════
class _MessageCard extends StatelessWidget {
  final String message;
  final String fromLabel;

  const _MessageCard({required this.message, required this.fromLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Body — selectable so users can copy account numbers, links, dates
          // out of an announcement without retyping them.
          SelectableText(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.75,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 20.h),
          Divider(height: 1, color: AppColors.bg),
          SizedBox(height: 14.h),

          // Signature — the only "sender" an admin broadcast ever shows.
          Row(
            children: [
              Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: AppColors.pinkGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  size: 13.r,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                fromLabel,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Footer CTA
// ═══════════════════════════════════════════════════════════════
class _Footer extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _Footer({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.pinkGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.30),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16.r),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Decorative orbs behind the header
// ═══════════════════════════════════════════════════════════════
class _OrbPainter extends CustomPainter {
  final double t;
  _OrbPainter(this.t);

  static const _orbs = <_Orb>[
    _Orb(dx: 0.14, dy: 0.18, r: 0.30, alpha: 0.10, phase: 0.0),
    _Orb(dx: 0.86, dy: 0.12, r: 0.22, alpha: 0.08, phase: 1.7),
    _Orb(dx: 0.74, dy: 0.82, r: 0.36, alpha: 0.06, phase: 3.1),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width;
    for (final o in _orbs) {
      final drift = sin(t * 2 * pi + o.phase) * 6.0;
      canvas.drawCircle(
        Offset(o.dx * size.width, o.dy * size.height + drift),
        o.r * unit * 0.5,
        Paint()..color = Colors.white.withValues(alpha: o.alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_OrbPainter old) => old.t != t;
}

class _Orb {
  final double dx, dy, r, alpha, phase;
  const _Orb({
    required this.dx,
    required this.dy,
    required this.r,
    required this.alpha,
    required this.phase,
  });
}
