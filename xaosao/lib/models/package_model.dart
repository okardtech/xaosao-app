// To parse this JSON data, do
//
//     final packageModel = packageModelFromJson(jsonString);

import 'dart:convert';

PackageModel packageModelFromJson(String str) => PackageModel.fromJson(json.decode(str));

String packageModelToJson(PackageModel data) => json.encode(data.toJson());

class PackageModel {
    List<PackageData>? data;
    CurrentSubscriptionPlan? currentSubscriptionPlan;

    PackageModel({
        this.data,
        this.currentSubscriptionPlan,
    });

    PackageModel copyWith({
        List<PackageData>? data,
        CurrentSubscriptionPlan? currentSubscriptionPlan,
    }) => 
        PackageModel(
            data: data ?? this.data,
            currentSubscriptionPlan: currentSubscriptionPlan ?? this.currentSubscriptionPlan,
        );

    factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        data: json["data"] == null ? [] : List<PackageData>.from(json["data"]!.map((x) => PackageData.fromJson(x))),
        currentSubscriptionPlan: json["currentSubscriptionPlan"] == null ? null : CurrentSubscriptionPlan.fromJson(json["currentSubscriptionPlan"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "currentSubscriptionPlan": currentSubscriptionPlan?.toJson(),
    };
}

class CurrentSubscriptionPlan {
    String? id;
    String? name;
    String? status;
    DateTime? endDate;
    int? daysRemaining;

    CurrentSubscriptionPlan({
        this.id,
        this.name,
        this.status,
        this.endDate,
        this.daysRemaining,
    });

    CurrentSubscriptionPlan copyWith({
        String? id,
        String? name,
        String? status,
        DateTime? endDate,
        int? daysRemaining,
    }) =>
        CurrentSubscriptionPlan(
            id: id ?? this.id,
            name: name ?? this.name,
            status: status ?? this.status,
            endDate: endDate ?? this.endDate,
            daysRemaining: daysRemaining ?? this.daysRemaining,
        );

    factory CurrentSubscriptionPlan.fromJson(Map<String, dynamic> json) => CurrentSubscriptionPlan(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        daysRemaining: json["daysRemaining"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "endDate": endDate?.toIso8601String(),
        "daysRemaining": daysRemaining,
    };
}

class PackageData {
    String? id;
    String? name;
    String? description;
    int? price;
    int? durationDays;
    Features? features;
    String? status;
    bool? isPopular;
    DateTime? createdAt;
    bool? current;

    PackageData({
        this.id,
        this.name,
        this.description,
        this.price,
        this.durationDays,
        this.features,
        this.status,
        this.isPopular,
        this.createdAt,
        this.current,
    });

    PackageData copyWith({
        String? id,
        String? name,
        String? description,
        int? price,
        int? durationDays,
        Features? features,
        String? status,
        bool? isPopular,
        DateTime? createdAt,
        bool? current,
    }) => 
        PackageData(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            price: price ?? this.price,
            durationDays: durationDays ?? this.durationDays,
            features: features ?? this.features,
            status: status ?? this.status,
            isPopular: isPopular ?? this.isPopular,
            createdAt: createdAt ?? this.createdAt,
            current: current ?? this.current,
        );

    factory PackageData.fromJson(Map<String, dynamic> json) => PackageData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        durationDays: json["durationDays"],
        features: json["features"] == null ? null : Features.fromJson(json["features"]),
        status: json["status"],
        isPopular: json["isPopular"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        current: json["current"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "durationDays": durationDays,
        "features": features?.toJson(),
        "status": status,
        "isPopular": isPopular,
        "createdAt": createdAt?.toIso8601String(),
        "current": current,
    };
}

class Features {
    String? feature1;
    String? feature2;
    String? feature3;
    String? feature4;
    String? feature5;
    String? feature6;
    String? feature7;
    String? feature8;

    Features({
        this.feature1,
        this.feature2,
        this.feature3,
        this.feature4,
        this.feature5,
        this.feature6,
        this.feature7,
        this.feature8,
    });

    Features copyWith({
        String? feature1,
        String? feature2,
        String? feature3,
        String? feature4,
        String? feature5,
        String? feature6,
        String? feature7,
        String? feature8,
    }) => 
        Features(
            feature1: feature1 ?? this.feature1,
            feature2: feature2 ?? this.feature2,
            feature3: feature3 ?? this.feature3,
            feature4: feature4 ?? this.feature4,
            feature5: feature5 ?? this.feature5,
            feature6: feature6 ?? this.feature6,
            feature7: feature7 ?? this.feature7,
            feature8: feature8 ?? this.feature8,
        );

    factory Features.fromJson(Map<String, dynamic> json) => Features(
        feature1: json["feature_1"],
        feature2: json["feature_2"],
        feature3: json["feature_3"],
        feature4: json["feature_4"],
        feature5: json["feature_5"],
        feature6: json["feature_6"],
        feature7: json["feature_7"],
        feature8: json["feature_8"],
    );

    Map<String, dynamic> toJson() => {
        "feature_1": feature1,
        "feature_2": feature2,
        "feature_3": feature3,
        "feature_4": feature4,
        "feature_5": feature5,
        "feature_6": feature6,
        "feature_7": feature7,
        "feature_8": feature8,
    };
}
