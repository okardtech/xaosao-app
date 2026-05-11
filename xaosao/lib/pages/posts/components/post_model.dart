import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
//  PostModel
// ═══════════════════════════════════════════════════════════════
class PostModel {
  final String id;
  final String authorName;
  final int authorAge;
  final String? authorImageUrl;
  final List<Color> authorGradient;
  final String text;
  final String? imageUrl;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final int giftCount;
  final int bookCount;
  final bool isLikedByMe;

  const PostModel({
    required this.id,
    required this.authorName,
    required this.authorAge,
    this.authorImageUrl,
    required this.authorGradient,
    required this.text,
    this.imageUrl,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.giftCount = 0,
    this.bookCount = 0,
    this.isLikedByMe = false,
  });

  PostModel copyWith({bool? isLikedByMe, int? likeCount}) => PostModel(
    id: id,
    authorName: authorName,
    authorAge: authorAge,
    authorImageUrl: authorImageUrl,
    authorGradient: authorGradient,
    text: text,
    imageUrl: imageUrl,
    createdAt: createdAt,
    likeCount: likeCount ?? this.likeCount,
    commentCount: commentCount,
    giftCount: giftCount,
    bookCount: bookCount,
    isLikedByMe: isLikedByMe ?? this.isLikedByMe,
  );

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} ນາທີກ່ອນ';
    if (diff.inHours < 24) return '${diff.inHours} ຊ.ມ. ກ່ອນ';
    if (diff.inDays < 7) return '${diff.inDays} ວັນກ່ອນ';
    return 'ມື້ວານ';
  }
}

// ═══════════════════════════════════════════════════════════════
//  Mock data
// ═══════════════════════════════════════════════════════════════
final List<PostModel> mockAllPosts = [
  PostModel(
    id: 'p1',
    authorName: 'Kai',
    authorAge: 26,
    authorGradient: [const Color(0xFF5C6BC0), const Color(0xFF1A1A2E)],
    text: 'ຫາເພື່ອນໄປທ່ຽວ Weekend ນີ້ 🗺️ ໃຜຫວ່າງ DM ຫາໄດ້ #ຫາຄູ່ທ່ຽວ',
    imageUrl: 'https://cdn.ubitto.com/content/uploads/2019/09/xcscscs.jpg',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    likeCount: 24,
    commentCount: 8,
    giftCount: 3,
    bookCount: 2,
    isLikedByMe: true,
  ),
  PostModel(
    id: 'p2',
    authorName: 'Leo',
    authorAge: 28,
    authorGradient: [const Color(0xFFf093fb), const Color(0xFFc2185b)],
    text:
        'ວ່າງທຸກວັນ ຈ–ສ ຮັບນວດ Home Service ເຂດວຽງຈັນ ລາຄາ 150,000 ກີບ/ຊ.ມ. #ນວດ #HomeSpa',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    imageUrl:
        "https://i.pinimg.com/736x/56/5c/7b/565c7b3ee745a34db26b1794962901d7.jpg",
    likeCount: 18,
    commentCount: 3,
    giftCount: 1,
    bookCount: 5,
  ),
  PostModel(
    id: 'p3',
    authorName: 'Mark',
    authorAge: 24,
    authorGradient: [const Color(0xFF43e97b), const Color(0xFF1A5276)],
    text: 'ຫາເພື່ອນດູໜັງຄືນນີ້ ໃຜຫວ່າງ DM ໄດ້ 🎬 #ດູໜັງ #ຫາຄູ່',
    imageUrl: 'https://www.shutterstock.com/image-photo/closeup-20yearold-korean-woman-neatly-260nw-2581247643.jpg',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    likeCount: 41,
    commentCount: 12,
    giftCount: 0,
    bookCount: 3,
  ),
];

final List<PostModel> mockMyPosts = [
  PostModel(
    id: 'mp1',
    authorName: 'Me',
    authorAge: 25,
    authorGradient: [const Color(0xFF5C6BC0), const Color(0xFF1A1A2E)],
    text: 'ຫາເພື່ອນໄປທ່ຽວ Weekend ນີ້ 🗺️ ໃຜຫວ່າງ DM ຫາໄດ້ #ຫາຄູ່ທ່ຽວ',
    imageUrl: '',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    likeCount: 24,
    commentCount: 8,
    giftCount: 3,
    bookCount: 2,
  ),
  PostModel(
    id: 'mp2',
    authorName: 'Me',
    authorAge: 25,
    authorGradient: [const Color(0xFF5C6BC0), const Color(0xFF1A1A2E)],
    text: 'ວ່າງຄືນນີ້ ໃຜຢາກໄປເດີນແຖວວຽງຈັນ DM ຫາ 😊 #ວຽງຈັນ',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    likeCount: 11,
    commentCount: 2,
    giftCount: 0,
    bookCount: 1,
  ),
  PostModel(
    id: 'mp3',
    authorName: 'Me',
    authorAge: 25,
    authorGradient: [const Color(0xFF5C6BC0), const Color(0xFF1A1A2E)],
    text: 'ຮັບນວດ Home Service ທຸກວັນ 150,000 ກີບ/ຊ.ມ. #ນວດ',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    likeCount: 33,
    commentCount: 5,
    giftCount: 1,
    bookCount: 4,
  ),
];
