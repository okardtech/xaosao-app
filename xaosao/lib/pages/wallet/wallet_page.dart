import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../topup/topup_amount.dart';
import 'wallet_model.dart';

// ═══════════════════════════════════════════════════════════════
//  WalletPage
//
//  Layout (CustomScrollView):
//    SliverToBoxAdapter → header
//    SliverToBoxAdapter → WalletCard (pink gradient)
//    SliverPersistentHeader (pinned) → filter chips
//    SliverList → transaction cards
// ═══════════════════════════════════════════════════════════════
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool _amountsVisible = true;
  TransactionStatus? _filter; // null = ທັງໝົດ

  static const _chips = <(String, TransactionStatus?)>[
    ('ທັງໝົດ', null),
    ('ສຳເລັດ', TransactionStatus.completed),
    ('ລໍຖ້າ', TransactionStatus.pending),
    ('ດຳເນີນການ', TransactionStatus.processing),
    ('ຍົກເລີກ', TransactionStatus.cancelled),
  ];

  List<TransactionModel> get _filtered => _filter == null
      ? mockTransactions
      : mockTransactions.where((t) => t.status == _filter).toList();

  int _count(TransactionStatus? s) => s == null
      ? mockTransactions.length
      : mockTransactions.where((t) => t.status == s).length;

  void _toggleVisibility() =>
      setState(() => _amountsVisible = !_amountsVisible);

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

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ────────────────────────────────────────
            SliverToBoxAdapter(child: _buildHeader()),
            // ── Wallet card ───────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                child: _WalletCard(
                  wallet: mockWallet,
                  amountsVisible: _amountsVisible,
                  onToggleVisibility: _toggleVisibility,
                  onTopUp: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TopUpAmountPage()),
                    );
                  },
                ),
              ),
            ),

            // ── Section label ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                child: Text(
                  'ປະຫວັດການເຕີມ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ),

            // ── Filter chips (pinned) ─────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _ChipsDelegate(
                filter: _filter,
                chips: _chips,
                countFor: _count,
                onSelect: (s) => setState(() => _filter = s),
                height: 42,
              ),
            ),

            // ── Empty ─────────────────────────────────────────
            if (_filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'ບໍ່ມີລາຍການ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ),
              ),

            // ── Transaction cards ─────────────────────────────
            if (_filtered.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16, 16.w, 32.h),
                sliver: SliverList.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (_, i) => _TransactionCard(tx: _filtered[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11.r),
                border: Border.all(
                  color: Colors.black.withOpacity(0.08),
                  width: 0.5,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14.r,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ກະເປົ໋າເງິນ',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              Text(
                'ຍອດ ແລະ ປະຫວັດ',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF9B9BAD),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _WalletCard — pink gradient card
// ═══════════════════════════════════════════════════════════════
class _WalletCard extends StatelessWidget {
  final WalletModel wallet;
  final bool amountsVisible;
  final VoidCallback onToggleVisibility;
  final VoidCallback onTopUp;

  const _WalletCard({
    required this.wallet,
    required this.amountsVisible,
    required this.onToggleVisibility,
    required this.onTopUp,
  });

  String _mask(String v) => '••••••';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF06292), Color(0xFFFF8A80)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF06292).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -22,
            right: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -32,
            left: -12,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: label + Eye icon top right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ກະເປົ໋າເງິນ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.55),
                        letterSpacing: 0.3,
                      ),
                    ),
                    // Eye toggle button
                    GestureDetector(
                      onTap: onToggleVisibility,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 30.r,
                        height: 30.r,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(9.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.22),
                            width: 0.5,
                          ),
                        ),
                        child: Icon(
                          amountsVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 14.r,
                          color: Colors.white.withOpacity(0.90),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 10.h),

                // Balance amount
                Text(
                  'ຍອດຄົງເຫຼືອ, ອັບເດດລ່າສຸດ ${DateFormat("HH:mm").format(DateTime.now())}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.45),
                  ),
                ),
                SizedBox(height: 3.h),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    amountsVisible
                        ? wallet.formattedBalance
                        : _mask(wallet.formattedBalance),
                    key: ValueKey(amountsVisible),
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.8,
                      height: 1,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                // 2 stat pills
                Row(
                  children: [
                    Expanded(
                      child: _StatPill(
                        label: 'ເຕີມທັງໝົດ',
                        value: amountsVisible
                            ? wallet.formattedTotalTopUp
                            : _mask(wallet.formattedTotalTopUp),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _StatPill(
                        label: 'ໃຊ້ໄປແລ້ວ',
                        value: amountsVisible
                            ? wallet.formattedTotalUsed
                            : _mask(wallet.formattedTotalUsed),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Top-up button full width
                GestureDetector(
                  onTap: onTopUp,
                  child: Container(
                    width: double.infinity,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.22),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 16.r,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'ເຕີມເງິນ',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat pill inside wallet card ───────────────────────────────
class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              color: Colors.white.withOpacity(0.50),
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 3.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              value,
              key: ValueKey(value),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ChipsDelegate — pinned filter chips
// ═══════════════════════════════════════════════════════════════
class _ChipsDelegate extends SliverPersistentHeaderDelegate {
  final TransactionStatus? filter;
  final List<(String, TransactionStatus?)> chips;
  final int Function(TransactionStatus?) countFor;
  final ValueChanged<TransactionStatus?> onSelect;
  final double height;

  const _ChipsDelegate({
    required this.filter,
    required this.chips,
    required this.countFor,
    required this.onSelect,
    required this.height,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(_ChipsDelegate old) => old.filter != filter;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: height,
      color: const Color(0xFFF8F8FC),
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: chips.length,
        separatorBuilder: (_, _) => SizedBox(width: 6.w),
        itemBuilder: (_, i) {
          final (label, status) = chips[i];
          final isOn = filter == status;
          final count = countFor(status);
          return GestureDetector(
            onTap: () => onSelect(status),
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isOn ? const Color(0xFF1A1A2E) : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isOn
                      ? const Color(0xFF1A1A2E)
                      : Colors.black.withOpacity(0.09),
                  width: 0.5,
                ),
              ),
              child: Text(
                '$label ($count)',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: isOn ? Colors.white : const Color(0xFF9B9BAD),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _TransactionCard
// ═══════════════════════════════════════════════════════════════
class _TransactionCard extends StatelessWidget {
  final TransactionModel tx;
  const _TransactionCard({required this.tx});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: tx.status.cardOpacity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: tx.status.iconBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                tx.status.icon,
                size: 16.r,
                color: tx.status.iconColor,
              ),
            ),
            SizedBox(width: 11.w),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    tx.formattedDate,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ],
              ),
            ),

            // Amount + badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tx.status == TransactionStatus.cancelled
                      ? tx.formattedAmount
                      : tx.formattedAmount,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: tx.status.iconColor,
                    decoration: tx.status == TransactionStatus.cancelled
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: const Color(0xFF9B9BAD),
                  ),
                ),
                SizedBox(height: 3.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: tx.status.badgeBg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    tx.status.label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: tx.status.badgeFg,
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
