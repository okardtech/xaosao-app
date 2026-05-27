// To parse this JSON data, do
//
//     final transactionsModel = transactionsModelFromJson(jsonString);

import 'dart:convert';

List<TransactionsModel> transactionsModelFromJson(String str) => List<TransactionsModel>.from(json.decode(str).map((x) => TransactionsModel.fromJson(x)));

String transactionsModelToJson(List<TransactionsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionsModel {
    String? id;
    String? identifier;
    int? amount;
    List<String>? paymentSlip;
    String? status;
    int? comission;
    int? fee;
    String? reason;
    String? customerId;
    dynamic modelId;
    DateTime? createdAt;
    DateTime? updatedAt;

    TransactionsModel({
        this.id,
        this.identifier,
        this.amount,
        this.paymentSlip,
        this.status,
        this.comission,
        this.fee,
        this.reason,
        this.customerId,
        this.modelId,
        this.createdAt,
        this.updatedAt,
    });

    TransactionsModel copyWith({
        String? id,
        String? identifier,
        int? amount,
        List<String>? paymentSlip,
        String? status,
        int? comission,
        int? fee,
        String? reason,
        String? customerId,
        dynamic modelId,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        TransactionsModel(
            id: id ?? this.id,
            identifier: identifier ?? this.identifier,
            amount: amount ?? this.amount,
            paymentSlip: paymentSlip ?? this.paymentSlip,
            status: status ?? this.status,
            comission: comission ?? this.comission,
            fee: fee ?? this.fee,
            reason: reason ?? this.reason,
            customerId: customerId ?? this.customerId,
            modelId: modelId ?? this.modelId,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory TransactionsModel.fromJson(Map<String, dynamic> json) => TransactionsModel(
        id: json["id"],
        identifier: json["identifier"],
        amount: json["amount"],
        paymentSlip: json["paymentSlip"] == null ? [] : List<String>.from(json["paymentSlip"]!.map((x) => x)),
        status: json["status"],
        comission: json["comission"],
        fee: json["fee"],
        reason: json["reason"],
        customerId: json["customerId"],
        modelId: json["modelId"],
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
        "reason": reason,
        "customerId": customerId,
        "modelId": modelId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
