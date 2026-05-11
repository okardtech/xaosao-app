import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_color.dart';

// ═══════════════════════════════════════════════════════════════
//  topup_constants.dart
//  Shared colors, helpers, painters, and small widgets
//  used across all TopUp pages.
// ═══════════════════════════════════════════════════════════════

// ── colours ───────────────────────────────────────────────────
const kPink = Color(0xFFF06292);
const kPinkLight = Color(0xFFFF8A80);
const kNavy = Color(0xFF1A1A2E);
const kBg = Color(0xFFF8F8FC);
const kHint = Color(0xFF9B9BAD);
const kBorder = Color(0x12000000);

// ── number formatter ──────────────────────────────────────────
String fmtKip(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '${b.toString()} ກີບ';
}

String fmtNum(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

// ═══════════════════════════════════════════════════════════════
class TopUpGradientAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String sub;
  final String step; // "1" | "2" | "3"
  final VoidCallback onBack;

  const TopUpGradientAppBar({
    super.key,
    required this.title,
    required this.sub,
    required this.step,
    required this.onBack,
  });

  @override
  Size get preferredSize => Size.fromHeight(58.h);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        // white icons on gradient bg
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.pinkGradient, // [#F06292, #FF8A80]
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              child: Row(
                children: [
                  // ── Back button ──────────────────────────────
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      width: 34.r,
                      height: 34.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 0.5,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 14.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // ── Title + subtitle ─────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          sub,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white.withOpacity(0.70),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Step pill ────────────────────────────────
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.30),
                        width: 0.5,
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.75),
                        ),
                        children: [
                          TextSpan(
                            text: step,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const TextSpan(text: '/3'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  TopUpPinkBtn — primary action button
// ═══════════════════════════════════════════════════════════════
class TopUpPinkBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const TopUpPinkBtn({
    super.key,
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 46.h,
        decoration: BoxDecoration(
          color: enabled ? kPink : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: enabled ? Colors.white : kHint,
              ),
            ),
            SizedBox(width: 5.w),
            Icon(icon, size: 13.r, color: enabled ? Colors.white : kHint),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  TopUpOrb — radial gradient circle (background decoration)
// ═══════════════════════════════════════════════════════════════
class TopUpOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const TopUpOrb(this.size, this.color, this.opacity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(opacity), color.withOpacity(0.0)],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BankBadge — coloured bank label pill
// ═══════════════════════════════════════════════════════════════
class BankBadge extends StatelessWidget {
  final String name;
  final Color color;
  const BankBadge(this.name, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ReceiptRow — key / value row inside receipt card
// ═══════════════════════════════════════════════════════════════
class ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const ReceiptRow(this.label, this.value, {super.key, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withOpacity(0.06), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: kHint),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: valueColor ?? kNavy,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  DotGridPainter — subtle pink dot grid background
// ═══════════════════════════════════════════════════════════════
class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kPink.withOpacity(0.055)
      ..style = PaintingStyle.fill;
    for (double x = 0; x < size.width; x += 22) {
      for (double y = 0; y < size.height; y += 22) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ═══════════════════════════════════════════════════════════════
//  LinePainter — subtle horizontal lines for QR placeholder
// ═══════════════════════════════════════════════════════════════
class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kPink.withOpacity(0.04)
      ..strokeWidth = 1.5;
    for (double y = 0; y < size.height; y += 8) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
