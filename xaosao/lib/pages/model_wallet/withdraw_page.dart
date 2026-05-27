import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/bank_account_model.dart';
import 'package:xaosao/pages/model_wallet/components/model_wallet_shimmer.dart';
import 'package:xaosao/pages/model_wallet/getx/model_wallet_logic.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_text_field.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  late final ModelWalletLogic _logic;
  final _amountCtrl = TextEditingController();
  final _amountFocus = FocusNode();
  String? _selectedBankId;
  int _amount = 0;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<ModelWalletLogic>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _logic.fetchBankAccounts(),
    );
    _amountCtrl.addListener(() {
      final raw = _amountCtrl.text.replaceAll(',', '').replaceAll(' ', '');
      setState(() => _amount = int.tryParse(raw) ?? 0);
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  bool _canSubmit(int minWithdraw, int maxWithdraw) =>
      _selectedBankId != null &&
      _amount >= minWithdraw &&
      _amount <= maxWithdraw;

  Future<void> _submit() async {
    if (_selectedBankId == null) return;
    final ok = await _logic.withdraw(_amount, _selectedBankId!);
    if (ok && mounted) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(title: 'ຖອນເງິນ', subtitle: 'ຈ່າຍໃຫ້ບັນຊີທະນາຄານ'),
      body: Obx(() {
        final st = _logic.state;
        final wallet = st.wallet;
        final minWithdraw = wallet?.minimumWithdrawal ?? 0;
        final maxWithdraw = wallet?.withdrawableBalance ?? 0;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Balance info card ────────────────────────
                    if (wallet != null)
                      _BalanceInfoCard(
                        wallet: wallet,
                        onTapAll: wallet.canWithdraw == true
                            ? () => _amountCtrl.text =
                                  (wallet.withdrawableBalance ?? 0).toString()
                            : null,
                      ),
                    if (wallet != null) SizedBox(height: 16.h),

                    // ── Section: Bank accounts ───────────────────
                    Text(
                      'ເລືອກບັນຊີທະນາຄານ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryVariant,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    if (st.loadingBanks && st.bankAccounts.isEmpty)
                      const BankAccountListShimmer()
                    else if (st.bankAccounts.isEmpty)
                      _EmptyBankState()
                    else
                      SizedBox(
                        height: 196.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: st.bankAccounts.length,
                          separatorBuilder: (_, __) => SizedBox(width: 10.w),
                          itemBuilder: (_, i) {
                            final bank = st.bankAccounts[i];
                            final isSelected = _selectedBankId == bank.id;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedBankId = bank.id),
                              child: _BankCard(
                                bank: bank,
                                isSelected: isSelected,
                              ),
                            );
                          },
                        ),
                      ),

                    SizedBox(height: 20.h),

                    // ── Section: Amount input ────────────────────
                    Text(
                      'ຈໍານວນເງິນ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryVariant,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AppTextField(
                      controller: _amountCtrl,
                      focusNode: _amountFocus,
                      hint: 'ປ້ອນຈໍານວນ',
                      prefixIcon: Icons.attach_money_rounded,
                      suffixLabel: 'ກີບ',
                      keyboardType: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      accent: AppColors.primary,
                    ),
                    SizedBox(height: 8.h),

                    // ── Min / Max hints ──────────────────────────
                    Row(
                      children: [
                        _HintChip(
                          icon: Icons.arrow_downward_rounded,
                          label: 'ຕ່ຳສຸດ',
                          value: _fmtKip(minWithdraw),
                          color: AppColors.online,
                        ),
                        SizedBox(width: 8.w),
                        _HintChip(
                          icon: Icons.arrow_upward_rounded,
                          label: 'ສູງສຸດ',
                          value: _fmtKip(maxWithdraw),
                          color: AppColors.primary,
                        ),
                      ],
                    ),

                    // ── Validation message ───────────────────────
                    if (_amount > 0 && _amount < minWithdraw) ...[
                      SizedBox(height: 8.h),
                      _ValidationMsg(
                        'ຈໍານວນຕ່ຳກວ່າຂີດຈໍາກັດ (${_fmtKip(minWithdraw)})',
                      ),
                    ] else if (_amount > maxWithdraw && maxWithdraw > 0) ...[
                      SizedBox(height: 8.h),
                      _ValidationMsg(
                        'ເກີນຍອດທີ່ສາມາດຖອນໄດ້ (${_fmtKip(maxWithdraw)})',
                      ),
                    ],

                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),

            // ── Submit button ────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              child: AppPrimaryButton(
                label: 'ຢືນຢັນການຖອນ',
                enabled: _canSubmit(minWithdraw, maxWithdraw),
                onTap: _submit,
                trailingIcon: Icons.arrow_forward_ios_rounded,
              ),
            ),
          ],
        );
      }),
    );
  }
}

String _fmtKip(int? n) => '${NumberFormat.decimalPattern().format(n ?? 0)} ກີບ';

// ── Balance info card ─────────────────────────────────────────────
class _BalanceInfoCard extends StatelessWidget {
  final dynamic wallet;
  final VoidCallback? onTapAll;
  const _BalanceInfoCard({required this.wallet, this.onTapAll});

  @override
  Widget build(BuildContext context) {
    final canWithdraw = wallet.canWithdraw == true;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.socialBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 18.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ຍອດທີ່ຖອນໄດ້',
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                ),
                SizedBox(height: 2.h),
                Text(
                  _fmtKip(wallet.withdrawableBalance as int?),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          if (canWithdraw)
            GestureDetector(
              onTap: onTapAll,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.pinkGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_downward_rounded,
                      size: 11.r,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'ຖອນທັງໝົດ',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'ຖອນບໍ່ໄດ້',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFDC2626),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Selectable bank card ───────────────────────────────────────────
class _BankCard extends StatelessWidget {
  final BankAccountModel bank;
  final bool isSelected;
  const _BankCard({required this.bank, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 150.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 0.8,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: bank.qrCode != null && bank.qrCode!.isNotEmpty
                    ? Image.network(
                        bank.qrCode!,
                        width: 100.r,
                        height: 100.r,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _QrPlaceholder(),
                      )
                    : _QrPlaceholder(),
              ),
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 12.r,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            bank.bankAccountName ?? '-',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          if (bank.isDefault == true) ...[
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.socialBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'ບັນຊີຫຼັກ',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.r,
      height: 100.r,
      color: AppColors.surfaceSecondary,
      child: Icon(
        Icons.qr_code_2_rounded,
        size: 40.r,
        color: AppColors.textDisabled,
      ),
    );
  }
}

// ── Empty bank state ──────────────────────────────────────────────
class _EmptyBankState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 32.r,
            color: AppColors.textDisabled,
          ),
          SizedBox(height: 8.h),
          Text(
            'ຍັງບໍ່ມີບັນຊີທະນາຄານ',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ── Hint chip ─────────────────────────────────────────────────────
class _HintChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _HintChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13.r, color: color),
            SizedBox(width: 5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: color.withValues(alpha: 0.75),
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Validation message ────────────────────────────────────────────
class _ValidationMsg extends StatelessWidget {
  final String message;
  const _ValidationMsg(this.message);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: 13.r,
          color: const Color(0xFFDC2626),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            message,
            style: TextStyle(fontSize: 11.sp, color: const Color(0xFFDC2626)),
          ),
        ),
      ],
    );
  }
}
