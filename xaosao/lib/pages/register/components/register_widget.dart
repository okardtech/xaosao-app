import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_data_config.dart';
import 'package:xaosao/utils/picker_date.dart';
import '../../login/getx/login_state.dart';

// ── Field label ────────────────────────────────────────────────
class RegLabel extends StatelessWidget {
  final String text;
  const RegLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
  );
}

// ═══════════════════════════════════════════════════════════════
//  RegField — universal text input (height 44.h)
// ═══════════════════════════════════════════════════════════════
class RegField extends StatefulWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final FocusNode? nextFocus;
  final String hint;
  final IconData icon;
  final RegisterRole role;
  final TextInputType keyboard;
  final List<TextInputFormatter>? formatters;
  final String? suffixText;
  final TextInputAction action;

  const RegField({
    super.key,
    required this.ctrl,
    required this.focus,
    required this.hint,
    required this.icon,
    required this.role,
    this.nextFocus,
    this.keyboard = TextInputType.text,
    this.formatters,
    this.suffixText,
    this.action = TextInputAction.next,
  });

  @override
  State<RegField> createState() => _RegFieldState();
}

class _RegFieldState extends State<RegField> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focus.addListener(_listen);
  }

  void _listen() {
    if (mounted) setState(() => _focused = widget.focus.hasFocus);
  }

  @override
  void dispose() {
    widget.focus.removeListener(_listen);
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
          color: _focused ? AppColors.primary : Colors.black.withOpacity(0.12),
          width: _focused ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Icon(
              widget.icon,
              size: 14.r,
              color: _focused ? AppColors.primary : AppColors.textHint,
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.ctrl,
              focusNode: widget.focus,
              keyboardType: widget.keyboard,
              inputFormatters: widget.formatters,
              textInputAction: widget.action,
              onSubmitted: (_) => widget.nextFocus != null
                  ? FocusScope.of(context).requestFocus(widget.nextFocus)
                  : FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFFC4C4D0),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                suffixText: widget.suffixText,
                suffixStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                ),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryVariant,
              ),
            ),
          ),
          if (widget.suffixText != null) SizedBox(width: 8.w),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PhoneRegField — +856 prefix + number
// ═══════════════════════════════════════════════════════════════
class PhoneRegField extends StatefulWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final FocusNode? nextFocus;
  final RegisterRole role;

  const PhoneRegField({
    super.key,
    required this.ctrl,
    required this.focus,
    required this.role,
    this.nextFocus,
  });

  @override
  State<PhoneRegField> createState() => _PhoneRegFieldState();
}

class _PhoneRegFieldState extends State<PhoneRegField> {
  bool _focused = false;
  @override
  void initState() {
    super.initState();
    widget.focus.addListener(_l);
  }

  void _l() {
    if (mounted) setState(() => _focused = widget.focus.hasFocus);
  }

  @override
  void dispose() {
    widget.focus.removeListener(_l);
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
          color: _focused ? AppColors.primary : Colors.black.withOpacity(0.12),
          width: _focused ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Container(
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
          ),
          Container(
            width: 0.5,
            height: 20.h,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            color: Colors.black.withOpacity(0.10),
          ),
          Expanded(
            child: TextField(
              controller: widget.ctrl,
              focusNode: widget.focus,
              keyboardType: TextInputType.phone,

              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => widget.nextFocus != null
                  ? FocusScope.of(context).requestFocus(widget.nextFocus)
                  : null,
              decoration: InputDecoration(
                hintText: '20 XXXX XXXX',
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFFC4C4D0),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
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
//  GenderSelector — ຊາຍ / ຍິງ chip pair
// ═══════════════════════════════════════════════════════════════
class GenderSelector extends StatelessWidget {
  final Map<String, dynamic> selected;
  final void Function(Map<String, dynamic>) onSelect;

  const GenderSelector({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6.w,
      children: List.generate(AppDataConfig.genderList.length, (index) {
        final gender = AppDataConfig.genderList[index];
        return Expanded(
          child: _GChip(
            label: gender['name'],
            isSelected: selected['id'] == gender['id'],
            onTap: () => onSelect(gender),
          ),
        );
      }),
    );
  }
}

class _GChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  bool get _isOn => isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: _isOn ? AppColors.primary : AppColors.border,
            width: _isOn ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isOn
                  ? Icons.radio_button_checked_rounded
                  : Icons.circle_outlined,
              size: 16.r,
              color: _isOn ? AppColors.primary : AppColors.textHint,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: _isOn ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  DatePickerField — read-only + date picker dialog
// ═══════════════════════════════════════════════════════════════
class DatePickerField extends StatelessWidget {
  final DateTime? value;
  final RegisterRole role;
  final void Function(DateTime) onPick;

  const DatePickerField({
    super.key,
    required this.value,
    required this.role,
    required this.onPick,
  });

  String get _label {
    if (value == null) return 'dd/mm/yyyy';
    return '${value!.day.toString().padLeft(2, '0')}/'
        '${value!.month.toString().padLeft(2, '0')}/'
        '${value!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await pickDate(context, lastDate: DateTime.now());
        if (picked != null) onPick(picked);
      },
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.black.withOpacity(0.12), width: 0.8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 18.r,
              color: AppColors.textHint,
            ),
            SizedBox(width: 8.w),
            Text(
              _label,
              style: TextStyle(
                fontSize: 14.sp,
                color: value != null
                    ? AppColors.primaryVariant
                    : const Color(0xFFC4C4D0),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: 18.r,
              color: Colors.black.withOpacity(0.18),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  TermsCheckbox
// ═══════════════════════════════════════════════════════════════
class TermsCheckbox extends StatelessWidget {
  final bool checked;
  final RegisterRole role;
  final VoidCallback onToggle;

  const TermsCheckbox({
    super.key,
    required this.checked,
    required this.role,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 20.r,
            height: 20.r,
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              color: checked ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(
                color: checked ? AppColors.primary : AppColors.border,
                width: checked ? 0 : 1.5,
              ),
            ),
            child: checked
                ? Icon(Icons.check_rounded, size: 13.r, color: Colors.white)
                : null,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                  height: 1.55,
                ),
                children: [
                  const TextSpan(text: 'ຂ້ອຍໄດ້ອ່ານ ແລະ ຍອມຮັບ '),
                  TextSpan(
                    text: 'ຂໍ້ກຳນົດການໃຊ້ງານ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const TextSpan(text: ' ແລະ '),
                  TextSpan(
                    text: 'ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const TextSpan(text: ' ຂອງ XAOSAO'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  RegButton — CTA button (gradient or solid)
// ═══════════════════════════════════════════════════════════════
class RegButton extends StatelessWidget {
  final RegisterRole role;
  final bool enabled;
  final VoidCallback onTap;

  const RegButton({
    super.key,
    required this.role,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
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
                    color: AppColors.primary.withOpacity(0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ສ້າງບັນຊື",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: enabled ? Colors.white : AppColors.textHint,
                ),
              ),
              SizedBox(width: 12.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
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

class RegProfile extends StatelessWidget {
  final File? file;
  const RegProfile({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 1.w, color: AppColors.primary),
      ),
      child: Icon(Icons.person, size: 50.sp),
    );
  }
}
