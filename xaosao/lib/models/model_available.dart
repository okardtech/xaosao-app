import 'dart:convert';

List<ModelAvailable> modelAvailableFromJson(String str) =>
    List<ModelAvailable>.from(
      json.decode(str).map((x) => ModelAvailable.fromJson(x)),
    );

String modelAvailableToJson(List<ModelAvailable> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelAvailable {
  String? id;
  String? name;
  String? billingType;
  double? customRate;           // ✅ double
  double? customHourlyRate;     // ✅ double
  double? customMinuteRate;     // ✅ double
  double? customOneTimePrice;   // ✅ double
  double? customOneNightPrice;  // ✅ double
  String? serviceLocation;

  ModelAvailable({
    this.id,
    this.name,
    this.billingType,
    this.customRate,
    this.customHourlyRate,
    this.customMinuteRate,
    this.customOneTimePrice,
    this.customOneNightPrice,
    this.serviceLocation,
  });

  ModelAvailable copyWith({
    String? id,
    String? name,
    String? billingType,
    double? customRate,
    double? customHourlyRate,
    double? customMinuteRate,
    double? customOneTimePrice,
    double? customOneNightPrice,
    String? serviceLocation,
  }) => ModelAvailable(
    id: id ?? this.id,
    name: name ?? this.name,
    billingType: billingType ?? this.billingType,
    customRate: customRate ?? this.customRate,
    customHourlyRate: customHourlyRate ?? this.customHourlyRate,
    customMinuteRate: customMinuteRate ?? this.customMinuteRate,
    customOneTimePrice: customOneTimePrice ?? this.customOneTimePrice,
    customOneNightPrice: customOneNightPrice ?? this.customOneNightPrice,
    serviceLocation: serviceLocation ?? this.serviceLocation,
  );

  factory ModelAvailable.fromJson(Map<String, dynamic> json) => ModelAvailable(
    id: json["id"],
    name: json["name"],
    billingType: json["billingType"],
    customRate: json["customRate"] == null
        ? null
        : (json["customRate"] as num).toDouble(),
    customHourlyRate: json["customHourlyRate"] == null
        ? null
        : (json["customHourlyRate"] as num).toDouble(),
    customMinuteRate: json["customMinuteRate"] == null
        ? null
        : (json["customMinuteRate"] as num).toDouble(),
    customOneTimePrice: json["customOneTimePrice"] == null
        ? null
        : (json["customOneTimePrice"] as num).toDouble(),
    customOneNightPrice: json["customOneNightPrice"] == null
        ? null
        : (json["customOneNightPrice"] as num).toDouble(),
    serviceLocation: json["serviceLocation"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "billingType": billingType,
    "customRate": customRate,
    "customHourlyRate": customHourlyRate,
    "customMinuteRate": customMinuteRate,
    "customOneTimePrice": customOneTimePrice,
    "customOneNightPrice": customOneNightPrice,
    "serviceLocation": serviceLocation,
  };

  // ✅ effective rate based on billingType
  double? get effectiveRate {
    switch (billingType) {
      case "per_hour":   return customHourlyRate ?? customRate;
      case "per_day":    return customRate;
      case "per_night":  return customOneNightPrice ?? customRate;
      case "one_time":   return customOneTimePrice ?? customRate;
      case "per_minute": return customMinuteRate ?? customRate;
      default:           return customRate;
    }
  }
}