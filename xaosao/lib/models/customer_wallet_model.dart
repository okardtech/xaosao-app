// To parse this JSON data, do
//
//     final customerWalletModel = customerWalletModelFromJson(jsonString);

import 'dart:convert';

CustomerWalletModel customerWalletModelFromJson(String str) => CustomerWalletModel.fromJson(json.decode(str));

String customerWalletModelToJson(CustomerWalletModel data) => json.encode(data.toJson());

class CustomerWalletModel {
    int? availableBalance;
    int? pendingBalance;
    int? totalBalance;
    int? totalSpend;
    int? totalRefunded;
    String? currency;

    CustomerWalletModel({
        this.availableBalance,
        this.pendingBalance,
        this.totalBalance,
        this.totalSpend,
        this.totalRefunded,
        this.currency,
    });

    CustomerWalletModel copyWith({
        int? availableBalance,
        int? pendingBalance,
        int? totalBalance,
        int? totalSpend,
        int? totalRefunded,
        String? currency,
    }) => 
        CustomerWalletModel(
            availableBalance: availableBalance ?? this.availableBalance,
            pendingBalance: pendingBalance ?? this.pendingBalance,
            totalBalance: totalBalance ?? this.totalBalance,
            totalSpend: totalSpend ?? this.totalSpend,
            totalRefunded: totalRefunded ?? this.totalRefunded,
            currency: currency ?? this.currency,
        );

    factory CustomerWalletModel.fromJson(Map<String, dynamic> json) => CustomerWalletModel(
        availableBalance: json["available_balance"],
        pendingBalance: json["pending_balance"],
        totalBalance: json["total_balance"],
        totalSpend: json["total_spend"],
        totalRefunded: json["total_refunded"],
        currency: json["currency"],
    );

    Map<String, dynamic> toJson() => {
        "available_balance": availableBalance,
        "pending_balance": pendingBalance,
        "total_balance": totalBalance,
        "total_spend": totalSpend,
        "total_refunded": totalRefunded,
        "currency": currency,
    };
}
