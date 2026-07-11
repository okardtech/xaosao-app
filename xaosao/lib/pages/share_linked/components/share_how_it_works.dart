import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

class ShareHowItWorks extends StatelessWidget {
  const ShareHowItWorks({super.key});

  static const _steps = [
    (
      icon: Icons.share_rounded,
      color: AppColors.primary,
      title: 'ແບ່ງປັນລະຫັດ',
      desc: 'ແບ່ງປັນລະຫັດແນະນຳ ຫຼື ລິ້ງຂອງທ່ານກັບໝູ່ທີ່ຕ້ອງການເປັນໂມດອ.',
      isLast: false,
    ),
    (
      icon: Icons.person_add_alt_1_rounded,
      color: AppColors.primary,
      title: 'ພວກເຂົາລົງທະບຽນ',
      desc: 'ໝູ່ຂອງທ່ານລົງທະບຽນໂດຍໃຊ້ລະຫັດແນະນຳຂອງທ່ານ.',
      isLast: false,
    ),
    (
      icon: Icons.card_giftcard_rounded,
      color: Color(0xFF22C55E),
      title: 'ຮັບລາງວັນ',
      desc: 'ເມື່ອໝູ່ຖືກອະນຸມັດ, ທ່ານໄດ້ຮັບ 10,000 ກີບ ທັນທີ!',
      isLast: true,
    ),
  ];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16.r, color: AppColors.primary),
              SizedBox(width: 6.w),
              Text(
                'ວິທີເຮັດຊ່ວງ',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          ..._steps.map((s) => _StepRow(s)),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final ({IconData icon, Color color, String title, String desc, bool isLast})
  data;
  const _StepRow(this.data);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40.r,
          child: Column(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(data.icon, size: 18.r, color: data.color),
              ),
              if (!data.isLast)
                Container(
                  width: 2.w,
                  height: 32.h,
                  margin: EdgeInsets.symmetric(vertical: 3.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        data.color.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: 8.h,
              bottom: data.isLast ? 0 : 22.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  data.desc,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textHint,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
