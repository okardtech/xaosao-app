import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_data_config.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/pages/login/getx/login_state.dart';
import 'package:xaosao/pages/profile_detail/getx/profile_detail_logic.dart';
import 'package:xaosao/pages/register/components/register_widget.dart';
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
  late final String _tag;
  late final ProfileDetailLogic _logic;

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  final _fnFocus = FocusNode();
  final _lnFocus = FocusNode();
  final _adFocus = FocusNode();

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
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: GradientAppBar(
          title: l10n.profileEditTitle,
          subtitle: l10n.registerFillInfo,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── ຊື່ / ນາມສະກຸນ ──────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _FieldCol(
                        label: l10n.registerFirstName,
                        child: RegField(
                          ctrl: _firstNameCtrl,
                          focus: _fnFocus,
                          nextFocus: _lnFocus,
                          hint: l10n.registerFirstNameHint,
                          icon: Icons.person_outline_rounded,
                          role: RegisterRole.customer,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: _FieldCol(
                        label: l10n.registerLastName,
                        child: RegField(
                          ctrl: _lastNameCtrl,
                          focus: _lnFocus,
                          hint: l10n.registerLastNameHint,
                          icon: Icons.person_outline_rounded,
                          role: RegisterRole.customer,
                          action: TextInputAction.next,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ── ເບີໂທ (read-only) ─────────────────────────────────
                _FieldCol(
                  label: l10n.profilePhoneReadonlyLabel,
                  child: _PhoneReadOnly(
                    number: widget.profile.whatsapp?.toString() ?? '',
                  ),
                ),
                SizedBox(height: 12.h),

                // ── ເພດ ───────────────────────────────────────────────
                RegLabel(l10n.registerSelectGender),
                SizedBox(height: 4.h),
                GenderSelector(
                  selected: _selectedGender,
                  onSelect: (g) => setState(() => _selectedGender = g),
                ),
                SizedBox(height: 12.h),

                // ── ວັນເດືອນປີເກີດ ────────────────────────────────────
                _FieldCol(
                  label: l10n.registerDob,
                  child: DatePickerField(
                    value: _selectedDob,
                    role: RegisterRole.customer,
                    onPick: (d) => setState(() => _selectedDob = d),
                  ),
                ),
                SizedBox(height: 12.h),

                // ── ທີ່ຢູ່ (model only) ────────────────────────────────
                if (_isModel) ...[
                  _FieldCol(
                    label: l10n.registerAddress,
                    child: RegField(
                      ctrl: _addressCtrl,
                      focus: _adFocus,
                      hint: l10n.profileAddressHint,
                      icon: Icons.location_on_outlined,
                      role: RegisterRole.customer,
                      action: TextInputAction.done,
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],

                // ── ໝາຍເຫດ ───────────────────────────────────────────
                _InfoNote(
                  l10n.profileEditNote,
                ),
                SizedBox(height: 24.h),

                // ── ປຸ່ມບັນທຶກ ────────────────────────────────────────
                Obx(() {
                  final isLoading =
                      _logic.status.value == ProfileUpdateStatus.loading;
                  return _SaveButton(
                    enabled: _canSubmit,
                    loading: isLoading,
                    onTap: _submit,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Label + field column ───────────────────────────────────────────────

class _FieldCol extends StatelessWidget {
  final String label;
  final Widget child;
  const _FieldCol({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RegLabel(label),
          SizedBox(height: 4.h),
          child,
        ],
      );
}

// ── Read-only phone display ────────────────────────────────────────────

class _PhoneReadOnly extends StatelessWidget {
  final String number;
  const _PhoneReadOnly({required this.number});

  @override
  Widget build(BuildContext context) => Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.12),
            width: 0.8,
          ),
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
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇱🇦', style: TextStyle(fontSize: 12.sp)),
                  SizedBox(width: 4.w),
                  Text(
                    '+856',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 0.5,
              height: 20.h,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              color: Colors.black.withValues(alpha: 0.10),
            ),
            Expanded(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Icon(Icons.lock_outline_rounded,
                size: 16.r, color: AppColors.textHint),
          ],
        ),
      );
}

// ── Gradient save button ───────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;
  const _SaveButton({
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (enabled && !loading) ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 46.h,
        decoration: BoxDecoration(
          color: enabled ? null : AppColors.textDisabled,
          borderRadius: BorderRadius.circular(13.r),
          gradient: enabled
              ? LinearGradient(
                  colors: AppColors.pinkGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: loading
              ? SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.profileSave,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: enabled ? Colors.white : AppColors.textHint,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Icons.check_rounded,
                      size: 14.r,
                      color: enabled ? Colors.white : AppColors.textHint,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
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
          border: Border.all(color: const Color(0xFFFED7AA), width: 0.8),
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
