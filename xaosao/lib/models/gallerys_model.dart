// To parse this JSON data, do
//
//     final gallerysModel = gallerysModelFromJson(jsonString);

import 'dart:convert';

List<GallerysModel> gallerysModelFromJson(String str) => List<GallerysModel>.from(json.decode(str).map((x) => GallerysModel.fromJson(x)));

String gallerysModelToJson(List<GallerysModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GallerysModel {
    String? id;
    String? url;

    GallerysModel({
        this.id,
        this.url,
    });

    GallerysModel copyWith({
        String? id,
        String? url,
    }) => 
        GallerysModel(
            id: id ?? this.id,
            url: url ?? this.url,
        );

    factory GallerysModel.fromJson(Map<String, dynamic> json) => GallerysModel(
        id: json["id"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
    };
}
