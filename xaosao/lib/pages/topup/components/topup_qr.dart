import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/topup/components/topup_constant.dart';
import 'package:xaosao/pages/topup/getx/topup_logic.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class TopUpQRPage extends StatefulWidget {
  const TopUpQRPage({super.key});

  @override
  State<TopUpQRPage> createState() => _TopUpQRPageState();
}

class _TopUpQRPageState extends State<TopUpQRPage> {
  late final TopupLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<TopupLogic>();
    _logic.fetchQr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ສະແກນ QR',
        subtitle: 'ຊຳລະຜ່ານ app ທະນາຄານ',
        actions: [const TopUpStepBadge('2')],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Gradient bg
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFF5F8),
                            Color(0xFFFFFFFF),
                            AppColors.bg,
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Orbs
                  Positioned(
                    top: -80.h,
                    right: -60.w,
                    child: TopUpOrb(220.w, AppColors.primary, 0.14),
                  ),
                  Positioned(
                    top: 120.h,
                    left: -80.w,
                    child: TopUpOrb(200.w, AppColors.secondary, 0.09),
                  ),
                  Positioned(
                    bottom: 80.h,
                    right: -50.w,
                    child: TopUpOrb(180.w, AppColors.primary, 0.07),
                  ),
                  // Dot grid
                  Positioned.fill(
                    child: CustomPaint(painter: DotGridPainter()),
                  ),
                  // Main card
                  Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 12.h,
                      ),
                      child: Obx(() => _logic.state.loadingQr
                          ? _QrCardShimmer()
                          : _QrCard(
                              amountKip: _logic.state.amount,
                              qrUrl: _logic.state.qrUrl,
                            )),
                    ),
                  ),
                ],
              ),
            ),
            // CTA
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: AppPrimaryButton(
                label: 'ຊຳລະແລ້ວ — ອັບ slip',
                trailingIcon: Icons.arrow_forward_ios_rounded,
                onTap: () => Get.toNamed(AppRoutes.topupUpload),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── QR card shimmer ─────────────────────────────────────────────
class _QrCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8F0),
      highlightColor: const Color(0xFFF5F5FA),
      child: Container(
        width: double.infinity,
        height: 440.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
        ),
      ),
    );
  }
}

// ── QR white card ───────────────────────────────────────────────
class _QrCard extends StatelessWidget {
  final int amountKip;
  final String? qrUrl;
  const _QrCard({required this.amountKip, required this.qrUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.18),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 40,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Stack(
          children: [
            // Pink top stripe
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4.h,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.pinkGradient),
                ),
              ),
            ),
            // Watermark circles
            Positioned(
              top: -30.h,
              left: -20.w,
              child: Container(
                width: 130.w,
                height: 130.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.035),
                ),
              ),
            ),
            Positioned(
              bottom: -20.h,
              right: -20.w,
              child: Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.035),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 24.h),
              child: Column(
                children: [
                  // Brand row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: AppColors.pinkGradient,
                          ),
                          borderRadius: BorderRadius.circular(9.r),
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          size: 14.r,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 9.w),
                      Text(
                        'XAOSAO Payment',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'ຈຳນວນທີ່ຕ້ອງຊຳລະ',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHint,
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    fmtKip(amountKip),
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Gradient divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // QR image frame
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: AppColors.socialBg,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: qrUrl != null
                        ? Image.network(
                            qrUrl!,
                            width: 210.w,
                            height: 210.w,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _QrError(),
                          )
                        : _QrError(),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'ສະແກນ QR ດ້ວຍ app ທະນາຄານ\nຈາກນັ້ນກົດ "ຊຳລະແລ້ວ" ເພື່ອອັບ slip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textHint,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Powered badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.socialBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7.r,
                          height: 7.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Powered by XAOSAO',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
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
      ),
    );
  }
}

// ── QR error/empty placeholder ──────────────────────────────────
class _QrError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210.w,
      height: 210.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_2_rounded, size: 48.r, color: AppColors.textHint),
          SizedBox(height: 8.h),
          Text(
            'ບໍ່ສາມາດໂຫຼດ QR',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
