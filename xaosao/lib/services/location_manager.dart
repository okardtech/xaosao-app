import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

/// Resolves GPS permission once on startup and caches the result.
/// Re-usable anywhere via Get.find<LocationManager>().position.
class LocationManager extends GetxService {
  final Rx<Position?> position = Rx<Position?>(null);

  Future<LocationManager> init() async {
    position.value = await _resolve();
    return this;
  }

  /// Refreshes the cached position on demand (e.g. user taps "re-locate").
  Future<void> refresh() async {
    position.value = await _resolve();
  }

  // ── Internal ────────────────────────────────────────────────
  static Future<Position?> _resolve() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      return null;
    }
  }
}
