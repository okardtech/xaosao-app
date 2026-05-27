// To parse this JSON data, do
//
//     final feeModel = feeModelFromJson(jsonString);

import 'dart:convert';

List<FeeModel> feeModelFromJson(String str) => List<FeeModel>.from(json.decode(str).map((x) => FeeModel.fromJson(x)));

String feeModelToJson(List<FeeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeeModel {
    String? id;
    String? authorType;
    String? content;
    List<String>? images;
    bool? hasTip;
    String? status;
    DateTime? expiresAt;
    int? interestedCount;
    int? commentCount;
    int? giftCount;
    bool? isInterested;
    DateTime? createdAt;
    DateTime? updatedAt;
    Author? author;
    Service? service;
    String? location;
    String? targetGender;

    FeeModel({
        this.id,
        this.authorType,
        this.content,
        this.images,
        this.hasTip,
        this.status,
        this.expiresAt,
        this.interestedCount,
        this.commentCount,
        this.giftCount,
        this.isInterested,
        this.createdAt,
        this.updatedAt,
        this.author,
        this.service,
        this.location,
        this.targetGender,
    });

    factory FeeModel.fromJson(Map<String, dynamic> json) => FeeModel(
        id: json["id"],
        authorType: json["authorType"],
        content: json["content"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        hasTip: json["hasTip"],
        status: json["status"],
        expiresAt: json["expiresAt"] == null ? null : DateTime.parse(json["expiresAt"]),
        interestedCount: json["interestedCount"],
        commentCount: json["commentCount"],
        giftCount: json["giftCount"],
        isInterested: json["isInterested"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        location: json["location"],
        targetGender: json["targetGender"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "authorType": authorType,
        "content": content,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "hasTip": hasTip,
        "status": status,
        "expiresAt": expiresAt?.toIso8601String(),
        "interestedCount": interestedCount,
        "commentCount": commentCount,
        "giftCount": giftCount,
        "isInterested": isInterested,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "author": author?.toJson(),
        "service": service?.toJson(),
        "location": location,
        "targetGender": targetGender,
    };
}

class Author {
    String? id;
    String? firstName;
    String? lastName;
    String? profile;
    String? gender;
    int? whatsapp;

    Author({
        this.id,
        this.firstName,
        this.lastName,
        this.profile,
        this.gender,
        this.whatsapp,
    });

    factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profile: json["profile"],
        gender: json["gender"],
        whatsapp: json["whatsapp"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "profile": profile,
        "gender": gender,
        "whatsapp": whatsapp,
    };
}

class Service {
    String? id;
    String? name;

    Service({
        this.id,
        this.name,
    });

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
