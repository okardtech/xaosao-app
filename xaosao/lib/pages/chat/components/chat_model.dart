import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
//  MessageStatus
// ═══════════════════════════════════════════════════════════════
enum MessageStatus { sending, sent, read }

// ═══════════════════════════════════════════════════════════════
//  MessageType
// ═══════════════════════════════════════════════════════════════
enum MessageType { text, booking }

// ═══════════════════════════════════════════════════════════════
//  BookingRequest — embedded in message
// ═══════════════════════════════════════════════════════════════
class BookingRequest {
  final String serviceName;
  final DateTime dateTime;
  final int durationHours;
  final int priceKip;
  final bool? accepted; // null = pending

  const BookingRequest({
    required this.serviceName,
    required this.dateTime,
    required this.durationHours,
    required this.priceKip,
    this.accepted,
  });

  String get formattedDate {
    const days = ['ອາ', 'ຈ', 'ອ', 'ພ', 'ພຫ', 'ສຸ', 'ສ'];
    const months = [
      '', 'ມ.ກ', 'ກ.ພ', 'ມ.ນ', 'ມ.ສ', 'ພ.ພ', 'ມ.ຖ',
      'ກ.ລ', 'ສ.ຫ', 'ກ.ຍ', 'ຕ.ລ', 'ພ.ຈ', 'ທ.ວ',
    ];
    final h = dateTime.hour.toString().padLeft(2, '0');
    final m = dateTime.minute.toString().padLeft(2, '0');
    return '${days[dateTime.weekday % 7]}. ${dateTime.day} ${months[dateTime.month]} $h:$m';
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

  BookingRequest copyWith({bool? accepted}) => BookingRequest(
        serviceName:   serviceName,
        dateTime:      dateTime,
        durationHours: durationHours,
        priceKip:      priceKip,
        accepted:      accepted ?? this.accepted,
      );
}

// ═══════════════════════════════════════════════════════════════
//  ChatMessage
// ═══════════════════════════════════════════════════════════════
class ChatMessage {
  final String id;
  final bool isMe;
  final MessageType type;
  final String? text;
  final BookingRequest? booking;
  final DateTime timestamp;
  final MessageStatus status;

  const ChatMessage({
    required this.id,
    required this.isMe,
    required this.type,
    this.text,
    this.booking,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  ChatMessage copyWith({MessageStatus? status, BookingRequest? booking}) =>
      ChatMessage(
        id:        id,
        isMe:      isMe,
        type:      type,
        text:      text,
        booking:   booking ?? this.booking,
        timestamp: timestamp,
        status:    status ?? this.status,
      );

  String get timeString {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ═══════════════════════════════════════════════════════════════
//  ChatPreview — ສຳລັບ chat list row
// ═══════════════════════════════════════════════════════════════
class ChatPreview {
  final String id;
  final String name;
  final int age;
  final String? imageUrl;
  final List<Color> gradient;
  final String lastMessage;
  final bool lastIsMe;
  final DateTime lastTime;
  final int unreadCount;
  final bool isOnline;
  final MessageStatus lastStatus;

  const ChatPreview({
    required this.id,
    required this.name,
    required this.age,
    this.imageUrl,
    required this.gradient,
    required this.lastMessage,
    this.lastIsMe    = false,
    required this.lastTime,
    this.unreadCount = 0,
    this.isOnline    = false,
    this.lastStatus  = MessageStatus.read,
  });

  String get timeLabel {
    final now  = DateTime.now();
    final diff = now.difference(lastTime);
    if (diff.inMinutes < 60) {
      final h = lastTime.hour.toString().padLeft(2, '0');
      final m = lastTime.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    if (diff.inDays == 0) return 'ມື້ນີ້';
    if (diff.inDays == 1) return 'ມື້ວານ';
    if (diff.inDays < 7)  return '${diff.inDays} ວັນ';
    const days = ['ອາ', 'ຈ', 'ອ', 'ພ', 'ພຫ', 'ສຸ', 'ສ'];
    return '${days[lastTime.weekday % 7]}. ${lastTime.day}';
  }
}

// ═══════════════════════════════════════════════════════════════
//  Mock data
// ═══════════════════════════════════════════════════════════════
final mockChatPreviews = <ChatPreview>[
  ChatPreview(
    id: 'c1', name: 'Kai', age: 26,
    gradient: [const Color(0xFF5C6BC0), const Color(0xFF1A1A2E)],
    lastMessage: 'ໂອເຄ ຈະໄປຖ້ານຳ Coffee ນັ້ນ',
    lastTime: DateTime.now().subtract(const Duration(minutes: 8)),
    unreadCount: 2, isOnline: true,
  ),
  ChatPreview(
    id: 'c2', name: 'Leo', age: 28,
    gradient: [const Color(0xFFf093fb), const Color(0xFFc2185b)],
    lastMessage: 'ຂ້ອຍ: ຂອບໃຈຫຼາຍໆ!',
    lastIsMe: true,
    lastTime: DateTime.now().subtract(const Duration(hours: 20)),
    lastStatus: MessageStatus.read,
  ),
  ChatPreview(
    id: 'c3', name: 'Mark', age: 24,
    gradient: [const Color(0xFF43e97b), const Color(0xFF1A5276)],
    lastMessage: 'ຂ້ອຍ: ວ່າງ Sunday ບໍ?',
    lastIsMe: true,
    lastTime: DateTime.now().subtract(const Duration(hours: 4)),
    lastStatus: MessageStatus.sent, isOnline: true,
  ),
  ChatPreview(
    id: 'c4', name: 'Ryan', age: 29,
    gradient: [const Color(0xFFfa709a), const Color(0xFF7B1FA2)],
    lastMessage: '📅 ຄຳຂໍຈອງໃໝ່',
    lastTime: DateTime.now().subtract(const Duration(days: 2)),
    unreadCount: 1, isOnline: true,
  ),
  ChatPreview(
    id: 'c5', name: 'Sam', age: 23,
    gradient: [const Color(0xFFFFCC80), const Color(0xFFE65100)],
    lastMessage: 'ດີໃຈທີ່ໄດ້ທ່ຽວ ✨',
    lastTime: DateTime.now().subtract(const Duration(days: 3)),
  ),
  ChatPreview(
    id: 'c6', name: 'Alex', age: 25,
    gradient: [const Color(0xFF4facfe), const Color(0xFF1A237E)],
    lastMessage: 'ໂອ ດີເລີຍ ຮ່ວມດ້ວຍໄດ້ເລີຍ',
    lastTime: DateTime.now().subtract(const Duration(days: 5)),
  ),
];

final mockMessages = <ChatMessage>[
  ChatMessage(
    id: 'm1', isMe: false, type: MessageType.text,
    text: 'ສະບາຍດີ! ຂ້ອຍສົນໃຈຈອງ weekend ນີ້ 😊',
    timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 20)),
  ),
  ChatMessage(
    id: 'm2', isMe: true, type: MessageType.text,
    text: 'ສະບາຍດີ! ຍິນດີຕ້ອນຮັບ ວ່າງ Saturday ໃດ?',
    timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 18)),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: 'm3', isMe: false, type: MessageType.text,
    text: 'ວ່າງຕອນ 14:00 ໄດ້ ທ່ຽວ Central ຕ້ອງການ?',
    timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 17)),
  ),
  ChatMessage(
    id: 'm4', isMe: false, type: MessageType.booking,
    booking: BookingRequest(
      serviceName: 'ເພື່ອນສັງຄົມ · ທ່ຽວ',
      dateTime: DateTime(2026, 3, 22, 14, 0),
      durationHours: 3,
      priceKip: 450000,
    ),
    timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 16)),
  ),
  ChatMessage(
    id: 'm5', isMe: true, type: MessageType.text,
    text: 'ໂອ ຍອມຮັບການຈອງ Saturday 22/3 ໄດ້ເລີຍ 🎉',
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: 'm6', isMe: false, type: MessageType.text,
    text: 'ໂອເຄ ຈະໄປຖ້ານຳ Coffee ນັ້ນ ✨',
    timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
  ),
];