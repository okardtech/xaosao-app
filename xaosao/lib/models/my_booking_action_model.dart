// To parse this JSON data, do
//
//     final myBookingActionModel = myBookingActionModelFromJson(jsonString);

import 'dart:convert';

MyBookingActionModel myBookingActionModelFromJson(String str) => MyBookingActionModel.fromJson(json.decode(str));

String myBookingActionModelToJson(MyBookingActionModel data) => json.encode(data.toJson());

class MyBookingActionModel {
    String? id;
    String? status;
    String? paymentStatus;

    MyBookingActionModel({
        this.id,
        this.status,
        this.paymentStatus,
    });

    MyBookingActionModel copyWith({
        String? id,
        String? status,
        String? paymentStatus,
    }) => 
        MyBookingActionModel(
            id: id ?? this.id,
            status: status ?? this.status,
            paymentStatus: paymentStatus ?? this.paymentStatus,
        );

    factory MyBookingActionModel.fromJson(Map<String, dynamic> json) => MyBookingActionModel(
        id: json["id"],
        status: json["status"],
        paymentStatus: json["paymentStatus"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "paymentStatus": paymentStatus,
    };
}
