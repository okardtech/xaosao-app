import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginUser? user;           // ✅ unified: holds either model or customer data
  String? userType;          // ✅ "model" or "customer"
  String? accessToken;
  String? refreshToken;
  int? expiresIn;

  LoginModel({
    this.user,
    this.userType,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  LoginModel copyWith({
    LoginUser? user,
    String? userType,
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
  }) => LoginModel(
    user: user ?? this.user,
    userType: userType ?? this.userType,
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    expiresIn: expiresIn ?? this.expiresIn,
  );

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    // ✅ detect which user type is present
    final isModel = json.containsKey("model");
    final isCustomer = json.containsKey("customer");

    return LoginModel(
      user: isModel
          ? LoginUser.fromJson(json["model"])
          : isCustomer
              ? LoginUser.fromJson(json["customer"])
              : null,
      userType: isModel
          ? "model"
          : isCustomer
              ? "customer"
              : null,
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
      expiresIn: json["expiresIn"],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "expiresIn": expiresIn,
    };
    // ✅ write back under the correct key
    if (userType == "model") {
      map["model"] = user?.toJson();
    } else if (userType == "customer") {
      map["customer"] = user?.toJson();
    }
    return map;
  }

  // ✅ Helper getters
  bool get isModel => userType == "model";
  bool get isCustomer => userType == "customer";
  bool get isLoggedIn => accessToken != null;
}

// ✅ Unified user class for both model & customer
class LoginUser {
  String? firstName;
  String? lastName;
  double? whatsapp;       // ✅ double — large phone number
  String? status;
  bool? isPhoneVerified;

  LoginUser({
    this.firstName,
    this.lastName,
    this.whatsapp,
    this.status,
    this.isPhoneVerified,
  });

  LoginUser copyWith({
    String? firstName,
    String? lastName,
    double? whatsapp,
    String? status,
    bool? isPhoneVerified,
  }) => LoginUser(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    whatsapp: whatsapp ?? this.whatsapp,
    status: status ?? this.status,
    isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
  );

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
    firstName: json["firstName"],
    lastName: json["lastName"],
    whatsapp: json["whatsapp"] == null
        ? null
        : (json["whatsapp"] as num).toDouble(),
    status: json["status"],
    isPhoneVerified: json["isPhoneVerified"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "whatsapp": whatsapp,
    "status": status,
    "isPhoneVerified": isPhoneVerified,
  };

  // ✅ Helper getters
  String get fullName => "${firstName ?? ''} ${lastName ?? ''}".trim();
  bool get isActive => status == "active";
  bool get isVerified => isPhoneVerified ?? false;
}