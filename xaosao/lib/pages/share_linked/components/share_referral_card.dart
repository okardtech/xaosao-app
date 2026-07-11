import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/utils/share_utils.dart';
import 'package:xaosao/widgets/app_button.dart';

class ShareReferralCard extends StatelessWidget {
  final int totalModels;
  final String refCode;

  const ShareReferralCard({
    super.key,
    required this.totalModels,
    required this.refCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: totalModels == 0
          ? _EmptyState(refCode: refCode)
          : _FilledState(total: totalModels),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String refCode;
  const _EmptyState({required this.refCode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(
          width: 64.r,
          height: 64.r,
          decoration: BoxDecoration(
            color: AppColors.bg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.people_alt_outlined,
            size: 28.r,
            color: AppColors.textDisabled,
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          'ຍັງບໍ່ມີການແນະນຳ',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'ແບ່ງປັນລະຫັດເພື່ອເລີ່ມຮັບລາຍໄດ້!',
          style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        AppPrimaryButton(
          label: 'ແບ່ງປັນ',
          leadingIcon: Icons.share_rounded,
          onTap: () => ShareUtils.shareReferralLink(refCode),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}

class _FilledState extends StatelessWidget {
  final int total;
  const _FilledState({required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people_alt_rounded,
                size: 16.r, color: AppColors.primary),
            SizedBox(width: 6.w),
            Text(
              'ໂມດອທີ່ແນະນຳ ($total)',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.pinkGradient),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded,
                    size: 20.r, color: Colors.white),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$total ໂມດອໄດ້ຮັບການແນະນຳ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '${CurrFormatter.kip(total * 10000.0)} ທັງໝົດ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
