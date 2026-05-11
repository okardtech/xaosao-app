import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/login/components/login_widget.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/pages/login/components/role_tabs.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import '../../constants/app_color.dart';
import 'getx/login_state.dart';

// ═══════════════════════════════════════════════════════════════
//  LoginPage — ໜ້າ Login ດຽວ ມີ 2 role tabs
//  Customer  = ຜູ້ບໍລິການ  (pink theme)
//  Companion = ຜູ້ໃຫ້ບໍລິການ (navy theme)
//
//  Navigate in:
//    Navigator.pushReplacement(context,
//      MaterialPageRoute(builder: (_) => const LoginPage()))
// ═══════════════════════════════════════════════════════════════
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscure = true;

  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  Future<void> _submit() async {
    if (_phoneCtrl.text.trim().length < 8) {
      AppSnackbar.error('ກະລຸນາໃສ່ເບີໂທລະສັບໃຫ້ຖືກຕ້ອງ');
      return;
    }
    if (_passCtrl.text.isEmpty) {
      AppSnackbar.error('ກະລຸນາໃສ່ລະຫັດຜ່ານ');
      return;
    }
    FocusScope.of(context).unfocus();
    await Get.find<LoginLogic>().login(
      phone: '${_phoneCtrl.text.trim()}',
      password: _passCtrl.text,
    );
  }

  @override
  void initState() {
    super.initState();
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

  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final login = Get.find<LoginLogic>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          // physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // ── Hero ────────────────────────────────────────
                  Center(child: const LoginHero()),

                  // ── Form card (overlaps hero) ───────────────────
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
                        child: Obx(() {
                          final state = login.state;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ຍິນດີຕ້ອນຮັບ 👋',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryVariant,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'ທ່ານເຂົ້າໃນຖານະໃດ?',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textHint,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              // ── Role tabs ──────────────────────────
                              RoleCards(
                                selected: state.role,
                                onSelect: login.setRole,
                              ),
                              SizedBox(height: 20.h),
                              // ── Phone ──────────────────────────────
                              FieldLabel(label: 'ເບີໂທລະສັບ'),
                              SizedBox(height: 5.h),
                              PhoneField(
                                ctrl: _phoneCtrl,
                                focus: _phoneFocus,
                                nextFocus: _passFocus,
                                accent: state.role == RegisterRole.customer
                                    ? AppColors.primary
                                    : AppColors.primaryVariant,
                              ),
                              SizedBox(height: 12.h),
                              // ── Password ───────────────────────────
                              FieldLabel(label: 'ລະຫັດຜ່ານ'),
                              SizedBox(height: 5.h),
                              PasswordField(
                                ctrl: _passCtrl,
                                focus: _passFocus,
                                accent: state.role == RegisterRole.customer
                                    ? AppColors.primary
                                    : AppColors.primaryVariant,
                                obscure: _obscure,
                                onToggle: () =>
                                    setState(() => _obscure = !_obscure),
                                onSubmit: _submit,
                              ),
                              SizedBox(height: 8.h),
                              // ── Forgot ─────────────────────────────
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.forgotPassword,
                                    );
                                  },
                                  child: Text(
                                    'ລືມລະຫັດຜ່ານ?',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 18.h),
                              // ── Login button ───────────────────────
                              LoginButton(
                                isCustomer: state.role == RegisterRole.customer,
                                onTap: _submit,
                              ),
                              SizedBox(height: 16.h),
                              // ── Divider ────────────────────────────
                              _OrDivider(),
                              SizedBox(height: 14.h),
                              RegisterLink(role: state.role),
                            ],
                          );
                        }),
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
  }
}

// ── Or divider ─────────────────────────────────────────────────
class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 0.5, color: Colors.black.withOpacity(0.08)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'ຍັງບໍ່ມີບັນຊີ?',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFFC4C4D0)),
          ),
        ),
        Expanded(
          child: Container(height: 0.5, color: Colors.black.withOpacity(0.08)),
        ),
      ],
    );
  }
}
