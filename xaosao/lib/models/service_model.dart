import 'dart:convert';

List<ServiceModel> serviceModelFromJson(String str) =>
    List<ServiceModel>.from(
      json.decode(str).map((x) => ServiceModel.fromJson(x)),
    );

String serviceModelToJson(List<ServiceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceModel {
  String? id;
  String? serviceId;
  String? name;
  String? description;
  double? baseRate;           // ✅ double
  double? commission;         // ✅ double
  String? status;
  String? billingType;
  double? hourlyRate;         // ✅ double
  double? oneTimePrice;       // ✅ double
  double? oneNightPrice;      // ✅ double
  double? minuteRate;         // ✅ double
  double? customRate;         // ✅ double
  double? customHourlyRate;   // ✅ double
  double? customOneTimePrice; // ✅ double
  double? customOneNightPrice;// ✅ double
  double? customMinuteRate;   // ✅ double
  bool? isAvailable;
  List<MassageVariant>? massageVariants;
  String? serviceLocation;

  ServiceModel({
    this.id,
    this.serviceId,
    this.name,
    this.description,
    this.baseRate,
    this.commission,
    this.status,
    this.billingType,
    this.hourlyRate,
    this.oneTimePrice,
    this.oneNightPrice,
    this.minuteRate,
    this.customRate,
    this.customHourlyRate,
    this.customOneTimePrice,
    this.customOneNightPrice,
    this.customMinuteRate,
    this.isAvailable,
    this.massageVariants,
    this.serviceLocation,
  });

  ServiceModel copyWith({
    String? id,
    String? serviceId,
    String? name,
    String? description,
    double? baseRate,
    double? commission,
    String? status,
    String? billingType,
    double? hourlyRate,
    double? oneTimePrice,
    double? oneNightPrice,
    double? minuteRate,
    double? customRate,
    double? customHourlyRate,
    double? customOneTimePrice,
    double? customOneNightPrice,
    double? customMinuteRate,
    bool? isAvailable,
    List<MassageVariant>? massageVariants,
    String? serviceLocation,
  }) => ServiceModel(
    id: id ?? this.id,
    serviceId: serviceId ?? this.serviceId,
    name: name ?? this.name,
    description: description ?? this.description,
    baseRate: baseRate ?? this.baseRate,
    commission: commission ?? this.commission,
    status: status ?? this.status,
    billingType: billingType ?? this.billingType,
    hourlyRate: hourlyRate ?? this.hourlyRate,
    oneTimePrice: oneTimePrice ?? this.oneTimePrice,
    oneNightPrice: oneNightPrice ?? this.oneNightPrice,
    minuteRate: minuteRate ?? this.minuteRate,
    customRate: customRate ?? this.customRate,
    customHourlyRate: customHourlyRate ?? this.customHourlyRate,
    customOneTimePrice: customOneTimePrice ?? this.customOneTimePrice,
    customOneNightPrice: customOneNightPrice ?? this.customOneNightPrice,
    customMinuteRate: customMinuteRate ?? this.customMinuteRate,
    isAvailable: isAvailable ?? this.isAvailable,
    massageVariants: massageVariants ?? this.massageVariants,
    serviceLocation: serviceLocation ?? this.serviceLocation,
  );

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json["id"],
    serviceId: json["serviceId"],
    name: json["name"],
    description: json["description"],
    baseRate: json["baseRate"] == null
        ? null
        : (json["baseRate"] as num).toDouble(),
    commission: json["commission"] == null
        ? null
        : (json["commission"] as num).toDouble(),
    status: json["status"],
    billingType: json["billingType"],
    hourlyRate: json["hourlyRate"] == null
        ? null
        : (json["hourlyRate"] as num).toDouble(),
    oneTimePrice: json["oneTimePrice"] == null
        ? null
        : (json["oneTimePrice"] as num).toDouble(),
    oneNightPrice: json["oneNightPrice"] == null
        ? null
        : (json["oneNightPrice"] as num).toDouble(),
    minuteRate: json["minuteRate"] == null
        ? null
        : (json["minuteRate"] as num).toDouble(),
    customRate: json["customRate"] == null
        ? null
        : (json["customRate"] as num).toDouble(),
    customHourlyRate: json["customHourlyRate"] == null
        ? null
        : (json["customHourlyRate"] as num).toDouble(),
    customOneTimePrice: json["customOneTimePrice"] == null
        ? null
        : (json["customOneTimePrice"] as num).toDouble(),
    customOneNightPrice: json["customOneNightPrice"] == null
        ? null
        : (json["customOneNightPrice"] as num).toDouble(),
    customMinuteRate: json["customMinuteRate"] == null
        ? null
        : (json["customMinuteRate"] as num).toDouble(),
    isAvailable: json["isAvailable"],
    massageVariants: json["massageVariants"] == null
        ? []
        : List<MassageVariant>.from(
            json["massageVariants"].map((x) => MassageVariant.fromJson(x)),
          ),
    serviceLocation: json["serviceLocation"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceId": serviceId,
    "name": name,
    "description": description,
    "baseRate": baseRate,
    "commission": commission,
    "status": status,
    "billingType": billingType,
    "hourlyRate": hourlyRate,
    "oneTimePrice": oneTimePrice,
    "oneNightPrice": oneNightPrice,
    "minuteRate": minuteRate,
    "customRate": customRate,
    "customHourlyRate": customHourlyRate,
    "customOneTimePrice": customOneTimePrice,
    "customOneNightPrice": customOneNightPrice,
    "customMinuteRate": customMinuteRate,
    "isAvailable": isAvailable,
    "massageVariants": massageVariants == null
        ? []
        : List<dynamic>.from(massageVariants!.map((x) => x.toJson())),
    "serviceLocation": serviceLocation,
  };
}

class MassageVariant {
  String? id;
  String? name;
  double? pricePerHour;   // ✅ double

  MassageVariant({
    this.id,
    this.name,
    this.pricePerHour,
  });

  MassageVariant copyWith({
    String? id,
    String? name,
    double? pricePerHour,
  }) => MassageVariant(
    id: id ?? this.id,
    name: name ?? this.name,
    pricePerHour: pricePerHour ?? this.pricePerHour,
  );

  factory MassageVariant.fromJson(Map<String, dynamic> json) => MassageVariant(
    id: json["id"],
    name: json["name"],
    pricePerHour: json["pricePerHour"] == null
        ? null
        : (json["pricePerHour"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "pricePerHour": pricePerHour,
  };
}