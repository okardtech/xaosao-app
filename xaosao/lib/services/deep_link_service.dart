import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/main.dart';
import 'package:xaosao/pages/login/getx/login_state.dart';
import 'package:xaosao/services/storage_service.dart';

/// Page-target categories supported by the deep-link router.
enum DeepLinkType {
  companion,
  model;

  String get wire => name;

  static DeepLinkType? tryParse(String? raw) {
    if (raw == null) return null;
    for (final t in values) {
      if (t.name == raw) return t;
    }
    return null;
  }
}

class DeepLinkPayload {
  final DeepLinkType type;
  final String id;
  const DeepLinkPayload({required this.type, required this.id});

  bool get isValid => id.trim().isNotEmpty;
}

/// A referral link click, pending navigation.
class _PendingReferral {
  final String code;
  final RegisterRole role;
  const _PendingReferral({required this.code, required this.role});
}

/// Routes incoming AppsFlyer deep-link payloads to the matching in-app page.
///
/// Cold-start sequencing:
///   1. AppsFlyer's `onDeepLinking` may fire before the splash finishes,
///      so we queue the payload in [_pending] / [_pendingReferral].
///   2. The splash calls [markSessionResolved] once the auth check picks a
///      landing route (so referral navigation can happen regardless of
///      whether we're on login, onboarding or dashboard), and
///      [markNavigatorReady] once we're on the dashboard (so profile deep
///      links can flush).
///   3. If the user is unauthenticated, a profile payload stays queued
///      until [markNavigatorReady] is invoked from a later sign-in flow.
class DeepLinkService extends GetxService {
  DeepLinkPayload? _pending;
  _PendingReferral? _pendingReferral;
  bool _navigatorReady = false;
  bool _sessionResolved = false;

  /// Forwarded from [AppsFlyerService] when a deep link carries a
  /// `type` + `id` (companion or model) payload.
  void handle(DeepLinkPayload payload) {
    if (!payload.isValid) return;
    _pending = payload;
    if (_navigatorReady) _flush();
  }

  /// Forwarded from [AppsFlyerService] when a deep link carries a
  /// referral code (+ optional target). Signed-in users are ignored so
  /// we never hijack an existing session; the code stays in storage.
  void handleReferral({required String code, String? target}) {
    if (code.trim().isEmpty) return;
    final role = target == 'customer'
        ? RegisterRole.customer
        : RegisterRole.companion;
    _pendingReferral = _PendingReferral(code: code, role: role);
    if (_sessionResolved) _flushReferral();
  }

  /// Called by the splash after it decides which route to land on.
  /// Enables the referral queue to flush regardless of whether that route
  /// was dashboard, onboarding, or login.
  void markSessionResolved() {
    _sessionResolved = true;
    _flushReferral();
  }

  /// Called once the app is on a screen where navigating into a
  /// profile is meaningful (dashboard). Safe to call repeatedly.
  void markNavigatorReady() {
    _navigatorReady = true;
    _flush();
  }

  void _flush() {
    final payload = _pending;
    if (payload == null) return;
    final nav = NavigationService.navigatorKey.currentState;
    // Navigator not mounted yet — leave the payload queued; the next
    // markNavigatorReady() (or a re-fired deep link) will retry.
    if (nav == null) return;
    _pending = null;
    switch (payload.type) {
      case DeepLinkType.companion:
        nav.pushNamed(AppRoutes.companionProfile, arguments: payload.id);
        break;
      case DeepLinkType.model:
        nav.pushNamed(AppRoutes.customerProfile, arguments: payload.id);
        break;
    }
  }

  void _flushReferral() {
    final referral = _pendingReferral;
    if (referral == null) return;
    final nav = NavigationService.navigatorKey.currentState;
    if (nav == null) return;

    // Signed-in users already have an account — don't hijack their session.
    // The code stays in storage in case they later log out and register.
    final token = Get.find<StorageService>().read<String>('token');
    if (token != null && token.isNotEmpty) {
      _pendingReferral = null;
      return;
    }

    _pendingReferral = null;
    nav.pushNamed(AppRoutes.register, arguments: referral.role);
  }
}
