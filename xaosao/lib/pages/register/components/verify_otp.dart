import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/register/components/register_app_bar.dart';
import 'package:xaosao/pages/register/getx/register_logic.dart';
import 'package:xaosao/pages/register/getx/register_state.dart';
import '../../login/getx/login_state.dart';

class OtpPage extends StatefulWidget {
  final RegisterModel model;

  const OtpPage({super.key, required this.model});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  // ── OTP ───────────────────────────────────────────────────
  final _otpCtrl = TextEditingController();
  String _otp = '';
  bool _loading = false;
  bool _hasError = false;

  // ── Countdown ─────────────────────────────────────────────
  static const _totalSecs = 300; // 5 min
  int _remaining = _totalSecs;
  Timer? _timer;
  bool _canResend = false;

  String get _timerLabel {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── lifecycle ─────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpCtrl.dispose();
    super.dispose();
  }

  // ── timer ─────────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remaining = _totalSecs;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 0) {
        _timer?.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _resend() {
    if (!_canResend) return;
    _otpCtrl.clear();
    setState(() {
      _otp = '';
      _hasError = false;
    });
    _startTimer();
    Get.find<RegisterLogic>().resendOtp(
      phone: widget.model.phone,
      isCustomer: widget.model.role == RegisterRole.customer,
    );
  }

  // ── verify ────────────────────────────────────────────────
  Future<void> _verify() async {
    if (_otp.length < 6 || _loading) return;
    setState(() {
      _loading = true;
      _hasError = false;
    });
    final ok = await Get.find<RegisterLogic>().verifyOtp(
      phone: widget.model.phone,
      otp: _otp,
      isCustomer: widget.model.role == RegisterRole.customer,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (!ok) setState(() => _hasError = true);
  }

  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Hero ────────────────────────────────────────
            _OtpHero(model: widget.model),
            // ── Form (white card overlapping hero) ──────────
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
                    children: [
                      // Subtitle
                      Text(
                        'ກະລຸນາກວດເບິ່ງ SMS ຂອງທ່ານ\nລະຫັດໃຊ້ໄດ້ 5 ນາທີ ເທົ່ານັ້ນ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textHint,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 22.h),

                      // ── PinCodeTextField ─────────────────────
                      MaterialPinField(
                        length: 6,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        enableHapticFeedback: true,
                        clearErrorOnInput: true,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        errorText: _hasError
                            ? 'ລະຫັດ OTP ບໍ່ຖືກຕ້ອງ — ລອງໃໝ່'
                            : null,
                        theme: MaterialPinTheme(
                          shape: MaterialPinShape.outlined,
                          cellSize: Size(42.w, 48.h),
                          spacing: 4.w,
                          borderRadius: BorderRadius.circular(12.r),
                          // active/focused cell
                          focusedBorderColor: AppColors.primary,
                          focusedFillColor: Colors.white,
                          // filled cells (already typed)
                          filledBorderColor: AppColors.primary,
                          filledFillColor: Colors.white,
                          // empty/inactive cells
                          borderColor: AppColors.textDisabled,
                          fillColor: AppColors.bg,
                          // error
                          errorColor: Colors.red.shade400,
                          cursorColor: AppColors.primary,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: _hasError
                                ? AppColors.primary
                                : AppColors.primaryVariant,
                          ),
                        ),
                        onChanged: (v) {
                          setState(() {
                            _otp = v;
                            if (_hasError) _hasError = false;
                          });
                        },
                        onCompleted: (_) => _verify(),
                      ),
                      SizedBox(height: 4.h),

                      // ── Error message ─────────────────────────
                      AnimatedOpacity(
                        opacity: _hasError ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Text(
                            'ລະຫັດ OTP ບໍ່ຖືກຕ້ອງ ກະລຸນາລອງໃໝ່',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.red.shade400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // ── Countdown + Resend ────────────────────
                      _CountdownRow(
                        timerLabel: _timerLabel,
                        canResend: _canResend,
                        onResend: _resend,
                      ),
                      SizedBox(height: 22.h),

                      // ── Verify button ─────────────────────────
                      _VerifyButton(
                        role: widget.model.role,
                        enabled: _otp.length == 6,
                        loading: _loading,
                        onTap: _verify,
                      ),
                      SizedBox(height: 14.h),

                      // ── Change number ─────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'ປ່ຽນເບີໂທລະສັບ',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.arrow_forward,
                            size: 14.sp,
                            color: AppColors.primary,
                          ),
                        ],
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
//  _OtpHero — pink/navy hero section
// ═══════════════════════════════════════════════════════════════
class _OtpHero extends StatelessWidget {
  final RegisterModel model;
  const _OtpHero({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.primary],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20.h,
            right: -20.w,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10),
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
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          // Content
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
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Icon(Icons.phone, size: 26.r, color: Colors.white),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'ຢືນຢັນເບີໂທ',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'ໃສ່ລະຫັດ 6 ໂຕທີ່ສົ່ງໄປຫາ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.70),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    model.phone,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: StepIndicatorRow(
                      currentStep: model.role == RegisterRole.customer ? 2 : 3,
                      steps: model.role == RegisterRole.customer
                          ? const [
                              StepItem(label: 'ຂໍ້ມູນ'),
                              StepItem(label: 'OTP'),
                            ]
                          : const [
                              StepItem(label: 'ຂໍ້ມູນ'),
                              StepItem(label: 'ບໍລິການ'),
                              StepItem(label: 'OTP'),
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

// ═══════════════════════════════════════════════════════════════
//  _CountdownRow
// ═══════════════════════════════════════════════════════════════
class _CountdownRow extends StatelessWidget {
  final String timerLabel;
  final bool canResend;
  final VoidCallback onResend;

  const _CountdownRow({
    required this.timerLabel,
    required this.canResend,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!canResend)
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 14.sp, color: AppColors.textHint),
              children: [
                const TextSpan(text: 'ລະຫັດໝົດອາຍຸໃນ '),
                TextSpan(
                  text: timerLabel,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryVariant,
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            'ລະຫັດໝົດອາຍຸແລ້ວ',
            style: TextStyle(fontSize: 14.sp, color: Colors.red.shade400),
          ),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: canResend ? onResend : null,
          child: Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 14.sp, color: AppColors.textHint),
              children: [
                TextSpan(text: 'ຍັງບໍ່ໄດ້ຮັບລະຫັດ? '),
                TextSpan(
                  text: 'ສົ່ງໃໝ່',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: canResend
                        ? AppColors.primary
                        : const Color(0xFFC4C4D0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _VerifyButton
// ═══════════════════════════════════════════════════════════════
class _VerifyButton extends StatelessWidget {
  final RegisterRole role;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  const _VerifyButton({
    required this.role,
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && !loading ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 46.h,
        decoration: BoxDecoration(
          color: enabled ? null : AppColors.textDisabled,
          borderRadius: BorderRadius.circular(13.r),
          gradient: enabled
              ? LinearGradient(colors: AppColors.pinkGradient)
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
          child: loading
              ? SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ຢືນຢັນ OTP',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: enabled ? Colors.white : AppColors.textHint,
                      ),
                    ),
                    SizedBox(width: 5.w),
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
