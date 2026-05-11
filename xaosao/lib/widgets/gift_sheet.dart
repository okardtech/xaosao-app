import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ═══════════════════════════════════════════════════════════════
//  gift_sheet.dart
//  Modal bottom sheet ສ່ງຂອງຂວັນ — ເລືອກ 1 ອັນ, ສ່ງທັນທີ
//
//  ໃຊ້ງານ:
//    GiftSheet.show(
//      context,
//      companionName: 'ນາລີ',
//      balanceKip: 125000,
//      onSent: (gift) {
//        // handle success
//      },
//    );
// ═══════════════════════════════════════════════════════════════

// ── Gift model ─────────────────────────────────────────────────
class GiftItem {
  final String id;
  final String emoji;
  final String name;
  final int priceKip;

  const GiftItem({
    required this.id,
    required this.emoji,
    required this.name,
    required this.priceKip,
  });

  String get formattedPrice {
    final s = priceKip.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return '${b.toString()} ກີບ';
  }
}

// ── Default gift catalogue ─────────────────────────────────────
const _defaultGifts = [
  GiftItem(id: 'glasses', emoji: '🕶️', name: 'ແວ່ນຕາ', priceKip: 2000),
  GiftItem(id: 'lipstick', emoji: '💄', name: 'ລິບສະຕິກ', priceKip: 5000),
  GiftItem(id: 'flower', emoji: '🌸', name: 'ດອກໄມ້', priceKip: 15000),
  GiftItem(id: 'mushroom', emoji: '🍄', name: 'ເຫັດ', priceKip: 20000),
  GiftItem(id: 'outfit', emoji: '👙', name: 'ຊຸດ', priceKip: 25000),
  GiftItem(id: 'diamond', emoji: '💎', name: 'ໄພລິນ', priceKip: 50000),
];

// ═══════════════════════════════════════════════════════════════
//  GiftSheet — static helper to show the sheet
// ═══════════════════════════════════════════════════════════════
class GiftSheet {
  GiftSheet._();

  static Future<void> show(
    BuildContext context, {
    required String companionName,
    required int balanceKip,
    List<GiftItem>? gifts,
    void Function(GiftItem)? onSent,
    VoidCallback? onTopUp,
  }) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _GiftSheetContent(
        companionName: companionName,
        balanceKip: balanceKip,
        gifts: gifts ?? _defaultGifts,
        onSent: onSent,
        onTopUp: onTopUp,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _GiftSheetContent — StatefulWidget (content of the sheet)
// ═══════════════════════════════════════════════════════════════
class _GiftSheetContent extends StatefulWidget {
  final String companionName;
  final int balanceKip;
  final List<GiftItem> gifts;
  final void Function(GiftItem)? onSent;
  final VoidCallback? onTopUp;

  const _GiftSheetContent({
    required this.companionName,
    required this.balanceKip,
    required this.gifts,
    this.onSent,
    this.onTopUp,
  });

  @override
  State<_GiftSheetContent> createState() => _GiftSheetContentState();
}

class _GiftSheetContentState extends State<_GiftSheetContent> {
  GiftItem? _selected;
  bool _sending = false;

  bool get _canAfford =>
      _selected != null && _selected!.priceKip <= widget.balanceKip;

  String _fmt(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return '${b.toString()} ກີບ';
  }

  Future<void> _send() async {
    if (_selected == null || !_canAfford || _sending) return;
    HapticFeedback.heavyImpact();
    setState(() => _sending = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _sending = false);
    Navigator.pop(context);
    widget.onSent?.call(_selected!);
    // TODO: call API to send gift
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ─────────────────────────────────
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.12),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 12.h),

          // ── Header ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🎁 ສົ່ງຂອງຂວັນ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF9B9BAD),
                          ),
                          children: [
                            const TextSpan(text: 'ເລືອກຂອງຂວັນໃຫ້ '),
                            TextSpan(
                              text: widget.companionName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Close button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30.r,
                    height: 30.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8FC),
                      borderRadius: BorderRadius.circular(9.r),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.08),
                        width: 0.5,
                      ),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 14.r,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // ── Balance pill ─────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FC),
                borderRadius: BorderRadius.circular(11.r),
                // border: Border.all(
                //     color: Colors.black.withOpacity(0.07), width: 0.5),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF06292), Color(0xFFFF8A80)],
                      ),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 12.r,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ຍອດກະເປົ໋າ',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xFF9B9BAD),
                        ),
                      ),
                      Text(
                        _fmt(widget.balanceKip),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onTopUp?.call();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F6),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFF06292).withOpacity(0.25),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        '+ ເຕີມເງິນ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF06292),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // ── Gift grid ────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _GiftGrid(
              gifts: widget.gifts,
              selected: _selected,
              onSelect: (g) => setState(() => _selected = g),
            ),
          ),
          SizedBox(height: 12.h),

          // ── Send button ──────────────────────────────────
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
            ),
            child: _SendButton(
              selected: _selected,
              canAfford: _canAfford,
              sending: _sending,
              onTap: _send,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _GiftGrid — 3-col grid of gift cells
// ═══════════════════════════════════════════════════════════════
class _GiftGrid extends StatelessWidget {
  final List<GiftItem> gifts;
  final GiftItem? selected;
  final void Function(GiftItem) onSelect;

  const _GiftGrid({
    required this.gifts,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: gifts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
      ),
      itemBuilder: (_, i) {
        final gift = gifts[i];
        final isSelected = selected?.id == gift.id;
        // border positions
        final isRight = i % 3 != 2;
        final isBottom = i < gifts.length - 3;

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onSelect(gift);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFF0F6) : Colors.white,
              border: Border(
                right: isRight
                    ? BorderSide(
                        color: Colors.black.withOpacity(0.06),
                        width: 0.5,
                      )
                    : BorderSide.none,
                bottom: isBottom
                    ? BorderSide(
                        color: Colors.black.withOpacity(0.06),
                        width: 0.5,
                      )
                    : BorderSide.none,
              ),
            ),
            child: Stack(
              children: [
                // Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: isSelected ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          gift.emoji,
                          style: TextStyle(fontSize: 28.sp),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        gift.name,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        gift.formattedPrice,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFFF06292)
                              : const Color(0xFF9B9BAD),
                        ),
                      ),
                    ],
                  ),
                ),
                // Checkmark
                if (isSelected)
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      width: 18.r,
                      height: 18.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF06292),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 11.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _SendButton
// ═══════════════════════════════════════════════════════════════
class _SendButton extends StatelessWidget {
  final GiftItem? selected;
  final bool canAfford;
  final bool sending;
  final VoidCallback onTap;

  const _SendButton({
    required this.selected,
    required this.canAfford,
    required this.sending,
    required this.onTap,
  });

  bool get _active => selected != null && canAfford && !sending;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _active ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: _active
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF06292), Color(0xFFFF8A80)],
                )
              : null,
          color: _active ? null : const Color(0xFFE8E8F0),
          boxShadow: _active
              ? [
                  BoxShadow(
                    color: const Color(0xFFF06292).withOpacity(0.30),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: sending
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : selected == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.card_giftcard_rounded,
                      size: 16.r,
                      color: const Color(0xFFB0B0C0),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'ເລືອກຂອງຂວັນກ່ອນ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB0B0C0),
                      ),
                    ),
                  ],
                )
              : !canAfford
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 15.r,
                      color: const Color(0xFFB0B0C0),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'ຍອດບໍ່ພໍ — ເຕີມເງິນ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB0B0C0),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_rounded, size: 15.r, color: Colors.white),
                    SizedBox(width: 7.w),
                    Text(
                      'ສົ່ງ ${selected!.name} ${selected!.emoji}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  GiftSentSnackbar — ສະແດງຫຼັງສ່ງສຳເລັດ
//  ໃຊ້: GiftSentSnackbar.show(context, gift: gift)
// ═══════════════════════════════════════════════════════════════
class GiftSentSnackbar {
  GiftSentSnackbar._();

  static void show(BuildContext context, {required GiftItem gift}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Text(gift.emoji, style: TextStyle(fontSize: 20.sp)),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ສ່ງຂອງຂວັນສຳເລັດ!',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${gift.name} · ${gift.formattedPrice}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white.withOpacity(0.60),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20.r,
              height: 20.r,
              decoration: const BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded, size: 12.r, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
