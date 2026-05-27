// To parse this JSON data, do
//
//     final createCommentModel = createCommentModelFromJson(jsonString);

import 'dart:convert';

CreateCommentModel createCommentModelFromJson(String str) => CreateCommentModel.fromJson(json.decode(str));

String createCommentModelToJson(CreateCommentModel data) => json.encode(data.toJson());

class CreateCommentModel {
    String? id;
    String? postId;
    String? userType;
    String? content;
    DateTime? createdAt;

    CreateCommentModel({
        this.id,
        this.postId,
        this.userType,
        this.content,
        this.createdAt,
    });

    factory CreateCommentModel.fromJson(Map<String, dynamic> json) => CreateCommentModel(
        id: json["id"],
        postId: json["postId"],
        userType: json["userType"],
        content: json["content"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "userType": userType,
        "content": content,
        "createdAt": createdAt?.toIso8601String(),
    };
}
