import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final bool autofocus;

  const AppSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'ຄົ້ນຫາ...',
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 18.r,
          color: AppColors.textHint,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 14.w,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.07),
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.07),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
    );
  }
}
