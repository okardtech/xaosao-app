import 'package:xaosao/utils/api_date_parser.dart';

class ConversationParticipant {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? profileImage;
  final bool isOnline;

  const ConversationParticipant({
    required this.id,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.isOnline = false,
  });

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) {
    return ConversationParticipant(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      profileImage: json['profile']?.toString(),
      isOnline: json['isOnline'] == true,
    );
  }

  String get displayName {
    final parts = [firstName, lastName]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');
    return parts.isNotEmpty ? parts : 'Unknown';
  }
}

class ConversationModel {
  final String id;
  final String? customerId;
  final String? modelId;
  final ConversationParticipant? customer;
  final ConversationParticipant? model;
  final String? lastMessageText;
  final String? lastMessageType;
  final String? lastMessageSenderId;
  final DateTime? lastMessageAt;
  final int customerUnreadCount;
  final int modelUnreadCount;
  final String? status;
  final bool blockedByCustomer;
  final bool blockedByModel;

  const ConversationModel({
    required this.id,
    this.customerId,
    this.modelId,
    this.customer,
    this.model,
    this.lastMessageText,
    this.lastMessageType,
    this.lastMessageSenderId,
    this.lastMessageAt,
    this.customerUnreadCount = 0,
    this.modelUnreadCount = 0,
    this.status,
    this.blockedByCustomer = false,
    this.blockedByModel = false,
  });

  bool get isActive => status == 'active';
  bool get isBlocked => status == 'blocked';

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      customerId: json['customerId']?.toString(),
      modelId: json['modelId']?.toString(),
      customer: json['customer'] is Map
          ? ConversationParticipant.fromJson(
              Map<String, dynamic>.from(json['customer'] as Map))
          : null,
      model: json['model'] is Map
          ? ConversationParticipant.fromJson(
              Map<String, dynamic>.from(json['model'] as Map))
          : null,
      lastMessageText: json['lastMessageText']?.toString(),
      lastMessageType: json['lastMessageType']?.toString(),
      lastMessageSenderId: json['lastMessageSenderId']?.toString(),
      lastMessageAt: _tryParse(json['lastMessage'] ?? json['updatedAt']),
      customerUnreadCount:
          (json['customerUnreadCount'] as num?)?.toInt() ?? 0,
      modelUnreadCount: (json['modelUnreadCount'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString(),
      blockedByCustomer: json['blockedByCustomer'] == true,
      blockedByModel: json['blockedByModel'] == true,
    );
  }

  static DateTime? _tryParse(dynamic v) => parseApiDateTime(v);

  ConversationParticipant? otherParticipant(String myRole) =>
      myRole == 'customer' ? model : customer;

  int unreadCountFor(String role) =>
      role == 'customer' ? customerUnreadCount : modelUnreadCount;

  /// Returns true when [myRole] is the one who placed the block.
  bool iBlockedThis(String myRole) =>
      myRole == 'customer' ? blockedByCustomer : blockedByModel;

  ConversationModel copyWith({
    ConversationParticipant? customer,
    ConversationParticipant? model,
    String? lastMessageText,
    String? lastMessageType,
    String? lastMessageSenderId,
    DateTime? lastMessageAt,
    int? customerUnreadCount,
    int? modelUnreadCount,
    String? status,
    bool? blockedByCustomer,
    bool? blockedByModel,
  }) =>
      ConversationModel(
        id: id,
        customerId: customerId,
        modelId: modelId,
        customer: customer ?? this.customer,
        model: model ?? this.model,
        lastMessageText: lastMessageText ?? this.lastMessageText,
        lastMessageType: lastMessageType ?? this.lastMessageType,
        lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        customerUnreadCount: customerUnreadCount ?? this.customerUnreadCount,
        modelUnreadCount: modelUnreadCount ?? this.modelUnreadCount,
        status: status ?? this.status,
        blockedByCustomer: blockedByCustomer ?? this.blockedByCustomer,
        blockedByModel: blockedByModel ?? this.blockedByModel,
      );
}
