// To parse this JSON data, do
//
//     final packageHourModel = packageHourModelFromJson(jsonString);

import 'dart:convert';

PackageHourModel packageHourModelFromJson(String str) => PackageHourModel.fromJson(json.decode(str));

String packageHourModelToJson(PackageHourModel data) => json.encode(data.toJson());

class PackageHourModel {
    bool? canStart;
    bool? eligible;
    Plan? plan;

    PackageHourModel({
        this.canStart,
        this.eligible,
        this.plan,
    });

    PackageHourModel copyWith({
        bool? canStart,
        bool? eligible,
        Plan? plan,
    }) => 
        PackageHourModel(
            canStart: canStart ?? this.canStart,
            eligible: eligible ?? this.eligible,
            plan: plan ?? this.plan,
        );

    factory PackageHourModel.fromJson(Map<String, dynamic> json) => PackageHourModel(
        canStart: json["canStart"],
        eligible: json["eligible"],
        plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
    );

    Map<String, dynamic> toJson() => {
        "canStart": canStart,
        "eligible": eligible,
        "plan": plan?.toJson(),
    };
}

class Plan {
    String? id;
    String? name;
    String? description;
    int? price;
    int? durationDays;
    Features? features;
    String? status;
    bool? isPopular;
    DateTime? createdAt;

    Plan({
        this.id,
        this.name,
        this.description,
        this.price,
        this.durationDays,
        this.features,
        this.status,
        this.isPopular,
        this.createdAt,
    });

    Plan copyWith({
        String? id,
        String? name,
        String? description,
        int? price,
        int? durationDays,
        Features? features,
        String? status,
        bool? isPopular,
        DateTime? createdAt,
    }) => 
        Plan(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            price: price ?? this.price,
            durationDays: durationDays ?? this.durationDays,
            features: features ?? this.features,
            status: status ?? this.status,
            isPopular: isPopular ?? this.isPopular,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        durationDays: json["durationDays"],
        features: json["features"] == null ? null : Features.fromJson(json["features"]),
        status: json["status"],
        isPopular: json["isPopular"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
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
    };
}

class Features {
    String? chat;
    String? booking;
    String? support;

    Features({
        this.chat,
        this.booking,
        this.support,
    });

    Features copyWith({
        String? chat,
        String? booking,
        String? support,
    }) => 
        Features(
            chat: chat ?? this.chat,
            booking: booking ?? this.booking,
            support: support ?? this.support,
        );

    factory Features.fromJson(Map<String, dynamic> json) => Features(
        chat: json["chat"],
        booking: json["booking"],
        support: json["support"],
    );

    Map<String, dynamic> toJson() => {
        "chat": chat,
        "booking": booking,
        "support": support,
    };
}
