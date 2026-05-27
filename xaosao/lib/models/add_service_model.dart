// To parse this JSON data, do
//
//     final addServiceModel = addServiceModelFromJson(jsonString);

import 'dart:convert';

AddServiceModel addServiceModelFromJson(String str) => AddServiceModel.fromJson(json.decode(str));

String addServiceModelToJson(AddServiceModel data) => json.encode(data.toJson());

class AddServiceModel {
    String? id;
    String? serviceId;
    String? serviceName;
    int? customHourlyRate;

    AddServiceModel({
        this.id,
        this.serviceId,
        this.serviceName,
        this.customHourlyRate,
    });

    AddServiceModel copyWith({
        String? id,
        String? serviceId,
        String? serviceName,
        int? customHourlyRate,
    }) => 
        AddServiceModel(
            id: id ?? this.id,
            serviceId: serviceId ?? this.serviceId,
            serviceName: serviceName ?? this.serviceName,
            customHourlyRate: customHourlyRate ?? this.customHourlyRate,
        );

    factory AddServiceModel.fromJson(Map<String, dynamic> json) => AddServiceModel(
        id: json["id"],
        serviceId: json["serviceId"],
        serviceName: json["serviceName"],
        customHourlyRate: json["customHourlyRate"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "serviceId": serviceId,
        "serviceName": serviceName,
        "customHourlyRate": customHourlyRate,
    };
}
