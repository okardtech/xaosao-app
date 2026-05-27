class CommentAuthor {
  final String id;
  final String? userType;
  final String? firstName;
  final String? lastName;
  final String? profile;

  const CommentAuthor({
    required this.id,
    this.userType,
    this.firstName,
    this.lastName,
    this.profile,
  });

  factory CommentAuthor.fromJson(Map<String, dynamic> json) => CommentAuthor(
        id: (json['id'] as String?) ?? '',
        userType: json['userType'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        profile: json['profile'] as String?,
      );

  String get displayName {
    final parts = <String>[];
    if (firstName != null && firstName!.isNotEmpty) parts.add(firstName!);
    if (lastName != null && lastName!.isNotEmpty) parts.add(lastName!);
    return parts.isEmpty ? 'ຜູ້ໃຊ້' : parts.join(' ');
  }
}

class CommentModel {
  final String id;
  final String? postId;
  final String? userType;
  final String? parentId; // null = top-level comment; non-null = reply
  final String? content;
  final DateTime? createdAt;
  final CommentAuthor? author;
  final int replyCount; // only meaningful for top-level comments

  const CommentModel({
    required this.id,
    this.postId,
    this.userType,
    this.parentId,
    this.content,
    this.createdAt,
    this.author,
    this.replyCount = 0,
  });

  bool get isReply => parentId != null;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: (json['id'] as String?) ?? '',
        postId: json['postId'] as String?,
        userType: json['userType'] as String?,
        parentId: json['parentId'] as String?,
        content: json['content'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        author: json['author'] != null
            ? CommentAuthor.fromJson(json['author'] as Map<String, dynamic>)
            : null,
        replyCount: (json['replyCount'] as int?) ?? 0,
      );

  CommentModel copyWith({
    CommentAuthor? author,
    int? replyCount,
    String? content,
  }) =>
      CommentModel(
        id: id,
        postId: postId,
        userType: userType,
        parentId: parentId,
        content: content ?? this.content,
        createdAt: createdAt,
        author: author ?? this.author,
        replyCount: replyCount ?? this.replyCount,
      );
}
