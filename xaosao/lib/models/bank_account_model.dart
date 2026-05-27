// To parse this JSON data, do
//
//     final bankAccountModel = bankAccountModelFromJson(jsonString);

import 'dart:convert';

List<BankAccountModel> bankAccountModelFromJson(String str) =>
    List<BankAccountModel>.from(
      json.decode(str).map((x) => BankAccountModel.fromJson(x)),
    );

String bankAccountModelToJson(List<BankAccountModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BankAccountModel {
  String? id;
  String? qrCode;
  String? bankAccountName;
  bool? isDefault;
  String? status;

  BankAccountModel({
    this.id,
    this.qrCode,
    this.bankAccountName,
    this.isDefault,
    this.status,
  });

  BankAccountModel copyWith({
    String? id,
    String? qrCode,
    String? bankAccountName,
    bool? isDefault,
    String? status,
  }) => BankAccountModel(
    id: id ?? this.id,
    qrCode: qrCode ?? this.qrCode,
    bankAccountName: bankAccountName ?? this.bankAccountName,
    isDefault: isDefault ?? this.isDefault,
    status: status ?? this.status,
  );

  factory BankAccountModel.fromJson(Map<String, dynamic> json) =>
      BankAccountModel(
        id: json["id"],
        qrCode: json["qr_code"],
        bankAccountName: json["bank_account_name"],
        isDefault: json["isDefault"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "qr_code": qrCode,
    "bank_account_name": bankAccountName,
    "isDefault": isDefault,
    "status": status,
  };
}
