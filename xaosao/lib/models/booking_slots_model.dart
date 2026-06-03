// To parse this JSON data, do
//
//     final bookedSlotsModel = bookedSlotsModelFromJson(jsonString);

import 'dart:convert';

List<BookedSlotsModel> bookedSlotsModelFromJson(String str) => List<BookedSlotsModel>.from(json.decode(str).map((x) => BookedSlotsModel.fromJson(x)));

String bookedSlotsModelToJson(List<BookedSlotsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookedSlotsModel {
    String? id;
    DateTime? startDate;
    DateTime? endDate;
    int? hours;
    dynamic dayAmount;
    dynamic minutes;
    dynamic sessionType;
    String? status;

    BookedSlotsModel({
        this.id,
        this.startDate,
        this.endDate,
        this.hours,
        this.dayAmount,
        this.minutes,
        this.sessionType,
        this.status,
    });

    factory BookedSlotsModel.fromJson(Map<String, dynamic> json) => BookedSlotsModel(
        id: json["id"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        hours: json["hours"],
        dayAmount: json["dayAmount"],
        minutes: json["minutes"],
        sessionType: json["sessionType"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "hours": hours,
        "dayAmount": dayAmount,
        "minutes": minutes,
        "sessionType": sessionType,
        "status": status,
    };
}
