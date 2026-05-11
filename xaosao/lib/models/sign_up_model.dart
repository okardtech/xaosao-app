// To parse this JSON data, do
//
//     final signUpModel = signUpModelFromJson(jsonString);

import 'dart:convert';

SignUpModel signUpModelFromJson(String str) =>
    SignUpModel.fromJson(json.decode(str));

String signUpModelToJson(SignUpModel data) => json.encode(data.toJson());

class SignUpModel {
  String token;
  String? refreshToken;
  bool requiresPhoneVerification;

  SignUpModel({
    required this.token,
    required this.refreshToken,
    required this.requiresPhoneVerification,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
    token: json["token"],
    refreshToken: json["refreshToken"],
    requiresPhoneVerification: json["requiresPhoneVerification"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "refreshToken": refreshToken,
    "requiresPhoneVerification": requiresPhoneVerification,
  };
}
