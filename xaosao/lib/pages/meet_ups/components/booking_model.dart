import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
//  BookingStatus enum
// ═══════════════════════════════════════════════════════════════
enum BookingStatus { upcoming, completed, cancelled, rejected }

extension BookingStatusExt on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.upcoming:   return 'ກຳລັງມາ';
      case BookingStatus.completed:  return 'ສຳເລັດ';
      case BookingStatus.cancelled:  return 'ຍົກເລີກ';
      case BookingStatus.rejected:   return 'ຖືກປະຕິເສດ';
    }
  }

  double get cardOpacity {
    switch (this) {
      case BookingStatus.upcoming:   return 1.0;
      case BookingStatus.completed:  return 1.0;
      case BookingStatus.cancelled:  return 0.45;
      case BookingStatus.rejected:   return 0.80;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
//  BookingModel
// ═══════════════════════════════════════════════════════════════
class BookingModel {
  final String id;
  final String companionName;
  final int companionAge;
  final String? companionImageUrl;
  final List<Color> companionGradient;
  final List<String> services;
  final DateTime dateTime;
  final int durationHours;
  final String locationName;
  final String locationSub;
  final int priceKip;
  final BookingStatus status;
  final double? rating;         // ສຳລັບ completed
  final String? rejectedReason; // ສຳລັບ rejected
  final Duration? countdown;    // ສຳລັບ upcoming

  const BookingModel({
    required this.id,
    required this.companionName,
    required this.companionAge,
    this.companionImageUrl,
    required this.companionGradient,
    required this.services,
    required this.dateTime,
    required this.durationHours,
    required this.locationName,
    required this.locationSub,
    required this.priceKip,
    required this.status,
    this.rating,
    this.rejectedReason,
    this.countdown,
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

  String get formattedDate {
    const days = ['ອາ', 'ຈ', 'ອ', 'ພ', 'ພຫ', 'ສຸ', 'ສ'];
    const months = [
      '', 'ມ.ກ', 'ກ.ພ', 'ມ.ນ', 'ມ.ສ', 'ພ.ພ', 'ມ.ຖ',
      'ກ.ລ', 'ສ.ຫ', 'ກ.ຍ', 'ຕ.ລ', 'ພ.ຈ', 'ທ.ວ',
    ];
    final d = dateTime;
    final time =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return '${days[d.weekday % 7]}. ${d.day} ${months[d.month]} ${d.year % 100}\n$time ໂມງ';
  }

  String get countdownText {
    if (countdown == null) return '';
    final days = countdown!.inDays;
    final hours = countdown!.inHours % 24;
    if (days > 0) return 'ເຫຼືອອີກ $days ວັນ $hours ຊົ່ວໂມງ';
    if (hours > 0) return 'ເຫຼືອອີກ $hours ຊົ່ວໂມງ';
    final mins = countdown!.inMinutes;
    return 'ເຫຼືອອີກ $mins ນາທີ';
  }

  String get countdownDateSub {
    final d = dateTime;
    const months = [
      '', 'ມ.ກ', 'ກ.ພ', 'ມ.ນ', 'ມ.ສ', 'ພ.ພ', 'ມ.ຖ',
      'ກ.ລ', 'ສ.ຫ', 'ກ.ຍ', 'ຕ.ລ', 'ພ.ຈ', 'ທ.ວ',
    ];
    final time =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return '${d.day} ${months[d.month]} $time';
  }
}

// ═══════════════════════════════════════════════════════════════
//  Mock data
// ═══════════════════════════════════════════════════════════════
final List<BookingModel> mockBookings = [
  BookingModel(
    id: '1',
    companionName: 'Kai',
    companionAge: 26,
    companionImageUrl: "https://en.pimg.jp/060/438/636/1/60438636.jpg",
    companionGradient: [const Color(0xFF5C6BC0), const Color(0xFF1A1A2E)],
    services: ['ເພື່ອນສັງຄົມ', 'ທ່ຽວ'],
    dateTime: DateTime(2026, 3, 22, 14, 0),
    durationHours: 3,
    locationName: 'ຮ້ານກາເຟ The Cup',
    locationSub: 'ໂຊນ 1 · ວຽງຈັນ',
    priceKip: 450000,
    status: BookingStatus.upcoming,
    countdown: const Duration(days: 6, hours: 4),
  ),
  BookingModel(
    id: '2',
    companionName: 'Leo',
    companionAge: 28,
    companionImageUrl: "https://t4.ftcdn.net/jpg/02/80/30/47/360_F_280304759_9EXjImbS6ePdVsrPYIew6f3ecFuLGF6G.jpg",
    companionGradient: [const Color(0xFFf093fb), const Color(0xFFc2185b)],
    services: ['ນວດ', 'ທ່ຽວ'],
    dateTime: DateTime(2026, 3, 14, 10, 0),
    durationHours: 2,
    locationName: 'ໂຮງແຮມ Lao Plaza',
    locationSub: 'ໃຈກາງວຽງຈັນ',
    priceKip: 15000,
    status: BookingStatus.completed,
    rating: 4.0,
  ),
  BookingModel(
    id: '3',
    companionName: 'Mark',
    companionAge: 24,
    companionImageUrl: "https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA1KVuhP.img?w=768&h=432&m=6&x=896&y=224&s=410&d=410",
    companionGradient: [const Color(0xFF4facfe), const Color(0xFF1A237E)],
    services: ['ເພື່ອນສັງຄົມ'],
    dateTime: DateTime(2026, 3, 10, 16, 0),
    durationHours: 2,
    locationName: 'Night Market',
    locationSub: 'ຮິມນ້ຳຂອງ · ວຽງຈັນ',
    priceKip: 300000,
    status: BookingStatus.rejected,
    rejectedReason: 'ຕິດທຸລະສ່ວນຕົວ ບໍ່ສາມາດຮັບການຈອງໃນວັນດັ່ງກ່າວໄດ້',
  ),
  BookingModel(
    id: '4',
    companionName: 'Sam',
    companionAge: 23,
    companionImageUrl: "https://cdn.ubitto.com/content/uploads/2019/09/xcscscs.jpg",
    companionGradient: [const Color(0xFF43e97b), const Color(0xFF1A5276)],
    services: ['ທ່ຽວ', 'ນວດ'],
    dateTime: DateTime(2026, 3, 3, 9, 0),
    durationHours: 4,
    locationName: 'Vientiane Center',
    locationSub: 'ຊັ້ນ 2',
    priceKip: 500000,
    status: BookingStatus.cancelled,
  ),
];