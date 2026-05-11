// ─── Shared base fields ───────────────────────────────────────────────────────
abstract class BaseProfileModel {
  String? id;
  String? firstName;
  String? lastName;
  String? profile;
  String? gender;
  DateTime? dob;
  int? whatsapp;
  double? latitude;
  double? longitude;
  bool? isPhoneVerified;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<GalleryItem> gallery;
  List<dynamic> interests;

  BaseProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.profile,
    this.gender,
    this.dob,
    this.whatsapp,
    this.latitude,
    this.longitude,
    this.isPhoneVerified,
    this.status,
    this.createdAt,
    this.updatedAt,
    required this.gallery,
    required this.interests,
  });

  // ✅ Shared helper getters
  String get fullName => "${firstName ?? ''} ${lastName ?? ''}".trim();
  bool get isActive => status == "active";
  bool get isVerified => isPhoneVerified ?? false;
  int? get age {
    if (dob == null) return null;
    final now = DateTime.now();
    int age = now.year - dob!.year;
    if (now.month < dob!.month ||
        (now.month == dob!.month && now.day < dob!.day)) {
      age--;
    }
    return age;
  }
}

// ─── Customer Profile ─────────────────────────────────────────────────────────
class CustomerProfileModel extends BaseProfileModel {
  String? number; // e.g. "XSC-0014"
  String? country;
  String? ip;
  ProfileLocation? location;
  String? referredByModelId;
  bool? twofactorEnabled;

  CustomerProfileModel({
    super.id,
    super.firstName,
    super.lastName,
    super.profile,
    super.gender,
    super.dob,
    super.whatsapp,
    super.latitude,
    super.longitude,
    super.isPhoneVerified,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.gallery = const [],
    super.interests = const [],
    this.number,
    this.country,
    this.ip,
    this.location,
    this.referredByModelId,
    this.twofactorEnabled,
  });

  CustomerProfileModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? profile,
    String? gender,
    DateTime? dob,
    int? whatsapp,
    double? latitude,
    double? longitude,
    bool? isPhoneVerified,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<GalleryItem>? gallery,
    List<dynamic>? interests,
    String? number,
    String? country,
    String? ip,
    ProfileLocation? location,
    String? referredByModelId,
    bool? twofactorEnabled,
  }) => CustomerProfileModel(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    profile: profile ?? this.profile,
    gender: gender ?? this.gender,
    dob: dob ?? this.dob,
    whatsapp: whatsapp ?? this.whatsapp,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    gallery: gallery ?? this.gallery,
    interests: interests ?? this.interests,
    number: number ?? this.number,
    country: country ?? this.country,
    ip: ip ?? this.ip,
    location: location ?? this.location,
    referredByModelId: referredByModelId ?? this.referredByModelId,
    twofactorEnabled: twofactorEnabled ?? this.twofactorEnabled,
  );

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) =>
      CustomerProfileModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profile: json["profile"],
        gender: json["gender"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        whatsapp: json["whatsapp"] == null ? null : (json["whatsapp"]),
        latitude: json["latitude"] == null
            ? null
            : (json["latitude"] as num).toDouble(),
        longitude: json["longitude"] == null
            ? null
            : (json["longitude"] as num).toDouble(),
        isPhoneVerified: json["isPhoneVerified"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        gallery: json["gallery"] == null
            ? []
            : List<GalleryItem>.from(
                json["gallery"].map((x) => GalleryItem.fromJson(x)),
              ),
        interests: json["interests"] == null
            ? []
            : List<dynamic>.from(json["interests"]),
        number: json["number"],
        country: json["country"],
        ip: json["ip"],
        location: json["location"] == null
            ? null
            : ProfileLocation.fromJson(json["location"]),
        referredByModelId: json["referredByModelId"],
        twofactorEnabled: json["twofactorEnabled"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profile": profile,
    "gender": gender,
    "dob": dob?.toIso8601String(),
    "whatsapp": whatsapp,
    "latitude": latitude,
    "longitude": longitude,
    "isPhoneVerified": isPhoneVerified,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "gallery": List<dynamic>.from(gallery.map((x) => x.toJson())),
    "interests": interests,
    "number": number,
    "country": country,
    "ip": ip,
    "location": location?.toJson(),
    "referredByModelId": referredByModelId,
    "twofactorEnabled": twofactorEnabled,
  };
}

// ─── Model Profile ────────────────────────────────────────────────────────────
class ModelProfileModel extends BaseProfileModel {
  String? address;
  String? availableStatus;
  bool? sendMailNoti;
  bool? sendSMSNoti;
  bool? sendPushNoti;
  bool? sendWhatsappNoti;
  String? defaultLanguage;
  String? defaultTheme;
  bool? isProfileHidden;
  bool? vip;
  String? referralCode;
  String? customerReferralCode;
  int? totalReferredModels;
  int? totalReferredCustomers;
  double? recommendationScore;
  List<ModelService> services;
  List<ModelBank> banks;
  ModelCounts? counts;

  ModelProfileModel({
    super.id,
    super.firstName,
    super.lastName,
    super.profile,
    super.gender,
    super.dob,
    super.whatsapp,
    super.latitude,
    super.longitude,
    super.isPhoneVerified,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.gallery = const [],
    super.interests = const [],
    this.address,
    this.availableStatus,
    this.sendMailNoti,
    this.sendSMSNoti,
    this.sendPushNoti,
    this.sendWhatsappNoti,
    this.defaultLanguage,
    this.defaultTheme,
    this.isProfileHidden,
    this.vip,
    this.referralCode,
    this.customerReferralCode,
    this.totalReferredModels,
    this.totalReferredCustomers,
    this.recommendationScore,
    this.services = const [],
    this.banks = const [],
    this.counts,
  });

  ModelProfileModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? profile,
    String? gender,
    DateTime? dob,
    int? whatsapp,
    double? latitude,
    double? longitude,
    bool? isPhoneVerified,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<GalleryItem>? gallery,
    List<dynamic>? interests,
    String? address,
    String? availableStatus,
    bool? sendMailNoti,
    bool? sendSMSNoti,
    bool? sendPushNoti,
    bool? sendWhatsappNoti,
    String? defaultLanguage,
    String? defaultTheme,
    bool? isProfileHidden,
    bool? vip,
    String? referralCode,
    String? customerReferralCode,
    int? totalReferredModels,
    int? totalReferredCustomers,
    double? recommendationScore,
    List<ModelService>? services,
    List<ModelBank>? banks,
    ModelCounts? counts,
  }) => ModelProfileModel(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    profile: profile ?? this.profile,
    gender: gender ?? this.gender,
    dob: dob ?? this.dob,
    whatsapp: whatsapp ?? this.whatsapp,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    gallery: gallery ?? this.gallery,
    interests: interests ?? this.interests,
    address: address ?? this.address,
    availableStatus: availableStatus ?? this.availableStatus,
    sendMailNoti: sendMailNoti ?? this.sendMailNoti,
    sendSMSNoti: sendSMSNoti ?? this.sendSMSNoti,
    sendPushNoti: sendPushNoti ?? this.sendPushNoti,
    sendWhatsappNoti: sendWhatsappNoti ?? this.sendWhatsappNoti,
    defaultLanguage: defaultLanguage ?? this.defaultLanguage,
    defaultTheme: defaultTheme ?? this.defaultTheme,
    isProfileHidden: isProfileHidden ?? this.isProfileHidden,
    vip: vip ?? this.vip,
    referralCode: referralCode ?? this.referralCode,
    customerReferralCode: customerReferralCode ?? this.customerReferralCode,
    totalReferredModels: totalReferredModels ?? this.totalReferredModels,
    totalReferredCustomers:
        totalReferredCustomers ?? this.totalReferredCustomers,
    recommendationScore: recommendationScore ?? this.recommendationScore,
    services: services ?? this.services,
    banks: banks ?? this.banks,
    counts: counts ?? this.counts,
  );

  factory ModelProfileModel.fromJson(Map<String, dynamic> json) =>
      ModelProfileModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profile: json["profile"],
        gender: json["gender"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        whatsapp: json["whatsapp"] == null ? null : (json["whatsapp"]),
        latitude: json["latitude"] == null
            ? null
            : (json["latitude"] as num).toDouble(),
        longitude: json["longitude"] == null
            ? null
            : (json["longitude"] as num).toDouble(),
        isPhoneVerified: json["isPhoneVerified"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        gallery: json["gallery"] == null
            ? []
            : List<GalleryItem>.from(
                json["gallery"].map((x) => GalleryItem.fromJson(x)),
              ),
        interests: json["interests"] == null
            ? []
            : List<dynamic>.from(json["interests"]),
        address: json["address"],
        availableStatus: json["available_status"],
        sendMailNoti: json["sendMailNoti"],
        sendSMSNoti: json["sendSMSNoti"],
        sendPushNoti: json["sendPushNoti"],
        sendWhatsappNoti: json["sendWhatsappNoti"],
        defaultLanguage: json["defaultLanguage"],
        defaultTheme: json["defaultTheme"],
        isProfileHidden: json["isProfileHidden"],
        vip: json["vip"],
        referralCode: json["referralCode"],
        customerReferralCode: json["customerReferralCode"],
        totalReferredModels: json["totalReferredModels"],
        totalReferredCustomers: json["totalReferredCustomers"],
        recommendationScore: json["recommendationScore"] == null
            ? null
            : (json["recommendationScore"] as num).toDouble(),
        services: json["services"] == null
            ? []
            : List<ModelService>.from(
                json["services"].map((x) => ModelService.fromJson(x)),
              ),
        banks: json["banks"] == null
            ? []
            : List<ModelBank>.from(
                json["banks"].map((x) => ModelBank.fromJson(x)),
              ),
        counts: json["counts"] == null
            ? null
            : ModelCounts.fromJson(json["counts"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profile": profile,
    "gender": gender,
    "dob": dob?.toIso8601String(),
    "whatsapp": whatsapp,
    "latitude": latitude,
    "longitude": longitude,
    "isPhoneVerified": isPhoneVerified,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "gallery": List<dynamic>.from(gallery.map((x) => x.toJson())),
    "interests": interests,
    "address": address,
    "available_status": availableStatus,
    "sendMailNoti": sendMailNoti,
    "sendSMSNoti": sendSMSNoti,
    "sendPushNoti": sendPushNoti,
    "sendWhatsappNoti": sendWhatsappNoti,
    "defaultLanguage": defaultLanguage,
    "defaultTheme": defaultTheme,
    "isProfileHidden": isProfileHidden,
    "vip": vip,
    "referralCode": referralCode,
    "customerReferralCode": customerReferralCode,
    "totalReferredModels": totalReferredModels,
    "totalReferredCustomers": totalReferredCustomers,
    "recommendationScore": recommendationScore,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "banks": List<dynamic>.from(banks.map((x) => x.toJson())),
    "counts": counts?.toJson(),
  };

  // ✅ Model-specific helpers
  bool get isVip => vip ?? false;
  bool get isBusy => availableStatus == "busy";
  bool get isAvailable => availableStatus == "available";
  bool get isProfileVisible => !(isProfileHidden ?? false);
}

// ─── Shared sub-models ────────────────────────────────────────────────────────
class GalleryItem {
  String? id;
  String? url;
  String? status;
  DateTime? createdAt;

  GalleryItem({this.id, this.url, this.status, this.createdAt});

  GalleryItem copyWith({
    String? id,
    String? url,
    String? status,
    DateTime? createdAt,
  }) => GalleryItem(
    id: id ?? this.id,
    url: url ?? this.url,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );

  factory GalleryItem.fromJson(Map<String, dynamic> json) => GalleryItem(
    id: json["id"],
    url: json["url"],
    status: json["status"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
  };
}

// ─── Customer-only sub-models ─────────────────────────────────────────────────
class ProfileLocation {
  String? ip;
  String? continentCode;
  String? continentName;
  String? countryCode;
  String? countryName;
  String? countryNameNative;
  String? city;
  String? postalCode;
  double? latitude;
  double? longitude;
  String? capital;
  String? phoneCode;
  String? countryFlag;
  String? currencyCode;
  String? currencyName;
  String? languages;
  String? timeZone;

  ProfileLocation({
    this.ip,
    this.continentCode,
    this.continentName,
    this.countryCode,
    this.countryName,
    this.countryNameNative,
    this.city,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.capital,
    this.phoneCode,
    this.countryFlag,
    this.currencyCode,
    this.currencyName,
    this.languages,
    this.timeZone,
  });

  ProfileLocation copyWith({
    String? ip,
    String? continentCode,
    String? continentName,
    String? countryCode,
    String? countryName,
    String? countryNameNative,
    String? city,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? capital,
    String? phoneCode,
    String? countryFlag,
    String? currencyCode,
    String? currencyName,
    String? languages,
    String? timeZone,
  }) => ProfileLocation(
    ip: ip ?? this.ip,
    continentCode: continentCode ?? this.continentCode,
    continentName: continentName ?? this.continentName,
    countryCode: countryCode ?? this.countryCode,
    countryName: countryName ?? this.countryName,
    countryNameNative: countryNameNative ?? this.countryNameNative,
    city: city ?? this.city,
    postalCode: postalCode ?? this.postalCode,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    capital: capital ?? this.capital,
    phoneCode: phoneCode ?? this.phoneCode,
    countryFlag: countryFlag ?? this.countryFlag,
    currencyCode: currencyCode ?? this.currencyCode,
    currencyName: currencyName ?? this.currencyName,
    languages: languages ?? this.languages,
    timeZone: timeZone ?? this.timeZone,
  );

  factory ProfileLocation.fromJson(Map<String, dynamic> json) =>
      ProfileLocation(
        ip: json["ip"],
        continentCode: json["continentCode"],
        continentName: json["continentName"],
        countryCode: json["countryCode"],
        countryName: json["countryName"],
        countryNameNative: json["countryNameNative"],
        city: json["city"],
        postalCode: json["postalCode"],
        latitude: json["latitude"] == null
            ? null
            : (json["latitude"] as num).toDouble(),
        longitude: json["longitude"] == null
            ? null
            : (json["longitude"] as num).toDouble(),
        capital: json["capital"],
        phoneCode: json["phoneCode"],
        countryFlag: json["countryFlag"],
        currencyCode: json["currencyCode"],
        currencyName: json["currencyName"],
        languages: json["languages"],
        timeZone: json["timeZone"],
      );

  Map<String, dynamic> toJson() => {
    "ip": ip,
    "continentCode": continentCode,
    "continentName": continentName,
    "countryCode": countryCode,
    "countryName": countryName,
    "countryNameNative": countryNameNative,
    "city": city,
    "postalCode": postalCode,
    "latitude": latitude,
    "longitude": longitude,
    "capital": capital,
    "phoneCode": phoneCode,
    "countryFlag": countryFlag,
    "currencyCode": currencyCode,
    "currencyName": currencyName,
    "languages": languages,
    "timeZone": timeZone,
  };
}

// ─── Model-only sub-models ────────────────────────────────────────────────────
class ModelService {
  String? modelServiceId;
  String? serviceId;
  String? serviceName;
  String? billingType;
  double? customRate;
  double? customHourlyRate;
  double? customOneTimePrice;
  double? customOneNightPrice;
  double? customMinuteRate;
  String? serviceLocation;
  bool? isAvailable;

  ModelService({
    this.modelServiceId,
    this.serviceId,
    this.serviceName,
    this.billingType,
    this.customRate,
    this.customHourlyRate,
    this.customOneTimePrice,
    this.customOneNightPrice,
    this.customMinuteRate,
    this.serviceLocation,
    this.isAvailable,
  });

  ModelService copyWith({
    String? modelServiceId,
    String? serviceId,
    String? serviceName,
    String? billingType,
    double? customRate,
    double? customHourlyRate,
    double? customOneTimePrice,
    double? customOneNightPrice,
    double? customMinuteRate,
    String? serviceLocation,
    bool? isAvailable,
  }) => ModelService(
    modelServiceId: modelServiceId ?? this.modelServiceId,
    serviceId: serviceId ?? this.serviceId,
    serviceName: serviceName ?? this.serviceName,
    billingType: billingType ?? this.billingType,
    customRate: customRate ?? this.customRate,
    customHourlyRate: customHourlyRate ?? this.customHourlyRate,
    customOneTimePrice: customOneTimePrice ?? this.customOneTimePrice,
    customOneNightPrice: customOneNightPrice ?? this.customOneNightPrice,
    customMinuteRate: customMinuteRate ?? this.customMinuteRate,
    serviceLocation: serviceLocation ?? this.serviceLocation,
    isAvailable: isAvailable ?? this.isAvailable,
  );

  factory ModelService.fromJson(Map<String, dynamic> json) => ModelService(
    modelServiceId: json["modelServiceId"],
    serviceId: json["serviceId"],
    serviceName: json["serviceName"],
    billingType: json["billingType"],
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
    serviceLocation: json["serviceLocation"],
    isAvailable: json["isAvailable"],
  );

  Map<String, dynamic> toJson() => {
    "modelServiceId": modelServiceId,
    "serviceId": serviceId,
    "serviceName": serviceName,
    "billingType": billingType,
    "customRate": customRate,
    "customHourlyRate": customHourlyRate,
    "customOneTimePrice": customOneTimePrice,
    "customOneNightPrice": customOneNightPrice,
    "customMinuteRate": customMinuteRate,
    "serviceLocation": serviceLocation,
    "isAvailable": isAvailable,
  };

  // ✅ effective display rate
  double? get effectiveRate {
    switch (billingType) {
      case "per_hour":
        return customHourlyRate ?? customRate;
      case "per_day":
        return customRate;
      case "per_night":
        return customOneNightPrice ?? customRate;
      case "one_time":
        return customOneTimePrice ?? customRate;
      case "per_minute":
        return customMinuteRate ?? customRate;
      default:
        return customRate;
    }
  }
}

class ModelBank {
  String? id;
  String? qrCode;
  String? bankAccountName;
  bool? isDefault;

  ModelBank({this.id, this.qrCode, this.bankAccountName, this.isDefault});

  ModelBank copyWith({
    String? id,
    String? qrCode,
    String? bankAccountName,
    bool? isDefault,
  }) => ModelBank(
    id: id ?? this.id,
    qrCode: qrCode ?? this.qrCode,
    bankAccountName: bankAccountName ?? this.bankAccountName,
    isDefault: isDefault ?? this.isDefault,
  );

  factory ModelBank.fromJson(Map<String, dynamic> json) => ModelBank(
    id: json["id"],
    qrCode: json["qr_code"],
    bankAccountName: json["bank_account_name"],
    isDefault: json["isDefault"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "qr_code": qrCode,
    "bank_account_name": bankAccountName,
    "isDefault": isDefault,
  };
}

class ModelCounts {
  int? totalLikes;
  int? totalFriends;
  int? totalBookings;

  ModelCounts({this.totalLikes, this.totalFriends, this.totalBookings});

  ModelCounts copyWith({
    int? totalLikes,
    int? totalFriends,
    int? totalBookings,
  }) => ModelCounts(
    totalLikes: totalLikes ?? this.totalLikes,
    totalFriends: totalFriends ?? this.totalFriends,
    totalBookings: totalBookings ?? this.totalBookings,
  );

  factory ModelCounts.fromJson(Map<String, dynamic> json) => ModelCounts(
    totalLikes: json["totalLikes"],
    totalFriends: json["totalFriends"],
    totalBookings: json["totalBookings"],
  );

  Map<String, dynamic> toJson() => {
    "totalLikes": totalLikes,
    "totalFriends": totalFriends,
    "totalBookings": totalBookings,
  };
}
