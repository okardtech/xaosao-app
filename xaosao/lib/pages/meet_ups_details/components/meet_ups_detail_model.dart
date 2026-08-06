import 'package:flutter/material.dart';
import 'package:xaosao/utils/l10n.dart' as g;

// ── Localised short month names (index 1..12) ─────────────────
List<String> _monthShortList() => [
      '',
      g.l10n.monthShortJan,
      g.l10n.monthShortFeb,
      g.l10n.monthShortMar,
      g.l10n.monthShortApr,
      g.l10n.monthShortMay,
      g.l10n.monthShortJun,
      g.l10n.monthShortJul,
      g.l10n.monthShortAug,
      g.l10n.monthShortSep,
      g.l10n.monthShortOct,
      g.l10n.monthShortNov,
      g.l10n.monthShortDec,
    ];

List<String> _dayShortList() => [
      g.l10n.meetupsDayShortSun,
      g.l10n.meetupsDayShortMon,
      g.l10n.meetupsDayShortTue,
      g.l10n.meetupsDayShortWed,
      g.l10n.meetupsDayShortThu,
      g.l10n.meetupsDayShortFri,
      g.l10n.meetupsDayShortSat,
    ];

// ═══════════════════════════════════════════════════════════════
//  BookingDetailEntry — ບອກວ່ານັດລາຍລະອຽດເປີດຈາກໃສ
// ═══════════════════════════════════════════════════════════════
enum BookingEntrySource { meetUps, chat }

extension BookingEntrySourceExt on BookingEntrySource {
  String get label => switch (this) {
        BookingEntrySource.meetUps => g.l10n.meetupsEntryFromMeetUps,
        BookingEntrySource.chat    => g.l10n.meetupsEntryFromChat,
      };

  IconData get icon => switch (this) {
        BookingEntrySource.meetUps => Icons.calendar_month_outlined,
        BookingEntrySource.chat    => Icons.chat_bubble_outline_rounded,
      };
}

// ═══════════════════════════════════════════════════════════════
//  BookingTimelineEvent — ແຕ່ລະ step ໃນ timeline
// ═══════════════════════════════════════════════════════════════
class BookingTimelineEvent {
  final String title;
  final DateTime timestamp;
  final Color dotColor;
  final bool isCurrent; // dot ສະເຫຼີມ (glow)

  const BookingTimelineEvent({
    required this.title,
    required this.timestamp,
    required this.dotColor,
    this.isCurrent = false,
  });

  String get formattedTime {
    final months = _monthShortList();
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    return '${timestamp.day} ${months[timestamp.month]} · $h:$m';
  }
}

// ═══════════════════════════════════════════════════════════════
//  BookingDetailModel — full data for detail page
// ═══════════════════════════════════════════════════════════════
class BookingDetailModel {
  final String id;
  final String companionName;
  final String? companionImageUrl;
  final List<Color> companionGradient;
  final List<String> services;
  final MeetUpsStatus status;
  final DateTime dateTime;
  final int durationHours;
  final String locationName;
  final String locationSub;
  final int priceKip;
  final Duration? countdown;
  final double? rating;
  final String? reviewText;
  final String? rejectedReason;
  final List<BookingTimelineEvent> timeline;
  final Map<String, int> priceBreakdown; // service label → price
  final BookingEntrySource entrySource;

  const BookingDetailModel({
    required this.id,
    required this.companionName,
    this.companionImageUrl,
    required this.companionGradient,
    required this.services,
    required this.status,
    required this.dateTime,
    required this.durationHours,
    required this.locationName,
    required this.locationSub,
    required this.priceKip,
    this.countdown,
    this.rating,
    this.reviewText,
    this.rejectedReason,
    required this.timeline,
    required this.priceBreakdown,
    this.entrySource = BookingEntrySource.meetUps,
  });

  String get formattedDateRange {
    final days = _dayShortList();
    final months = _monthShortList();
    final d   = dateTime;
    final end = d.add(Duration(hours: durationHours));
    final sh  = d.hour.toString().padLeft(2, '0');
    final sm  = d.minute.toString().padLeft(2, '0');
    final eh  = end.hour.toString().padLeft(2, '0');
    final em  = end.minute.toString().padLeft(2, '0');
    return '${days[d.weekday % 7]}. ${d.day} ${months[d.month]} ${d.year}\n$sh:$sm – $eh:$em ${g.l10n.meetupsClockSuffix}';
  }

  String get formattedTotal {
    final s = priceKip.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '${buf.toString()} ${g.l10n.commonCurrencyKip}';
  }

  String get countdownText {
    if (countdown == null) return '';
    final days  = countdown!.inDays;
    final hours = countdown!.inHours % 24;
    if (days > 0) return g.l10n.meetupsCountdownDays(days, hours);
    if (hours > 0) return g.l10n.meetupsCountdownHours(hours);
    return g.l10n.meetupsCountdownMinutes(countdown!.inMinutes);
  }

  String get countdownSub {
    final months = _monthShortList();
    final d = dateTime;
    return '${d.day} ${months[d.month]} '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }

  String get cancelDeadline {
    final dl = dateTime.subtract(const Duration(minutes: 30));
    final months = _monthShortList();
    return '${dl.day} ${months[dl.month]} '
        '${dl.hour.toString().padLeft(2, '0')}:'
        '${dl.minute.toString().padLeft(2, '0')} ${g.l10n.meetupsClockSuffix}';
  }
}

// ── MeetUpsStatus (re-export convenience) ─────────────────────
enum MeetUpsStatus { upcoming, completed, cancelled, rejected }

extension MeetUpsStatusExt on MeetUpsStatus {
  String get label => switch (this) {
        MeetUpsStatus.upcoming   => g.l10n.bookingSummaryActive,
        MeetUpsStatus.completed  => g.l10n.meetupsStepCompleted,
        MeetUpsStatus.cancelled  => g.l10n.meetupsStepCancelled,
        MeetUpsStatus.rejected   => g.l10n.meetupsStepRejected,
      };

  Color get badgeBg => switch (this) {
        MeetUpsStatus.upcoming   => const Color(0xFFEFF6FF),
        MeetUpsStatus.completed  => const Color(0xFFEDFAF3),
        MeetUpsStatus.cancelled  => const Color(0xFFF0F0F5),
        MeetUpsStatus.rejected   => const Color(0xFFFFFBEB),
      };

  Color get badgeFg => switch (this) {
        MeetUpsStatus.upcoming   => const Color(0xFF1D4ED8),
        MeetUpsStatus.completed  => const Color(0xFF15803D),
        MeetUpsStatus.cancelled  => const Color(0xFF9B9BAD),
        MeetUpsStatus.rejected   => const Color(0xFF92400E),
      };
}

// ── Mock data ──────────────────────────────────────────────────
final mockBookingDetailUpcoming = BookingDetailModel(
  id: 'bd1',
  companionName: 'Kai Vongkhamphanh',
  companionImageUrl: 'https://i.pinimg.com/736x/70/be/80/70be807191077db8da6a6d25765ca11e.jpg',
  companionGradient: [const Color(0xFF5C6BC0), const Color(0xFF1A1A2E)],
  services: ['ເພື່ອນສັງຄົມ', 'ທ່ຽວ'],
  status: MeetUpsStatus.upcoming,
  dateTime: DateTime(2026, 3, 22, 14, 0),
  durationHours: 3,
  locationName: 'ຮ້ານກາເຟ The Cup',
  locationSub: 'ໂຊນ 1 · ວຽງຈັນ',
  priceKip: 450000,
  countdown: const Duration(days: 6, hours: 4),
  priceBreakdown: {'ເພື່ອນສັງຄົມ × 3 ຊ.ມ.': 450000, 'ຄ່າບໍລິການ': 0},
  entrySource: BookingEntrySource.meetUps,
  timeline: [
    BookingTimelineEvent(
      title: 'ຈອງສຳເລັດ',
      timestamp: DateTime(2026, 3, 16, 9, 32),
      dotColor: const Color(0xFF22C55E),
    ),
    BookingTimelineEvent(
      title: 'Companion ຍືນຢັນ',
      timestamp: DateTime(2026, 3, 16, 10, 15),
      dotColor: const Color(0xFF22C55E),
    ),
    BookingTimelineEvent(
      title: 'ລໍຖ້ານັດພົບ',
      timestamp: DateTime(2026, 3, 22, 14, 0),
      dotColor: const Color(0xFF3B82F6),
      isCurrent: true,
    ),
  ],
);

final mockBookingDetailCompleted = BookingDetailModel(
  id: 'bd2',
  companionName: 'Leo Phantivilay',
  companionImageUrl:
      'https://i.pinimg.com/736x/70/be/80/70be807191077db8da6a6d25765ca11e.jpg',
  companionGradient: [const Color(0xFFf093fb), const Color(0xFFc2185b)],
  services: ['ນວດ', 'ທ່ຽວ'],
  status: MeetUpsStatus.completed,
  dateTime: DateTime(2026, 3, 14, 10, 0),
  durationHours: 2,
  locationName: 'ໂຮງແຮມ Lao Plaza',
  locationSub: 'ໃຈກາງວຽງຈັນ',
  priceKip: 15000,
  rating: 4.0,
  reviewText: 'ດີຫຼາຍ ພາທ່ຽວຊອບ ເຂົ້ານ້ຳໃຈດີ ຈະໃຊ້ຊ້ຳ!',
  priceBreakdown: {'ນວດ × 2 ຊ.ມ.': 15000},
  entrySource: BookingEntrySource.chat,
  timeline: [
    BookingTimelineEvent(
      title: 'ຈອງສຳເລັດ',
      timestamp: DateTime(2026, 3, 9, 9, 0),
      dotColor: const Color(0xFF22C55E),
    ),
    BookingTimelineEvent(
      title: 'Companion ຍືນຢັນ',
      timestamp: DateTime(2026, 3, 9, 9, 45),
      dotColor: const Color(0xFF22C55E),
    ),
    BookingTimelineEvent(
      title: 'ການນັດພົບສຳເລັດ',
      timestamp: DateTime(2026, 3, 14, 12, 0),
      dotColor: const Color(0xFF22C55E),
    ),
    BookingTimelineEvent(
      title: 'ທ່ານໃຫ້ຄະແນນ ⭐⭐⭐⭐',
      timestamp: DateTime(2026, 3, 14, 14, 22),
      dotColor: const Color(0xFFF9C846),
    ),
  ],
);