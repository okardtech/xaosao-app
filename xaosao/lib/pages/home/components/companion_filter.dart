import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Gender Tab Bar  — underline indicator style, no counts
// ─────────────────────────────────────────────────────────────────────────────
class GenderTabBar extends StatelessWidget {
  final String selected; // 'male' | 'female' | 'all'
  final ValueChanged<String> onChanged;

  const GenderTabBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _tabs = [
    {'value': 'male', 'label': 'ຜູ້ຊາຍ'},
    {'value': 'female', 'label': 'ຜູ້ຍິງ'},
    {'value': 'all', 'label': 'ທັງໝົດ'},
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: _tabs.map((t) {
          final val = t['value'] as String;
          final isSelected = selected == val;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(val),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  t['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Category Pill Row  (ໃໝ່, ໃກ້ຄຽງ, VIP, ...)
// ─────────────────────────────────────────────────────────────────────────────
class CategoryPillRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const CategoryPillRow({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _categories = [
    {'value': 'new', 'label': 'ໃໝ່', 'emoji': '✨'},
    {'value': 'nearby', 'label': 'ໃກ້ຄຽງ', 'emoji': '📍'},
    {'value': 'vip', 'label': 'VIP', 'emoji': '⭐'},
    {'value': 'popular', 'label': 'ນິຍົມ', 'emoji': '🔥'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _categories.map((c) {
          final val = c['value'] as String;
          final isSelected = selected == val;

          return GestureDetector(
            onTap: () => onChanged(val),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: AppColors.pinkGradient,
                      )
                    : null,
                color: (!isSelected) ? Colors.white : null,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Text(c['emoji'] as String, style: TextStyle(fontSize: 12.sp)),
                  SizedBox(width: 5.w),
                  Text(
                    c['label'] as String,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: (isSelected)
                          ? Colors.white
                          : const Color(0xFF555570),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Service Filter Chips  (ເພື່ອນສັງຄົມ, ນວດ, ທ່ອງທ່ຽວ)
// ─────────────────────────────────────────────────────────────────────────────
class ServiceFilterRow extends StatelessWidget {
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const ServiceFilterRow({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  static const _filters = [
    {
      'value': 'social',
      'label': 'ເພື່ອນສັງຄົມ',
      'icon': Icons.people_alt_outlined,
      'color': 0xFFF06292,
    },
    {
      'value': 'massage',
      'label': 'ນວດ',
      'icon': Icons.spa_outlined,
      'color': 0xFF9C6FDE,
    },
    {
      'value': 'travel',
      'label': 'ທ່ອງທ່ຽວ',
      'icon': Icons.flight_takeoff_outlined,
      'color': 0xFF42A5F5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _filters.map((f) {
        final val = f['value'] as String;
        final isOn = selected.contains(val);
        final color = Color(f['color'] as int);

        return Expanded(
          child: GestureDetector(
            onTap: () => onToggle(val),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(right: val != 'travel' ? 8.w : 0),
              padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 6.w),
              decoration: BoxDecoration(
                color: isOn ? color.withOpacity(0.12) : Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isOn ? color.withOpacity(0.50) : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    f['icon'] as IconData,
                    size: 13.r,
                    color: isOn ? color : const Color(0xFF9B9BAD),
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: Text(
                      f['label'] as String,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: isOn ? color : const Color(0xFF9B9BAD),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
