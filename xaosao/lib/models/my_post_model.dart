// To parse this JSON data, do
//
//     final myPostModel = myPostModelFromJson(jsonString);

import 'dart:convert';

List<MyPostModel> myPostModelFromJson(String str) => List<MyPostModel>.from(json.decode(str).map((x) => MyPostModel.fromJson(x)));

String myPostModelToJson(List<MyPostModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyPostModel {
    String? authorType;
    String? content;
    List<dynamic>? images;
    bool? hasTip;
    String? status;
    DateTime? expiresAt;
    int? interestedCount;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? id;
    Counts? counts;
    String? location;

    MyPostModel({
        this.authorType,
        this.content,
        this.images,
        this.hasTip,
        this.status,
        this.expiresAt,
        this.interestedCount,
        this.createdAt,
        this.updatedAt,
        this.id,
        this.counts,
        this.location,
    });

    factory MyPostModel.fromJson(Map<String, dynamic> json) => MyPostModel(
        authorType: json["authorType"],
        content: json["content"],
        images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
        hasTip: json["hasTip"],
        status: json["status"],
        expiresAt: json["expiresAt"] == null ? null : DateTime.parse(json["expiresAt"]),
        interestedCount: json["interestedCount"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        id: json["id"],
        counts: json["counts"] == null ? null : Counts.fromJson(json["counts"]),
        location: json["location"],
    );

    Map<String, dynamic> toJson() => {
        "authorType": authorType,
        "content": content,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "hasTip": hasTip,
        "status": status,
        "expiresAt": expiresAt?.toIso8601String(),
        "interestedCount": interestedCount,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "id": id,
        "counts": counts?.toJson(),
        "location": location,
    };
}

class Counts {
    int? interests;
    int? comments;
    int? gifts;

    Counts({
        this.interests,
        this.comments,
        this.gifts,
    });

    factory Counts.fromJson(Map<String, dynamic> json) => Counts(
        interests: json["interests"],
        comments: json["comments"],
        gifts: json["gifts"],
    );

    Map<String, dynamic> toJson() => {
        "interests": interests,
        "comments": comments,
        "gifts": gifts,
    };
}
