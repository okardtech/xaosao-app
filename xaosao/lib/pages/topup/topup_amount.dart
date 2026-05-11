import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/topup/components/topup_constant.dart';
import 'package:xaosao/pages/topup/components/topup_qr.dart';

// ═══════════════════════════════════════════════════════════════
//  topup_amount_page.dart — Page 1: ປ້ອນຈຳນວນເງິນ
//  Entry point for the top-up flow.
//  Navigate in: Navigator.push(context,
//    MaterialPageRoute(builder: (_) => const TopUpAmountPage()))
// ═══════════════════════════════════════════════════════════════
class TopUpAmountPage extends StatefulWidget {
  const TopUpAmountPage({super.key});

  @override
  State<TopUpAmountPage> createState() => _TopUpAmountPageState();
}

class _TopUpAmountPageState extends State<TopUpAmountPage> {
  static const _presets = [10000, 50000, 100000, 200000, 500000];

  int? _selected;
  bool _custom = false;
  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  // ── derived ────────────────────────────────────────────────
  int get _amount {
    if (_custom) {
      return int.tryParse(_ctrl.text.replaceAll(',', '')) ?? 0;
    }
    return _selected ?? 0;
  }

  // ── handlers ───────────────────────────────────────────────
  void _pick(int v) {
    setState(() {
      _selected = v;
      _custom = false;
      _ctrl.text = fmtNum(v);
    });
    _focus.unfocus();
  }

  void _toCustom() {
    setState(() {
      _custom = true;
      _selected = null;
    });
    _focus.requestFocus();
  }

  void _next() {
    if (_amount < 10000) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TopUpQRPage(amountKip: _amount)),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: TopUpGradientAppBar(
        title: 'ເຕີມເງິນ',
        sub: 'ເລືອກ ຫຼື ປ້ອນຈຳນວນ',
        step: '1',
        onBack: () => Navigator.pop(context),
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
                    // ── Preset chips ────────────────────────
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        ..._presets.map(
                          (v) => PresetChip(
                            label: fmtNum(v),
                            sub: 'ກີບ',
                            selected: !_custom && _selected == v,
                            onTap: () => _pick(v),
                          ),
                        ),
                        PresetChip(
                          label: 'ອື່ນໆ',
                          sub: 'ກຳນົດເອງ',
                          selected: _custom,
                          onTap: _toCustom,
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    TopUpDivider(label: 'ຫຼື ປ້ອນເອງ'),
                    SizedBox(height: 10.h),

                    // ── Manual input ────────────────────────
                    AmountTextInput(
                      ctrl: _ctrl,
                      focus: _focus,
                      isFocused: _custom,
                      onChanged: (_) => setState(() {
                        _custom = true;
                        _selected = null;
                      }),
                      onTap: _toCustom,
                    ),
                    SizedBox(height: 20.h),

                    // ── CTA ─────────────────────────────────
                    TopUpPinkBtn(
                      label: 'ຕໍ່ໄປ',
                      icon: Icons.arrow_forward_ios_rounded,
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

// ═══════════════════════════════════════════════════════════════
//  AmountDisplayCard — large number display at top
// ═══════════════════════════════════════════════════════════════
class AmountDisplayCard extends StatelessWidget {
  final int amount;
  final bool isCustom;

  const AmountDisplayCard({
    super.key,
    required this.amount,
    required this.isCustom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ຈຳນວນເງິນ',
            style: TextStyle(fontSize: 10.sp, color: kHint),
          ),
          SizedBox(height: 5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                amount > 0 ? fmtNum(amount) : '0',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: kNavy,
                  letterSpacing: -0.8,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'ກີບ',
                style: TextStyle(fontSize: 13.sp, color: kHint),
              ),
              if (isCustom) ...[SizedBox(width: 3.w), const _BlinkingCursor()],
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PresetChip — quick amount selector chip
// ═══════════════════════════════════════════════════════════════
class PresetChip extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  const PresetChip({
    super.key,
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
          color: selected ? const Color(0xFFFFF0F6) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? kPink : Colors.black.withOpacity(0.08),
            width: selected ? 1 : 0.5,
          ),
        ),
        child: Text(
          '$label $sub',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: selected ? kPink : kNavy,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  AmountTextInput — manual number input field
// ═══════════════════════════════════════════════════════════════
class AmountTextInput extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final bool isFocused;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;

  const AmountTextInput({
    super.key,
    required this.ctrl,
    required this.focus,
    required this.isFocused,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isFocused ? kPink : Colors.black.withOpacity(0.08),
          width: isFocused ? 1 : 0.5,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Icon(
              Icons.attach_money_rounded,
              size: 16.r,
              color: const Color(0xFFC4C4D0),
            ),
          ),
          Expanded(
            child: TextField(
              controller: ctrl,
              focusNode: focus,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onTap: onTap,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'ປ້ອນຈຳນວນ',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFC4C4D0),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              style: TextStyle(fontSize: 14.sp, color: kNavy),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'ກີບ',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFFC4C4D0)),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  TopUpDivider — labelled horizontal divider
// ═══════════════════════════════════════════════════════════════
class TopUpDivider extends StatelessWidget {
  final String label;
  const TopUpDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 0.5, color: Colors.black.withOpacity(0.08)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: const Color(0xFFC4C4D0)),
          ),
        ),
        Expanded(
          child: Container(height: 0.5, color: Colors.black.withOpacity(0.08)),
        ),
      ],
    );
  }
}

// ── Blinking cursor (private) ──────────────────────────────────
class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _visible = !_visible);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 80),
      child: Container(
        width: 2.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: kPink,
          borderRadius: BorderRadius.circular(1.r),
        ),
      ),
    );
  }
}
