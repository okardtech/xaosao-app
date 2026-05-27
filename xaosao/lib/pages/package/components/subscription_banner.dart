import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/package_hour_model.dart';
import 'package:xaosao/pages/package/getx/package_logic.dart';
import 'package:xaosao/pages/package/subscription_checkout_page.dart';
import 'package:xaosao/pages/wallet/getx/wallet_logic.dart';

const _kAdminPhone = '+85620XXXXXXXX';

String _fmtKip(int? n) => NumberFormat.decimalPattern().format(n ?? 0);

// ── Entry point ───────────────────────────────────────────────────
Future<void> showSubscriptionBanner(
  BuildContext context,
  PackageHourModel pkg,
) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => _SubscriptionDialog(pkg: pkg),
  );
}

// ═══════════════════════════════════════════════════════════════════
//  _SubscriptionDialog
// ═══════════════════════════════════════════════════════════════════
class _SubscriptionDialog extends StatelessWidget {
  final PackageHourModel pkg;
  const _SubscriptionDialog({required this.pkg});

  @override
  Widget build(BuildContext context) {
    final plan = pkg.plan;
    final walletBalance =
        Get.find<WalletLogic>().state.wallet?.availableBalance ?? 0;
    final price = plan?.price ?? 0;
    final hasBalance = walletBalance >= price;
    final shortfall = price - walletBalance;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Gradient header ─────────────────────────────
              _GradientHeader(plan: plan),

              // ── Body ────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price + Duration tiles
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            label: 'ລາຄາ',
                            value: '${_fmtKip(price)} KIP',
                            valueColor: AppColors.primary,
                            icon: Icons.sell_outlined,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _InfoTile(
                            label: 'ໄລຍະເວລາ',
                            value: _duration(plan?.durationDays),
                            valueColor: AppColors.textPrimary,
                            icon: Icons.access_time_rounded,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Features
                    if (_hasFeatures(plan?.features)) ...[
                      Text(
                        'ສິ່ງທີ່ທ່ານຈະໄດ້ຮັບ:',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ..._featureRows(plan?.features),
                      SizedBox(height: 14.h),
                    ],

                    // Wallet balance card
                    _WalletTile(
                      balance: walletBalance,
                      price: price,
                      hasBalance: hasBalance,
                      shortfall: shortfall,
                    ),
                    SizedBox(height: 12.h),

                    // See all packages link
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.toNamed(AppRoutes.package);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ເບິ່ງແພັກທັງໝົດ',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 13.r,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Action buttons
                    Row(
                      children: [
                        // Close
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              height: 46.h,
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: AppColors.borderMedium,
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'ປິດ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),

                        // CTA
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              if (hasBalance && plan?.id != null) {
                                Get.toNamed(
                                  AppRoutes.subscriptionCheckout,
                                  arguments: SubscriptionCheckoutArgs(
                                    planId: plan!.id!,
                                    planName: plan.name ?? '',
                                    description: plan.description,
                                    price: price,
                                    durationDays: plan.durationDays,
                                    currentPlan: Get.find<PackageLogic>()
                                        .state
                                        .currentPlan,
                                  ),
                                );
                              } else {
                                Get.toNamed(
                                  AppRoutes.topupAmount,
                                  arguments: {
                                    'initialAmount': price,
                                    if (plan?.id != null)
                                      'subscriptionPlanId': plan!.id!,
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 46.h,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: AppColors.pinkGradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.30,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    hasBalance
                                        ? Icons.bolt_rounded
                                        : Icons.account_balance_wallet_outlined,
                                    size: 16.r,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    hasBalance ? 'ຊື້ເລີຍ' : 'ຕື່ມເງິນ',
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
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _duration(int? days) {
    if (days == null) return '—';
    if (days == 0) return pkg.plan?.name ?? '—';
    if (days < 1) return '${(days * 24).round()} ຊ.ມ';
    if (days == 1) return '1 ວັນ';
    if (days == 7) return '1 ອາທິດ';
    if (days == 30) return '1 ເດືອນ';
    if (days == 90) return '3 ເດືອນ';
    if (days == 365) return '1 ປີ';
    return '$days ວັນ';
  }

  bool _hasFeatures(Features? f) =>
      f != null &&
      [f.chat, f.booking, f.support].any((v) => v != null && v.isNotEmpty);

  List<Widget> _featureRows(Features? f) {
    if (f == null) return [];
    final items = <(IconData, Color, String?)>[
      (Icons.chat_bubble_outline_rounded, AppColors.primary, f.chat),
      (Icons.calendar_today_outlined, const Color(0xFF3B82F6), f.booking),
      (Icons.support_agent_outlined, AppColors.online, f.support),
    ];
    return items
        .where((e) => e.$3 != null && e.$3!.isNotEmpty)
        .map(
          (e) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: e.$2.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(e.$1, size: 14.r, color: e.$2),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    e.$3!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(Icons.check_rounded, size: 16.r, color: AppColors.online),
              ],
            ),
          ),
        )
        .toList();
  }
}

// ── Gradient header ───────────────────────────────────────────────
class _GradientHeader extends StatelessWidget {
  final Plan? plan;
  const _GradientHeader({this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.pinkGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative orbs
          Positioned(
            top: -20,
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
            bottom: -30,
            left: -14,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Close button
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 14.r,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 44.w, 18.h),
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    size: 24.r,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan?.name ?? 'ແພັກພິເສດ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (plan?.description != null &&
                          plan!.description!.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          plan!.description!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white.withValues(alpha: 0.75),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
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

// ── Info tile ─────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;
  const _InfoTile({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.r, color: AppColors.textHint),
          SizedBox(width: 6.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: valueColor,
                    letterSpacing: -0.3,
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

// ── Wallet balance tile ───────────────────────────────────────────
class _WalletTile extends StatelessWidget {
  final int balance;
  final int price;
  final bool hasBalance;
  final int shortfall;
  const _WalletTile({
    required this.balance,
    required this.price,
    required this.hasBalance,
    required this.shortfall,
  });

  @override
  Widget build(BuildContext context) {
    final bg = hasBalance ? const Color(0xFFEDFAF3) : const Color(0xFFFFFBEB);
    final iconColor = hasBalance ? AppColors.online : const Color(0xFFF59E0B);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 16.r,
              color: iconColor,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ຍອດເງິນຂອງທ່ານ',
                  style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                ),
                SizedBox(height: 1.h),
                Text(
                  '${_fmtKip(balance)} KIP',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: iconColor,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          if (!hasBalance)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'ຕ້ອງການ +${_fmtKip(shortfall)} KIP',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF92400E),
                ),
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.online.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'ຊຳລະໄດ້ເລີຍ',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.online,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Pending subscription banner ───────────────────────────────────
Future<void> showPendingSubscriptionBanner(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => const _PendingSubscriptionDialog(),
  );
}

class _PendingSubscriptionDialog extends StatelessWidget {
  const _PendingSubscriptionDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PendingHeader(),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36.r,
                            height: 36.r,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFF59E0B,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.hourglass_top_rounded,
                              size: 18.r,
                              color: const Color(0xFFD97706),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ລໍຖ້າການຢືນຢັນ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF92400E),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'ທ່ານໄດ້ສະໝັກ Package ແລ້ວ',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFFB45309),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFF59E0B,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'ລໍຖ້າ',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF92400E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 14.r,
                            color: AppColors.textHint,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Package ຂອງທ່ານກຳລັງລໍຖ້າການຢືນຢັນຈາກ Admin. ກະລຸນາລໍຖ້າ ຫຼື ຕິດຕໍ່ Admin ເພື່ອຢືນຢັນໂດຍໄວ.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                height: 1.55,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_in_talk_rounded,
                            size: 16.r,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ເບີໂທ Admin',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.textHint,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  _kAdminPhone,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              height: 46.h,
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: AppColors.borderMedium,
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'ປິດ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () async {
                              final uri = Uri(
                                scheme: 'tel',
                                path: _kAdminPhone,
                              );
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                            child: Container(
                              height: 46.h,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: AppColors.pinkGradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.30,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone_rounded,
                                    size: 16.r,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'ໂທຫາ Admin',
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
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
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
            bottom: -30,
            left: -14,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 14.r,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 44.w, 18.h),
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    size: 24.r,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ກຳລັງລໍຖ້າການຢືນຢັນ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Package ຂອງທ່ານລໍຖ້າ Admin ກວດສອບ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.75),
                          height: 1.4,
                        ),
                      ),
                    ],
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
