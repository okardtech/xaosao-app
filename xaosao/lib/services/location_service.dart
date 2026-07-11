import 'package:get/get.dart';
import 'package:xaosao/repository/login_repo.dart';
import 'package:xaosao/services/location_manager.dart';

/// One-shot GPS → server push.
///
/// Permission and OS-level GPS-toggle handling live in
/// [PermissionCoordinator]. Position acquisition is delegated to
/// [LocationManager.getOrRefresh] so the GPS hardware is fixed AT MOST
/// once per cache window (5 min) regardless of how many consumers ask.
///
/// Fire-and-forget — never throws, swallows all failures silently
/// (no permission, GPS off, hardware timeout, network error).
class LocationService {
  LocationService._();

  static final _repo = LoginRepo();

  static Future<void> push() async {
    try {
      final position = await Get.find<LocationManager>().getOrRefresh();
      if (position == null) return;
      await _repo.updateLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      // LocationManager not registered yet, or any other failure — swallow.
    }
  }
}
