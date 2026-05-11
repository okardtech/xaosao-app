import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/app_color.dart';
import '../getx/register_logic.dart';

class AvatarPicker extends StatelessWidget {
  final RegisterLogic logic;
  final Color accent;
  const AvatarPicker({super.key, required this.logic, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final file = logic.getXController.value.avatarFile;
      final hasImage = file != null;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: logic.pickAvatar,
            child: SizedBox(
              width: 84.r,
              height: 84.r,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ── Main circle ─────────────────────────
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 84.r,
                    height: 84.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // filled bg when image selected
                      color: hasImage ? Colors.transparent : AppColors.primary.withOpacity(0.05),
                      // dashed border when empty, solid when filled
                      border: Border.all(
                        color: hasImage ? accent : accent.withOpacity(0.35),
                        width: hasImage ? 2.0 : 1.5,
                        // dashed style via custom painter below
                      ),
                      image: hasImage
                          ? DecorationImage(
                              image: FileImage(File(file.path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: hasImage
                        ? null
                        : _DashedCircleContent(accent: accent),
                  ),

                  // ── Dashed border overlay when empty ─────
                  if (!hasImage)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DashedBorderPainter(color: accent),
                      ),
                    ),

                  // ── Camera badge bottom-right ─────────────
                  Positioned(
                    bottom: 2.r,
                    right: 2.r,
                    child: Container(
                      width: 26.r,
                      height: 26.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.secondary, AppColors.primary],
                        ),
                        border: Border.all(color: AppColors.bg, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        hasImage ? Icons.edit_rounded : Icons.add_rounded,
                        size: 11.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 7.h),
          // Hint text below
          Text(
            hasImage ? 'ກົດເພື່ອປ່ຽນຮູບ' : 'ກົດເພື່ອເລືອກຮູບ',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF9B9BAD),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    });
  }
}

// ── Content shown inside empty circle ─────────────────────────
class _DashedCircleContent extends StatelessWidget {
  final Color accent;
  const _DashedCircleContent({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accent.withOpacity(0.08),
          ),
          child: Icon(
            Icons.camera_alt_outlined,
            size: 16.r,
            color: accent.withOpacity(0.55),
          ),
        ),
      ],
    );
  }
}

// ── Dashed border painter ──────────────────────────────────────
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 1.0;

    const dashCount = 20;
    const gapFraction = 0.4; // fraction of arc that is gap
    final dashAngle = (2 * 3.14159265) / dashCount;
    final solidAngle = dashAngle * (1 - gapFraction);

    for (int i = 0; i < dashCount; i++) {
      final startAngle = dashAngle * i - (3.14159265 / 2);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        solidAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color;
}
