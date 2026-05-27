// To parse this JSON data, do
//
//     final packageHistoryModel = packageHistoryModelFromJson(jsonString);

import 'dart:convert';

List<PackageHistoryModel> packageHistoryModelFromJson(String str) => List<PackageHistoryModel>.from(json.decode(str).map((x) => PackageHistoryModel.fromJson(x)));

String packageHistoryModelToJson(List<PackageHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PackageHistoryModel {
    String? id;
    String? planName;
    int? planPrice;
    int? durationDays;
    DateTime? startDate;
    DateTime? endDate;
    String? paymentMethod;
    String? status;
    DateTime? createdAt;

    PackageHistoryModel({
        this.id,
        this.planName,
        this.planPrice,
        this.durationDays,
        this.startDate,
        this.endDate,
        this.paymentMethod,
        this.status,
        this.createdAt,
    });

    PackageHistoryModel copyWith({
        String? id,
        String? planName,
        int? planPrice,
        int? durationDays,
        DateTime? startDate,
        DateTime? endDate,
        String? paymentMethod,
        String? status,
        DateTime? createdAt,
    }) => 
        PackageHistoryModel(
            id: id ?? this.id,
            planName: planName ?? this.planName,
            planPrice: planPrice ?? this.planPrice,
            durationDays: durationDays ?? this.durationDays,
            startDate: startDate ?? this.startDate,
            endDate: endDate ?? this.endDate,
            paymentMethod: paymentMethod ?? this.paymentMethod,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
        );

    factory PackageHistoryModel.fromJson(Map<String, dynamic> json) => PackageHistoryModel(
        id: json["id"],
        planName: json["planName"],
        planPrice: json["planPrice"],
        durationDays: json["durationDays"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        paymentMethod: json["paymentMethod"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "planName": planName,
        "planPrice": planPrice,
        "durationDays": durationDays,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "paymentMethod": paymentMethod,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
    };
}
