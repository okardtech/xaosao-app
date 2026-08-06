import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/pages/forgot_password/getx/forgot_logic.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
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
      isCustomer: Get.find<LoginLogic>().state.isCustomer,
    );
    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8FC),
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
                      SizedBox(height: 4.h),
                      AppFieldLabel(l10n.registerPhone, required: true),
                      SizedBox(height: 6.h),
                      AppPhoneField(
                        controller: _phoneCtrl,
                        focusNode: _phoneFocus,
                        accent: AppColors.primary,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.forgotOtpWillSendHere,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                      SizedBox(height: 28.h),
                      AppPrimaryButton(
                        label: l10n.forgotSendOtp,
                        enabled: _canSubmit,
                        loading: _loading,
                        trailingIcon: Icons.send_rounded,
                        onTap: _sendOtp,
                      ),
                      SizedBox(height: 14.h),
                      AppOutlineButton(
                        label: l10n.forgotBackToLogin,
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
    final l10n = AppLocalizations.of(context)!;
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
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 26.r,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    l10n.forgotTitle,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    l10n.forgotEnterRegistered,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.70),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: StepIndicatorRow(
                      currentStep: 1,
                      steps: [
                        StepItem(label: l10n.forgotStepPhone),
                        StepItem(label: l10n.registerStepOtp),
                        StepItem(label: l10n.changePasswordSectionNew),
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
