import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/forgot_password/getx/forgot_logic.dart';
import 'package:xaosao/pages/register/components/register_app_bar.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_text_field.dart';

class ForgotNewPasswordPage extends StatefulWidget {
  final String phone;
  const ForgotNewPasswordPage({super.key, required this.phone});

  @override
  State<ForgotNewPasswordPage> createState() => _ForgotNewPasswordPageState();
}

class _ForgotNewPasswordPageState extends State<ForgotNewPasswordPage> {
  late final ForgotLogic _logic;

  final _pwCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _pwFocus = FocusNode();
  final _confirmFocus = FocusNode();
  bool _loading = false;

  _PwStrength get _strength => _computeStrength(_pwCtrl.text);
  bool get _passwordsMatch =>
      _pwCtrl.text.isNotEmpty && _pwCtrl.text == _confirmCtrl.text;
  bool get _canSubmit => _passwordsMatch && _pwCtrl.text.length >= 6;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<ForgotLogic>();
    _pwCtrl.addListener(() => setState(() {}));
    _confirmCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pwCtrl.dispose();
    _confirmCtrl.dispose();
    _pwFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_canSubmit || _loading) return;
    setState(() => _loading = true);
    await _logic.newPassword(
      context,
      phone: widget.phone,
      newPass: _pwCtrl.text,
      isCustomer: _logic.state.isCustomer,
    );
    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            const _ForgotNewPasswordHero(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(22.r),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppFieldLabel('ລະຫັດຜ່ານໃໝ່', required: true),
                      SizedBox(height: 6.h),
                      AppPasswordField(
                        controller: _pwCtrl,
                        focusNode: _pwFocus,
                        accent: AppColors.primary,
                        hint: 'ລະຫັດຜ່ານໃໝ່',
                        action: TextInputAction.next,
                        onChanged: (_) {},
                      ),
                      SizedBox(height: 8.h),
                      if (_pwCtrl.text.isNotEmpty) ...[
                        _PasswordStrengthBar(strength: _strength),
                        SizedBox(height: 4.h),
                        Text(
                          _strength.label,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: _strength.color,
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ] else
                        SizedBox(height: 16.h),
                      const AppFieldLabel('ຢືນຢັນລະຫັດຜ່ານ', required: true),
                      SizedBox(height: 6.h),
                      AppPasswordField(
                        controller: _confirmCtrl,
                        focusNode: _confirmFocus,
                        accent: _confirmCtrl.text.isNotEmpty && _passwordsMatch
                            ? AppColors.online
                            : AppColors.primary,
                        hint: 'ຢືນຢັນລະຫັດຜ່ານ',
                        action: TextInputAction.done,
                        onSubmit: _save,
                      ),
                      if (_confirmCtrl.text.isNotEmpty && !_passwordsMatch) ...[
                        SizedBox(height: 6.h),
                        Text(
                          'ລະຫັດຜ່ານບໍ່ກົງກັນ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ],
                      SizedBox(height: 32.h),
                      AppPrimaryButton(
                        label: 'ບັນທຶກລະຫັດຜ່ານ',
                        enabled: _canSubmit,
                        loading: _loading,
                        trailingIcon: Icons.check_circle_outline_rounded,
                        onTap: _save,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Password strength ─────────────────────────────────────────────

enum _PwStrength { weak, fair, strong }

extension _PwStrengthX on _PwStrength {
  String get label {
    switch (this) {
      case _PwStrength.weak:
        return 'ອ່ອນ';
      case _PwStrength.fair:
        return 'ປານກາງ';
      case _PwStrength.strong:
        return 'ແຂງແຮງ';
    }
  }

  Color get color {
    switch (this) {
      case _PwStrength.weak:
        return Colors.red.shade400;
      case _PwStrength.fair:
        return Colors.orange.shade400;
      case _PwStrength.strong:
        return AppColors.online;
    }
  }

  double get progress {
    switch (this) {
      case _PwStrength.weak:
        return 0.33;
      case _PwStrength.fair:
        return 0.66;
      case _PwStrength.strong:
        return 1.0;
    }
  }
}

_PwStrength _computeStrength(String pw) {
  if (pw.length < 6) return _PwStrength.weak;
  final hasUpper = pw.contains(RegExp(r'[A-Z]'));
  final hasDigit = pw.contains(RegExp(r'[0-9]'));
  if (pw.length >= 8 && (hasUpper || hasDigit)) return _PwStrength.strong;
  return _PwStrength.fair;
}

class _PasswordStrengthBar extends StatelessWidget {
  final _PwStrength strength;
  const _PasswordStrengthBar({required this.strength});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: strength.progress),
        duration: const Duration(milliseconds: 300),
        builder: (_, value, __) => LinearProgressIndicator(
          value: value,
          backgroundColor: const Color(0xFFEEEEF4),
          valueColor: AlwaysStoppedAnimation(strength.color),
          minHeight: 4.h,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
class _ForgotNewPasswordHero extends StatelessWidget {
  const _ForgotNewPasswordHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.pinkGradient,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20.h,
            right: -20.w,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            bottom: -35.h,
            left: -20.w,
            child: Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 55.h, 18.w, 36.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56.r,
                    height: 56.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Icon(
                      Icons.shield_rounded,
                      size: 26.r,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'ຕັ້ງລະຫັດຜ່ານໃໝ່',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'ຕັ້ງລະຫັດຜ່ານໃໝ່ທີ່ປອດໄພ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.70),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: const StepIndicatorRow(
                      currentStep: 3,
                      steps: [
                        StepItem(label: 'ໂທລະສັບ'),
                        StepItem(label: 'OTP'),
                        StepItem(label: 'ລະຫັດໃໝ່'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
