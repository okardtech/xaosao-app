// To parse this JSON data, do
//
//     final packageActiveModel = packageActiveModelFromJson(jsonString);

import 'dart:convert';

PackageActiveModel packageActiveModelFromJson(String str) => PackageActiveModel.fromJson(json.decode(str));

String packageActiveModelToJson(PackageActiveModel data) => json.encode(data.toJson());

class PackageActiveModel {
    bool? hasActiveSubscription;
    bool? hasPendingSubscription;

    PackageActiveModel({
        this.hasActiveSubscription,
        this.hasPendingSubscription,
    });

    PackageActiveModel copyWith({
        bool? hasActiveSubscription,
        bool? hasPendingSubscription,
    }) => 
        PackageActiveModel(
            hasActiveSubscription: hasActiveSubscription ?? this.hasActiveSubscription,
            hasPendingSubscription: hasPendingSubscription ?? this.hasPendingSubscription,
        );

    factory PackageActiveModel.fromJson(Map<String, dynamic> json) => PackageActiveModel(
        hasActiveSubscription: json["hasActiveSubscription"],
        hasPendingSubscription: json["hasPendingSubscription"],
    );

    Map<String, dynamic> toJson() => {
        "hasActiveSubscription": hasActiveSubscription,
        "hasPendingSubscription": hasPendingSubscription,
    };
}
