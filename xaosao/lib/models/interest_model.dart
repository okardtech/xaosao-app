// To parse this JSON data, do
//
//     final interestModel = interestModelFromJson(jsonString);

import 'dart:convert';

List<InterestModel> interestModelFromJson(String str) => List<InterestModel>.from(json.decode(str).map((x) => InterestModel.fromJson(x)));

String interestModelToJson(List<InterestModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InterestModel {
    String? id;
    String? userType;
    DateTime? createdAt;
    User? user;

    InterestModel({
        this.id,
        this.userType,
        this.createdAt,
        this.user,
    });

    InterestModel copyWith({
        String? id,
        String? userType,
        DateTime? createdAt,
        User? user,
    }) => 
        InterestModel(
            id: id ?? this.id,
            userType: userType ?? this.userType,
            createdAt: createdAt ?? this.createdAt,
            user: user ?? this.user,
        );

    factory InterestModel.fromJson(Map<String, dynamic> json) => InterestModel(
        id: json["id"],
        userType: json["userType"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userType": userType,
        "createdAt": createdAt?.toIso8601String(),
        "user": user?.toJson(),
    };
}

class User {
    String? id;
    String? firstName;
    String? lastName;
    String? profile;

    User({
        this.id,
        this.firstName,
        this.lastName,
        this.profile,
    });

    User copyWith({
        String? id,
        String? firstName,
        String? lastName,
        String? profile,
    }) => 
        User(
            id: id ?? this.id,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            profile: profile ?? this.profile,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
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
