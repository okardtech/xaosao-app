import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';

// ═══════════════════════════════════════════════════════════════
//  utils/app_text_field.dart
//  ໃຊ້ໄດ້ທຸກໜ້າໃນ project
//
//  Widgets:
//    AppTextField      — universal input
//    AppPhoneField     — 🇱🇦 +856 prefix
//    AppPasswordField  — password + eye toggle
//    AppFieldLabel     — field label with optional *
// ═══════════════════════════════════════════════════════════════

// ── Shared tokens ──────────────────────────────────────────────
abstract class AppFieldStyle {
  static const double height   = 50;
  static const double radius   = 14;
  static const double iconSize = 18;
  static const double textSize = 14;
  static const Color  hint     = Color(0xFFC4C4D0);
  static const Color  label    = Color(0xFF6B6B80);
  static const Color  navy     = Color(0xFF1A1A2E);
  static const Color  bg       = Color(0xFFF8F8FC);
  static const Color  border   = Color(0x1F000000);
}

// ── Field label ────────────────────────────────────────────────
class AppFieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  const AppFieldLabel(this.text, {super.key, this.required = false});

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppFieldStyle.label,
      ),
      children: required
          ? [TextSpan(text: ' *',
              style: TextStyle(color: AppColors.primary))]
          : null,
    ),
  );
}

// ── Animated shell ─────────────────────────────────────────────
class Shell extends StatelessWidget {
  final bool focused;
  final Color accent;
  final Widget child;
  final double? height;
  final bool autoHeight;

  const Shell({
    required this.focused,
    required this.accent,
    required this.child,
    this.height,
    this.autoHeight = false,
  });

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 180),
    height: autoHeight ? null : (height ?? AppFieldStyle.height).h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppFieldStyle.radius.r),
      border: Border.all(
        color: focused ? accent : AppFieldStyle.border,
        width: focused ? 1.5 : 0.8,
      ),
      boxShadow: focused
          ? [BoxShadow(
              color: accent.withOpacity(0.08),
              blurRadius: 0, spreadRadius: 3)]
          : null,
    ),
    child: child,
  );
}

// ═══════════════════════════════════════════════════════════════
//  AppTextField
// ═══════════════════════════════════════════════════════════════
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String hint;
  final IconData? prefixIcon;
  final Color accent;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? formatters;
  final TextInputAction action;
  final String? suffixLabel;
  final bool enabled;
  final int maxLines;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.accent,
    this.nextFocusNode,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.formatters,
    this.action = TextInputAction.next,
    this.suffixLabel,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_l);
  }

  void _l() {
    if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_l);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final multiline = widget.maxLines > 1;
    return Shell(
      focused: _focused,
      accent: widget.accent,
      autoHeight: multiline,
      child: Row(
        crossAxisAlignment: multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          if (widget.prefixIcon != null)
            Padding(
              padding: EdgeInsets.only(
                left: 12.w,
                right: 12.w,
                top: multiline ? 13.h : 0,
              ),
              child: Icon(widget.prefixIcon,
                  size: AppFieldStyle.iconSize.r,
                  color: _focused ? widget.accent : AppFieldStyle.hint),
            ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.formatters,
              textInputAction: widget.action,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              onChanged: widget.onChanged,
              onSubmitted: (_) {
                if (widget.nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocusNode);
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                    fontSize: AppFieldStyle.textSize.sp,
                    color: AppFieldStyle.hint),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.prefixIcon != null ? 0 : 14.w,
                    vertical: multiline ? 12.h : 0),
                suffixText: widget.suffixLabel,
                suffixStyle:
                    TextStyle(fontSize: 12.sp, color: AppFieldStyle.hint),
              ),
              style: TextStyle(
                  fontSize: AppFieldStyle.textSize.sp,
                  color: AppFieldStyle.navy),
            ),
          ),
          if (widget.suffixLabel != null) SizedBox(width: 8.w),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  AppPhoneField
// ═══════════════════════════════════════════════════════════════
class AppPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final Color accent;
  final void Function(String)? onChanged;

  const AppPhoneField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.accent,
    this.nextFocusNode,
    this.onChanged,
  });

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_l);
  }

  void _l() {
    if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_l);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Shell(
    focused: _focused,
    accent: widget.accent,
    child: Row(children: [
      Padding(
        padding: EdgeInsets.only(left: 11.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppFieldStyle.bg,
            borderRadius: BorderRadius.circular(7.r),
            border: Border.all(
                color: AppFieldStyle.border, width: 0.5),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('🇱🇦', style: TextStyle(fontSize: 13.sp)),
            SizedBox(width: 4.w),
            Text('+856',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppFieldStyle.navy)),
          ]),
        ),
      ),
      Container(
        width: 0.5, height: 22.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        color: Colors.black.withOpacity(0.09),
      ),
      Expanded(
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textInputAction: TextInputAction.next,
          onChanged: widget.onChanged,
          onSubmitted: (_) {
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          },
          decoration: InputDecoration(
            hintText: '20 XXXX XXXX',
            hintStyle: TextStyle(
                fontSize: AppFieldStyle.textSize.sp,
                color: AppFieldStyle.hint),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
          ),
          style: TextStyle(
              fontSize: AppFieldStyle.textSize.sp,
              color: AppFieldStyle.navy),
        ),
      ),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
//  AppPasswordField
// ═══════════════════════════════════════════════════════════════
class AppPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color accent;
  final String hint;
  final TextInputAction action;
  final VoidCallback? onSubmit;
  final void Function(String)? onChanged;

  const AppPasswordField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.accent,
    this.hint = 'ລະຫັດຜ່ານ',
    this.action = TextInputAction.done,
    this.onSubmit,
    this.onChanged,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _focused = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_l);
  }

  void _l() {
    if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_l);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Shell(
    focused: _focused,
    accent: widget.accent,
    child: Row(children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Icon(Icons.lock_outline_rounded,
            size: AppFieldStyle.iconSize.r,
            color: _focused ? widget.accent : AppFieldStyle.hint),
      ),
      Expanded(
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscure,
          textInputAction: widget.action,
          onChanged: widget.onChanged,
          onSubmitted: (_) => widget.onSubmit?.call(),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
                fontSize: AppFieldStyle.textSize.sp,
                color: AppFieldStyle.hint),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
          ),
          style: TextStyle(
              fontSize: AppFieldStyle.textSize.sp,
              color: AppFieldStyle.navy),
        ),
      ),
      GestureDetector(
        onTap: () => setState(() => _obscure = !_obscure),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: AppFieldStyle.iconSize.r,
            color: AppFieldStyle.hint,
          ),
        ),
      ),
    ]),
  );
}