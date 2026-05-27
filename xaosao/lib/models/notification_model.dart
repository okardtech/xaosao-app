// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    bool? pushEnabled;
    bool? emailEnabled;
    bool? smsEnabled;
    bool? whatsappEnabled;

    NotificationModel({
        this.pushEnabled,
        this.emailEnabled,
        this.smsEnabled,
        this.whatsappEnabled,
    });

    NotificationModel copyWith({
        bool? pushEnabled,
        bool? emailEnabled,
        bool? smsEnabled,
        bool? whatsappEnabled,
    }) => 
        NotificationModel(
            pushEnabled: pushEnabled ?? this.pushEnabled,
            emailEnabled: emailEnabled ?? this.emailEnabled,
            smsEnabled: smsEnabled ?? this.smsEnabled,
            whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
        );

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        pushEnabled: json["push_enabled"],
        emailEnabled: json["email_enabled"],
        smsEnabled: json["sms_enabled"],
        whatsappEnabled: json["whatsapp_enabled"],
    );

    Map<String, dynamic> toJson() => {
        "push_enabled": pushEnabled,
        "email_enabled": emailEnabled,
        "sms_enabled": smsEnabled,
        "whatsapp_enabled": whatsappEnabled,
    };
}
