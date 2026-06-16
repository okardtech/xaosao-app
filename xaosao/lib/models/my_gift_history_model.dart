// To parse this JSON data, do
//
//     final myGiftHistoryModel = myGiftHistoryModelFromJson(jsonString);

import 'dart:convert';

List<MyGiftHistoryModel> myGiftHistoryModelFromJson(String str) => List<MyGiftHistoryModel>.from(json.decode(str).map((x) => MyGiftHistoryModel.fromJson(x)));

String myGiftHistoryModelToJson(List<MyGiftHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyGiftHistoryModel {
    String? id;
    String? type;
    String? giftId;
    String? postId;
    String? modelId;
    int? amount;
    DateTime? createdAt;
    Gift? gift;

    MyGiftHistoryModel({
        this.id,
        this.type,
        this.giftId,
        this.postId,
        this.modelId,
        this.amount,
        this.createdAt,
        this.gift,
    });

    MyGiftHistoryModel copyWith({
        String? id,
        String? type,
        String? giftId,
        String? postId,
        String? modelId,
        int? amount,
        DateTime? createdAt,
        Gift? gift,
    }) => 
        MyGiftHistoryModel(
            id: id ?? this.id,
            type: type ?? this.type,
            giftId: giftId ?? this.giftId,
            postId: postId ?? this.postId,
            modelId: modelId ?? this.modelId,
            amount: amount ?? this.amount,
            createdAt: createdAt ?? this.createdAt,
            gift: gift ?? this.gift,
        );

    factory MyGiftHistoryModel.fromJson(Map<String, dynamic> json) => MyGiftHistoryModel(
        id: json["id"],
        type: json["type"],
        giftId: json["giftId"],
        postId: json["postId"],
        modelId: json["modelId"],
        amount: json["amount"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        gift: json["gift"] == null ? null : Gift.fromJson(json["gift"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "giftId": giftId,
        "postId": postId,
        "modelId": modelId,
        "amount": amount,
        "createdAt": createdAt?.toIso8601String(),
        "gift": gift?.toJson(),
    };
}

class Gift {
    String? id;
    String? name;
    String? image;
    int? price;

    Gift({
        this.id,
        this.name,
        this.image,
        this.price,
    });

    Gift copyWith({
        String? id,
        String? name,
        String? image,
        int? price,
    }) => 
        Gift(
            id: id ?? this.id,
            name: name ?? this.name,
            image: image ?? this.image,
            price: price ?? this.price,
        );

    factory Gift.fromJson(Map<String, dynamic> json) => Gift(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
    };
}
