// To parse this JSON data, do
//
//     final topUpModel = topUpModelFromJson(jsonString);

import 'dart:convert';

TopUpModel topUpModelFromJson(String str) => TopUpModel.fromJson(json.decode(str));

String topUpModelToJson(TopUpModel data) => json.encode(data.toJson());

class TopUpModel {
    String? id;
    String? identifier;
    int? amount;
    List<String>? paymentSlip;
    String? status;
    int? comission;
    int? fee;
    String? customerId;
    DateTime? createdAt;
    DateTime? updatedAt;

    TopUpModel({
        this.id,
        this.identifier,
        this.amount,
        this.paymentSlip,
        this.status,
        this.comission,
        this.fee,
        this.customerId,
        this.createdAt,
        this.updatedAt,
    });

    TopUpModel copyWith({
        String? id,
        String? identifier,
        int? amount,
        List<String>? paymentSlip,
        String? status,
        int? comission,
        int? fee,
        String? customerId,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        TopUpModel(
            id: id ?? this.id,
            identifier: identifier ?? this.identifier,
            amount: amount ?? this.amount,
            paymentSlip: paymentSlip ?? this.paymentSlip,
            status: status ?? this.status,
            comission: comission ?? this.comission,
            fee: fee ?? this.fee,
            customerId: customerId ?? this.customerId,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory TopUpModel.fromJson(Map<String, dynamic> json) => TopUpModel(
        id: json["id"],
        identifier: json["identifier"],
        amount: json["amount"],
        paymentSlip: json["paymentSlip"] == null ? [] : List<String>.from(json["paymentSlip"]!.map((x) => x)),
        status: json["status"],
        comission: json["comission"],
        fee: json["fee"],
        customerId: json["customerId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
        "amount": amount,
        "paymentSlip": paymentSlip == null ? [] : List<dynamic>.from(paymentSlip!.map((x) => x)),
        "status": status,
        "comission": comission,
        "fee": fee,
        "customerId": customerId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
