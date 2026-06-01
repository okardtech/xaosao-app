import 'package:geolocator/geolocator.dart';
import 'package:xaosao/repository/login_repo.dart';

/// One-shot GPS → server push.
/// Call [push] on app open. Fire-and-forget — never throws.
class LocationService {
  LocationService._();

  static final _repo = LoginRepo();

  /// Resolves permission, fetches current position, then PATCHes the server.
  /// Returns silently on any failure (permission denied, GPS timeout, network).
  static Future<void> push() async {
    try {
      final position = await _resolvePosition();
      if (position == null) return;

      await _repo.updateLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {}
  }

  // ── Internal ───────────────────────────────────────────────────

  static Future<Position?> _resolvePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }
}
