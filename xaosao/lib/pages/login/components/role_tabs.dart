import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/widgets/app_svg_icon.dart';

import '../../../constants/app_color.dart';
import '../getx/login_state.dart';

class RoleCards extends StatelessWidget {
  final RegisterRole selected;
  final void Function(RegisterRole) onSelect;

  const RoleCards({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RoleCard(
            role: RegisterRole.customer,
            selected: selected,
            label: 'ຜູ້ຈອງ',
            sub: 'ຄົ້ນຫາ ແລະ ຈອງບໍລິການ',
            icon: AppIcons.user,
            activeGrad: AppColors.pinkGradient,
            activeBg: const Color(0xFFFFF5F6),
            activeBd: AppColors.primary,
            activeText: AppColors.primary,
            onTap: () => onSelect(RegisterRole.customer),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _RoleCard(
            role: RegisterRole.companion,
            selected: selected,
            label: 'ຜູ້ໃຫ້ບໍລິການ',
            sub: 'ໂພສບໍລິການ ແລະ ຮັບການຈອງ',
            icon: AppIcons.userGroup,
            activeGrad: const [Color(0xFF2A2A4E), Color(0xFF1A1A2E)],
            activeBg: const Color(0xFFF2F2F8),
            activeBd: const Color(0xFF1A1A2E),
            activeText: const Color(0xFF1A1A2E),
            onTap: () => onSelect(RegisterRole.companion),
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final RegisterRole role;
  final RegisterRole selected;
  final String label;
  final String sub;
  final String icon;
  final List<Color> activeGrad;
  final Color activeBg;
  final Color activeBd;
  final Color activeText;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.selected,
    required this.label,
    required this.sub,
    required this.icon,
    required this.activeGrad,
    required this.activeBg,
    required this.activeBd,
    required this.activeText,
    required this.onTap,
  });

  bool get _isOn => selected == role;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.fromLTRB(11.w, 12.h, 11.w, 11.h),
        decoration: BoxDecoration(
          color: _isOn ? activeBg : const Color(0xFFF8F8FC),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: _isOn ? activeBd : Colors.black.withOpacity(0.08),
            width: _isOn ? 1.5 : 0.8,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Row(
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        gradient: _isOn
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: activeGrad,
                              )
                            : null,
                        color: _isOn ? null : const Color(0xFFE8E8F0),
                        borderRadius: BorderRadius.circular(11.r),
                      ),
                      child: AppSvgIcon(
                        assetName: icon,
                        width: 17.w,
                        height: 17.h,
                        color: _isOn ? Colors.white : const Color(0xFFBBBBCC),
                      ),
                      // child: Icon(
                      //   icon,
                      //   size: 17.r,
                      //   color: _isOn ? Colors.white : const Color(0xFFBBBBCC),
                      // ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: _isOn ? activeText : const Color(0xFF9B9BAD),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Sub
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _isOn
                        ? activeText.withOpacity(0.55)
                        : const Color(0xFFC4C4D0),
                    height: 1.45,
                  ),
                ),
              ],
            ),
            // Check badge
            if (_isOn)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 16.r,
                  height: 16.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: activeGrad,
                    ),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 9.r,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
