import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/package/components/package_history_model.dart';

// ═══════════════════════════════════════════════════════════════
//  PackageHistoryPage — ປະຫວັດການຊື້ Package  (v3 redesign)
//
//  Layout per card:
//    Row(accent bar | inner)
//      inner:
//        r1 → pkg name + badge
//        r2 → meta pills (ວັນທີ + ໄລຍະ)
//        r3 → price row
//        note / expiry
// ═══════════════════════════════════════════════════════════════
class PackageHistoryPage extends StatefulWidget {
  const PackageHistoryPage({super.key});

  @override
  State<PackageHistoryPage> createState() => _PackageHistoryPageState();
}

class _PackageHistoryPageState extends State<PackageHistoryPage> {
  PurchaseStatus? _filter;

  int _count(PurchaseStatus? s) => s == null
      ? mockPurchases.length
      : mockPurchases.where((p) => p.status == s).length;

  List<PurchaseModel> get _filtered => _filter == null
      ? mockPurchases
      : mockPurchases.where((p) => p.status == _filter).toList();

  static const _chips = <(String, PurchaseStatus?)>[
    ('ທັງໝົດ',   null),
    ('ລໍຖ້າ',    PurchaseStatus.pending),
    ('ສຳເລັດ',   PurchaseStatus.approved),
    ('ປະຕິເສດ', PurchaseStatus.rejected),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(children: [
          _buildHeader(),
          _buildFilterChips(),
          Expanded(child: _buildList()),
        ]),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36.r, height: 36.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11.r),
              border: Border.all(
                  color: Colors.black.withOpacity(0.08), width: 0.5),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 14.r, color: const Color(0xFF1A1A2E)),
          ),
        ),
        SizedBox(width: 12.w),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ປະຫວັດ Package',
              style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1A1A2E),
                  letterSpacing: -0.3)),
          SizedBox(height: 2.h),
          Text('ລາຍການຊື້ທັງໝົດ',
              style: TextStyle(
                  fontSize: 11.sp, color: const Color(0xFF9B9BAD))),
        ]),
      ]),
    );
  }

  // ── Filter chips ────────────────────────────────────────────
  Widget _buildFilterChips() {
    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
        itemCount: _chips.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (_, i) {
          final (label, status) = _chips[i];
          final isOn = _filter == status;
          return GestureDetector(
            onTap: () => setState(() => _filter = status),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
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
                '$label (${_count(status)})',
                style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: isOn ? Colors.white : const Color(0xFF9B9BAD)),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── List ────────────────────────────────────────────────────
  Widget _buildList() {
    final list = _filtered;
    if (list.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.receipt_long_outlined,
              size: 48.r, color: const Color(0xFFD1D1E0)),
          SizedBox(height: 12.h),
          Text('ບໍ່ມີລາຍການ',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9B9BAD))),
        ]),
      );
    }
    print('filtered list length: ${list.length}');
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      itemCount: list.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (_, i) => _PurchaseCard(purchase: list[i]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _PurchaseCard — v3 redesign
//  Row(accent 4px | inner column)
//  ບໍ່ມີ dividers ພາຍໃນ
//  Meta pills ສຳລັບ ວັນທີ + ໄລຍະ
// ═══════════════════════════════════════════════════════════════
class _PurchaseCard extends StatelessWidget {
  final PurchaseModel purchase;
  const _PurchaseCard({required this.purchase});

  // ── Status colors ─────────────────────────────────────────
  static Color _accent(PurchaseStatus s) => switch (s) {
        PurchaseStatus.pending  => const Color(0xFFBA7517),
        PurchaseStatus.approved => const Color(0xFF3B6D11),
        PurchaseStatus.rejected => const Color(0xFFA32D2D),
      };

  static Color _badgeBg(PurchaseStatus s) => switch (s) {
        PurchaseStatus.pending  => const Color(0xFFFAEEDA),
        PurchaseStatus.approved => const Color(0xFFEAF3DE),
        PurchaseStatus.rejected => const Color(0xFFFCEBEB),
      };

  static Color _badgeFg(PurchaseStatus s) => switch (s) {
        PurchaseStatus.pending  => const Color(0xFF633806),
        PurchaseStatus.approved => const Color(0xFF27500A),
        PurchaseStatus.rejected => const Color(0xFF791F1F),
      };

  @override
  Widget build(BuildContext context) {
    final p = purchase;
    return Opacity(
      opacity: p.status == PurchaseStatus.rejected ? 0.65 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left accent bar
              Container(width: 4.w, color: _accent(p.status)),

              // Card content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildR1(p),
                      SizedBox(height: 9.h),
                      _buildR2(p),
                      SizedBox(height: 10.h),
                      _buildR3(p),
                      SizedBox(height: 10.h),
                      if (p.status == PurchaseStatus.pending &&
                          p.noteMessage != null)
                        _buildNote(
                          text: p.noteMessage!,
                          bg: const Color(0xFFFAEEDA),
                          iconColor: const Color(0xFFBA7517),
                          textColor: const Color(0xFF633806),
                          icon: Icons.info_outline_rounded,
                        ),
                      if (p.status == PurchaseStatus.rejected &&
                          p.noteMessage != null)
                        _buildNote(
                          text: p.noteMessage!,
                          bg: const Color(0xFFFCEBEB),
                          iconColor: const Color(0xFFA32D2D),
                          textColor: const Color(0xFF791F1F),
                          icon: Icons.cancel_outlined,
                        ),
                      if (p.status == PurchaseStatus.approved &&
                          p.expiryText != null)
                        _buildExpiry(p.expiryText!),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Row 1: name + badge ─────────────────────────────────────
  Widget _buildR1(PurchaseModel p) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.packageName,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1A1A2E),
                    letterSpacing: -0.2)),
            SizedBox(height: 2.h),
            Text(p.packageDuration,
                style: TextStyle(
                    fontSize: 11.sp, color: const Color(0xFF9B9BAD))),
          ]),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: _badgeBg(p.status),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(p.status.label,
              style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: _badgeFg(p.status))),
        ),
      ],
    );
  }

  // ── Row 2: meta pills ───────────────────────────────────────
  Widget _buildR2(PurchaseModel p) {
    return Row(children: [
      _MetaPill(
        icon: Icons.calendar_month_outlined,
        iconColor: _accent(p.status),
        text: p.formattedDateShort,
      ),
      SizedBox(width: 7.w),
      _MetaPill(
        icon: Icons.access_time_rounded,
        iconColor: const Color(0xFF9B9BAD),
        text: p.packageName,
      ),
    ]);
  }

  // ── Row 3: price ────────────────────────────────────────────
  Widget _buildR3(PurchaseModel p) {
    final isRejected = p.status == PurchaseStatus.rejected;
    return Row(children: [
      Text('ຈຳນວນ',
          style: TextStyle(
              fontSize: 11.sp, color: const Color(0xFF9B9BAD))),
      const Spacer(),
      Text(p.formattedPrice,
          style: TextStyle(
            fontSize: isRejected ? 14.sp : 17.sp,
            fontWeight: FontWeight.w900,
            color: isRejected
                ? const Color(0xFFD1D1E0)
                : const Color(0xFF1A1A2E),
            letterSpacing: -0.4,
            decoration: isRejected ? TextDecoration.lineThrough : null,
            decorationColor: const Color(0xFFD1D1E0),
            decorationThickness: 2,
          )),
    ]);
  }

  // ── Note ────────────────────────────────────────────────────
  Widget _buildNote({
    required String text,
    required Color bg,
    required Color iconColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 13.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Icon(icon, size: 13.r, color: iconColor),
            ),
            SizedBox(width: 7.w),
            Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 11.sp, color: textColor, height: 1.55)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Expiry ──────────────────────────────────────────────────
  Widget _buildExpiry(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 13.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F1FB),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(children: [
          Icon(Icons.access_time_rounded,
              size: 13.r, color: const Color(0xFF185FA5)),
          SizedBox(width: 7.w),
          Text(text,
              style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0C447C))),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _MetaPill — icon + text pill
// ═══════════════════════════════════════════════════════════════
class _MetaPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  const _MetaPill({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11.r, color: iconColor),
        SizedBox(width: 5.w),
        Text(text,
            style: TextStyle(
                fontSize: 11.sp, color: const Color(0xFF6B6B80))),
      ]),
    );
  }
}