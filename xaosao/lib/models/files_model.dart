// To parse this JSON data, do
//
//     final filesModel = filesModelFromJson(jsonString);

import 'dart:convert';

FilesModel filesModelFromJson(String str) => FilesModel.fromJson(json.decode(str));

String filesModelToJson(FilesModel data) => json.encode(data.toJson());

class FilesModel {
    String? id;
    String? filename;
    String? url;

    FilesModel({
        this.id,
        this.filename,
        this.url,
    });

    factory FilesModel.fromJson(Map<String, dynamic> json) => FilesModel(
        id: json["id"],
        filename: json["filename"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "filename": filename,
        "url": url,
    };
}
