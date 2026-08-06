import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/notification_item_model.dart';
import 'package:xaosao/utils/l10n.dart' as g;

class WelcomeNotificationPage extends StatefulWidget {
  final NotificationItemModel? notification;
  const WelcomeNotificationPage({super.key, this.notification});

  @override
  State<WelcomeNotificationPage> createState() =>
      _WelcomeNotificationPageState();
}

class _WelcomeNotificationPageState extends State<WelcomeNotificationPage>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final AnimationController _floatCtrl;
  late final AnimationController _confettiCtrl;

  late final Animation<double> _iconScale;
  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _heroFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _enterCtrl,
            curve: const Interval(0.25, 0.75, curve: Curves.easeOutCubic),
          ),
        );
    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.50, 1.0, curve: Curves.easeOut),
      ),
    );
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _enterCtrl,
            curve: const Interval(0.50, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _floatCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  String get _notifTitle =>
      widget.notification?.laTitle ??
      widget.notification?.title ??
      g.l10n.welcomeTitle;

  String get _notifMessage =>
      widget.notification?.laMessage ??
      widget.notification?.message ??
      g.l10n.welcomeBody;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heroCut = size.height * 0.58;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background layers ──────────────────────────────
          _BgLayers(heroCut: heroCut),

          // ── Confetti overlay ───────────────────────────────
          AnimatedBuilder(
            animation: _confettiCtrl,
            builder: (_, __) => CustomPaint(
              painter: _ConfettiPainter(_confettiCtrl.value, heroCut),
              size: Size(size.width, heroCut),
            ),
          ),

          // ── Main content ───────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Hero zone
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Floating icon
                        ScaleTransition(
                          scale: _iconScale,
                          child: AnimatedBuilder(
                            animation: _floatCtrl,
                            builder: (_, child) => Transform.translate(
                              offset: Offset(
                                0,
                                sin(_floatCtrl.value * pi) * 7.0,
                              ),
                              child: child,
                            ),
                            child: _CelebrationIcon(),
                          ),
                        ),
                        SizedBox(height: 28.h),

                        // Title + message
                        FadeTransition(
                          opacity: _heroFade,
                          child: SlideTransition(
                            position: _heroSlide,
                            child: Column(
                              children: [
                                Text(
                                  _notifTitle,
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.4,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  _notifMessage,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white.withValues(alpha: 0.80),
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Card zone
                FadeTransition(
                  opacity: _cardFade,
                  child: SlideTransition(
                    position: _cardSlide,
                    child: _BottomCard(
                      onStart: () => Get.until(
                        (r) =>
                            r.settings.name == AppRoutes.dashboard || r.isFirst,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Background: gradient top + white bottom ───────────────────────────────
class _BgLayers extends StatelessWidget {
  final double heroCut;
  const _BgLayers({required this.heroCut});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient hero area
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: heroCut + 32.h,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.pinkGradient,
              ),
            ),
          ),
        ),
        // Soft arc divider
        Positioned(
          top: heroCut,
          left: 0,
          right: 0,
          child: Container(
            height: 32.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Celebration icon ──────────────────────────────────────────────────────
class _CelebrationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108.r,
      height: 108.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF06292).withValues(alpha: 0.30),
            blurRadius: 32,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text('🎉', style: TextStyle(fontSize: 48.sp)),
      ),
    );
  }
}

// ── Confetti particles ────────────────────────────────────────────────────
class _ConfettiPainter extends CustomPainter {
  final double progress;
  final double maxH;
  _ConfettiPainter(this.progress, this.maxH);

  static final _rng = Random(7);
  static final _dots = List.generate(28, (i) {
    final colors = [
      Colors.white.withValues(alpha: 0.28),
      Colors.white.withValues(alpha: 0.14),
      const Color(0xFFFFD6E7).withValues(alpha: 0.38),
      const Color(0xFFFFC0DB).withValues(alpha: 0.28),
      const Color(0xFFE8B4CB).withValues(alpha: 0.22),
    ];
    return _Particle(
      x: _rng.nextDouble(),
      y: _rng.nextDouble(),
      r: _rng.nextDouble() * 5.5 + 1.5,
      speed: _rng.nextDouble() * 0.55 + 0.15,
      phase: _rng.nextDouble() * 2 * pi,
      color: colors[_rng.nextInt(colors.length)],
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _dots) {
      final dy = (p.y + progress * p.speed) % 1.0;
      final dx = p.x + sin(progress * 2 * pi * p.speed + p.phase) * 0.03;
      canvas.drawCircle(
        Offset(dx * size.width, dy * size.height),
        p.r,
        Paint()..color = p.color,
      );
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, r, speed, phase;
  final Color color;
  const _Particle({
    required this.x,
    required this.y,
    required this.r,
    required this.speed,
    required this.phase,
    required this.color,
  });
}

// ── Bottom card ───────────────────────────────────────────────────────────
class _BottomCard extends StatelessWidget {
  final VoidCallback onStart;
  const _BottomCard({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
      padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, -6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              Text(
                l10n.welcomeCanDoTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Feature tiles
          Row(
            children: [
              _FeatureTile(
                emoji: '💬',
                label: l10n.welcomeChat,
                color: const Color(0xFFF06292),
              ),
              SizedBox(width: 10.w),
              _FeatureTile(
                emoji: '📅',
                label: l10n.welcomeBook,
                color: const Color(0xFF7C3AED),
              ),
              SizedBox(width: 10.w),
              _FeatureTile(
                emoji: '🌟',
                label: l10n.welcomeExplore,
                color: const Color(0xFFF59E0B),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // CTA button
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _StartButton(onTap: onStart),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Feature tile ──────────────────────────────────────────────────────────
class _FeatureTile extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  const _FeatureTile({
    required this.emoji,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.16),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 46.r,
              height: 46.r,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.85), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(emoji, style: TextStyle(fontSize: 22.sp)),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Start button ──────────────────────────────────────────────────────────
class _StartButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StartButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              color: AppColors.primary.withValues(alpha: 0.32),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.welcomeGetStartedCta,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
