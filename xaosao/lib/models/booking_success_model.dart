// To parse this JSON data, do
//
//     final bookingSuccessModel = bookingSuccessModelFromJson(jsonString);

import 'dart:convert';

BookingSuccessModel bookingSuccessModelFromJson(String str) => BookingSuccessModel.fromJson(json.decode(str));

String bookingSuccessModelToJson(BookingSuccessModel data) => json.encode(data.toJson());

class BookingSuccessModel {
    String? id;
    String? customerId;
    String? modelId;
    String? modelServiceId;
    String? status;
    String? paymentStatus;
    DateTime? startDate;
    dynamic endDate;
    int? price;
    int? hours;
    String? location;
    String? preferredAttire;
    bool? hasTip;
    DateTime? createdAt;
    Model? model;
    ModelService? modelService;

    BookingSuccessModel({
        this.id,
        this.customerId,
        this.modelId,
        this.modelServiceId,
        this.status,
        this.paymentStatus,
        this.startDate,
        this.endDate,
        this.price,
        this.hours,
        this.location,
        this.preferredAttire,
        this.hasTip,
        this.createdAt,
        this.model,
        this.modelService,
    });

    BookingSuccessModel copyWith({
        String? id,
        String? customerId,
        String? modelId,
        String? modelServiceId,
        String? status,
        String? paymentStatus,
        DateTime? startDate,
        dynamic endDate,
        int? price,
        int? hours,
        String? location,
        String? preferredAttire,
        bool? hasTip,
        DateTime? createdAt,
        Model? model,
        ModelService? modelService,
    }) => 
        BookingSuccessModel(
            id: id ?? this.id,
            customerId: customerId ?? this.customerId,
            modelId: modelId ?? this.modelId,
            modelServiceId: modelServiceId ?? this.modelServiceId,
            status: status ?? this.status,
            paymentStatus: paymentStatus ?? this.paymentStatus,
            startDate: startDate ?? this.startDate,
            endDate: endDate ?? this.endDate,
            price: price ?? this.price,
            hours: hours ?? this.hours,
            location: location ?? this.location,
            preferredAttire: preferredAttire ?? this.preferredAttire,
            hasTip: hasTip ?? this.hasTip,
            createdAt: createdAt ?? this.createdAt,
            model: model ?? this.model,
            modelService: modelService ?? this.modelService,
        );

    factory BookingSuccessModel.fromJson(Map<String, dynamic> json) => BookingSuccessModel(
        id: json["id"],
        customerId: json["customerId"],
        modelId: json["modelId"],
        modelServiceId: json["modelServiceId"],
        status: json["status"],
        paymentStatus: json["paymentStatus"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"],
        price: json["price"],
        hours: json["hours"],
        location: json["location"],
        preferredAttire: json["preferredAttire"],
        hasTip: json["hasTip"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        model: json["model"] == null ? null : Model.fromJson(json["model"]),
        modelService: json["modelService"] == null ? null : ModelService.fromJson(json["modelService"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customerId": customerId,
        "modelId": modelId,
        "modelServiceId": modelServiceId,
        "status": status,
        "paymentStatus": paymentStatus,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate,
        "price": price,
        "hours": hours,
        "location": location,
        "preferredAttire": preferredAttire,
        "hasTip": hasTip,
        "createdAt": createdAt?.toIso8601String(),
        "model": model?.toJson(),
        "modelService": modelService?.toJson(),
    };
}

class Model {
    String? id;
    String? firstName;
    String? profile;

    Model({
        this.id,
        this.firstName,
        this.profile,
    });

    Model copyWith({
        String? id,
        String? firstName,
        String? profile,
    }) => 
        Model(
            id: id ?? this.id,
            firstName: firstName ?? this.firstName,
            profile: profile ?? this.profile,
        );

    factory Model.fromJson(Map<String, dynamic> json) => Model(
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

class ModelService {
    String? id;
    int? customHourlyRate;
    Service? service;

    ModelService({
        this.id,
        this.customHourlyRate,
        this.service,
    });

    ModelService copyWith({
        String? id,
        int? customHourlyRate,
        Service? service,
    }) => 
        ModelService(
            id: id ?? this.id,
            customHourlyRate: customHourlyRate ?? this.customHourlyRate,
            service: service ?? this.service,
        );

    factory ModelService.fromJson(Map<String, dynamic> json) => ModelService(
        id: json["id"],
        customHourlyRate: json["customHourlyRate"],
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customHourlyRate": customHourlyRate,
        "service": service?.toJson(),
    };
}

class Service {
    String? id;
    String? name;
    String? billingType;

    Service({
        this.id,
        this.name,
        this.billingType,
    });

    Service copyWith({
        String? id,
        String? name,
        String? billingType,
    }) => 
        Service(
            id: id ?? this.id,
            name: name ?? this.name,
            billingType: billingType ?? this.billingType,
        );

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        billingType: json["billingType"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "billingType": billingType,
    };
}
