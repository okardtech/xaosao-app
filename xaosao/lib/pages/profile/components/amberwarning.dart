import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

class AmberWarning extends StatelessWidget {
  final String text;
  const AmberWarning({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.commissionFg,
          height: 1.5,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
