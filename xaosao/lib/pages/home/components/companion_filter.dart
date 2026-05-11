import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Gender Tab Bar
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
    {'value': 'male', 'label': 'ຜູ້ຊາຍ', 'icon': Icons.male_rounded},
    {'value': 'female', 'label': 'ຜູ້ຍິງ', 'icon': Icons.female_rounded},
    {'value': 'all', 'label': 'ທັງໝົດ', 'icon': Icons.people_alt_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _tabs.map((t) {
        final val = t['value'] as String;
        final isSelected = selected == val;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(val),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: isSelected
                    ? Border.all(width: 1.w, color: AppColors.primary)
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    t['icon'] as IconData,
                    size: 16.r,
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFF9B9BAD),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    t['label'] as String,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFF9B9BAD),
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
    {'value': 'vip', 'label': 'VIP Elite', 'emoji': '⭐'},
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
          final isVip = val == 'vip';
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
                        colors: [Color(0xFFF06292), Color(0xFFFF8A80)],
                      )
                    // : isVip
                    //     ? const LinearGradient(
                    //         colors: [Color(0xFFFFB800), Color(0xFFFF8F00)],
                    //       )
                    : null,
                color: (!isSelected) ? Colors.white : null,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFFF06292).withOpacity(0.30)
                        // : isVip
                        //     ? const Color(0xFFFFB800).withOpacity(0.30)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
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
