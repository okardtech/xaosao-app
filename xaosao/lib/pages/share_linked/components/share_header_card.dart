import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/utils/share_utils.dart';

import 'share_qr_dialog.dart';

class ShareHeaderCard extends StatelessWidget {
  final String refCode;
  final String link;
  final int totalModels;
  final double earnings;
  final String modelName;
  final String? profileUrl;

  const ShareHeaderCard({
    super.key,
    required this.refCode,
    required this.link,
    required this.totalModels,
    required this.earnings,
    required this.modelName,
    this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.pinkGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -24,
            right: -14,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -36,
            left: -16,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: label + gift icon ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ຮັບລາງວັນທຸກຄັ້ງທີ່ແນະນຳ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    Container(
                      width: 30.r,
                      height: 30.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(9.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                          width: 0.5,
                        ),
                      ),
                      child: Icon(
                        Icons.card_giftcard_rounded,
                        size: 15.r,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // ── Main big earn text ──
                Text(
                  'ຮັບ 10,000 ກີບ',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.8,
                    height: 1,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'ຕໍ່ການແນະນຳ 1 ໂມດອທີ່ຖືກອະນຸມັດ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                SizedBox(height: 10.h),

                // ── Stat pills ──
                Row(
                  children: [
                    Expanded(
                      child: _StatPill(
                        label: 'ໂມດອທັງໝົດ',
                        value: '$totalModels ທ່ານ',
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _StatPill(
                        label: 'ລາຍໄດ້ທັງໝົດ',
                        value: CurrFormatter.kip(earnings),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ── Link box ──
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          link,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _IconBtn(
                        icon: Icons.copy_rounded,
                        onTap: () async {
                          await ShareUtils.copyToClipboard(link);
                          AppSnackbar.success('ສຳເນົາລິ້ງແລ້ວ');
                        },
                      ),
                      SizedBox(width: 6.w),
                      _IconBtn(
                        icon: Icons.share_rounded,
                        onTap: () => ShareUtils.shareReferralLink(refCode),
                      ),
                      SizedBox(width: 6.w),
                      _IconBtn(
                        icon: Icons.qr_code_rounded,
                        onTap: () => ShareQrDialog.show(
                          context,
                          modelName: modelName,
                          profileUrl: profileUrl,
                          link: link,
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
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.r,
        height: 30.r,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 14.r, color: Colors.white),
      ),
    );
  }
}
