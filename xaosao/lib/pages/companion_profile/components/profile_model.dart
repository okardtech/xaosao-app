import 'package:flutter/material.dart';

import '../../home/components/companion_card.dart';

// enum ServiceType { social, massage, travel }

// extension ServiceTypeExt on ServiceType {
//   String get label {
//     switch (this) {
//       case ServiceType.social:   return 'ເພື່ອນສັງຄົມ';
//       case ServiceType.massage:  return 'ນວດ';
//       case ServiceType.travel:   return 'ເພື່ອນທ່ຽວ';
//     }
//   }
//   String get description {
//     switch (this) {
//       case ServiceType.social:   return 'ທ່ຽວ, ງານລ້ຽງ, ທຸກໂອກາດ';
//       case ServiceType.massage:  return 'ນວດສຸຂະພາບໂດຍມືອາຊີບ';
//       case ServiceType.travel:   return 'Guide ໃນ ແລະ ຕ່າງປະເທດ';
//     }
//   }
//   int get pricePerHour {
//     switch (this) {
//       case ServiceType.social:   return 150000;
//       case ServiceType.massage:  return 180000;
//       case ServiceType.travel:   return 200000;
//     }
//   }
//   IconData get icon {
//     switch (this) {
//       case ServiceType.social:   return Icons.people_outline_rounded;
//       case ServiceType.massage:  return Icons.spa_outlined;
//       case ServiceType.travel:   return Icons.flight_takeoff_outlined;
//     }
//   }
//   Color get color {
//     switch (this) {
//       case ServiceType.social:   return const Color(0xFFF06292);
//       case ServiceType.massage:  return const Color(0xFF42A5F5);
//       case ServiceType.travel:   return const Color(0xFFAB47BC);
//     }
//   }
//   Color get bgColor {
//     switch (this) {
//       case ServiceType.social:   return const Color(0xFFFFF0F6);
//       case ServiceType.massage:  return const Color(0xFFF0F7FF);
//       case ServiceType.travel:   return const Color(0xFFF3F0FF);
//     }
//   }
//   String get formattedPrice {
//     final n = pricePerHour;
//     if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
//     return '${n ~/ 1000}k';
//   }
// }

class ReviewModel {
  final String id;
  final String userName;
  final double rating;
  final String text;
  final String timeAgo;
  final Color avatarColor;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.text,
    required this.timeAgo,
    required this.avatarColor,
  });
}

class PostMini {
  final String id;
  final String? imageUrl;
  final List<Color> gradient;
  final String caption;
  final int likeCount;

  const PostMini({
    required this.id,
    this.imageUrl,
    required this.gradient,
    required this.caption,
    required this.likeCount,
  });

  String get formattedLikes =>
      likeCount >= 1000 ? '${(likeCount / 1000).toStringAsFixed(1)}k' : '$likeCount';
}

class CompanionProfile {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final List<String> photoUrls;
  final List<Color> gradient;
  final bool isOnline;
  final bool isVip;
  final bool isVerified;
  final bool isActive;
  final double distanceKm;
  final String district;
  final String city;
  final double rating;
  final int likeCount;
  final int followerCount;
  final int reviewCount;
  final String bio;
  final int heightCm;
  final List<String> languages;
  final List<ServiceType> services;
  final List<ReviewModel> reviews;
  final List<PostMini> posts;
  final Map<int, double> ratingBreakdown;

  const CompanionProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.photoUrls,
    required this.gradient,
    required this.isOnline,
    required this.isVip,
    required this.isVerified,
    required this.isActive,
    required this.distanceKm,
    required this.district,
    required this.city,
    required this.rating,
    required this.likeCount,
    required this.followerCount,
    required this.reviewCount,
    required this.bio,
    required this.heightCm,
    required this.languages,
    required this.services,
    required this.reviews,
    required this.posts,
    required this.ratingBreakdown,
  });

  String get fullName    => '$firstName $lastName';
  String get nameAge     => '$firstName, $age';
  String get formattedLikes =>
      likeCount >= 1000 ? '${(likeCount / 1000).toStringAsFixed(1)}k' : '$likeCount';
  String get formattedFollowers =>
      followerCount >= 1000 ? '${(followerCount / 1000).toStringAsFixed(1)}k' : '$followerCount';
  String get formattedDistance =>
      distanceKm < 1 ? '${(distanceKm * 1000).toInt()}m' : '${distanceKm}km';
  int get minPrice =>
      services.isEmpty ? 0 : services.map((s) => s.pricePerHour).reduce((a, b) => a < b ? a : b);
  String get formattedMinPrice {
    final n = minPrice;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000)    return '${n ~/ 1000},000';
    return '$n';
  }
}

// ── Mock data ──────────────────────────────────────────────────
final mockKaiProfile = CompanionProfile(
  id: 'kai_01',
  firstName: 'Kai', lastName: 'Vongkhamphanh', age: 26,
  photoUrls: const [
    "https://www.shutterstock.com/image-photo/beautiful-young-asian-woman-pointing-600nw-2341582245.jpg"
  ],
  gradient: [const Color(0xFF5C6BC0), const Color(0xFF1A1A2E)],
  isOnline: true, isVip: true, isVerified: true, isActive: true,
  distanceKm: 1.2, district: 'ໄຊເສດຖາ', city: 'ວຽງຈັນ',
  rating: 4.9, likeCount: 1400, followerCount: 892, reviewCount: 128,
  bio: 'ສະບາຍດີ ຂ້ອຍ Kai ມັກທ່ຽວ ກິນເຂົ້ານຳກັນ ແລະ ສ້າງຄວາມສຸກໃຫ້ທ່ານ. ພ້ອມເອົາໃຈໃສ່ທ່ານທຸກໂອກາດ 😊',
  heightCm: 178,
  languages: ['ລາວ', 'ອັງກິດ'],
  services: [ServiceType.social, ServiceType.travel],
  ratingBreakdown: {5: 0.88, 4: 0.09, 3: 0.03},
  reviews: const [
    ReviewModel(
      id: 'r1', userName: 'Anh V.', rating: 5.0,
      text: 'ດີຫຼາຍ ພາທ່ຽວຊອບ ເຂົ້ານ້ຳໃຈດີ ຈະໃຊ້ຊ້ຳ!',
      timeAgo: '2 ມື້ກ່ອນ', avatarColor: Color(0xFF43a047),
    ),
    ReviewModel(
      id: 'r2', userName: 'Mike T.', rating: 4.0,
      text: 'ໄວ້ໃຈໄດ້ ຕ້ອງການ guide ທ່ຽວ highly recommend',
      timeAgo: '1 ອາທິດ', avatarColor: Color(0xFF7b1fa2),
    ),
  ],
  posts: const [
    PostMini(id: 'pm1', gradient: [Color(0xFF5C6BC0), Color(0xFF1A1A2E)],
        caption: 'ຫາເພື່ອນທ່ຽວ Weekend!', likeCount: 24),
    PostMini(id: 'pm2', gradient: [Color(0xFF43e97b), Color(0xFF1A5276)],
        caption: 'ວ່າງຄືນນີ້ ໃຜຢາກໄປເດີນ', likeCount: 11),
    PostMini(id: 'pm3', gradient: [Color(0xFFf093fb), Color(0xFFc2185b)],
        caption: 'ຮ້ານກາເຟໃໝ່ ດີຫຼາຍ!', likeCount: 33),
    PostMini(id: 'pm4', gradient: [Color(0xFFfa709a), Color(0xFF7B1FA2)],
        caption: 'Sunday market', likeCount: 18),
  ],
);