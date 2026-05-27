// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

List<ReviewModel> reviewModelFromJson(String str) => List<ReviewModel>.from(json.decode(str).map((x) => ReviewModel.fromJson(x)));

String reviewModelToJson(List<ReviewModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewModel {
    String? id;
    int? rating;
    String? title;
    String? reviewText;
    bool? isAnonymous;
    Customer? customer;
    DateTime? createdAt;

    ReviewModel({
        this.id,
        this.rating,
        this.title,
        this.reviewText,
        this.isAnonymous,
        this.customer,
        this.createdAt,
    });

    ReviewModel copyWith({
        String? id,
        int? rating,
        String? title,
        String? reviewText,
        bool? isAnonymous,
        Customer? customer,
        DateTime? createdAt,
    }) => 
        ReviewModel(
            id: id ?? this.id,
            rating: rating ?? this.rating,
            title: title ?? this.title,
            reviewText: reviewText ?? this.reviewText,
            isAnonymous: isAnonymous ?? this.isAnonymous,
            customer: customer ?? this.customer,
            createdAt: createdAt ?? this.createdAt,
        );

    factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        rating: json["rating"],
        title: json["title"],
        reviewText: json["reviewText"],
        isAnonymous: json["isAnonymous"],
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "rating": rating,
        "title": title,
        "reviewText": reviewText,
        "isAnonymous": isAnonymous,
        "customer": customer?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
    };
}

class Customer {
    String? id;
    String? firstName;
    String? lastName;
    String? profile;

    Customer({
        this.id,
        this.firstName,
        this.lastName,
        this.profile,
    });

    Customer copyWith({
        String? id,
        String? firstName,
        String? lastName,
        String? profile,
    }) => 
        Customer(
            id: id ?? this.id,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            profile: profile ?? this.profile,
        );

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profile: json["profile"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "profile": profile,
    };
}
