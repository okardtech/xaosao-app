import 'dart:convert';

List<RecommendedModel> recommendedModelFromJson(String str) =>
    List<RecommendedModel>.from(
      json.decode(str).map((x) => RecommendedModel.fromJson(x)),
    );

String recommendedModelToJson(List<RecommendedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecommendedModel {
  String? id;
  String? firstName;
  String? lastName;
  DateTime? dob;
  String? gender;
  String? bio;
  String? address;
  String? profile;
  List<String>? images;
  double? latitude;
  double? longitude;
  double? rating;
  int? totalReview;
  String? status;
  String? availableStatus;
  DateTime? createdAt;
  bool? vip;
  int? friendsCount;
  int? likeCount;
  bool? isLikedByMe;
  bool? isOnline;
  DateTime? lastOnlineAt;
  double? distanceKm;

  RecommendedModel({
    this.id,
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
    this.bio,
    this.address,
    this.profile,
    this.images,
    this.latitude,
    this.longitude,
    this.rating,
    this.totalReview,
    this.status,
    this.availableStatus,
    this.createdAt,
    this.vip,
    this.friendsCount,
    this.likeCount,
    this.isLikedByMe,
    this.isOnline,
    this.lastOnlineAt,
    this.distanceKm,
  });

  RecommendedModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? dob,
    String? gender,
    String? bio,
    String? address,
    String? profile,
    List<String>? images,
    double? latitude,
    double? longitude,
    double? rating,
    int? totalReview,
    String? status,
    String? availableStatus,
    DateTime? createdAt,
    bool? vip,
    int? friendsCount,
    int? likeCount,
    bool? isLikedByMe,
    bool? isOnline,
    DateTime? lastOnlineAt,
    double? distanceKm,
  }) => RecommendedModel(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    dob: dob ?? this.dob,
    gender: gender ?? this.gender,
    bio: bio ?? this.bio,
    address: address ?? this.address,
    profile: profile ?? this.profile,
    images: images ?? this.images,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    rating: rating ?? this.rating,
    totalReview: totalReview ?? this.totalReview,
    status: status ?? this.status,
    availableStatus: availableStatus ?? this.availableStatus,
    createdAt: createdAt ?? this.createdAt,
    vip: vip ?? this.vip,
    friendsCount: friendsCount ?? this.friendsCount,
    likeCount: likeCount ?? this.likeCount,
    isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    isOnline: isOnline ?? this.isOnline,
    lastOnlineAt: lastOnlineAt ?? this.lastOnlineAt,
    distanceKm: distanceKm ?? this.distanceKm,
  );

  factory RecommendedModel.fromJson(Map<String, dynamic> json) =>
      RecommendedModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        gender: json["gender"],
        bio: json["bio"],
        address: json["address"],
        profile: json["profile"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"].map((x) => x.toString())),
        latitude: json["latitude"] == null
            ? null
            : (json["latitude"] as num).toDouble(),
        longitude: json["longitude"] == null
            ? null
            : (json["longitude"] as num).toDouble(),
        rating: json["rating"] == null
            ? null
            : (json["rating"] as num).toDouble(),
        totalReview: json["total_review"],
        status: json["status"],
        availableStatus: json["available_status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        vip: json["vip"],
        friendsCount: json["friendsCount"],
        likeCount: json["likeCount"],
        isLikedByMe: json["isLikedByMe"],
        isOnline: json["isOnline"],
        lastOnlineAt: json["lastOnlineAt"] == null
            ? null
            : DateTime.parse(json["lastOnlineAt"]),
        distanceKm: json["distanceKm"] == null
            ? null
            : (json["distanceKm"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "dob": dob?.toIso8601String(),
    "gender": gender,
    "bio": bio,
    "profile": profile,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "latitude": latitude,
    "longitude": longitude,
    "rating": rating,
    "total_review": totalReview,
    "status": status,
    "available_status": availableStatus,
    "createdAt": createdAt?.toIso8601String(),
    "vip": vip,
    "friendsCount": friendsCount,
    "likeCount": likeCount,
    "isLikedByMe": isLikedByMe,
    "isOnline": isOnline,
    "lastOnlineAt": lastOnlineAt?.toIso8601String(),
    "distanceKm": distanceKm,
  };

  // helpers
  bool get isLiked => isLikedByMe ?? false;
  bool get isVip => vip ?? false;
  bool get isAvailable => availableStatus == "available";
  bool get online => isOnline ?? false;
  String get fullName => "${firstName ?? ''} ${lastName ?? ''}".trim();
}
