// To parse this JSON data, do
//
//     final myBookingModel = myBookingModelFromJson(jsonString);

import 'dart:convert';

List<MyBookingModel> myBookingModelFromJson(String str) =>
    List<MyBookingModel>.from(
      json.decode(str).map((x) => MyBookingModel.fromJson(x)),
    );

String myBookingModelToJson(List<MyBookingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyBookingModel {
  String? id;
  int? price;
  int? dayAmount;
  int? hours;
  dynamic sessionType;
  String? location;
  dynamic locationLat;
  dynamic locationLng;
  String? preferredAttire;
  DateTime? startDate;
  DateTime? endDate;
  String? status;
  String? paymentStatus;
  bool? hasTip;
  dynamic minutes;
  Model? model;
  Customer? customer;
  ModelService? modelService;
  bool? customerHidden;
  bool? modelHidden;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isContact;

  MyBookingModel({
    this.id,
    this.price,
    this.dayAmount,
    this.hours,
    this.sessionType,
    this.location,
    this.locationLat,
    this.locationLng,
    this.preferredAttire,
    this.startDate,
    this.endDate,
    this.status,
    this.paymentStatus,
    this.hasTip,
    this.minutes,
    this.model,
    this.customer,
    this.modelService,
    this.customerHidden,
    this.modelHidden,
    this.createdAt,
    this.updatedAt,
    this.isContact,
  });

  MyBookingModel copyWith({
    String? id,
    int? price,
    int? dayAmount,
    int? hours,
    dynamic sessionType,
    String? location,
    dynamic locationLat,
    dynamic locationLng,
    String? preferredAttire,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? paymentStatus,
    bool? hasTip,
    dynamic minutes,
    Model? model,
    Customer? customer,
    ModelService? modelService,
    bool? customerHidden,
    bool? modelHidden,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isContact,
  }) => MyBookingModel(
    id: id ?? this.id,
    price: price ?? this.price,
    dayAmount: dayAmount ?? this.dayAmount,
    hours: hours ?? this.hours,
    sessionType: sessionType ?? this.sessionType,
    location: location ?? this.location,
    locationLat: locationLat ?? this.locationLat,
    locationLng: locationLng ?? this.locationLng,
    preferredAttire: preferredAttire ?? this.preferredAttire,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    status: status ?? this.status,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    hasTip: hasTip ?? this.hasTip,
    minutes: minutes ?? this.minutes,
    model: model ?? this.model,
    customer: customer ?? this.customer,
    modelService: modelService ?? this.modelService,
    customerHidden: customerHidden ?? this.customerHidden,
    modelHidden: modelHidden ?? this.modelHidden,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isContact: isContact ?? this.isContact,
  );

  factory MyBookingModel.fromJson(Map<String, dynamic> json) => MyBookingModel(
    id: json["id"],
    price: json["price"],
    dayAmount: json["dayAmount"],
    hours: json["hours"],
    sessionType: json["sessionType"],
    location: json["location"],
    locationLat: json["locationLat"],
    locationLng: json["locationLng"],
    preferredAttire: json["preferredAttire"],
    startDate: json["startDate"] == null
        ? null
        : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    status: json["status"],
    paymentStatus: json["paymentStatus"],
    hasTip: json["hasTip"],
    minutes: json["minutes"],
    model: json["model"] == null ? null : Model.fromJson(json["model"]),
    customer: json["customer"] == null
        ? null
        : Customer.fromJson(json["customer"]),
    modelService: json["modelService"] == null
        ? null
        : ModelService.fromJson(json["modelService"]),
    customerHidden: json["customerHidden"],
    modelHidden: json["modelHidden"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    isContact: json["isContact"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "dayAmount": dayAmount,
    "hours": hours,
    "sessionType": sessionType,
    "location": location,
    "locationLat": locationLat,
    "locationLng": locationLng,
    "preferredAttire": preferredAttire,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "status": status,
    "paymentStatus": paymentStatus,
    "hasTip": hasTip,
    "minutes": minutes,
    "model": model?.toJson(),
    "customer": customer?.toJson(),
    "modelService": modelService?.toJson(),
    "customerHidden": customerHidden,
    "modelHidden": modelHidden,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "isContact": isContact,
  };
}

class Customer {
  String? id;
  String? firstName;
  String? lastName;
  String? name;
  String? profile;
  int? age;

  Customer({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.profile,
    this.age,
  });

  Customer copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? name,
    String? profile,
    int? age,
  }) => Customer(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    name: name ?? this.name,
    profile: profile ?? this.profile,
    age: age ?? this.age,
  );

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    name: json["name"],
    profile: json["profile"],
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "name": name,
    "profile": profile,
    "age": age,
  };
}

class Model {
  String? id;
  String? firstName;
  String? lastName;
  String? profile;
  DateTime? dob;
  int? age;
  int? whatsapp;

  Model({
    this.id,
    this.firstName,
    this.lastName,
    this.profile,
    this.dob,
    this.age,
    this.whatsapp,
  });

  Model copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? profile,
    DateTime? dob,
    int? age,
    int? whatsapp,
  }) => Model(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    profile: profile ?? this.profile,
    dob: dob ?? this.dob,
    age: age ?? this.age,
    whatsapp: whatsapp ?? this.whatsapp,
  );

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profile: json["profile"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    age: json["age"],
    whatsapp: json["whatsapp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profile": profile,
    "dob": dob?.toIso8601String(),
    "age": age,
    "whatsapp": whatsapp,
  };
}

class ModelService {
  String? id;
  String? name;
  int? customRate;
  int? customHourlyRate;
  dynamic customOneTimePrice;
  dynamic customOneNightPrice;
  dynamic customMinuteRate;

  ModelService({
    this.id,
    this.name,
    this.customRate,
    this.customHourlyRate,
    this.customOneTimePrice,
    this.customOneNightPrice,
    this.customMinuteRate,
  });

  ModelService copyWith({
    String? id,
    String? name,
    int? customRate,
    int? customHourlyRate,
    dynamic customOneTimePrice,
    dynamic customOneNightPrice,
    dynamic customMinuteRate,
  }) => ModelService(
    id: id ?? this.id,
    name: name ?? this.name,
    customRate: customRate ?? this.customRate,
    customHourlyRate: customHourlyRate ?? this.customHourlyRate,
    customOneTimePrice: customOneTimePrice ?? this.customOneTimePrice,
    customOneNightPrice: customOneNightPrice ?? this.customOneNightPrice,
    customMinuteRate: customMinuteRate ?? this.customMinuteRate,
  );

  factory ModelService.fromJson(Map<String, dynamic> json) => ModelService(
    id: json["id"],
    name: json["name"],
    customRate: json["customRate"],
    customHourlyRate: json["customHourlyRate"],
    customOneTimePrice: json["customOneTimePrice"],
    customOneNightPrice: json["customOneNightPrice"],
    customMinuteRate: json["customMinuteRate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "customRate": customRate,
    "customHourlyRate": customHourlyRate,
    "customOneTimePrice": customOneTimePrice,
    "customOneNightPrice": customOneNightPrice,
    "customMinuteRate": customMinuteRate,
  };
}
