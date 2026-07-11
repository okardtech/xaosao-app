import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String hint;
  final IconData? prefixIcon;
  final Color accent;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
    this.prefixIcon,
    this.accent = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: hasValue
              ? accent.withValues(alpha: 0.45)
              : Colors.black.withValues(alpha: 0.08),
          width: hasValue ? 1.4 : 0.8,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20.r,
            color: AppColors.textHint,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          hint: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 18.r, color: AppColors.textHint),
                SizedBox(width: 10.w),
              ],
              Text(
                hint,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textDisabled,
                ),
              ),
            ],
          ),
          selectedItemBuilder: (_) => items
              .map(
                (e) => Row(
                  children: [
                    if (prefixIcon != null) ...[
                      Icon(prefixIcon, size: 18.r, color: accent),
                      SizedBox(width: 10.w),
                    ],
                    Text(
                      e.label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e.value,
                  child: Row(
                    children: [
                      if (e.icon != null) ...[
                        Icon(e.icon, size: 16.r, color: accent),
                        SizedBox(width: 10.w),
                      ],
                      Text(
                        e.label,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class AppDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const AppDropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}
