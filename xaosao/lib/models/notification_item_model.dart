// To parse this JSON data, do
//
//     final notificationItemModel = notificationItemModelFromJson(jsonString);

import 'dart:convert';

List<NotificationItemModel> notificationItemModelFromJson(String str) => List<NotificationItemModel>.from(json.decode(str).map((x) => NotificationItemModel.fromJson(x)));

String notificationItemModelToJson(List<NotificationItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationItemModel {
    String? id;
    String? type;
    String? title;
    String? message;
    Data? data;
    bool? isRead;
    DateTime? createdAt;

    NotificationItemModel({
        this.id,
        this.type,
        this.title,
        this.message,
        this.data,
        this.isRead,
        this.createdAt,
    });

    factory NotificationItemModel.fromJson(Map<String, dynamic> json) => NotificationItemModel(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        isRead: json["is_read"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "title": title,
        "message": message,
        "data": data?.toJson(),
        "is_read": isRead,
        "created_at": createdAt?.toIso8601String(),
    };
}

class Data {
    String? screen;
    String? bookingId;
    String? modelId;
    String? modelDisplayName;
    dynamic profilePhoto;
    String? reason;

    Data({
        this.screen,
        this.bookingId,
        this.modelId,
        this.modelDisplayName,
        this.profilePhoto,
        this.reason,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        screen: json["screen"],
        bookingId: json["bookingId"],
        modelId: json["modelId"],
        modelDisplayName: json["modelDisplayName"],
        profilePhoto: json["profilePhoto"],
        reason: json["reason"],
    );

    Map<String, dynamic> toJson() => {
        "screen": screen,
        "bookingId": bookingId,
        "modelId": modelId,
        "modelDisplayName": modelDisplayName,
        "profilePhoto": profilePhoto,
        "reason": reason,
    };
}

// ── Paginated list wrapper ─────────────────────────────────────
class NotificationListData {
  final List<NotificationItemModel> items;
  final bool hasNextPage;
  final int currentPage;
  final int unreadCount;

  const NotificationListData({
    required this.items,
    required this.hasNextPage,
    required this.currentPage,
    required this.unreadCount,
  });

  factory NotificationListData.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] as Map<String, dynamic>? ?? {};
    final items = (json['items'] as List? ?? [])
        .map((e) => NotificationItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return NotificationListData(
      items: items,
      hasNextPage: pagination['hasNextPage'] as bool? ?? false,
      currentPage: pagination['currentPage'] as int? ?? 1,
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }
}
