import 'dart:convert';

List<ServiceModel> serviceModelFromJson(String str) =>
    List<ServiceModel>.from(
      json.decode(str).map((x) => ServiceModel.fromJson(x)),
    );

String serviceModelToJson(List<ServiceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceModel {
  String id;
  String name;
  String? description;
  double? baseRate;             // ✅ double & nullable
  double? commission;           // ✅ double & nullable
  String? billingType;
  double? hourlyRate;           // ✅ double & nullable
  double? oneTimePrice;         // ✅ double & nullable
  double? oneNightPrice;        // ✅ double & nullable
  double? minuteRate;           // ✅ double & nullable

  ServiceModel({
    required this.id,
    required this.name,
    this.description,
    this.baseRate,
    this.commission,
    this.billingType,
    this.hourlyRate,
    this.oneTimePrice,
    this.oneNightPrice,
    this.minuteRate,
  });

  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    double? baseRate,
    double? commission,
    String? billingType,
    double? hourlyRate,
    double? oneTimePrice,
    double? oneNightPrice,
    double? minuteRate,
  }) => ServiceModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    baseRate: baseRate ?? this.baseRate,
    commission: commission ?? this.commission,
    billingType: billingType ?? this.billingType,
    hourlyRate: hourlyRate ?? this.hourlyRate,
    oneTimePrice: oneTimePrice ?? this.oneTimePrice,
    oneNightPrice: oneNightPrice ?? this.oneNightPrice,
    minuteRate: minuteRate ?? this.minuteRate,
  );

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    baseRate: json["baseRate"] == null
        ? null
        : (json["baseRate"] as num).toDouble(),
    commission: json["commission"] == null
        ? null
        : (json["commission"] as num).toDouble(),
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
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "baseRate": baseRate,
    "commission": commission,
    "billingType": billingType,
    "hourlyRate": hourlyRate,
    "oneTimePrice": oneTimePrice,
    "oneNightPrice": oneNightPrice,
    "minuteRate": minuteRate,
  };

  // ✅ Helper getter for display price based on billingType
  double? get displayPrice {
    switch (billingType) {
      case "per_hour":
        return hourlyRate ?? baseRate;
      case "per_day":
        return baseRate;
      case "per_night":
        return oneNightPrice ?? baseRate;
      case "one_time":
        return oneTimePrice ?? baseRate;
      case "per_minute":
        return minuteRate ?? baseRate;
      default:
        return baseRate;
    }
  }

  // ✅ Helper getter for billing label
  String get billingLabel {
    switch (billingType) {
      case "per_hour":
        return "/ hour";
      case "per_day":
        return "/ day";
      case "per_night":
        return "/ night";
      case "one_time":
        return "one time";
      case "per_minute":
        return "/ min";
      default:
        return "";
    }
  }
}