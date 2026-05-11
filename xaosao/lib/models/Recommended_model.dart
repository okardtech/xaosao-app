// To parse this JSON data, do
//
//     final recommendedModel = recommendedModelFromJson(jsonString);

import 'dart:convert';

List<RecommendedModel> recommendedModelFromJson(String str) => List<RecommendedModel>.from(json.decode(str).map((x) => RecommendedModel.fromJson(x)));

String recommendedModelToJson(List<RecommendedModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecommendedModel {
    String? id;
    String? firstName;
    String? lastName;
    DateTime? dob;
    String? gender;
    String? bio;
    String? profile;
    List<String>? images;
    double? latitude;
    double? longitude;
    int? rating;
    int? totalReview;
    String? status;
    String? availableStatus;
    DateTime? createdAt;
    bool? vip;

    RecommendedModel({
        this.id,
        this.firstName,
        this.lastName,
        this.dob,
        this.gender,
        this.bio,
        this.profile,
        this.images,
        this.latitude,
        this.longitude,
        this.rating,
        this.totalReview,
        this.status,
        this.availableStatus,
        this.createdAt,
        this.vip,
    });

    factory RecommendedModel.fromJson(Map<String, dynamic> json) => RecommendedModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        gender: json["gender"],
        bio: json["bio"],
        profile: json["profile"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        rating: json["rating"],
        totalReview: json["total_review"],
        status: json["status"],
        availableStatus: json["available_status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        vip: json["vip"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "dob": dob?.toIso8601String(),
        "gender": gender,
        "bio": bio,
        "profile": profile,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "latitude": latitude,
        "longitude": longitude,
        "rating": rating,
        "total_review": totalReview,
        "status": status,
        "available_status": availableStatus,
        "createdAt": createdAt?.toIso8601String(),
        "vip": vip,
    };
}
