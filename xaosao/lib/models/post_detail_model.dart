// To parse this JSON data, do
//
//     final postDetailModel = postDetailModelFromJson(jsonString);

import 'dart:convert';

PostDetailModel postDetailModelFromJson(String str) => PostDetailModel.fromJson(json.decode(str));

String postDetailModelToJson(PostDetailModel data) => json.encode(data.toJson());

class PostDetailModel {
    Post? post;
    Author? author;
    dynamic service;
    int? interestedCount;
    List<dynamic>? interestedUsers;
    List<GiftedUser>? giftedUsers;
    bool? isInterested;

    PostDetailModel({
        this.post,
        this.author,
        this.service,
        this.interestedCount,
        this.interestedUsers,
        this.giftedUsers,
        this.isInterested,
    });

    PostDetailModel copyWith({
        Post? post,
        Author? author,
        dynamic service,
        int? interestedCount,
        List<dynamic>? interestedUsers,
        List<GiftedUser>? giftedUsers,
        bool? isInterested,
    }) => 
        PostDetailModel(
            post: post ?? this.post,
            author: author ?? this.author,
            service: service ?? this.service,
            interestedCount: interestedCount ?? this.interestedCount,
            interestedUsers: interestedUsers ?? this.interestedUsers,
            giftedUsers: giftedUsers ?? this.giftedUsers,
            isInterested: isInterested ?? this.isInterested,
        );

    factory PostDetailModel.fromJson(Map<String, dynamic> json) => PostDetailModel(
        post: json["post"] == null ? null : Post.fromJson(json["post"]),
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        service: json["service"],
        interestedCount: json["interestedCount"],
        interestedUsers: json["interestedUsers"] == null ? [] : List<dynamic>.from(json["interestedUsers"]!.map((x) => x)),
        giftedUsers: json["giftedUsers"] == null ? [] : List<GiftedUser>.from(json["giftedUsers"]!.map((x) => GiftedUser.fromJson(x))),
        isInterested: json["isInterested"],
    );

    Map<String, dynamic> toJson() => {
        "post": post?.toJson(),
        "author": author?.toJson(),
        "service": service,
        "interestedCount": interestedCount,
        "interestedUsers": interestedUsers == null ? [] : List<dynamic>.from(interestedUsers!.map((x) => x)),
        "giftedUsers": giftedUsers == null ? [] : List<dynamic>.from(giftedUsers!.map((x) => x.toJson())),
        "isInterested": isInterested,
    };
}

class Author {
    String? id;
    String? firstName;
    String? lastName;
    DateTime? dob;
    String? gender;
    String? address;
    String? availableStatus;
    String? profile;
    double? latitude;
    double? longitude;
    DateTime? locationUpdatedAt;
    bool? isPhoneVerified;
    bool? sendMailNoti;
    bool? sendSmsNoti;
    bool? sendPushNoti;
    bool? sendWhatsappNoti;
    String? referralCode;
    String? customerReferralCode;
    dynamic referredById;
    int? totalReferredModels;
    int? totalReferredCustomers;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? approveById;
    double? recommendationScore;

    Author({
        this.id,
        this.firstName,
        this.lastName,
        this.dob,
        this.gender,
        this.address,
        this.availableStatus,
        this.profile,
        this.latitude,
        this.longitude,
        this.locationUpdatedAt,
        this.isPhoneVerified,
        this.sendMailNoti,
        this.sendSmsNoti,
        this.sendPushNoti,
        this.sendWhatsappNoti,
        this.referralCode,
        this.customerReferralCode,
        this.referredById,
        this.totalReferredModels,
        this.totalReferredCustomers,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.approveById,
        this.recommendationScore,
    });

    Author copyWith({
        String? id,
        String? firstName,
        String? lastName,
        DateTime? dob,
        String? gender,
        String? address,
        String? availableStatus,
        String? profile,
        double? latitude,
        double? longitude,
        DateTime? locationUpdatedAt,
        bool? isPhoneVerified,
        bool? sendMailNoti,
        bool? sendSmsNoti,
        bool? sendPushNoti,
        bool? sendWhatsappNoti,
        String? referralCode,
        String? customerReferralCode,
        dynamic referredById,
        int? totalReferredModels,
        int? totalReferredCustomers,
        String? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? approveById,
        double? recommendationScore,
    }) => 
        Author(
            id: id ?? this.id,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            dob: dob ?? this.dob,
            gender: gender ?? this.gender,
            address: address ?? this.address,
            availableStatus: availableStatus ?? this.availableStatus,
            profile: profile ?? this.profile,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
            locationUpdatedAt: locationUpdatedAt ?? this.locationUpdatedAt,
            isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
            sendMailNoti: sendMailNoti ?? this.sendMailNoti,
            sendSmsNoti: sendSmsNoti ?? this.sendSmsNoti,
            sendPushNoti: sendPushNoti ?? this.sendPushNoti,
            sendWhatsappNoti: sendWhatsappNoti ?? this.sendWhatsappNoti,
            referralCode: referralCode ?? this.referralCode,
            customerReferralCode: customerReferralCode ?? this.customerReferralCode,
            referredById: referredById ?? this.referredById,
            totalReferredModels: totalReferredModels ?? this.totalReferredModels,
            totalReferredCustomers: totalReferredCustomers ?? this.totalReferredCustomers,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            approveById: approveById ?? this.approveById,
            recommendationScore: recommendationScore ?? this.recommendationScore,
        );

    factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        gender: json["gender"],
        address: json["address"],
        availableStatus: json["available_status"],
        profile: json["profile"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        locationUpdatedAt: json["locationUpdatedAt"] == null ? null : DateTime.parse(json["locationUpdatedAt"]),
        isPhoneVerified: json["isPhoneVerified"],
        sendMailNoti: json["sendMailNoti"],
        sendSmsNoti: json["sendSMSNoti"],
        sendPushNoti: json["sendPushNoti"],
        sendWhatsappNoti: json["sendWhatsappNoti"],
        referralCode: json["referralCode"],
        customerReferralCode: json["customerReferralCode"],
        referredById: json["referredById"],
        totalReferredModels: json["totalReferredModels"],
        totalReferredCustomers: json["totalReferredCustomers"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        approveById: json["approveById"],
        recommendationScore: json["recommendationScore"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "dob": dob?.toIso8601String(),
        "gender": gender,
        "address": address,
        "available_status": availableStatus,
        "profile": profile,
        "latitude": latitude,
        "longitude": longitude,
        "locationUpdatedAt": locationUpdatedAt?.toIso8601String(),
        "isPhoneVerified": isPhoneVerified,
        "sendMailNoti": sendMailNoti,
        "sendSMSNoti": sendSmsNoti,
        "sendPushNoti": sendPushNoti,
        "sendWhatsappNoti": sendWhatsappNoti,
        "referralCode": referralCode,
        "customerReferralCode": customerReferralCode,
        "referredById": referredById,
        "totalReferredModels": totalReferredModels,
        "totalReferredCustomers": totalReferredCustomers,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "approveById": approveById,
        "recommendationScore": recommendationScore,
    };
}

class GiftedUser {
    String? id;
    String? userType;
    int? amount;
    DateTime? createdAt;
    Gift? gift;
    User? user;

    GiftedUser({
        this.id,
        this.userType,
        this.amount,
        this.createdAt,
        this.gift,
        this.user,
    });

    GiftedUser copyWith({
        String? id,
        String? userType,
        int? amount,
        DateTime? createdAt,
        Gift? gift,
        User? user,
    }) => 
        GiftedUser(
            id: id ?? this.id,
            userType: userType ?? this.userType,
            amount: amount ?? this.amount,
            createdAt: createdAt ?? this.createdAt,
            gift: gift ?? this.gift,
            user: user ?? this.user,
        );

    factory GiftedUser.fromJson(Map<String, dynamic> json) => GiftedUser(
        id: json["id"],
        userType: json["userType"],
        amount: json["amount"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        gift: json["gift"] == null ? null : Gift.fromJson(json["gift"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userType": userType,
        "amount": amount,
        "createdAt": createdAt?.toIso8601String(),
        "gift": gift?.toJson(),
        "user": user?.toJson(),
    };
}

class Gift {
    String? id;
    String? name;
    dynamic icon;
    String? image;
    int? price;

    Gift({
        this.id,
        this.name,
        this.icon,
        this.image,
        this.price,
    });

    Gift copyWith({
        String? id,
        String? name,
        dynamic icon,
        String? image,
        int? price,
    }) => 
        Gift(
            id: id ?? this.id,
            name: name ?? this.name,
            icon: icon ?? this.icon,
            image: image ?? this.image,
            price: price ?? this.price,
        );

    factory Gift.fromJson(Map<String, dynamic> json) => Gift(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        image: json["image"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "image": image,
        "price": price,
    };
}

class User {
    String? id;
    String? firstName;
    String? lastName;
    String? profile;

    User({
        this.id,
        this.firstName,
        this.lastName,
        this.profile,
    });

    User copyWith({
        String? id,
        String? firstName,
        String? lastName,
        String? profile,
    }) => 
        User(
            id: id ?? this.id,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            profile: profile ?? this.profile,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profile: json["profile"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "profile": profile,
    };
}

class Post {
    String? id;
    String? authorType;
    String? content;
    List<String>? images;
    dynamic targetGender;
    dynamic targetCount;
    dynamic targetAgeMin;
    dynamic targetAgeMax;
    dynamic preferredDate;
    dynamic preferredTime;
    dynamic location;
    bool? hasTip;
    String? status;
    DateTime? expiresAt;
    int? interestedCount;
    List<dynamic>? notifiedUserIds;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? modelId;
    dynamic customerId;
    dynamic serviceId;

    Post({
        this.id,
        this.authorType,
        this.content,
        this.images,
        this.targetGender,
        this.targetCount,
        this.targetAgeMin,
        this.targetAgeMax,
        this.preferredDate,
        this.preferredTime,
        this.location,
        this.hasTip,
        this.status,
        this.expiresAt,
        this.interestedCount,
        this.notifiedUserIds,
        this.createdAt,
        this.updatedAt,
        this.modelId,
        this.customerId,
        this.serviceId,
    });

    Post copyWith({
        String? id,
        String? authorType,
        String? content,
        List<String>? images,
        dynamic targetGender,
        dynamic targetCount,
        dynamic targetAgeMin,
        dynamic targetAgeMax,
        dynamic preferredDate,
        dynamic preferredTime,
        dynamic location,
        bool? hasTip,
        String? status,
        DateTime? expiresAt,
        int? interestedCount,
        List<dynamic>? notifiedUserIds,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? modelId,
        dynamic customerId,
        dynamic serviceId,
    }) => 
        Post(
            id: id ?? this.id,
            authorType: authorType ?? this.authorType,
            content: content ?? this.content,
            images: images ?? this.images,
            targetGender: targetGender ?? this.targetGender,
            targetCount: targetCount ?? this.targetCount,
            targetAgeMin: targetAgeMin ?? this.targetAgeMin,
            targetAgeMax: targetAgeMax ?? this.targetAgeMax,
            preferredDate: preferredDate ?? this.preferredDate,
            preferredTime: preferredTime ?? this.preferredTime,
            location: location ?? this.location,
            hasTip: hasTip ?? this.hasTip,
            status: status ?? this.status,
            expiresAt: expiresAt ?? this.expiresAt,
            interestedCount: interestedCount ?? this.interestedCount,
            notifiedUserIds: notifiedUserIds ?? this.notifiedUserIds,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            modelId: modelId ?? this.modelId,
            customerId: customerId ?? this.customerId,
            serviceId: serviceId ?? this.serviceId,
        );

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        authorType: json["authorType"],
        content: json["content"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        targetGender: json["targetGender"],
        targetCount: json["targetCount"],
        targetAgeMin: json["targetAgeMin"],
        targetAgeMax: json["targetAgeMax"],
        preferredDate: json["preferredDate"],
        preferredTime: json["preferredTime"],
        location: json["location"],
        hasTip: json["hasTip"],
        status: json["status"],
        expiresAt: json["expiresAt"] == null ? null : DateTime.parse(json["expiresAt"]),
        interestedCount: json["interestedCount"],
        notifiedUserIds: json["notifiedUserIds"] == null ? [] : List<dynamic>.from(json["notifiedUserIds"]!.map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        modelId: json["modelId"],
        customerId: json["customerId"],
        serviceId: json["serviceId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "authorType": authorType,
        "content": content,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "targetGender": targetGender,
        "targetCount": targetCount,
        "targetAgeMin": targetAgeMin,
        "targetAgeMax": targetAgeMax,
        "preferredDate": preferredDate,
        "preferredTime": preferredTime,
        "location": location,
        "hasTip": hasTip,
        "status": status,
        "expiresAt": expiresAt?.toIso8601String(),
        "interestedCount": interestedCount,
        "notifiedUserIds": notifiedUserIds == null ? [] : List<dynamic>.from(notifiedUserIds!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "modelId": modelId,
        "customerId": customerId,
        "serviceId": serviceId,
    };
}
