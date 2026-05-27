import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/profile/components/profile_constant.dart';

import '../../../constants/app_color.dart';

class QrRow extends StatelessWidget {
  final String bank;
  final VoidCallback onTap;
  const QrRow({super.key, required this.bank, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 46.r,
              height: 46.r,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                size: 26,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ສະແກນເພື່ອໂອນເງິນ',
                    style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    bank,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 17,
              color: Color(0xFFC4C4D0),
            ),
          ],
        ),
      ),
    );
  }
}
