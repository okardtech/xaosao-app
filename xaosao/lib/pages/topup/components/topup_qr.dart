import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/topup/components/topup_constant.dart';
import 'package:xaosao/pages/topup/components/topup_upload.dart';

// ═══════════════════════════════════════════════════════════════
//  topup_qr_page.dart — Page 2: ສະແກນ QR
//  Styled after BcelOneQRScan (insurance app pattern):
//    · gradient background
//    · pink radial orbs
//    · dot grid painter
//    · white card + pink top stripe + border
//
//  QR image: ໃຊ້ _QrImagePlaceholder() ຕອນນີ້
//  TODO: ປ່ຽນດ້ວຍ Image.asset('assets/images/xaosao_qr.png')
//        ຫຼື Image.network(qrUrl)
// ═══════════════════════════════════════════════════════════════
class TopUpQRPage extends StatelessWidget {
  final int amountKip;
  const TopUpQRPage({super.key, required this.amountKip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      appBar: TopUpGradientAppBar(
        title: 'ສະແກນ QR',
        sub: 'ຊຳລະຜ່ານ app ທະນາຄານ',
        step: '2',
        onBack: () => Navigator.pop(context),
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
                            Color(0xFFF8F8FC),
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
                    child: TopUpOrb(220.w, kPink, 0.14),
                  ),
                  Positioned(
                    top: 120.h,
                    left: -80.w,
                    child: TopUpOrb(200.w, kPinkLight, 0.09),
                  ),
                  Positioned(
                    bottom: 80.h,
                    right: -50.w,
                    child: TopUpOrb(180.w, kPink, 0.07),
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
                      child: _QrCard(amountKip: amountKip),
                    ),
                  ),
                ],
              ),
            ),

            // CTA
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: TopUpPinkBtn(
                label: 'ຊຳລະແລ້ວ — ອັບ slip',
                icon: Icons.arrow_forward_ios_rounded,
                enabled: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TopUpUploadSlipPage(amountKip: amountKip),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── QR white card ──────────────────────────────────────────────
class _QrCard extends StatelessWidget {
  final int amountKip;
  const _QrCard({required this.amountKip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: kPink.withOpacity(0.18), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kPink.withOpacity(0.12),
            blurRadius: 40,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                  gradient: LinearGradient(colors: [kPink, kPinkLight]),
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
                  color: kPink.withOpacity(0.035),
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
                  color: kPink.withOpacity(0.035),
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
                            colors: [kPink, kPinkLight],
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
                          color: kNavy,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Amount label
                  Text(
                    'ຈຳນວນທີ່ຕ້ອງຊຳລະ',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: kHint,
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    fmtKip(amountKip),
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      color: kNavy,
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
                          Colors.black.withOpacity(0.08),
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
                        color: const Color(0xFFFFF0F6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: kPink.withOpacity(0.10),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    // ═══════════════════════════════════════════
                    //  TODO: ປ່ຽນ _QrImagePlaceholder() ດ້ວຍ
                    //  Image.asset('assets/images/xaosao_qr.png',
                    //    width: 210.w, height: 210.w,
                    //    fit: BoxFit.cover)
                    // ═══════════════════════════════════════════
                    child: Image.network(
                      "https://manabi.chiaranai.co/wp-content/uploads/2026/02/CHRNQR-1-768x1024.jpg",
                      width: 210.w,
                      height: 210.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  // Hint
                  Text(
                    'ສະແກນ QR ດ້ວຍ app ທະນາຄານ\nຈາກນັ້ນກົດ "ຊຳລະແລ້ວ" ເພື່ອອັບ slip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: kHint,
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
                      color: const Color(0xFFFFF0F6),
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
                            color: kPink,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Powered by XAOSAO',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: kPink,
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
