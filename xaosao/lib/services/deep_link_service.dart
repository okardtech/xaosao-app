import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/main.dart';

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

/// Routes incoming AppsFlyer deep-link payloads to the matching in-app page.
///
/// Cold-start sequencing:
///   1. AppsFlyer's `onDeepLinking` may fire before the splash finishes,
///      so we queue the payload in [_pending].
///   2. The splash calls [markNavigatorReady] once auth resolves to the
///      dashboard, at which point we flush the queue.
///   3. If the user is unauthenticated, the payload stays queued until
///      [markNavigatorReady] is invoked from a later sign-in flow.
class DeepLinkService extends GetxService {
  DeepLinkPayload? _pending;
  bool _navigatorReady = false;

  /// Forwarded from [AppsFlyerService] when a deep link carries a
  /// `type` + `id` (companion or model) payload.
  void handle(DeepLinkPayload payload) {
    if (!payload.isValid) return;
    _pending = payload;
    if (_navigatorReady) _flush();
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
}
