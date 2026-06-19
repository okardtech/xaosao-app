import 'package:xaosao/utils/api_date_parser.dart';

class ChatMessageModel {
  final String id;
  final String? conversationId;
  final String? sender;
  final String? senderType;
  final String? messageText;
  final String messageType; // 'text' | 'image'
  final String? fileUrl;
  final String? fileName;
  final String? fileSize;
  final bool isRead;
  final bool isDeleted;
  final String? replyToMessageId;
  final DateTime? sendAt;
  final DateTime? readAt;
  final DateTime? editedAt;
  final DateTime? createdAt;
  final Map<String, dynamic>? metadata;

  const ChatMessageModel({
    required this.id,
    this.conversationId,
    this.sender,
    this.senderType,
    this.messageText,
    this.messageType = 'text',
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.isRead = false,
    this.isDeleted = false,
    this.replyToMessageId,
    this.sendAt,
    this.readAt,
    this.editedAt,
    this.createdAt,
    this.metadata,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? json['_id'] ?? '',
      conversationId: json['conversationId'],
      sender: json['sender'],
      senderType: json['senderType'],
      messageText: json['messageText'],
      messageType: json['messageType'] ?? 'text',
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      fileSize: json['fileSize']?.toString(),
      isRead: json['isRead'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      replyToMessageId: json['replyToMessageId'],
      sendAt: _tryParse(json['sendAt']),
      readAt: _tryParse(json['readAt']),
      editedAt: _tryParse(json['editedAt']),
      createdAt: _tryParse(json['createdAt']),
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null,
    );
  }

  static DateTime? _tryParse(dynamic v) => parseApiDateTime(v);

  ChatMessageModel copyWith({
    bool? isRead,
    bool? isDeleted,
  }) => ChatMessageModel(
        id: id,
        conversationId: conversationId,
        sender: sender,
        senderType: senderType,
        messageText: messageText,
        messageType: messageType,
        fileUrl: fileUrl,
        fileName: fileName,
        fileSize: fileSize,
        isRead: isRead ?? this.isRead,
        isDeleted: isDeleted ?? this.isDeleted,
        replyToMessageId: replyToMessageId,
        sendAt: sendAt,
        readAt: readAt,
        editedAt: editedAt,
        createdAt: createdAt,
        metadata: metadata,
      );

  DateTime get displayTime => sendAt ?? createdAt ?? DateTime.now();

  String get timeString {
    final t = displayTime;
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}
