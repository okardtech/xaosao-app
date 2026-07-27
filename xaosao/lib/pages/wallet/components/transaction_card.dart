import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/transactions_model.dart';
import 'package:xaosao/pages/wallet/getx/wallet_state.dart';

class TransactionCard extends StatelessWidget {
  final TransactionsModel tx;
  const TransactionCard({super.key, required this.tx});

  String _title(AppLocalizations l10n) => switch (tx.identifier) {
    'recharge' => l10n.walletTxTypeRecharge,
    'subscription' => l10n.walletTxTypeSubscription,
    'gift' => l10n.walletTxTypeGift,
    'booking_hold' => l10n.walletTxTypeBookingHold,
    'booking_refund' => l10n.walletTxTypeBookingRefund,
    'gift_earning' => l10n.walletTxTypeGiftEarning,
    'booking_earning' => l10n.walletTxTypeBookingEarning,
    'withdrawal' => l10n.walletTxTypeWithdrawal,
    'referral' => l10n.walletTxTypeReferral,
    'booking_referral' => l10n.walletTxTypeBookingReferral,
    'subscription_referral' => l10n.walletTxTypeSubscriptionReferral,
    _ => tx.identifier ?? l10n.walletTxTypeGeneric,
  };

  String _amount(AppLocalizations l10n) =>
      '+${NumberFormat.decimalPattern().format(tx.amount ?? 0)} ${l10n.commonCurrencyKip}';

  String _date(AppLocalizations l10n) {
    if (tx.createdAt == null) return '—';
    final d = tx.createdAt!;
    final mo = <String>[
      '',
      l10n.monthShortJan, l10n.monthShortFeb, l10n.monthShortMar,
      l10n.monthShortApr, l10n.monthShortMay, l10n.monthShortJun,
      l10n.monthShortJul, l10n.monthShortAug, l10n.monthShortSep,
      l10n.monthShortOct, l10n.monthShortNov, l10n.monthShortDec,
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${mo[d.month]} ${d.year} · $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = TxStatusX.from(tx.status);
    return Opacity(
      opacity: status.opacity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.07),
            width: 0.5,
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
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: status.iconBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(status.icon, size: 16.r, color: status.iconColor),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title(l10n),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _date(l10n),
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _amount(l10n),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: status.iconColor,
                    decoration: status == TxStatus.cancelled
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: AppColors.textHint,
                  ),
                ),
                SizedBox(height: 3.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: status.badgeBg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    status.label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: status.badgeFg,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
