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
      profileImage: json['profile']?.toString(), // API field is 'profile'
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
  final bool isActive;

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
    this.isActive = true,
  });

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
      // 'lastMessage' in API is the ISO timestamp, 'lastMessageText' is the text
      lastMessageAt: _tryParse(json['lastMessage'] ?? json['updatedAt']),
      customerUnreadCount:
          (json['customerUnreadCount'] as num?)?.toInt() ?? 0,
      modelUnreadCount: (json['modelUnreadCount'] as num?)?.toInt() ?? 0,
      isActive: json['status'] == 'active',
    );
  }

  static DateTime? _tryParse(dynamic v) =>
      v != null ? DateTime.tryParse(v.toString()) : null;

  /// Returns the participant that is NOT the logged-in user.
  /// Pass myRole = 'customer' | 'model'
  ConversationParticipant? otherParticipant(String myRole) {
    return myRole == 'customer' ? model : customer;
  }

  /// Returns unread count for the logged-in role.
  int unreadCountFor(String role) {
    return role == 'customer' ? customerUnreadCount : modelUnreadCount;
  }

  ConversationModel copyWith({
    ConversationParticipant? customer,
    ConversationParticipant? model,
    String? lastMessageText,
    String? lastMessageType,
    String? lastMessageSenderId,
    DateTime? lastMessageAt,
    int? customerUnreadCount,
    int? modelUnreadCount,
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
        isActive: isActive,
      );
}
