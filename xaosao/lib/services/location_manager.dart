import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

/// Caches the user's last-known GPS position for in-app use
/// (distance calculations on home / discover cards, server sync via
/// [LocationService.push]).
///
/// Permission and OS-level GPS-toggle handling live in
/// [PermissionCoordinator]. This service NEVER prompts — it only reads
/// the device location when permission is already granted.
///
/// Design contract:
///   • `init()` returns immediately (no `await`), so `Get.putAsync` in
///     the initial binding does NOT block app startup on a GPS fix.
///   • `getOrRefresh()` is the single source of truth — returns a fresh
///     position if the cache is older than [_staleAfter], otherwise the
///     cached value.
///   • `refresh()` always fetches fresh.
class LocationManager extends GetxService {
  final Rx<Position?> position = Rx<Position?>(null);

  // A cached fix is considered fresh enough to reuse for this long.
  static const _staleAfter = Duration(minutes: 5);

  /// Registered as `Get.putAsync<LocationManager>(() => LocationManager().init())`.
  /// Returns immediately; the GPS resolve happens in the background so
  /// app startup is never blocked on the (up-to-10s) hardware fix.
  Future<LocationManager> init() async {
    unawaited(refresh());
    return this;
  }

  /// Returns the cached position if fresh, otherwise fetches a new fix.
  /// Returns null if permission/service is unavailable. Never throws.
  Future<Position?> getOrRefresh() async {
    final cached = position.value;
    if (cached != null &&
        DateTime.now().difference(cached.timestamp) < _staleAfter) {
      return cached;
    }
    final fresh = await _resolve();
    if (fresh != null) position.value = fresh;
    return fresh;
  }

  /// Force a fresh GPS fix and update the cache, regardless of staleness.
  Future<void> refresh() async {
    final fresh = await _resolve();
    if (fresh != null) position.value = fresh;
  }

  // ── Internal — silent: never prompts, never throws ────────────
  static Future<Position?> _resolve() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      final perm = await Geolocator.checkPermission();
      if (perm != LocationPermission.whileInUse &&
          perm != LocationPermission.always) {
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
