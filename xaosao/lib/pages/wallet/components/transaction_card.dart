import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/transactions_model.dart';
import 'package:xaosao/pages/wallet/getx/wallet_state.dart';

class TransactionCard extends StatelessWidget {
  final TransactionsModel tx;
  const TransactionCard({super.key, required this.tx});

  String get _title =>
      tx.identifier?.isNotEmpty == true ? tx.identifier! : 'ເຕີມເງິນ';

  String get _amount =>
      '+${NumberFormat.decimalPattern().format(tx.amount ?? 0)} ກີບ';

  String get _date {
    if (tx.createdAt == null) return '—';
    final d = tx.createdAt!;
    const mo = [
      '', 'ມ.ກ', 'ກ.ພ', 'ມ.ນ', 'ມ.ສ', 'ພ.ພ', 'ມ.ຖ',
      'ກ.ລ', 'ສ.ຫ', 'ກ.ຍ', 'ຕ.ລ', 'ພ.ຈ', 'ທ.ວ',
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${mo[d.month]} ${d.year} · $h:$m';
  }

  @override
  Widget build(BuildContext context) {
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
                    _title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _date,
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _amount,
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
