import 'dart:convert';

ModelWalletModel modelWalletModelFromJson(String str) =>
    ModelWalletModel.fromJson(json.decode(str));

String modelWalletModelToJson(ModelWalletModel data) =>
    json.encode(data.toJson());

class ModelWalletModel {
  String? currency;
  double? totalBalance;
  double? totalPending;
  double? totalWithdraw;
  double? totalIncome;
  double? totalAvailable;
  double? pendingWithdrawals;
  double? withdrawableBalance;
  double? minimumWithdrawal;
  bool? canWithdraw;

  ModelWalletModel({
    this.currency,
    this.totalBalance,
    this.totalPending,
    this.totalWithdraw,
    this.totalIncome,
    this.totalAvailable,
    this.withdrawableBalance,
    this.minimumWithdrawal,
    this.canWithdraw,
    this.pendingWithdrawals,
  });

  ModelWalletModel copyWith({
    String? currency,
    double? totalBalance,
    double? totalPending,
    double? totalWithdraw,
    double? totalIncome,
    double? totalAvailable,
    double? withdrawableBalance,
    double? minimumWithdrawal,
    bool? canWithdraw,
    double? pendingWithdrawals,
  }) => ModelWalletModel(
    currency: currency ?? this.currency,
    totalBalance: totalBalance ?? this.totalBalance,
    totalPending: totalPending ?? this.totalPending,
    totalWithdraw: totalWithdraw ?? this.totalWithdraw,
    totalIncome: totalIncome ?? this.totalIncome,
    totalAvailable: totalAvailable ?? this.totalAvailable,
    withdrawableBalance: withdrawableBalance ?? this.withdrawableBalance,
    minimumWithdrawal: minimumWithdrawal ?? this.minimumWithdrawal,
    canWithdraw: canWithdraw ?? this.canWithdraw,
    pendingWithdrawals: pendingWithdrawals ?? this.pendingWithdrawals,
  );

  factory ModelWalletModel.fromJson(Map<String, dynamic> json) =>
      ModelWalletModel(
        currency: json["currency"] as String?,
        totalBalance: (json["totalBalance"] as num?)?.toDouble(),
        totalPending: (json["totalPending"] as num?)?.toDouble(),
        totalWithdraw: (json["totalWithdraw"] as num?)?.toDouble(),
        totalIncome: (json["totalIncome"] as num?)?.toDouble(),
        totalAvailable: (json["totalAvailable"] as num?)?.toDouble(),
        withdrawableBalance: (json["withdrawableBalance"] as num?)?.toDouble(),
        minimumWithdrawal: (json["minimumWithdrawal"] as num?)?.toDouble(),
        canWithdraw: json["canWithdraw"] as bool?,
        pendingWithdrawals: (json["pendingWithdrawals"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "currency": currency,
    "totalBalance": totalBalance,
    "totalPending": totalPending,
    "totalWithdraw": totalWithdraw,
    "totalIncome": totalIncome,
    "totalAvailable": totalAvailable,
    "withdrawableBalance": withdrawableBalance,
    "minimumWithdrawal": minimumWithdrawal,
    "canWithdraw": canWithdraw,
    "pendingWithdrawals": pendingWithdrawals,
  };
}
