import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/profile/components/profile_constant.dart';

class StatCell extends StatelessWidget {
  final String value;
  final String label;
  const StatCell({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.black.withOpacity(0.09), width: 0.5),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: PColor.navy,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: PColor.hint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
