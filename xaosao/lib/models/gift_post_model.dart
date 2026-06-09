// To parse this JSON data, do
//
//     final giftPostModel = giftPostModelFromJson(jsonString);

import 'dart:convert';

GiftPostModel giftPostModelFromJson(String str) => GiftPostModel.fromJson(json.decode(str));

String giftPostModelToJson(GiftPostModel data) => json.encode(data.toJson());

class GiftPostModel {
    int? totalGifts;
    List<GiftSummary>? giftSummary;
    List<GiftElement>? gifts;

    GiftPostModel({
        this.totalGifts,
        this.giftSummary,
        this.gifts,
    });

    factory GiftPostModel.fromJson(Map<String, dynamic> json) => GiftPostModel(
        totalGifts: json["totalGifts"],
        giftSummary: json["giftSummary"] == null ? [] : List<GiftSummary>.from(json["giftSummary"]!.map((x) => GiftSummary.fromJson(x))),
        gifts: json["gifts"] == null ? [] : List<GiftElement>.from(json["gifts"]!.map((x) => GiftElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalGifts": totalGifts,
        "giftSummary": giftSummary == null ? [] : List<dynamic>.from(giftSummary!.map((x) => x.toJson())),
        "gifts": gifts == null ? [] : List<dynamic>.from(gifts!.map((x) => x.toJson())),
    };
}

class GiftSummary {
    GiftSummaryGift? gift;
    int? count;

    GiftSummary({
        this.gift,
        this.count,
    });

    factory GiftSummary.fromJson(Map<String, dynamic> json) => GiftSummary(
        gift: json["gift"] == null ? null : GiftSummaryGift.fromJson(json["gift"]),
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "gift": gift?.toJson(),
        "count": count,
    };
}

class GiftSummaryGift {
    String? id;
    String? name;
    String? image;
    int? price;

    GiftSummaryGift({
        this.id,
        this.name,
        this.image,
        this.price,
    });

    factory GiftSummaryGift.fromJson(Map<String, dynamic> json) => GiftSummaryGift(
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

class GiftElement {
    String? id;
    String? giftId;
    String? customerId;
    String? modelId;
    int? amount;
    dynamic reaction;
    DateTime? createdAt;
    GiftSummaryGift? gift;

    GiftElement({
        this.id,
        this.giftId,
        this.customerId,
        this.modelId,
        this.amount,
        this.reaction,
        this.createdAt,
        this.gift,
    });

    factory GiftElement.fromJson(Map<String, dynamic> json) => GiftElement(
        id: json["id"],
        giftId: json["giftId"],
        customerId: json["customerId"],
        modelId: json["modelId"],
        amount: json["amount"],
        reaction: json["reaction"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        gift: json["gift"] == null ? null : GiftSummaryGift.fromJson(json["gift"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "giftId": giftId,
        "customerId": customerId,
        "modelId": modelId,
        "amount": amount,
        "reaction": reaction,
        "createdAt": createdAt?.toIso8601String(),
        "gift": gift?.toJson(),
    };
}
