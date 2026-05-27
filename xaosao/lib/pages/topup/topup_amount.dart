import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/topup/components/topup_constant.dart';
import 'package:xaosao/pages/topup/getx/topup_logic.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_text_field.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class TopUpAmountPage extends StatefulWidget {
  final int? initialAmount;
  final String? subscriptionPlanId;
  const TopUpAmountPage({super.key, this.initialAmount, this.subscriptionPlanId});

  @override
  State<TopUpAmountPage> createState() => _TopUpAmountPageState();
}

class _TopUpAmountPageState extends State<TopUpAmountPage> {
  static const _presets = [10000, 50000, 100000, 200000, 500000];

  int? _selected;
  bool _custom = false;
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  late final TopupLogic _logic;

  int get _amount {
    if (_custom) return int.tryParse(_ctrl.text.replaceAll(',', '')) ?? 0;
    return _selected ?? 0;
  }

  void _pick(int v) {
    setState(() {
      _selected = v;
      _custom = false;
      _ctrl.text = fmtNum(v);
    });
    _focus.unfocus();
  }

  void _next() {
    if (_amount < 10000) return;
    _logic.setAmount(_amount);
    Get.toNamed(AppRoutes.topupQr);
  }

  @override
  void initState() {
    super.initState();
    _logic = Get.find<TopupLogic>();
    _logic.resetFlow();
    final amt = widget.initialAmount;
    final planId = widget.subscriptionPlanId;
    if (amt != null && amt > 0) {
      _selected = amt;
      _ctrl.text = fmtNum(amt);
    }
    if (planId != null && planId.isNotEmpty) {
      _logic.setSubscriptionContext(planId: planId, amount: amt ?? 0);
    }
    _focus.addListener(() {
      if (_focus.hasFocus && mounted) {
        setState(() {
          _custom = true;
          _selected = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ເຕີມເງິນ',
        subtitle: 'ເລືອກ ຫຼື ປ້ອນຈຳນວນ',
        actions: [const TopUpStepBadge('1')],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    // ── Preset chips ────────────────────────────
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        ..._presets.map(
                          (v) => _PresetChip(
                            label: fmtNum(v),
                            sub: 'ກີບ',
                            selected: !_custom && _selected == v,
                            onTap: () => _pick(v),
                          ),
                        ),
                        _PresetChip(
                          label: 'ອື່ນໆ',
                          sub: 'ກຳນົດເອງ',
                          selected: _custom,
                          onTap: () {
                            setState(() {
                              _custom = true;
                              _selected = null;
                            });
                            _focus.requestFocus();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    _TopUpDivider(label: 'ຫຼື ປ້ອນເອງ'),
                    SizedBox(height: 10.h),

                    // ── Amount input ─────────────────────────────
                    AppTextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      hint: 'ປ້ອນຈຳນວນ',
                      accent: AppColors.primary,
                      prefixIcon: Icons.attach_money_rounded,
                      suffixLabel: 'ກີບ',
                      keyboardType: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      action: TextInputAction.done,
                      onChanged: (_) => setState(() {
                        _custom = true;
                        _selected = null;
                      }),
                    ),
                    SizedBox(height: 20.h),

                    // ── CTA ──────────────────────────────────────
                    AppPrimaryButton(
                      label: 'ຕໍ່ໄປ',
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                      enabled: _amount >= 10000,
                      onTap: _next,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Preset chip ────────────────────────────────────────────────
class _PresetChip extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  const _PresetChip({
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: selected ? AppColors.socialBg : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Colors.black.withValues(alpha: 0.08),
            width: selected ? 1 : 0.5,
          ),
        ),
        child: Text(
          '$label $sub',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ── Labelled divider ───────────────────────────────────────────
class _TopUpDivider extends StatelessWidget {
  final String label;
  const _TopUpDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 0.5,
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
          ),
        ),
        Expanded(
          child: Container(
            height: 0.5,
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}
