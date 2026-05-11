import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
//  PackageModel — ຂໍ້ມູນ package ທີ່ຊື້ໄດ້
// ═══════════════════════════════════════════════════════════════
class PackageModel {
  final String id;
  final String duration;        // "1 ເດືອນ"
  final String description;
  final int priceKip;
  final int? originalPriceKip; // ສຳລັບ strikethrough
  final int discountPercent;   // 0 = ບໍ່ discount
  final List<String> features;
  final bool isPopular;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color featureCheckColor;
  final Color featureCheckBg;

  const PackageModel({
    required this.id,
    required this.duration,
    required this.description,
    required this.priceKip,
    this.originalPriceKip,
    required this.discountPercent,
    required this.features,
    this.isPopular = false,
    required this.gradientColors,
    required this.accentColor,
    required this.featureCheckColor,
    required this.featureCheckBg,
  });

  String get formattedPrice {
    final s = priceKip.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '${buf.toString()} ກີບ';
  }
}

// ── All 3 packages (content from website) ─────────────────────
final List<PackageModel> allPackages = [
  PackageModel(
    id: 'monthly',
    duration: '1 ເດືອນ',
    description:
        'ເພີ່ມໂອກາດກັບການຈຳກັດໃຊ້ຫຼາຍຄັ້ງຕໍ່ເດືອນ ແລະ ພົບຄູ່ທີ່ມີຫຼາຍກວ່ານັ້ນຢ່າງງ່າຍດາຍ.',
    priceKip: 100000,
    discountPercent: 22,
    isPopular: true,
    gradientColors: [const Color(0xFFF06292), const Color(0xFFFF8A80)],
    accentColor: const Color(0xFFF06292),
    featureCheckColor: const Color(0xFFF06292),
    featureCheckBg: const Color(0xFFFFF0F6),
    features: [
      'ກົດໃຈໂປຣໄຟລ໌ບໍ່ຈຳກັດ',
      'ຕິດເລືອກ Smart Pass & ຊ້ຳ',
      'ເຫັນຄົນທີ່ກົດຖືກໃຈຕົນສູງສຸດ',
      'ທາດເຮົ້າໃຊ້ແຮ່ດສ່ວນຕົວໃນແອບ',
      'ລະບົບຈຸດດ່ວນໃນກ່ວາຍດາຍ',
      'ເພີ່ມໂປຣໄຟລ໌ & Spotlight',
      'ປະຊິນທາງໃຊ້ງານບໍ່ໂຄສະນາ',
      'ທາດຫ້ອຍເຕືອວຈາກຄູ່ສຸດລໍານັ້ນ',
    ],
  ),
  PackageModel(
    id: 'quarterly',
    duration: '3 ເດືອນ',
    description:
        'ຕົ້ນຊະເລີທີ່ດີທີ່ສຸດສຳລັບການນັດພົບໄລຍະຍາວ ແລະ ການຊ່ວຍຕໍ່ທີ່ຕ່ຳແກ່ຈ.',
    priceKip: 250000,
    discountPercent: 35,
    isPopular: false,
    gradientColors: [const Color(0xFF1A1A2E), const Color(0xFF3C3C6E)],
    accentColor: const Color(0xFF22C55E),
    featureCheckColor: const Color(0xFF22C55E),
    featureCheckBg: const Color(0xFFEDFAF3),
    features: [
      'ກົດໃຈໂປຣໄຟລ໌ບໍ່ຈຳກັດ',
      'ຕິດເລືອກ Smart Pass & ຊ້ຳ',
      'ເຫັນຄົນທີ່ກົດຖືກໃຈຕົນສູງສຸດ',
      'ທາດເຮົ້າໃຊ້ແຮ່ດສ່ວນຕົວໃນແອບ',
      'ລະບົບຈຸດດ່ວນໃນກ່ວາຍດາຍ',
      'ເພີ່ມໂປຣໄຟລ໌ & Spotlight',
      'ປະຊິນທາງໃຊ້ງານບໍ່ໂຄສະນາ',
    ],
  ),
  PackageModel(
    id: 'weekly',
    duration: '1 ອາທິດ',
    description:
        'ສຳຫຼວດຄວາມສຸດຈຸດພິທີທຸກທີ່ຢູ່ ແລະ ເພີ່ມໂຊ້ດຕໍ່ກັບທ່ານ.',
    priceKip: 30000,
    discountPercent: 0,
    isPopular: false,
    gradientColors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
    accentColor: const Color(0xFF7C3AED),
    featureCheckColor: const Color(0xFF7C3AED),
    featureCheckBg: const Color(0xFFF3F0FF),
    features: [
      'ກົດໃຈໂປຣໄຟລ໌ບໍ່ຈຳກັດ',
      'ຕິດເລືອກ Smart Pass & ຊ້ຳ',
      'ເຫັນຄົນທີ່ກົດຖືກໃຈຕົນສູງສຸດ',
      'ທາດເຮົ້າໃຊ້ແຮ່ດສ່ວນຕົວໃນແອບ',
      'ລະບົບຈຸດດ່ວນໃນກ່ວາຍດາຍ',
      'ເພີ່ມໂປຣໄຟລ໌ & Spotlight',
      'ປະຊິນທາງໃຊ້ງານບໍ່ໂຄສະນາ',
      'ທາດຫ້ອຍເຕືອວຈາກຄູ່ສຸດລໍານັ້ນ',
    ],
  ),
];