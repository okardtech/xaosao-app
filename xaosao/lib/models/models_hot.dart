// To parse this JSON data, do
//
//     final modelsHot = modelsHotFromJson(jsonString);

import 'dart:convert';

List<ModelsHot> modelsHotFromJson(String str) => List<ModelsHot>.from(json.decode(str).map((x) => ModelsHot.fromJson(x)));

String modelsHotToJson(List<ModelsHot> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelsHot {
    String id;
    String firstName;
    String? lastName;
    DateTime dob;
    String gender;
    String profile;
    int rating;
    int totalReview;
    String address;
    String availableStatus;
    DateTime updatedAt;
    List<ImageHot> images;
    Count count;
    int hotScore;
    String? bio;

    ModelsHot({
        required this.id,
        required this.firstName,
        this.lastName,
        required this.dob,
        required this.gender,
        required this.profile,
        required this.rating,
        required this.totalReview,
        required this.address,
        required this.availableStatus,
        required this.updatedAt,
        required this.images,
        required this.count,
        required this.hotScore,
        this.bio,
    });

    factory ModelsHot.fromJson(Map<String, dynamic> json) => ModelsHot(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: DateTime.parse(json["dob"]),
        gender: json["gender"],
        profile: json["profile"],
        rating: json["rating"],
        totalReview: json["total_review"],
        address: json["address"],
        availableStatus: json["available_status"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        images: List<ImageHot>.from(json["Images"].map((x) => ImageHot.fromJson(x))),
        count: Count.fromJson(json["_count"]),
        hotScore: json["hotScore"],
        bio: json["bio"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "dob": dob.toIso8601String(),
        "gender": gender,
        "profile": profile,
        "rating": rating,
        "total_review": totalReview,
        "address": address,
        "available_status": availableStatus,
        "updatedAt": updatedAt.toIso8601String(),
        "Images": List<dynamic>.from(images.map((x) => x.toJson())),
        "_count": count.toJson(),
        "hotScore": hotScore,
        "bio": bio,
    };
}

class Count {
    int customerInteractions;
    int review;

    Count({
        required this.customerInteractions,
        required this.review,
    });

    factory Count.fromJson(Map<String, dynamic> json) => Count(
        customerInteractions: json["customer_interactions"],
        review: json["Review"],
    );

    Map<String, dynamic> toJson() => {
        "customer_interactions": customerInteractions,
        "Review": review,
    };
}

class ImageHot {
    String id;
    String name;

    ImageHot({
        required this.id,
        required this.name,
    });

    factory ImageHot.fromJson(Map<String, dynamic> json) => ImageHot(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
