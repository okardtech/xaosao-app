// To parse this JSON data, do
//
//     final comissionModel = comissionModelFromJson(jsonString);

import 'dart:convert';

List<ComissionModel> comissionModelFromJson(String str) =>
    List<ComissionModel>.from(
        json.decode(str).map((x) => ComissionModel.fromJson(x)));

String comissionModelToJson(List<ComissionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ComissionModel {
  String? id;
  String? identifier;
  double? amount;
  double? comission;
  double? fee;
  String? status;
  String? reason;
  String? modelId;
  String? createdAt;
  String? updatedAt;

  ComissionModel({
    this.id,
    this.identifier,
    this.amount,
    this.comission,
    this.fee,
    this.status,
    this.reason,
    this.modelId,
    this.createdAt,
    this.updatedAt,
  });

  factory ComissionModel.fromJson(Map<String, dynamic> json) => ComissionModel(
        id: json["id"],
        identifier: json["identifier"],
        amount: _toDouble(json["amount"]),
        comission: _toDouble(json["comission"]),
        fee: _toDouble(json["fee"]),
        status: json["status"],
        reason: json["reason"],
        modelId: json["modelId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
        "amount": amount,
        "comission": comission,
        "fee": fee,
        "status": status,
        "reason": reason,
        "modelId": modelId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

// Numeric fields can arrive as int, double, or a string ("50000" / "50000.0")
// depending on the backend serializer. Coerce everything to double so the UI
// layer only ever sees one shape.
double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}
