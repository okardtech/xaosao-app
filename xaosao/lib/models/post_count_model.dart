// To parse this JSON data, do
//
//     final postCountModel = postCountModelFromJson(jsonString);

import 'dart:convert';

PostCountModel postCountModelFromJson(String str) => PostCountModel.fromJson(json.decode(str));

String postCountModelToJson(PostCountModel data) => json.encode(data.toJson());

class PostCountModel {
    int? interests;
    int? comments;
    int? gifts;

    PostCountModel({
        this.interests,
        this.comments,
        this.gifts,
    });

    factory PostCountModel.fromJson(Map<String, dynamic> json) => PostCountModel(
        interests: json["interests"],
        comments: json["comments"],
        gifts: json["gifts"],
    );

    Map<String, dynamic> toJson() => {
        "interests": interests,
        "comments": comments,
        "gifts": gifts,
    };
}
