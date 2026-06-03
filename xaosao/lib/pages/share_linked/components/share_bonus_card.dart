import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

class ShareBonusCard extends StatelessWidget {
  final int current;
  final int target;

  const ShareBonusCard({
    super.key,
    required this.current,
    required this.target,
  });

  static const _benefits = [
    '2% ຕໍ່ການຈອງດ້ວຍຜູ້ສາວທີ່ທ່ານແນະນຳ',
    '20% ຕໍ່ການສະໝັກສະມາຊິກຈາກຜູ້ທ່ານແນະນຳ',
  ];

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFBF0), Color(0xFFFFF3CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.commissionFg.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.commissionFg.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title row ──
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.commissionFg.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.star_rounded,
                    size: 20.r, color: AppColors.commissionFg),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ຮັບລາງວັນລຳດັບພິເສດ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'ແນະນຳໂມດອໃຫ້ຄົບ $target ທ່ານ ເພື່ອລຳດັບໂມດອພິເສດ!',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFFB45309),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ── Progress ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ໂມດອທີ່ແນະນຳແລ້ວ',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF92400E),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$current / $target',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.commissionFg,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor:
                  AppColors.commissionFg.withValues(alpha: 0.15),
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.commissionFg),
            ),
          ),
          SizedBox(height: 16.h),

          // ── Benefits ──
          Text(
            'ສ່ວນຫຼຸດທີ່ຈະໄດ້ຮັບ:',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF92400E),
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _benefits.map((b) => _BenefitChip(b)).toList(),
          ),
        ],
      ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  final String label;
  const _BenefitChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.commissionFg.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.commissionFg.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF92400E),
        ),
      ),
    );
  }
}
