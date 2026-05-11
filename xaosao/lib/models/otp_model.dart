// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
    String? message;
    int? expiresIn;

    OtpModel({
        this.message,
        this.expiresIn,
    });

    OtpModel copyWith({
        String? message,
        int? expiresIn,
    }) => 
        OtpModel(
            message: message ?? this.message,
            expiresIn: expiresIn ?? this.expiresIn,
        );

    factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        message: json["message"],
        expiresIn: json["expiresIn"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "expiresIn": expiresIn,
    };
}
