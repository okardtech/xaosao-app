// To parse this JSON data, do
//
//     final myFeedbackModel = myFeedbackModelFromJson(jsonString);

import 'dart:convert';

List<MyFeedbackModel> myFeedbackModelFromJson(String str) => List<MyFeedbackModel>.from(json.decode(str).map((x) => MyFeedbackModel.fromJson(x)));

String myFeedbackModelToJson(List<MyFeedbackModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyFeedbackModel {
    String? id;
    String? subject;
    String? description;
    String? status;
    DateTime? createdAt;

    MyFeedbackModel({
        this.id,
        this.subject,
        this.description,
        this.status,
        this.createdAt,
    });

    MyFeedbackModel copyWith({
        String? id,
        String? subject,
        String? description,
        String? status,
        DateTime? createdAt,
    }) => 
        MyFeedbackModel(
            id: id ?? this.id,
            subject: subject ?? this.subject,
            description: description ?? this.description,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
        );

    factory MyFeedbackModel.fromJson(Map<String, dynamic> json) => MyFeedbackModel(
        id: json["id"],
        subject: json["subject"],
        description: json["description"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "subject": subject,
        "description": description,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
    };
}
