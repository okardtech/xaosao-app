import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_data_config.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/pages/login/getx/login_state.dart';
import 'package:xaosao/pages/profile_detail/getx/profile_detail_logic.dart';
import 'package:xaosao/pages/register/components/register_widget.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_text_field.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class UpdateInfoPage extends StatefulWidget {
  final bool isClient;
  final BaseProfileModel profile;

  const UpdateInfoPage({
    super.key,
    required this.isClient,
    required this.profile,
  });

  @override
  State<UpdateInfoPage> createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  // unique tag so multiple instances never collide
  late final String _tag;
  late final ProfileDetailLogic _logic;

  // controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  // focus nodes
  final _fnFocus = FocusNode();
  final _lnFocus = FocusNode();
  final _adFocus = FocusNode();

  // form state
  Map<String, dynamic> _selectedGender = AppDataConfig.genderList.first;
  DateTime? _selectedDob;

  bool get _isModel => !widget.isClient;

  bool get _canSubmit =>
      _firstNameCtrl.text.trim().isNotEmpty &&
      _lastNameCtrl.text.trim().isNotEmpty &&
      _selectedDob != null;

  @override
  void initState() {
    super.initState();
    _tag = 'profile_update_$hashCode';
    _logic = Get.put(ProfileDetailLogic(), tag: _tag);
    _prefill();
    _firstNameCtrl.addListener(_rebuild);
    _lastNameCtrl.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  void _prefill() {
    _firstNameCtrl.text = widget.profile.firstName ?? '';
    _lastNameCtrl.text = widget.profile.lastName ?? '';
    _selectedDob = widget.profile.dob;
    _selectedGender = AppDataConfig.genderList.firstWhere(
      (g) => g['value'] == widget.profile.gender,
      orElse: () => AppDataConfig.genderList.first,
    );
    if (_isModel) {
      _addressCtrl.text =
          (widget.profile as ModelProfileModel).address ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.removeListener(_rebuild);
    _lastNameCtrl.removeListener(_rebuild);
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _addressCtrl.dispose();
    _fnFocus.dispose();
    _lnFocus.dispose();
    _adFocus.dispose();
    Get.delete<ProfileDetailLogic>(tag: _tag);
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    await _logic.updateInfo(
      isClient: widget.isClient,
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      gender: _selectedGender['value'] as String,
      dob: _selectedDob!,
      address: _isModel ? _addressCtrl.text.trim() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: const GradientAppBar(title: 'ແກ້ໄຂຂໍ້ມູນ'),
        bottomNavigationBar: _buildBottomBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── ຊື່ / ນາມສະກຸນ ───────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _FieldGroup(
                        label: 'ຊື່',
                        child: AppTextField(
                          controller: _firstNameCtrl,
                          focusNode: _fnFocus,
                          nextFocusNode: _lnFocus,
                          hint: 'ຊື່',
                          accent: AppColors.primary,
                          prefixIcon: Icons.person_outline_rounded,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _FieldGroup(
                        label: 'ນາມສະກຸນ',
                        child: AppTextField(
                          controller: _lastNameCtrl,
                          focusNode: _lnFocus,
                          hint: 'ນາມສະກຸນ',
                          accent: AppColors.primary,
                          prefixIcon: Icons.person_outline_rounded,
                          action: TextInputAction.next,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                // ── ເບີໂທ (read-only) ─────────────────────────────
                _FieldGroup(
                  label: 'ເບີໂທ (ບໍ່ສາມາດປ່ຽນ)',
                  child: _PhoneDisplayField(
                    number: widget.profile.whatsapp?.toString() ?? '',
                  ),
                ),
                SizedBox(height: 14.h),

                // ── ເພດ ────────────────────────────────────────────
                _FieldGroup(
                  label: 'ເພດ',
                  child: GenderSelector(
                    selected: _selectedGender,
                    onSelect: (g) => setState(() => _selectedGender = g),
                  ),
                ),
                SizedBox(height: 14.h),

                // ── ວັນເດືອນປີເກີດ ────────────────────────────────
                _FieldGroup(
                  label: 'ວັນເດືອນປີເກີດ',
                  child: DatePickerField(
                    value: _selectedDob,
                    role: RegisterRole.customer,
                    onPick: (d) => setState(() => _selectedDob = d),
                  ),
                ),
                SizedBox(height: 14.h),

                // ── ທີ່ຢູ່ (model only) ────────────────────────────
                if (_isModel) ...[
                  _FieldGroup(
                    label: 'ທີ່ຢູ່',
                    child: AppTextField(
                      controller: _addressCtrl,
                      focusNode: _adFocus,
                      hint: 'ເຊັ່ນ: ໂຊນ 1, ວຽງຈັນ',
                      accent: AppColors.primary,
                      prefixIcon: Icons.location_on_outlined,
                      action: TextInputAction.done,
                    ),
                  ),
                  SizedBox(height: 14.h),
                ],

                // ── ໝາຍເຫດ ────────────────────────────────────────
                _InfoNote(
                  'ການປ່ຽນລະຫັດຜ່ານ ແລະ ເລກໂທ, ຕ້ອງໄປທີ່ ໜ້າຕັ້ງຄ່າ',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Bottom save bar ────────────────────────────────────────────────

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
            _logic.status.value == ProfileUpdateStatus.loading;
        return AppPrimaryButton(
          label: 'ບັນທຶກ',
          enabled: _canSubmit,
          loading: isLoading,
          onTap: _submit,
        );
      }),
    );
  }
}

// ── Field group (label + input) ────────────────────────────────────────

class _FieldGroup extends StatelessWidget {
  final String label;
  final Widget child;
  const _FieldGroup({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFieldLabel(label),
          SizedBox(height: 5.h),
          child,
        ],
      );
}

// ── Read-only phone display ────────────────────────────────────────────

class _PhoneDisplayField extends StatelessWidget {
  final String number;
  const _PhoneDisplayField({required this.number});

  @override
  Widget build(BuildContext context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
              color: Colors.black.withValues(alpha: 0.08), width: 0.8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.r),
                border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1), width: 0.5),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('🇱🇦', style: TextStyle(fontSize: 12.sp)),
                SizedBox(width: 4.w),
                Text(
                  '+856',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ]),
            ),
            Container(
              width: 0.5,
              height: 20.h,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              color: Colors.black.withValues(alpha: 0.09),
            ),
            Expanded(
              child: Text(
                number,
                style: TextStyle(
                    fontSize: 14.sp, color: AppColors.textSecondary),
              ),
            ),
            Icon(Icons.lock_outline_rounded,
                size: 16.r, color: AppColors.textHint),
          ],
        ),
      );
}

// ── Info note ──────────────────────────────────────────────────────────

class _InfoNote extends StatelessWidget {
  final String message;
  const _InfoNote(this.message);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: const Color(0xFFFED7AA), width: 0.8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded,
                size: 16.r, color: const Color(0xFFF97316)),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF9A3412),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
}
