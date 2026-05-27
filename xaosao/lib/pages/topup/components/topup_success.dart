import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/topup/components/topup_constant.dart';
import 'package:xaosao/pages/topup/getx/topup_logic.dart';
import 'package:xaosao/widgets/app_button.dart';

class TopUpSuccessPage extends StatefulWidget {
  const TopUpSuccessPage({super.key});

  @override
  State<TopUpSuccessPage> createState() => _TopUpSuccessPageState();
}

class _TopUpSuccessPageState extends State<TopUpSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _buildDate() {
    final now = DateTime.now();
    const months = [
      '',
      'ມ.ກ',
      'ກ.ພ',
      'ມ.ນ',
      'ມ.ສ',
      'ພ.ພ',
      'ມ.ຖ',
      'ກ.ລ',
      'ສ.ຫ',
      'ກ.ຍ',
      'ຕ.ລ',
      'ພ.ຈ',
      'ທ.ວ',
    ];
    final h = now.hour.toString().padLeft(2, '0');
    final min = now.minute.toString().padLeft(2, '0');
    return '${now.day} ${months[now.month]} ${now.year}  $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final amount = Get.find<TopupLogic>().state.amount;
    final date = _buildDate();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Hero ──────────────────────────────────────────
            _Hero(scale: _scale, fade: _fade, amount: amount),
            SizedBox(height: 24.h),

            // ── Receipt card ──────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _ReceiptCard(amount: amount, date: date),
            ),
            SizedBox(height: 28.h),

            // ── Button ────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppPrimaryButton(
                label: 'ກັບໜ້າກະເປົ໋າ',
                leadingIcon: Icons.account_balance_wallet_outlined,
                onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

// ── Hero ──────────────────────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  final Animation<double> scale;
  final Animation<double> fade;
  final int amount;
  const _Hero({
    required this.scale,
    required this.fade,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 48.h, 0, 36.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.pinkGradient,
        ),
      ),
      child: FadeTransition(
        opacity: fade,
        child: Column(
          children: [
            ScaleTransition(
              scale: scale,
              child: Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.20),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 42.r,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'ເຕີມສຳເລັດ!',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'ກຳລັງລໍຖ້າການກວດສອບຈາກ Admin',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.30),
                  width: 0.8,
                ),
              ),
              child: Text(
                fmtKip(amount),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Receipt card ──────────────────────────────────────────────────────────
class _ReceiptCard extends StatelessWidget {
  final int amount;
  final String date;
  const _ReceiptCard({required this.amount, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.payments_outlined,
            label: 'ຈຳນວນ',
            value: fmtKip(amount),
            valueColor: AppColors.primary,
            valueBold: true,
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 16.w,
            endIndent: 16.w,
            color: Colors.black.withValues(alpha: 0.05),
          ),
          _DetailRow(
            icon: Icons.calendar_today_rounded,
            label: 'ວັນທີ',
            value: date,
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 16.w,
            endIndent: 16.w,
            color: Colors.black.withValues(alpha: 0.05),
          ),
          // ── Status footer ────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF59E0B),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'ລໍຖ້າການກວດສອບ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFB45309),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 14.r, color: AppColors.textHint),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: valueBold ? FontWeight.w800 : FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
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
