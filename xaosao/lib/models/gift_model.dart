import 'dart:convert';

List<GiftModel> GiftModelFromJson(String str) =>
    List<GiftModel>.from(
      json.decode(str).map((x) => GiftModel.fromJson(x)),
    );

String GiftModelToJson(List<GiftModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GiftModel {
  String? id;
  String? name;
  String? image;
  double? price;
  int? sortOrder;

  GiftModel({
    this.id,
    this.name,
    this.image,
    this.price,
    this.sortOrder,
  });

  GiftModel copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    int? sortOrder,
  }) => GiftModel(
    id: id ?? this.id,
    name: name ?? this.name,
    image: image ?? this.image,
    price: price ?? this.price,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    price: json["price"] == null
        ? null
        : (json["price"] as num).toDouble(),
    sortOrder: json["sortOrder"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "price": price,
    "sortOrder": sortOrder,
  };
}