import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/profile/change_password/getx/change_password_logic.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_text_field.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final ChangePasswordLogic _logic;

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _currentFocus = FocusNode();
  final _newFocus = FocusNode();
  final _confirmFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _logic = Get.put(ChangePasswordLogic());
    _currentCtrl.addListener(_rebuild);
    _newCtrl.addListener(_rebuild);
    _confirmCtrl.addListener(_rebuild);
  }

  @override
  void dispose() {
    _currentCtrl.removeListener(_rebuild);
    _newCtrl.removeListener(_rebuild);
    _confirmCtrl.removeListener(_rebuild);
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    _confirmFocus.dispose();
    Get.delete<ChangePasswordLogic>();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  String get _currentPass => _currentCtrl.text;
  String get _newPass => _newCtrl.text;
  String get _confirmPass => _confirmCtrl.text;

  bool get _currentOk => _currentPass.length >= 6;
  _PwStrength get _strength => _computeStrength(_newPass);
  bool get _confirmOk =>
      _confirmPass.isNotEmpty && _confirmPass == _newPass;

  bool get _canSubmit =>
      _currentOk &&
      _newPass.isNotEmpty &&
      _strength == _PwStrength.strong &&
      _confirmOk;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    await _logic.changePassword(
      currentPass: _currentPass,
      newPass: _newPass,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: const GradientAppBar(
          title: 'ປ່ຽນລະຫັດຜ່ານ',
          subtitle: 'ຕ້ອງໃສ່ລະຫັດທຳກ່ອນ',
        ),
        bottomNavigationBar: _buildBottomBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SecurityInfoCard(),
                SizedBox(height: 20.h),

                // ── ລະຫັດຜ່ານປັດຈຸບັນ ────────────────────────────
                _SectionSep('ລະຫັດຜ່ານ'),
                SizedBox(height: 12.h),
                AppFieldLabel('ລະຫັດຜ່ານປັດຈຸບັນ'),
                SizedBox(height: 5.h),
                AppPasswordField(
                  controller: _currentCtrl,
                  focusNode: _currentFocus,
                  accent: AppColors.primary,
                  hint: 'ລະຫັດຜ່ານປັດຈຸບັນ',
                  action: TextInputAction.next,
                ),
                if (_currentPass.isNotEmpty && !_currentOk) ...[
                  SizedBox(height: 6.h),
                  Text(
                    'ລະຫັດຜ່ານຕ້ອງຢ່າງໜ້ອຍ 6 ໂຕ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
                SizedBox(height: 20.h),

                // ── ລະຫັດໃໝ່ ─────────────────────────────────────
                _SectionSep('ລະຫັດໃໝ່'),
                SizedBox(height: 12.h),
                AppFieldLabel('ລະຫັດຜ່ານໃໝ່',),
                SizedBox(height: 5.h),
                AppPasswordField(
                  controller: _newCtrl,
                  focusNode: _newFocus,
                  accent: AppColors.primary,
                  hint: 'ໃສ່ລະຫັດໃໝ່',
                  action: TextInputAction.next,
                ),
                if (_newPass.isNotEmpty) ...[
                  SizedBox(height: 8.h),
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
                  SizedBox(height: 14.h),
                ] else
                  SizedBox(height: 14.h),

                // ── ຢືນຢັນ ───────────────────────────────────────
                AppFieldLabel('ຢືນຢັນລະຫັດໃໝ່'),
                SizedBox(height: 5.h),
                AppPasswordField(
                  controller: _confirmCtrl,
                  focusNode: _confirmFocus,
                  accent: _confirmPass.isNotEmpty && _confirmOk
                      ? AppColors.online
                      : AppColors.primary,
                  hint: 'ຢືນຢັນລະຫັດໃໝ່',
                  action: TextInputAction.done,
                  onSubmit: _submit,
                ),
                if (_confirmPass.isNotEmpty && !_confirmOk) ...[
                  SizedBox(height: 6.h),
                  Text(
                    'ລະຫັດຜ່ານບໍ່ກົງກັນ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        final isLoading =
            _logic.status.value == ChangePasswordStatus.loading;
        return AppPrimaryButton(
          label: 'ບັນທຶກລະຫັດໃໝ່',
          leadingIcon: Icons.lock_outline_rounded,
          enabled: _canSubmit,
          loading: isLoading,
          onTap: _submit,
        );
      }),
    );
  }
}

// ── Security info card ────────────────────────────────────────────────────

class _SecurityInfoCard extends StatelessWidget {
  const _SecurityInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: const LinearGradient(
                colors: AppColors.pinkGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 22.r,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ຄວາມປອດໄພ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'ລະຫັດຜ່ານຕ້ອງຢ່າງໜ້ອຍ 8 ໂຕ, '
                  'ລວມທັງຕົວໃຫຍ່, ຕົວເລກ ແລະ ສັນຍາລັກ',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section separator ─────────────────────────────────────────────────────

class _SectionSep extends StatelessWidget {
  final String label;
  const _SectionSep(this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 7.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Password strength ─────────────────────────────────────────────────────

enum _PwStrength { weak, fair, strong }

extension _PwStrengthX on _PwStrength {
  String get label {
    switch (this) {
      case _PwStrength.weak:   return 'ອ່ອນ';
      case _PwStrength.fair:   return 'ປານກາງ';
      case _PwStrength.strong: return 'ແຂງແຮງ';
    }
  }

  Color get color {
    switch (this) {
      case _PwStrength.weak:   return Colors.red.shade400;
      case _PwStrength.fair:   return Colors.orange.shade400;
      case _PwStrength.strong: return AppColors.online;
    }
  }

  double get progress {
    switch (this) {
      case _PwStrength.weak:   return 0.33;
      case _PwStrength.fair:   return 0.66;
      case _PwStrength.strong: return 1.0;
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
