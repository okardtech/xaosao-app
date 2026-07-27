import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/login/components/login_widget.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/l10n.dart';
import 'package:xaosao/pages/login/components/role_tabs.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import '../../constants/app_color.dart';
import 'getx/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  late final LoginLogic _logic;

  Future<void> _submit() async {
    final phone = _phoneCtrl.text.trim();
    final pass = _passCtrl.text;
    if (phone.length < 8) {
      AppSnackbar.error(l10n.authValidPhoneRequired);
      return;
    }
    if (pass.isEmpty) {
      AppSnackbar.error(l10n.authPasswordRequired);
      return;
    }
    FocusScope.of(context).unfocus();
    await _logic.login(phone: phone, password: pass);
  }

  @override
  void initState() {
    super.initState();
    _logic = Get.find<LoginLogic>();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _phoneFocus.dispose();
    _passFocus.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isCustomer = _logic.state.isCustomer;
      final obscure = _logic.state.obscure;
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: AppColors.bg,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // ── Hero ──────────────────────────────────────────
                    Center(child: const LoginHero()),

                    // ── Form card ─────────────────────────────────────
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(0, -16.h),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(22),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.authWelcome,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryVariant,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                l10n.authRolePrompt,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textHint,
                                ),
                              ),
                              SizedBox(height: 14.h),

                              // ── Role tabs ─────────────────────────────
                              RoleCards(
                                selected: isCustomer
                                    ? RegisterRole.customer
                                    : RegisterRole.companion,
                                onSelect: _logic.onRoleChange,
                              ),
                              SizedBox(height: 20.h),

                              // ── Phone ─────────────────────────────────
                              FieldLabel(label: l10n.authFieldPhone),
                              SizedBox(height: 5.h),
                              PhoneField(
                                ctrl: _phoneCtrl,
                                focus: _phoneFocus,
                                nextFocus: _passFocus,
                                accent: isCustomer
                                    ? AppColors.primary
                                    : AppColors.primaryVariant,
                              ),
                              SizedBox(height: 12.h),

                              // ── Password ──────────────────────────────
                              FieldLabel(label: l10n.authFieldPassword),
                              SizedBox(height: 5.h),
                              PasswordField(
                                ctrl: _passCtrl,
                                focus: _passFocus,
                                accent: isCustomer
                                    ? AppColors.primary
                                    : AppColors.primaryVariant,
                                obscure: obscure,
                                onToggle: _logic.toggleObscure,
                              ),
                              SizedBox(height: 8.h),

                              // ── Forgot ────────────────────────────────
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.forgotPassword,
                                  ),
                                  child: Text(
                                    l10n.authForgotPassword,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 18.h),

                              // ── Login button ──────────────────────────
                              LoginButton(
                                isCustomer: isCustomer,
                                onTap: _submit,
                              ),
                              SizedBox(height: 16.h),

                              // ── Divider + register ────────────────────
                              _OrDivider(),
                              SizedBox(height: 14.h),
                              RegisterLink(
                                role: isCustomer
                                    ? RegisterRole.customer
                                    : RegisterRole.companion,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 0.5,
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            l10n.authNoAccount,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFFC4C4D0)),
          ),
        ),
        Expanded(
          child: Container(
            height: 0.5,
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}
