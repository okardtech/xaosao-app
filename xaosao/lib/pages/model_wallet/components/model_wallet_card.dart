import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/model_wallet_model.dart';

class ModelWalletCard extends StatelessWidget {
  final ModelWalletModel wallet;
  final bool amountsVisible;
  final VoidCallback onToggleVisibility;
  final VoidCallback onWithdraw;

  const ModelWalletCard({
    super.key,
    required this.wallet,
    required this.amountsVisible,
    required this.onToggleVisibility,
    required this.onWithdraw,
  });

  String _fmt(int? n) =>
      '${NumberFormat.decimalPattern().format(n ?? 0)} ກີບ';

  static const String _masked = '••••••';

  @override
  Widget build(BuildContext context) {
    final balance = _fmt(wallet.totalBalance);
    final pending = _fmt(wallet.totalPending);
    final withdrawn = _fmt(wallet.totalWithdraw);
    final income = _fmt(wallet.totalIncome);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.pinkGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -22,
            right: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -32,
            left: -12,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label + eye toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ຍອດເງິນທັງໝົດ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.55),
                        letterSpacing: 0.3,
                      ),
                    ),
                    GestureDetector(
                      onTap: onToggleVisibility,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 30.r,
                        height: 30.r,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(9.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22),
                            width: 0.5,
                          ),
                        ),
                        child: Icon(
                          amountsVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 14.r,
                          color: Colors.white.withValues(alpha: 0.90),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // Main balance
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    amountsVisible ? balance : _masked,
                    key: ValueKey(amountsVisible),
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.8,
                      height: 1,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // 3 stat pills
                Row(
                  children: [
                    Expanded(
                      child: _StatPill(
                        label: 'ລໍຖ້າ',
                        value: amountsVisible ? pending : _masked,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: _StatPill(
                        label: 'ຖອນແລ້ວ',
                        value: amountsVisible ? withdrawn : _masked,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: _StatPill(
                        label: 'ລາຍຮັບ',
                        value: amountsVisible ? income : _masked,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Withdraw button
                GestureDetector(
                  onTap: onWithdraw,
                  child: Container(
                    width: double.infinity,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_outward_rounded,
                          size: 16.r,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'ຖອນເງິນ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.white.withValues(alpha: 0.50),
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 3.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            value,
            key: ValueKey(value),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }
}
