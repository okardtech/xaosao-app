import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/profile/components/profile_constant.dart';

class ServicesSection extends StatelessWidget {
  final VoidCallback onEdit;
  const ServicesSection({super.key, required this.onEdit});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Wrap(spacing: 6.w, runSpacing: 6.h, children: const [
        _SvcChip('ເພື່ອນສັງຄົມ', PColor.pink,
            Color(0xFFFFF0F6), Color(0x33F06292)),
        _SvcChip('ທ່ອງທ່ຽວ', Color(0xFF42A5F5),
            Color(0xFFF0F7FF), Color(0x3342A5F5)),
        _SvcChip('ບໍລິການນວດ', Color(0xFFAB47BC),
            Color(0xFFF3F0FF), Color(0x33AB47BC)),
      ]),
      SizedBox(height: 12.h),
      ProfileGroup(children: [
        ProfileMenuRow(
          iconBg: const Color(0xFFFFF0F6),
          iconColor: PColor.pink,
          icon: Icons.add_rounded,
          label: 'ແກ້ໄຂ / ເພີ່ມ ບໍລິການ',
          sub: 'ຕັ້ງລາຄາ ແລະ ຄຳອະທິບາຍ',
          onTap: onEdit,
        ),
      ]),
    ]);
  }
}

class _SvcChip extends StatelessWidget {
  final String label;
  final Color fg;
  final Color bg;
  final Color bd;
  const _SvcChip(this.label, this.fg, this.bg, this.bd);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: bd, width: 0.2),
      ),
      child: Text(label, style: TextStyle(
          fontSize: 12.sp, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}