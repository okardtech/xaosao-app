import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/package_model.dart';
import 'package:xaosao/pages/package/getx/package_logic.dart';
import 'package:xaosao/pages/wallet/getx/wallet_logic.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

// ── Route args ────────────────────────────────────────────────────
class SubscriptionCheckoutArgs {
  final String planId;
  final String planName;
  final String? description;
  final int price;
  final int? durationDays;
  final CurrentSubscriptionPlan? currentPlan;

  const SubscriptionCheckoutArgs({
    required this.planId,
    required this.planName,
    this.description,
    required this.price,
    this.durationDays,
    this.currentPlan,
  });
}

// ═══════════════════════════════════════════════════════════════════
//  SubscriptionCheckoutPage
// ═══════════════════════════════════════════════════════════════════
class SubscriptionCheckoutPage extends StatelessWidget {
  final SubscriptionCheckoutArgs args;
  const SubscriptionCheckoutPage({super.key, required this.args});

  String _durationLabel(int? days) {
    if (days == null || days == 0) return '—';
    if (days == 1) return '1 ວັນ';
    if (days == 7) return '1 ອາທິດ';
    if (days == 30) return '1 ເດືອນ';
    if (days == 90) return '3 ເດືອນ';
    if (days == 365) return '1 ປີ';
    return '$days ວັນ';
  }

  Future<void> _confirm(BuildContext context) async {
    showLoadingDialog();
    final ok = await Get.find<PackageLogic>().subscribeFromBanner(args.planId);
    hideLoadingDialog();
    if (ok && context.mounted) {
      Get.back();
      AppSnackbar.success('ຊື້ Package ສຳເລັດ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletLogic = Get.find<WalletLogic>();

    return Obx(() {
      final balance = walletLogic.state.wallet?.availableBalance ?? 0;
      final bonus = args.currentPlan?.daysRemaining ?? 0;
      final planDays = args.durationDays ?? 0;
      final totalDays = planDays + bonus;
      final canPay = balance >= args.price;

      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: GradientAppBar(
          title: 'ການອັບເກຣດ',
          subtitle: 'ກວດສອບ ແລະ ຢືນຢັນການຊຳລະ',
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  child: Column(
                    children: [
                      if (args.currentPlan != null) ...[
                        _CurrentPlanCard(plan: args.currentPlan!),
                        SizedBox(height: 12.h),
                      ],
                      _CheckoutSummaryCard(
                        planName: args.planName,
                        price: args.price,
                        planDays: planDays,
                        bonus: bonus,
                        totalDays: totalDays,
                        durationLabel: _durationLabel(args.durationDays),
                        balance: balance,
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: AppColors.borderMedium, width: 0.5),
                  ),
                ),
                child: AppPrimaryButton(
                  label: 'ດຳເນີນການຊຳລະ',
                  leadingIcon: Icons.bolt_rounded,
                  enabled: canPay,
                  onTap: () => _confirm(context),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ── Card 1: Current plan warning ──────────────────────────────────
class _CurrentPlanCard extends StatelessWidget {
  final CurrentSubscriptionPlan plan;
  const _CurrentPlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              size: 15.r,
              color: const Color(0xFFD97706),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ສະໝັກ Package ຢູ່ແລ້ວ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFB45309),
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    if (plan.name != null) _Pill(label: 'ແຜນ ${plan.name}'),
                    if (plan.daysRemaining != null && plan.daysRemaining! > 0) ...[
                      SizedBox(width: 6.w),
                      _Pill(label: 'ເຫຼືອ ${plan.daysRemaining} ວັນ'),
                    ],
                  ],
                ),
                SizedBox(height: 7.h),
                Text(
                  'ການຊຳລະໃໝ່ຈະເລີ່ມຕໍ່ຈາກ Package ປັດຈຸບັນ ແລະ ວັນທີ່ຍັງເຫຼືອຈະຖືກນຳໃສ່ Package ໃໝ່.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF92400E),
                    height: 1.5,
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

class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD97706).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFD97706),
        ),
      ),
    );
  }
}

// ── Card 2: Checkout summary (all-white) ─────────────────────────
class _CheckoutSummaryCard extends StatelessWidget {
  final String planName;
  final int price;
  final int planDays;
  final int bonus;
  final int totalDays;
  final String durationLabel;
  final int balance;

  const _CheckoutSummaryCard({
    required this.planName,
    required this.price,
    required this.planDays,
    required this.bonus,
    required this.totalDays,
    required this.durationLabel,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final canPay = balance >= price;
    final remaining = balance - price;
    final remainingColor = canPay ? AppColors.online : const Color(0xFFEF4444);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Plan identity ──────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.pinkGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.bolt_rounded, size: 20.r, color: Colors.white),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.4,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        planDays > 0 ? '$planDays ວັນ' : durationLabel,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                CurrFormatter.kip(price),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),
          Divider(height: 0, thickness: 0.5, color: AppColors.borderMedium),
          SizedBox(height: 14.h),

          // ── Duration breakdown ─────────────────────────────
          _SectionLabel('ໄລຍະ Package'),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                _DataRow(
                  icon: Icons.calendar_today_outlined,
                  iconColor: AppColors.textHint,
                  label: 'ໄລຍະ Package ໃໝ່',
                  value: planDays > 0 ? '$planDays ວັນ' : durationLabel,
                ),
                if (bonus > 0) ...[
                  SizedBox(height: 10.h),
                  _DataRow(
                    icon: Icons.card_giftcard_outlined,
                    iconColor: AppColors.online,
                    label: '+ ໂບນັດ (Package ເດີມ)',
                    value: '$bonus ວັນ',
                    valueColor: AppColors.online,
                    bold: true,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Divider(height: 0, thickness: 0.5, color: AppColors.borderMedium),
                  ),
                  _DataRow(
                    icon: Icons.timelapse_rounded,
                    iconColor: AppColors.primary,
                    label: 'ໄລຍະທັງໝົດ',
                    value: '$totalDays ວັນ',
                    valueColor: AppColors.primary,
                    bold: true,
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 16.h),
          Divider(height: 0, thickness: 0.5, color: AppColors.borderMedium),
          SizedBox(height: 14.h),

          // ── Payment breakdown ──────────────────────────────
          _SectionLabel('ສະຫຼຸບການຊຳລະ'),
          SizedBox(height: 10.h),
          _SummaryRow(label: 'ຍອດ Wallet', value: CurrFormatter.kip(balance)),
          SizedBox(height: 8.h),
          _SummaryRow(
            label: 'ລາຄາ Package',
            value: '− ${CurrFormatter.kip(price)}',
            valueColor: AppColors.primary,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 0, thickness: 0.5, color: AppColors.borderMedium),
          ),
          _SummaryRow(
            label: 'ຍອດຄົງເຫຼືອ',
            value: CurrFormatter.kip(remaining.abs()) + (remaining < 0 ? ' (ຂາດ)' : ''),
            valueColor: remainingColor,
            bold: true,
          ),

          SizedBox(height: 14.h),
          Divider(height: 0, thickness: 0.5, color: AppColors.borderMedium),
          SizedBox(height: 12.h),

          // ── Info note ──────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 13.r, color: AppColors.textDisabled),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'ຍອດ Wallet ຈະຖືກຕັດທັນທີ. Package ຈະເປີດໃຊ້ງານຫຼັງຈາກການຊຳລະສຳເລັດ.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textHint,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textDisabled,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  const _DataRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: iconColor),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textHint),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, color: AppColors.textHint)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 15.sp : 14.sp,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
