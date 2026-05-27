// To parse this JSON data, do
//
//     final modelWalletModel = modelWalletModelFromJson(jsonString);

import 'dart:convert';

ModelWalletModel modelWalletModelFromJson(String str) => ModelWalletModel.fromJson(json.decode(str));

String modelWalletModelToJson(ModelWalletModel data) => json.encode(data.toJson());

class ModelWalletModel {
    String? currency;
    int? totalBalance;
    int? totalPending;
    int? totalWithdraw;
    int? totalIncome;
    int? withdrawableBalance;
    int? minimumWithdrawal;
    bool? canWithdraw;

    ModelWalletModel({
        this.currency,
        this.totalBalance,
        this.totalPending,
        this.totalWithdraw,
        this.totalIncome,
        this.withdrawableBalance,
        this.minimumWithdrawal,
        this.canWithdraw,
    });

    ModelWalletModel copyWith({
        String? currency,
        int? totalBalance,
        int? totalPending,
        int? totalWithdraw,
        int? totalIncome,
        int? withdrawableBalance,
        int? minimumWithdrawal,
        bool? canWithdraw,
    }) => 
        ModelWalletModel(
            currency: currency ?? this.currency,
            totalBalance: totalBalance ?? this.totalBalance,
            totalPending: totalPending ?? this.totalPending,
            totalWithdraw: totalWithdraw ?? this.totalWithdraw,
            totalIncome: totalIncome ?? this.totalIncome,
            withdrawableBalance: withdrawableBalance ?? this.withdrawableBalance,
            minimumWithdrawal: minimumWithdrawal ?? this.minimumWithdrawal,
            canWithdraw: canWithdraw ?? this.canWithdraw,
        );

    factory ModelWalletModel.fromJson(Map<String, dynamic> json) => ModelWalletModel(
        currency: json["currency"],
        totalBalance: json["totalBalance"],
        totalPending: json["totalPending"],
        totalWithdraw: json["totalWithdraw"],
        totalIncome: json["totalIncome"],
        withdrawableBalance: json["withdrawableBalance"],
        minimumWithdrawal: json["minimumWithdrawal"],
        canWithdraw: json["canWithdraw"],
    );

    Map<String, dynamic> toJson() => {
        "currency": currency,
        "totalBalance": totalBalance,
        "totalPending": totalPending,
        "totalWithdraw": totalWithdraw,
        "totalIncome": totalIncome,
        "withdrawableBalance": withdrawableBalance,
        "minimumWithdrawal": minimumWithdrawal,
        "canWithdraw": canWithdraw,
    };
}
