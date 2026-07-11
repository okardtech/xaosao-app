// To parse this JSON data, do
//
//     final badgeModel = badgeModelFromJson(jsonString);

import 'dart:convert';

BadgeModel badgeModelFromJson(String str) => BadgeModel.fromJson(json.decode(str));

String badgeModelToJson(BadgeModel data) => json.encode(data.toJson());

class BadgeModel {
    int? unreadChats;
    int? pendingBookings;
    int? activePosts;

    BadgeModel({
        this.unreadChats,
        this.pendingBookings,
        this.activePosts,
    });

    factory BadgeModel.fromJson(Map<String, dynamic> json) => BadgeModel(
        unreadChats: json["unread_chats"],
        pendingBookings: json["pending_bookings"],
        activePosts: json["active_posts"],
    );

    Map<String, dynamic> toJson() => {
        "unread_chats": unreadChats,
        "pending_bookings": pendingBookings,
        "active_posts": activePosts,
    };
}
