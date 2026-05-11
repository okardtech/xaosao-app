import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/forgot_password/getx/forgot_logic.dart';
import 'package:xaosao/pages/login/components/role_tabs.dart';
import 'package:xaosao/pages/login/getx/login_state.dart';
import 'package:xaosao/pages/register/components/register_app_bar.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_text_field.dart';

class ForgotPhonePage extends StatefulWidget {
  const ForgotPhonePage({super.key});

  @override
  State<ForgotPhonePage> createState() => _ForgotPhonePageState();
}

class _ForgotPhonePageState extends State<ForgotPhonePage> {
  final _phoneCtrl = TextEditingController();
  final _phoneFocus = FocusNode();
  RegisterRole _role = RegisterRole.customer;
  bool _loading = false;

  bool get _canSubmit => _phoneCtrl.text.trim().length >= 8;

  @override
  void initState() {
    super.initState();
    _phoneCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_canSubmit || _loading) return;
    setState(() => _loading = true);
    await Get.find<ForgotLogic>().forgotPhone(
      context,
      phone: _phoneCtrl.text.trim(),
      isCustomer: _role == RegisterRole.customer,
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
            const _ForgotPhoneHero(),
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
                  padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ທ່ານເຂົ້າໃນຖານະໃດ?',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      RoleCards(
                        selected: _role,
                        onSelect: (r) => setState(() => _role = r),
                      ),
                      SizedBox(height: 20.h),
                      const AppFieldLabel('ເບີໂທລະສັບ', required: true),
                      SizedBox(height: 6.h),
                      AppPhoneField(
                        controller: _phoneCtrl,
                        focusNode: _phoneFocus,
                        accent: AppColors.primary,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'ລະຫັດ OTP ຈະຖືກສົ່ງໄປຫາເບີນີ້',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                      SizedBox(height: 28.h),
                      AppPrimaryButton(
                        label: 'ສົ່ງລະຫັດ OTP',
                        enabled: _canSubmit,
                        loading: _loading,
                        trailingIcon: Icons.send_rounded,
                        onTap: _sendOtp,
                      ),
                      SizedBox(height: 14.h),
                      AppOutlineButton(
                        label: 'ກັບຄືນໜ້າເຂົ້າສູ່ລະບົບ',
                        leadingIcon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
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

// ═══════════════════════════════════════════════════════════════
class _ForgotPhoneHero extends StatelessWidget {
  const _ForgotPhoneHero();

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
                      Icons.lock_reset_rounded,
                      size: 26.r,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'ລືມລະຫັດຜ່ານ',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'ໃສ່ເບີໂທທີ່ລົງທະບຽນ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.70),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: const StepIndicatorRow(
                      currentStep: 1,
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
