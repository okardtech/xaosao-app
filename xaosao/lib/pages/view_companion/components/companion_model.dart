import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════
//  Service type enum
// ═══════════════════════════════════════════════════════
enum ServiceType { social, massage, travel }

extension ServiceTypeExt on ServiceType {
  String get label {
    switch (this) {
      case ServiceType.social:   return 'ສັງຄົມ';
      case ServiceType.massage:  return 'ນວດ';
      case ServiceType.travel:   return 'ທ່ຽວ';
    }
  }

  Color get color {
    switch (this) {
      case ServiceType.social:   return const Color(0xFFF06292);
      case ServiceType.massage:  return const Color(0xFF42A5F5);
      case ServiceType.travel:   return const Color(0xFFAB47BC);
    }
  }

  Color get bgColor {
    switch (this) {
      case ServiceType.social:   return const Color(0xFFFFF0F6);
      case ServiceType.massage:  return const Color(0xFFF0F7FF);
      case ServiceType.travel:   return const Color(0xFFF3F0FF);
    }
  }
}

// ═══════════════════════════════════════════════════════
//  Companion model
// ═══════════════════════════════════════════════════════
class Companion {
  final String id;
  final String name;
  final int age;
  final String imageUrl;
  final double rating;
  final int likes;
  final double distanceKm;
  final String district;
  final bool isOnline;
  final bool isVip;
  final bool isNew;
  final List<ServiceType> services;

  const Companion({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.rating,
    required this.likes,
    required this.distanceKm,
    required this.district,
    required this.isOnline,
    required this.isVip,
    required this.isNew,
    required this.services,
  });

  String get formattedLikes =>
      likes >= 1000 ? '${(likes / 1000).toStringAsFixed(1)}k' : '$likes';

  String get formattedDistance =>
      distanceKm < 1 ? '${(distanceKm * 1000).toInt()}m' : '${distanceKm}km';
}

// ═══════════════════════════════════════════════════════
//  Mock data
// ═══════════════════════════════════════════════════════
final List<Companion> mockCompanions = [
  const Companion(
    id: '1', name: 'Kai', age: 26, imageUrl: '',
    rating: 4.9, likes: 1400, distanceKm: 1.2,
    district: 'ວຽງຈັນ', isOnline: true, isVip: true, isNew: false,
    services: [ServiceType.social, ServiceType.travel],
  ),
  const Companion(
    id: '2', name: 'Mark', age: 24, imageUrl: '',
    rating: 4.7, likes: 340, distanceKm: 2.8,
    district: 'ສີໂຄດຕາບອງ', isOnline: true, isVip: false, isNew: true,
    services: [ServiceType.social, ServiceType.massage, ServiceType.travel],
  ),
  const Companion(
    id: '3', name: 'Leo', age: 28, imageUrl: '',
    rating: 4.8, likes: 920, distanceKm: 3.5,
    district: 'ຈັນທະບູລີ', isOnline: false, isVip: false, isNew: false,
    services: [ServiceType.massage, ServiceType.travel],
  ),
  const Companion(
    id: '4', name: 'Alex', age: 25, imageUrl: '',
    rating: 5.0, likes: 2100, distanceKm: 0.8,
    district: 'ໄຊເສດຖາ', isOnline: true, isVip: true, isNew: false,
    services: [ServiceType.social],
  ),
  const Companion(
    id: '5', name: 'Jin', age: 27, imageUrl: '',
    rating: 4.6, likes: 670, distanceKm: 4.2,
    district: 'ສີສັດຕະນາກ', isOnline: true, isVip: false, isNew: false,
    services: [ServiceType.social, ServiceType.massage],
  ),
  const Companion(
    id: '6', name: 'Sam', age: 23, imageUrl: '',
    rating: 4.5, likes: 280, distanceKm: 5.6,
    district: 'ໄຊທານີ', isOnline: true, isVip: false, isNew: false,
    services: [ServiceType.travel],
  ),
  const Companion(
    id: '7', name: 'Ryan', age: 29, imageUrl: '',
    rating: 4.8, likes: 1100, distanceKm: 6.8,
    district: 'ຫາດຊາຍຟອງ', isOnline: false, isVip: true, isNew: false,
    services: [ServiceType.massage, ServiceType.social],
  ),
  const Companion(
    id: '8', name: 'Tom', age: 22, imageUrl: '',
    rating: 4.3, likes: 95, distanceKm: 7.1,
    district: 'ນາຊາຍທອງ', isOnline: true, isVip: false, isNew: true,
    services: [ServiceType.social, ServiceType.travel],
  ),
];

// ── Gradient colors per card index ──────────────────────
const List<List<Color>> cardGradients = [
  [Color(0xFF667eea), Color(0xFF764ba2)],
  [Color(0xFFfa709a), Color(0xFFfee140)],
  [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
  [Color(0xFF4facfe), Color(0xFF00f2fe)],
  [Color(0xFFf093fb), Color(0xFFf5576c)],
  [Color(0xFF30cfd0), Color(0xFF667eea)],
  [Color(0xFF43e97b), Color(0xFF38f9d7)],
  [Color(0xFFffecd2), Color(0xFFfcb69f)],
];