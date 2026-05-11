import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/topup/components/topup_constant.dart';

// ═══════════════════════════════════════════════════════════════
//  topup_success_page.dart — Page 4: ສຳເລັດ
//  No step pill — clean success screen.
//  "ກັບໜ້າກະເປົ໋າ" pops all routes back to first.
// ═══════════════════════════════════════════════════════════════
class TopUpSuccessPage extends StatelessWidget {
  final int amountKip;
  const TopUpSuccessPage({super.key, required this.amountKip});

  String _buildDate() {
    final now = DateTime.now();
    const months = [
      '',
      'ມ.ກ',
      'ກ.ພ',
      'ມ.ນ',
      'ມ.ສ',
      'ພ.ພ',
      'ມ.ຖ',
      'ກ.ລ',
      'ສ.ຫ',
      'ກ.ຍ',
      'ຕ.ລ',
      'ພ.ຈ',
      'ທ.ວ',
    ];
    final h = now.hour.toString().padLeft(2, '0');
    final min = now.minute.toString().padLeft(2, '0');
    return '${now.day} ${months[now.month]} ${now.year} · $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final date = _buildDate();

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 24.h),
                child: Column(
                  children: [
                    // ── Success ring ────────────────────────────
                    Container(
                      width: 70.r,
                      height: 70.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF22C55E).withOpacity(0.25),
                            blurRadius: 0,
                            spreadRadius: 16,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 34.r,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'ສົ່ງສຳເລັດ!',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: kNavy,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Admin ຈະກວດສອບ ແລະ ເຕີມ\nພາຍໃນ 1–3 ຊ.ມ.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color:AppColors.star,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // ── Receipt card ────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: kBorder, width: 0.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: Column(
                          children: [
                            ReceiptRow('ຈຳນວນ', fmtKip(amountKip)),
                            ReceiptRow('ວັນທີ', date),
                            ReceiptRow(
                              'ສະຖານະ',
                              'ລໍຖ້າກວດສອບ',
                              valueColor: const Color(0xFF16A34A),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ── Back to wallet ──────────────────────────
                    TopUpPinkBtn(
                      label: 'ກັບໜ້າກະເປົ໋າ',
                      icon: Icons.account_balance_wallet_outlined,
                      enabled: true,
                      onTap: () =>
                          Navigator.popUntil(context, (r) => r.isFirst),
                    ),
                    SizedBox(height: 10.h),

                    // ── Share receipt ───────────────────────────
                    GestureDetector(
                      onTap: () {}, // TODO: share
                      child: Container(
                        width: double.infinity,
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13.r),
                          border: Border.all(color: kBorder, width: 0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.share_outlined,
                              size: 14.r,
                              color: kHint,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'ແຊຣ໌ receipt',
                              style: TextStyle(fontSize: 12.sp, color: kHint),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
