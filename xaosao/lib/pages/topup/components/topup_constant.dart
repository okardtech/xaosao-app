import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

// ── Number formatters ─────────────────────────────────────────
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

// ── Step badge for GradientAppBar actions ─────────────────────
class TopUpStepBadge extends StatelessWidget {
  final String step;
  const TopUpStepBadge(this.step, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.30),
          width: 0.5,
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.75),
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
    );
  }
}

// ── Radial gradient orb (QR page background) ─────────────────
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
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

// ── Receipt row (success page) ────────────────────────────────
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
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, color: AppColors.textHint)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dot grid background painter (QR page) ────────────────────
class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.055)
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
