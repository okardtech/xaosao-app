import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
//  PurchaseStatus
// ═══════════════════════════════════════════════════════════════
enum PurchaseStatus { pending, approved, rejected }

extension PurchaseStatusExt on PurchaseStatus {
  String get label => switch (this) {
        PurchaseStatus.pending  => 'ລໍຖ້າຢືນຢັນ',
        PurchaseStatus.approved => 'ສຳເລັດ',
        PurchaseStatus.rejected => 'ປະຕິເສດ',
      };

  Color get leftBorderColor => switch (this) {
        PurchaseStatus.pending  => const Color(0xFFF59E0B),
        PurchaseStatus.approved => const Color(0xFF22C55E),
        PurchaseStatus.rejected => const Color(0xFFEF4444),
      };

  Color get badgeBg => switch (this) {
        PurchaseStatus.pending  => const Color(0xFFFFFBEB),
        PurchaseStatus.approved => const Color(0xFFEDFAF3),
        PurchaseStatus.rejected => const Color(0xFFFEF2F2),
      };

  Color get badgeFg => switch (this) {
        PurchaseStatus.pending  => const Color(0xFF92400E),
        PurchaseStatus.approved => const Color(0xFF15803D),
        PurchaseStatus.rejected => const Color(0xFFB91C1C),
      };
}

// ═══════════════════════════════════════════════════════════════
//  PurchaseModel
// ═══════════════════════════════════════════════════════════════
class PurchaseModel {
  final String id;
  final String packageName;      // "1 ເດືອນ"
  final String packageDuration;  // "VIP · 30 ວັນ"
  final DateTime purchaseDate;
  final int priceKip;
  final String referenceNo;      // "#PK-2025041"
  final PurchaseStatus status;
  final String? noteMessage;     // ສຳລັບ pending/rejected
  final DateTime? expiresAt;     // ສຳລັບ approved
  final List<Color> gradientColors;

  const PurchaseModel({
    required this.id,
    required this.packageName,
    required this.packageDuration,
    required this.purchaseDate,
    required this.priceKip,
    required this.referenceNo,
    required this.status,
    this.noteMessage,
    this.expiresAt,
    required this.gradientColors,
  });

  String get formattedDate {
    const months = [
      '', 'ມ.ກ', 'ກ.ພ', 'ມ.ນ', 'ມ.ສ', 'ພ.ພ', 'ມ.ຖ',
      'ກ.ລ', 'ສ.ຫ', 'ກ.ຍ', 'ຕ.ລ', 'ພ.ຈ', 'ທ.ວ',
    ];
    return '${purchaseDate.day} ${months[purchaseDate.month]}\n${purchaseDate.year}';
  }

  String get formattedDateShort {
    const months = [
      '', 'ມ.ກ', 'ກ.ພ', 'ມ.ນ', 'ມ.ສ', 'ພ.ພ', 'ມ.ຖ',
      'ກ.ລ', 'ສ.ຫ', 'ກ.ຍ', 'ຕ.ລ', 'ພ.ຈ', 'ທ.ວ',
    ];
    return '${purchaseDate.day} ${months[purchaseDate.month]} ${purchaseDate.year}';
  }

  String get formattedPrice {
    final s = priceKip.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '${buf.toString()} ກີບ';
  }

  String? get expiryText {
    if (expiresAt == null) return null;
    const months = [
      '', 'ມ.ກ', 'ກ.ພ', 'ມ.ນ', 'ມ.ສ', 'ພ.ພ', 'ມ.ຖ',
      'ກ.ລ', 'ສ.ຫ', 'ກ.ຍ', 'ຕ.ລ', 'ພ.ຈ', 'ທ.ວ',
    ];
    final d = expiresAt!;
    final remaining = d.difference(DateTime.now()).inDays;
    final dateStr = '${d.day} ${months[d.month]} ${d.year}';
    return 'ໝົດອາຍຸ $dateStr · ຍັງເຫຼືອ $remaining ວັນ';
  }
}

// ── Mock data ──────────────────────────────────────────────────
final List<PurchaseModel> mockPurchases = [
  PurchaseModel(
    id: 'p1',
    packageName: '1 ເດືອນ',
    packageDuration: 'VIP · 30 ວັນ',
    purchaseDate: DateTime(2026, 2, 4),
    priceKip: 100000,
    referenceNo: '#PK-2025041',
    status: PurchaseStatus.pending,
    noteMessage:
        'Admin ກຳລັງກວດສອບ — ປົກກະຕິ 1–3 ຊ.ມ. ຖ້າເກີນ 24 ຊ.ມ. ຕິດຕໍ່ support',
    gradientColors: [const Color(0xFFF06292), const Color(0xFFFF8A80)],
  ),
  PurchaseModel(
    id: 'p2',
    packageName: '3 ເດືອນ',
    packageDuration: 'VIP · 90 ວັນ',
    purchaseDate: DateTime(2026, 1, 1),
    priceKip: 250000,
    referenceNo: '#PK-2025038',
    status: PurchaseStatus.approved,
    expiresAt: DateTime(2026, 4, 1),
    gradientColors: [const Color(0xFF1A1A2E), const Color(0xFF3C3C6E)],
  ),
  PurchaseModel(
    id: 'p3',
    packageName: '1 ອາທິດ',
    packageDuration: 'VIP · 7 ວັນ',
    purchaseDate: DateTime(2025, 12, 20),
    priceKip: 30000,
    referenceNo: '#PK-2025031',
    status: PurchaseStatus.rejected,
    noteMessage: 'Slip ໂອນເງິນບໍ່ຊັດ — ກະລຸນາສົ່ງ slip ໃໝ່ ຫຼື ຕິດຕໍ່ support',
    gradientColors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
  ),
];