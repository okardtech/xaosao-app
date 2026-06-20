// To parse this JSON data, do
//
//     final packageActiveModel = packageActiveModelFromJson(jsonString);

import 'dart:convert';

PackageActiveModel packageActiveModelFromJson(String str) => PackageActiveModel.fromJson(json.decode(str));

String packageActiveModelToJson(PackageActiveModel data) => json.encode(data.toJson());

class PackageActiveModel {
    bool? hasActiveSubscription;
    bool? hasPendingSubscription;
    bool? neverSubscribed;

    PackageActiveModel({
        this.hasActiveSubscription,
        this.hasPendingSubscription,
        this.neverSubscribed,
    });

    PackageActiveModel copyWith({
        bool? hasActiveSubscription,
        bool? hasPendingSubscription,
        bool? neverSubscribed,
    }) => 
        PackageActiveModel(
            hasActiveSubscription: hasActiveSubscription ?? this.hasActiveSubscription,
            hasPendingSubscription: hasPendingSubscription ?? this.hasPendingSubscription,
            neverSubscribed: neverSubscribed ?? this.neverSubscribed,
        );

    factory PackageActiveModel.fromJson(Map<String, dynamic> json) => PackageActiveModel(
        hasActiveSubscription: json["hasActiveSubscription"],
        hasPendingSubscription: json["hasPendingSubscription"],
        neverSubscribed: json["neverSubscribed"]
    );

    Map<String, dynamic> toJson() => {
        "hasActiveSubscription": hasActiveSubscription,
        "hasPendingSubscription": hasPendingSubscription,
        "neverSubscribed":neverSubscribed
    };
}
