import 'package:xaosao/utils/api_date_parser.dart';

class CustomerPublicProfile {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final int? whatsapp;
  final String? profile;
  final List<String> images;
  final String? bio;
  final DateTime? dob;
  final String? country;
  final String? tier;
  final int bookingCount;
  final int postCount;
  final int giftCount;
  final int giftAmount;
  final DateTime? lastActivityAt;
  final double? distanceKm;
  final DateTime? likedAt;
  final DateTime? createdAt;

  const CustomerPublicProfile({
    required this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.whatsapp,
    this.profile,
    this.images = const [],
    this.bio,
    this.dob,
    this.country,
    this.tier,
    this.bookingCount = 0,
    this.postCount = 0,
    this.giftCount = 0,
    this.giftAmount = 0,
    this.lastActivityAt,
    this.distanceKm,
    this.likedAt,
    this.createdAt,
  });

  factory CustomerPublicProfile.fromJson(Map<String, dynamic> json) {
    return CustomerPublicProfile(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      gender: json['gender']?.toString(),
      whatsapp: (json['whatsapp'] as num?)?.toInt(),
      profile: json['profile']?.toString(),
      images: (json['images'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      bio: json['bio']?.toString(),
      dob: _tryParse(json['dob']),
      country: json['country']?.toString(),
      tier: json['tier']?.toString(),
      bookingCount: (json['bookingCount'] as num?)?.toInt() ?? 0,
      postCount: (json['postCount'] as num?)?.toInt() ?? 0,
      giftCount: (json['giftCount'] as num?)?.toInt() ?? 0,
      giftAmount: (json['giftAmount'] as num?)?.toInt() ?? 0,
      lastActivityAt: _tryParse(json['lastActivityAt']),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      likedAt: _tryParse(json['likedAt']),
      createdAt: _tryParse(json['createdAt']),
    );
  }

  static DateTime? _tryParse(dynamic v) => parseApiDateTime(v);

  String get displayName {
    final parts = [firstName, lastName]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');
    return parts.isNotEmpty ? parts : 'Unknown';
  }

  int get age {
    if (dob == null) return 0;
    final now = DateTime.now();
    int a = now.year - dob!.year;
    if (now.month < dob!.month ||
        (now.month == dob!.month && now.day < dob!.day)) {
      a--;
    }
    return a;
  }

  bool get isVip => tier != null && tier!.toLowerCase() != 'basic';

  List<String> get allPhotos {
    if (images.isNotEmpty) return images;
    if (profile != null && profile!.isNotEmpty) return [profile!];
    return [];
  }
}
