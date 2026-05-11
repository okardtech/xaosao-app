import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/forgot_password/getx/forgot_logic.dart';
import 'package:xaosao/pages/register/components/register_app_bar.dart';
import 'package:xaosao/widgets/app_button.dart';

class ForgotOtpPage extends StatefulWidget {
  final String phone;
  const ForgotOtpPage({super.key, required this.phone});

  @override
  State<ForgotOtpPage> createState() => _ForgotOtpPageState();
}

class _ForgotOtpPageState extends State<ForgotOtpPage> {
  late final ForgotLogic _logic;

  String _otp = '';
  bool _loading = false;
  bool _hasError = false;
  Key _pinKey = UniqueKey();

  late int _totalSecs;
  int _remaining = 300;
  Timer? _timer;
  bool _canResend = false;

  String get _timerLabel {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void initState() {
    super.initState();
    _logic = Get.find<ForgotLogic>();
    _totalSecs = _logic.state.forgotPhone?.expiresIn ?? 300;
    _remaining = _totalSecs;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
    setState(() {
      _otp = '';
      _hasError = false;
      _pinKey = UniqueKey();
    });
    _startTimer();
    _logic.forgotResend(
      context,
      phone: widget.phone,
      isCustomer: _logic.state.isCustomer,
    );
  }

  Future<void> _verify() async {
    if (_otp.length < 6 || _loading) return;
    setState(() {
      _loading = true;
      _hasError = false;
    });
    final ok = await _logic.forgotVerify(
      context,
      phone: widget.phone,
      otp: _otp,
      isCustomer: _logic.state.isCustomer,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (!ok) setState(() => _hasError = true);
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
            _ForgotOtpHero(phone: widget.phone),
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
                      MaterialPinField(
                        key: _pinKey,
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
                          focusedBorderColor: AppColors.primary,
                          focusedFillColor: Colors.white,
                          filledBorderColor: AppColors.primary,
                          filledFillColor: Colors.white,
                          borderColor: AppColors.textDisabled,
                          fillColor: AppColors.bg,
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
                      _CountdownRow(
                        timerLabel: _timerLabel,
                        canResend: _canResend,
                        onResend: _resend,
                      ),
                      SizedBox(height: 22.h),
                      AppPrimaryButton(
                        label: 'ຢືນຢັນ OTP',
                        enabled: _otp.length == 6,
                        loading: _loading,
                        trailingIcon: Icons.check_rounded,
                        onTap: _verify,
                      ),
                      SizedBox(height: 14.h),
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
class _ForgotOtpHero extends StatelessWidget {
  final String phone;
  const _ForgotOtpHero({required this.phone});

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
                      Icons.mark_email_read_rounded,
                      size: 26.r,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'ຢືນຢັນຕົວຕົນ',
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
                      color: Colors.white.withValues(alpha: 0.70),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    phone,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: const StepIndicatorRow(
                      currentStep: 2,
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
                const TextSpan(text: 'ຍັງບໍ່ໄດ້ຮັບລະຫັດ? '),
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
