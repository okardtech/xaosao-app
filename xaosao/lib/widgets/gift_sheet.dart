import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/models/gift_model.dart';
import 'package:xaosao/repository/gift_repo.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/app_network_image.dart';

// ═══════════════════════════════════════════════════════════════
//  gift_sheet.dart
//  Modal bottom sheet ສ່ງຂອງຂວັນ — ໂຫຼດລາຍການຈາກ API,
//  ເລືອກ 1 ອັນ, ສ່ງຜ່ານ giveGift endpoint
//
//  ໃຊ້ງານ:
//    GiftSheet.show(
//      context,
//      postId: post.id!,
//      companionName: 'ນາລີ',
//      balanceKip: walletBalance,
//      onSent: (gift) => GiftSentSnackbar.show(context, gift: gift),
//    );
// ═══════════════════════════════════════════════════════════════

// ── Price formatter ────────────────────────────────────────────
String _fmtKip(double? price) {
  if (price == null) return '0 ກີບ';
  final n = price.toInt();
  final s = n.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '${b.toString()} ກີບ';
}

// ═══════════════════════════════════════════════════════════════
//  GiftSheet — static entry point
// ═══════════════════════════════════════════════════════════════
class GiftSheet {
  GiftSheet._();

  static Future<void> show(
    BuildContext context, {
    required String postId,
    required String companionName,
    required int balanceKip,
    void Function(GiftModel)? onSent,
    VoidCallback? onTopUp,
  }) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => _GiftSheetContent(
        postId: postId,
        companionName: companionName,
        balanceKip: balanceKip,
        onSent: onSent,
        onTopUp: onTopUp,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _GiftSheetContent
// ═══════════════════════════════════════════════════════════════
class _GiftSheetContent extends StatefulWidget {
  final String postId;
  final String companionName;
  final int balanceKip;
  final void Function(GiftModel)? onSent;
  final VoidCallback? onTopUp;

  const _GiftSheetContent({
    required this.postId,
    required this.companionName,
    required this.balanceKip,
    this.onSent,
    this.onTopUp,
  });

  @override
  State<_GiftSheetContent> createState() => _GiftSheetContentState();
}

class _GiftSheetContentState extends State<_GiftSheetContent> {
  final _repo = GiftRepo();

  List<GiftModel> _gifts = [];
  bool _loadingGifts = true;
  GiftModel? _selected;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _loadGifts();
  }

  // ── Load gifts from API ───────────────────────────────────
  Future<void> _loadGifts() async {
    final res = await _repo.getGifts();
    if (!mounted) return;
    setState(() {
      _gifts = (res.success ? res.data : null) ?? [];
      _loadingGifts = false;
    });
  }

  String _fmt(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return '${b.toString()} ກີບ';
  }

  // ── Send gift via API ─────────────────────────────────────
  Future<void> _send() async {
    final gift = _selected;
    if (gift == null || gift.id == null || _sending) return;
    HapticFeedback.heavyImpact();

    setState(() => _sending = true);
    try {
      final res = await _repo.giveGift(
        postId: widget.postId,
        giftId: gift.id!,
      );
      if (!mounted) return;
      if (res.success) {
        Navigator.pop(context);
        widget.onSent?.call(gift);
      } else {
        AppSnackbar.error(res.laMessage ?? 'ສ່ງຂອງຂວັນບໍ່ສຳເລັດ');
      }
    } catch (_) {
      if (mounted) AppSnackbar.error('ສ່ງຂອງຂວັນບໍ່ສຳເລັດ');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
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
              color: Colors.black.withValues(alpha: 0.12),
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
                // Close
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30.r,
                    height: 30.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8FC),
                      borderRadius: BorderRadius.circular(9.r),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.08),
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
              ),
              child: Row(
                children: [
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
                          color: const Color(0xFFF06292).withValues(alpha: 0.25),
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
            child: _loadingGifts
                ? _GiftGridShimmer()
                : _gifts.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: Text(
                            'ບໍ່ມີຂອງຂວັນໃນຂະນະນີ້',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF9B9BAD),
                            ),
                          ),
                        ),
                      )
                    : _GiftGrid(
                        gifts: _gifts,
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
//  _GiftGrid — 3-col grid with network images
// ═══════════════════════════════════════════════════════════════
class _GiftGrid extends StatelessWidget {
  final List<GiftModel> gifts;
  final GiftModel? selected;
  final void Function(GiftModel) onSelect;

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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
      ),
      itemBuilder: (_, i) {
        final gift = gifts[i];
        final isSelected = selected?.id == gift.id;
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
                        color: Colors.black.withValues(alpha: 0.06),
                        width: 0.5,
                      )
                    : BorderSide.none,
                bottom: isBottom
                    ? BorderSide(
                        color: Colors.black.withValues(alpha: 0.06),
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
                      // Gift image from API
                      AnimatedScale(
                        scale: isSelected ? 1.12 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: AppNetworkImage(
                            imageUrl: gift.image ?? '',
                            width: 40.r,
                            height: 40.r,
                            fit: BoxFit.cover,
                            accentColor: const Color(0xFFF06292),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        gift.name ?? '',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _fmtKip(gift.price),
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
                // Selection checkmark
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
//  _GiftGridShimmer — loading skeleton for the gift grid
// ═══════════════════════════════════════════════════════════════
class _GiftGridShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEEE),
      highlightColor: const Color(0xFFF8F8FC),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (_, i) => Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _SendButton
// ═══════════════════════════════════════════════════════════════
class _SendButton extends StatelessWidget {
  final GiftModel? selected;
  final bool sending;
  final VoidCallback onTap;

  const _SendButton({
    required this.selected,
    required this.sending,
    required this.onTap,
  });

  bool get _active => selected != null && !sending;

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
                    color: const Color(0xFFF06292).withValues(alpha: 0.30),
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded,
                            size: 15.r, color: Colors.white),
                        SizedBox(width: 7.w),
                        Text(
                          'ສົ່ງ ${selected!.name ?? ''} · ${_fmtKip(selected!.price)}',
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
// ═══════════════════════════════════════════════════════════════
class GiftSentSnackbar {
  GiftSentSnackbar._();

  static void show(BuildContext context, {required GiftModel gift}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            // Gift image thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: AppNetworkImage(
                imageUrl: gift.image ?? '',
                width: 36.r,
                height: 36.r,
                fit: BoxFit.cover,
                accentColor: const Color(0xFFF06292),
              ),
            ),
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
                    '${gift.name ?? ''} · ${_fmtKip(gift.price)}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white.withValues(alpha: 0.60),
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
              child: Icon(
                Icons.check_rounded,
                size: 12.r,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
