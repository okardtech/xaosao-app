import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/register/components/register_app_bar.dart';
import 'package:xaosao/pages/register/components/register_widget.dart';
import '../login/getx/login_state.dart';
import 'components/avatar_picker.dart';
import 'getx/register_logic.dart';

class RegisterPage extends StatefulWidget {
  final RegisterRole role;
  const RegisterPage({super.key, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ── controllers ───────────────────────────────────────────
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _password = TextEditingController();

  // ── focus nodes ───────────────────────────────────────────
  final _fnFocus = FocusNode();
  final _lnFocus = FocusNode();
  final _phFocus = FocusNode();
  final _htFocus = FocusNode();
  final _adFocus = FocusNode();
  final _paFocus = FocusNode();

  bool _termsAccepted = false;

  // ── derived ───────────────────────────────────────────────
  bool get _isCompanion => widget.role == RegisterRole.companion;

  bool get _canSubmit {
    final base =
        _firstName.text.trim().isNotEmpty &&
        _lastName.text.trim().isNotEmpty &&
        _phone.text.trim().length >= 8 &&
        _termsAccepted;
    if (!_isCompanion) return base;
    return base && _address.text.trim().isNotEmpty;
  }

  // ── actions ───────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    await Get.find<RegisterLogic>().uploadAndRegister(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      phone: '${_phone.text.trim()}',
      password: _password.text,
      address: _isCompanion ? _address.text.trim() : null,
    );
  }

  @override
  void initState() {
    super.initState();
    Get.find<RegisterLogic>().setRole(widget.role);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _phone, _address, _password]) {
      c.dispose();
    }
    for (final f in [
      _fnFocus,
      _lnFocus,
      _phFocus,
      _htFocus,
      _adFocus,
      _paFocus,
    ]) {
      f.dispose();
    }
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final logic = Get.find<RegisterLogic>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: RegisterAppBar(
          role: widget.role,
          currentStep: 1,
          title: "ສ້າງບັນຊີ ສຳລັບລູກຄ້າ",
          subtitle: 'ກະລຸນາຕື່ມຂໍ້ມູນໃຫ້ຄົບ',
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AvatarSection(logic: logic, accent: AppColors.primary),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _FieldCol(
                              label: 'ຊື່',
                              child: RegField(
                                ctrl: _firstName,
                                focus: _fnFocus,
                                nextFocus: _lnFocus,
                                hint: 'ປ້ອນຊື່',
                                icon: Icons.person_outline_rounded,
                                role: widget.role,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: _FieldCol(
                              label: 'ນາມສະກຸນ',
                              child: RegField(
                                ctrl: _lastName,
                                focus: _lnFocus,
                                nextFocus: _phFocus,
                                hint: 'ປ້ອນນາມສະກຸນ',
                                icon: Icons.person_outline_rounded,
                                role: widget.role,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // ── ເບີໂທ ──────────────────────────────
                      RegLabel('ເບີໂທລະສັບ'),
                      SizedBox(height: 4.h),
                      PhoneRegField(
                        ctrl: _phone,
                        focus: _phFocus,
                        nextFocus: _paFocus,
                        role: widget.role,
                      ),
                      SizedBox(height: 12.h),
                      // ── ເພດ ─────────────────────────────────
                      RegLabel('ເລືອກເພດ'),
                      SizedBox(height: 4.h),
                      Obx(() {
                        final selected = logic.state.gender;
                        return GenderSelector(
                          selected: selected,
                          onSelect: (g) => logic.setGender(g),
                        );
                      }),
                      SizedBox(height: 12.h),

                      // ── ວັນເດືອນປີ & ຄວາມສູງ ────────────
                      Obx(() {
                        final dateTime = logic.state.dob;
                        return _FieldCol(
                          label: 'ວັນເດືອນປີເກີດ',
                          child: DatePickerField(
                            value: dateTime,
                            role: widget.role,
                            onPick: (d) => logic.setDob(d),
                          ),
                        );
                      }),
                      SizedBox(height: 12.h),
                      _FieldCol(
                        label: 'ລະຫັດຜ່ານ',
                        child: RegField(
                          ctrl: _password,
                          focus: _paFocus,
                          nextFocus: _adFocus,
                          hint: 'ປ້ອນລະຫັດຜ່ານ',
                          icon: Icons.lock,
                          role: widget.role,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // ── ທີ່ຢູ່ (Companion only) ────────────
                      if (_isCompanion) ...[
                        RegLabel('ທີ່ຢູ່'),
                        SizedBox(height: 4.h),
                        RegField(
                          ctrl: _address,
                          focus: _adFocus,
                          hint: 'ເຊັ່ນ: ໂຊນ 1, ວຽງຈັນ',
                          icon: Icons.location_on_outlined,
                          role: widget.role,
                          action: TextInputAction.done,
                        ),
                        SizedBox(height: 12.h),
                      ],

                      // ── Terms ───────────────────────────────
                      TermsCheckbox(
                        checked: _termsAccepted,
                        role: widget.role,
                        onToggle: () =>
                            setState(() => _termsAccepted = !_termsAccepted),
                      ),
                      SizedBox(height: 20.h),

                      // ── Submit ──────────────────────────────
                      RegButton(
                        role: widget.role,
                        enabled: _canSubmit,
                        onTap: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Label + child column helper ────────────────────────────────
class _FieldCol extends StatelessWidget {
  final String label;
  final Widget child;
  const _FieldCol({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegLabel(label),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final RegisterLogic logic;
  final Color accent;
  const _AvatarSection({required this.logic, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AvatarPicker(logic: logic, accent: accent),
    );
  }
}
