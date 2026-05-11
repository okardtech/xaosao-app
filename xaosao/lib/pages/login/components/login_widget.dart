import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_image.dart';
import 'package:xaosao/pages/register/getx/register_logic.dart';
import '../../register/register_page.dart';
import '../getx/login_state.dart';

// ═══════════════════════════════════════════════════════════════
//  login_widgets.dart — v2
//  Changes:
//    · PhoneField  — height 44.h, white fill, pink/navy border
//    · PasswordField — height 44.h, white fill, border, no filled bg
// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
//  LoginHero
// ═══════════════════════════════════════════════════════════════
class LoginHero extends StatelessWidget {
  const LoginHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.primary],
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 52.h, 0, 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.r,
            height: 80.r,
            child: Image.asset(AppImage.xaosaoNoBack),
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 120.w),
            child: Image.asset(AppImage.logoWhite),
          ),
          SizedBox(height: 4.h),
          Text(
            'ເພື່ອນຄູ່ໃຈ ທຸກທີ່ ທຸກເວລາ',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.70),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  RoleTabs
// ═══════════════════════════════════════════════════════════════
class RoleTabs extends StatelessWidget {
  final RegisterRole selected;
  final void Function(RegisterRole) onSelect;
  const RoleTabs({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _RoleTab(
            label: 'ລູກຄ້າ',
            icon: Icons.person_outline_rounded,
            role: RegisterRole.customer,
            selected: selected,
            onTap: onSelect,
          ),
          _RoleTab(
            label: 'Companion',
            icon: Icons.groups_outlined,
            role: RegisterRole.companion,
            selected: selected,
            onTap: onSelect,
          ),
        ],
      ),
    );
  }
}

class _RoleTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final RegisterRole role;
  final RegisterRole selected;
  final void Function(RegisterRole) onTap;

  const _RoleTab({
    required this.label,
    required this.icon,
    required this.role,
    required this.selected,
    required this.onTap,
  });

  bool get _isOn => selected == role;
  bool get _isCustomerTab => role == RegisterRole.customer;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(role),
        child: AnimatedContainer(
          height: double.infinity,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isOn ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: _isOn
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14.r,
                color: _isOn
                    ? (_isCustomerTab ? AppColors.primary : AppColors.textHint)
                    : AppColors.textHint,
              ),
              SizedBox(width: 5.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: _isOn
                      ? (_isCustomerTab
                            ? AppColors.primaryVariant
                            : AppColors.primaryVariant)
                      : AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  FieldLabel
// ═══════════════════════════════════════════════════════════════
class FieldLabel extends StatelessWidget {
  final String label;
  const FieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryVariant,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PhoneField — height 44, white bg, border, no duplicate fill
// ═══════════════════════════════════════════════════════════════
class PhoneField extends StatefulWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final FocusNode nextFocus;
  final Color accent;
  const PhoneField({
    super.key,
    required this.ctrl,
    required this.focus,
    required this.nextFocus,
    required this.accent,
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focus.addListener(_onFocus);
  }

  void _onFocus() {
    if (mounted) setState(() => _focused = widget.focus.hasFocus);
  }

  @override
  void dispose() {
    widget.focus.removeListener(_onFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: _focused ? widget.accent : Colors.black.withOpacity(0.12),
          width: _focused ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        children: [
          // Prefix +856
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(7.r),
                border: Border.all(
                  color: Colors.black.withOpacity(0.08),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇱🇦', style: TextStyle(fontSize: 13.sp)),
                  SizedBox(width: 4.w),
                  Text(
                    '+856',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Vertical divider
          Container(
            width: 0.5,
            height: 22.h,
            color: Colors.black.withOpacity(0.10),
          ),
          // Input
          Expanded(
            child: TextField(
              controller: widget.ctrl,
              focusNode: widget.focus,

              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(widget.nextFocus),
              decoration: InputDecoration(
                hintText: '20 XXXX XXXX',
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFFC4C4D0),
                ),
                // ← ບໍ່ໃຊ້ filled/fillColor ໃນ TextField
                // ສີຂາວຢູ່ Container ດ້ານນອກແລ້ວ
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 0,
                ),
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PasswordField — height 44, white bg, border
// ═══════════════════════════════════════════════════════════════
class PasswordField extends StatefulWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final Color accent;
  final bool obscure;
  final VoidCallback onToggle;
  final VoidCallback onSubmit;

  const PasswordField({
    super.key,
    required this.ctrl,
    required this.focus,
    required this.accent,
    required this.obscure,
    required this.onToggle,
    required this.onSubmit,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focus.addListener(_onFocus);
  }

  void _onFocus() {
    if (mounted) setState(() => _focused = widget.focus.hasFocus);
  }

  @override
  void dispose() {
    widget.focus.removeListener(_onFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: _focused ? widget.accent : Colors.black.withOpacity(0.12),
          width: _focused ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        children: [
          // Lock icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 16.r,
              color: _focused ? widget.accent : AppColors.textHint,
            ),
          ),
          // Input
          Expanded(
            child: TextField(
              controller: widget.ctrl,
              focusNode: widget.focus,
              obscureText: widget.obscure,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => widget.onSubmit(),
              decoration: InputDecoration(
                hintText: 'ລະຫັດຜ່ານ',
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFFC4C4D0),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryVariant,
              ),
            ),
          ),
          // Eye toggle
          GestureDetector(
            onTap: widget.onToggle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Icon(
                widget.obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 17.r,
                color: AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  LoginButton
// ═══════════════════════════════════════════════════════════════
class LoginButton extends StatelessWidget {
  final bool isCustomer;
  final VoidCallback onTap;

  const LoginButton({super.key, required this.isCustomer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: isCustomer
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondary, AppColors.primary],
                )
              : null,
          color: isCustomer ? null : AppColors.primaryVariant,
          boxShadow: [
            BoxShadow(
              color: (isCustomer ? AppColors.primary : AppColors.primaryVariant)
                  .withOpacity(0.30),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'ເຂົ້າສູ່ລະບົບ',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  RegisterLink
// ═══════════════════════════════════════════════════════════════
class RegisterLink extends StatelessWidget {
  final RegisterRole role;
  const RegisterLink({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isCustomer = role == RegisterRole.customer;
    final color = isCustomer ? AppColors.primary : AppColors.primaryVariant;
    final label = isCustomer ? 'ສ້າງບັນຊີ ລູກຄ້າ' : 'ສ້າງບັນຊີ ຜູ້ຮັບຈອງ';

    return Center(
      child: GestureDetector(
        onTap: () {
          Get.find<RegisterLogic>().clearState();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RegisterPage(role: role)),
          );
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            label,
            key: ValueKey(role),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: color,
              decoration: TextDecoration.underline,
              decorationColor: isCustomer
                  ? AppColors.primary
                  : AppColors.primaryVariant,
            ),
          ),
        ),
      ),
    );
  }
}
