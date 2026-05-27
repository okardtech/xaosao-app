import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_color.dart';

class StatCell extends StatelessWidget {
  final String value;
  final String label;
  final bool isBorder;
  const StatCell({super.key, required this.value, required this.label,this.isBorder = true});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          border:isBorder ? Border(
            left: BorderSide(color: Colors.black.withOpacity(0.09), width: 0.5),
          ): null,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryVariant,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
