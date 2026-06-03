import 'dart:math';

/// Haversine formula — returns distance in kilometres between two coordinates.
double distanceKmBetween(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const earthR = 6371.0;
  final dLat = _toRad(lat2 - lat1);
  final dLon = _toRad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  return earthR * 2 * atan2(sqrt(a), sqrt(1 - a));
}

/// Human-readable distance string.
/// < 1 km → "850m" · < 10 km → "3.4km" · ≥ 10 km → "15km"
String formatDistanceKm(double km) {
  if (km < 1) return '${(km * 1000).round()}m';
  if (km < 10) return '${km.toStringAsFixed(1)}km';
  return '${km.round()}km';
}

double _toRad(double deg) => deg * pi / 180;
