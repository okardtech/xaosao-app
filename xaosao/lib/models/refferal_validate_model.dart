// To parse this JSON data, do
//
//     final referralValidateModel = referralValidateModelFromJson(jsonString);

import 'dart:convert';

ReferralValidateModel referralValidateModelFromJson(String str) => ReferralValidateModel.fromJson(json.decode(str));

String referralValidateModelToJson(ReferralValidateModel data) => json.encode(data.toJson());

class ReferralValidateModel {
    bool? valid;
    String? codeType;
    Referrer? referrer;

    ReferralValidateModel({
        this.valid,
        this.codeType,
        this.referrer,
    });

    factory ReferralValidateModel.fromJson(Map<String, dynamic> json) => ReferralValidateModel(
        valid: json["valid"],
        codeType: json["codeType"],
        referrer: json["referrer"] == null ? null : Referrer.fromJson(json["referrer"]),
    );

    Map<String, dynamic> toJson() => {
        "valid": valid,
        "codeType": codeType,
        "referrer": referrer?.toJson(),
    };
}

class Referrer {
    String? id;
    String? firstName;
    String? profile;

    Referrer({
        this.id,
        this.firstName,
        this.profile,
    });

    factory Referrer.fromJson(Map<String, dynamic> json) => Referrer(
        id: json["id"],
        firstName: json["firstName"],
        profile: json["profile"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "profile": profile,
    };
}
