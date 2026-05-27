import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/pages/profile/components/profile_constant.dart';

class ServicesSection extends StatelessWidget {
  final List<ModelService> services;
  final VoidCallback onEdit;

  const ServicesSection({
    super.key,
    required this.services,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (services.isEmpty)
          _EmptyChip()
        else
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: services.map((s) {
              final c = _colorsFor(s.serviceName);
              return _SvcChip(s.serviceName ?? '—', c.fg, c.bg, c.bd);
            }).toList(),
          ),
        SizedBox(height: 12.h),
        ProfileGroup(
          children: [
            ProfileMenuRow(
              iconBg: AppColors.primary.withValues(alpha: 0.08),
              iconColor: AppColors.primary,
              icon: Icons.tune_rounded,
              label: 'ແກ້ໄຂ / ເພີ່ມ ບໍລິການ',
              sub: 'ຕັ້ງລາຄາ ແລະ ຄຳອະທິບາຍ',
              onTap: onEdit,
            ),
          ],
        ),
      ],
    );
  }
}

// ── chip colors by service name ────────────────────────────────
class _ChipColors {
  final Color fg, bg, bd;
  const _ChipColors(this.fg, this.bg, this.bd);
}

_ChipColors _colorsFor(String? name) {
  final n = (name ?? '').toLowerCase();
  if (n.contains('social') || n.contains('ສັງຄົມ') || n.contains('ເພື່ອນ')) {
    return const _ChipColors(
      AppColors.socialFg,
      AppColors.socialBg,
      AppColors.socialBd,
    );
  }
  if (n.contains('massage') || n.contains('ນວດ') || n.contains('spa')) {
    return const _ChipColors(
      AppColors.massageFg,
      AppColors.massageBg,
      AppColors.massageBd,
    );
  }
  if (n.contains('travel') || n.contains('ທ່ອງ') || n.contains('tour')) {
    return const _ChipColors(
      AppColors.travelFg,
      AppColors.travelBg,
      AppColors.travelBd,
    );
  }
  return _ChipColors(
    AppColors.primary,
    AppColors.primary.withValues(alpha: 0.08),
    AppColors.primary.withValues(alpha: 0.20),
  );
}

// ── chips ──────────────────────────────────────────────────────
class _SvcChip extends StatelessWidget {
  final String label;
  final Color fg, bg, bd;
  const _SvcChip(this.label, this.fg, this.bg, this.bd);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: bd, width: 0.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.07),
          width: 0.6,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_circle_outline_rounded,
            size: 12.r,
            color: AppColors.textHint,
          ),
          SizedBox(width: 5.w),
          Text(
            'ຍັງບໍ່ມີບໍລິການ',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
