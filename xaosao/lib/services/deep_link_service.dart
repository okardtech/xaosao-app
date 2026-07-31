import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/main.dart';
import 'package:xaosao/pages/login/getx/login_state.dart';
import 'package:xaosao/services/storage_service.dart';

/// ═══════════════════════════════════════════════════════════════
///  DeepLinkService — single source of truth for AppsFlyer routing
/// ═══════════════════════════════════════════════════════════════
///
/// Two independent flows:
///
///   1. **Referral link** (`?code=XXX&target=model|customer`)
///      Cold-start install / open. Routes an *unauthenticated* user
///      into RegisterPage with the correct role and populates the
///      referrer banner from storage.
///
///   2. **Profile deep link** (`?type=companion|model&id=…`)
///      Warm-app link tap that opens a specific profile. Requires a
///      signed-in user (dashboard); queued otherwise.
///
/// Guarantees:
///   • **Exactly-once navigation** per unique referral code. A
///     `_consumedRefCodes` set dedups both intra-session re-flushes
///     and out-of-order AppsFlyer callbacks.
///   • **Single push path.** Only `_navigateToRegister` calls
///     `pushNamed(register)`. Splash asks this service to consume
///     the referral rather than pushing itself.
///   • **Cold + warm + resume** all funnel through the same
///     [captureReferral] / [consumeReferralIfPresent] pair — no
///     ad-hoc branching in the caller.
///   • **Nav-mount race** handled by post-frame retry (capped) so
///     a briefly-null navigator never drops the payload silently.
///
/// Lifecycle:
///   • Registered once as `Get.put(DeepLinkService(), permanent: true)`
///     in [InitialBinding] — before AppsFlyerService so its
///     `onDeepLinking` callback can resolve it via `Get.find`.
///   • No `Stream` subscriptions, no `ChangeNotifier`s, no timers,
///     no image caches — nothing that needs disposing. Holds a
///     small in-memory `Set<String>` (bounded by unique campaign
///     codes seen this session, typically 1) plus two nullable
///     fields. Zero impact on scrolling / build performance.
class DeepLinkService extends GetxService {
  // ── Storage keys ────────────────────────────────────────────
  static const _kRefCode = 'pending_ref_code';
  static const _kRefTarget = 'pending_ref_target';
  static const _kToken = 'token';
  // static const _tag = '[DeepLink]';

  // Max frames to wait for the root navigator to mount before
  // giving up on a referral flush. 40 × 16.6ms ≈ 660ms — comfortably
  // longer than any cold-start splash transition.
  static const _maxFlushFrames = 40;

  // ── Referral state ──────────────────────────────────────────
  /// Codes we've already navigated to register with THIS session.
  /// In-memory only; on next launch splash re-reads storage and if
  /// storage is still populated (register wasn't completed) the code
  /// will be re-consumed exactly once.
  final Set<String> _consumedRefCodes = <String>{};
  bool _sessionResolved = false;
  int _flushAttempts = 0;

  // ── Profile deep-link state ─────────────────────────────────
  DeepLinkPayload? _pending;
  bool _navigatorReady = false;

  // ══════════════════════════════════════════════════════════════
  //  REFERRAL FLOW
  // ══════════════════════════════════════════════════════════════

  /// Called by [AppsFlyerService.onDeepLinking] when a referral link
  /// (`?code=`) is received. Idempotent — persists the code to storage
  /// and, if the splash has already resolved the session, attempts to
  /// navigate to register immediately.
  ///
  /// Deferred deep links on fresh install invoke this seconds after
  /// splash lands on onboarding — the splash-resolved branch here is
  /// how we recover without any polling.
  void captureReferral({required String code, String? target}) {
    final normalized = code.trim();
    if (normalized.isEmpty) return;

    // Already navigated for this code this session? Ignore.
    if (_consumedRefCodes.contains(normalized)) {
      // debugPrint('$_tag captureReferral: skip — already consumed=$normalized');
      return;
    }

    // debugPrint('$_tag captureReferral: code=$normalized target=$target');
    final storage = Get.find<StorageService>();
    storage.write(_kRefCode, normalized);
    if (target != null && target.isNotEmpty) {
      storage.write(_kRefTarget, target);
    }

    // Splash already picked a route — try to consume now. Otherwise
    // splash will call consumeReferralIfPresent() after its auth check.
    if (_sessionResolved) _tryNavigateFromStorage();
  }

  /// Called by [SplashPage] after the auth check for unauthenticated
  /// users. If a referral is queued in storage AND the user isn't
  /// signed in, this navigates to register (onboarding → register)
  /// and returns `true` so the splash skips its default onboarding push.
  ///
  /// Sets [_sessionResolved] so any later AppsFlyer callback (deferred
  /// deep link, warm-resume, etc.) can flush without polling.
  bool consumeReferralIfPresent() {
    _sessionResolved = true;
    return _tryNavigateFromStorage();
  }

  /// Called by [RegisterLogic] after a successful register+OTP flow,
  /// or when the referral is explicitly no longer relevant. Clears
  /// persistent storage AND marks the code consumed so re-firing the
  /// AppsFlyer callback for the same link can't re-open register.
  void clearReferral() {
    final storage = Get.find<StorageService>();
    final code = storage.read<String>(_kRefCode);
    if (code != null && code.isNotEmpty) _consumedRefCodes.add(code);
    storage.remove(_kRefCode);
    storage.remove(_kRefTarget);
    // debugPrint('$_tag clearReferral: cleared code=$code');
  }

  /// Reads storage → validates preconditions (has code, not signed in,
  /// not already consumed) → navigates. Returns `true` iff a navigation
  /// was scheduled. Retries on the next frame when the navigator isn't
  /// mounted yet, capped at [_maxFlushFrames].
  bool _tryNavigateFromStorage() {
    final storage = Get.find<StorageService>();
    final code = storage.read<String>(_kRefCode);
    if (code == null || code.isEmpty) return false;
    if (_consumedRefCodes.contains(code)) return false;

    // Signed-in users keep the code in storage (in case they log out
    // and want to register a new account), but we mark it consumed
    // for this session so we don't re-check on every event.
    final token = storage.read<String>(_kToken);
    if (token != null && token.isNotEmpty) {
      // debugPrint('$_tag navigate: skip — session already exists');
      _consumedRefCodes.add(code);
      return false;
    }

    final nav = NavigationService.navigatorKey.currentState;
    if (nav == null) {
      if (_flushAttempts++ >= _maxFlushFrames) {
        // debugPrint('$_tag navigate: gave up after $_flushAttempts frames');
        _flushAttempts = 0;
        return false;
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _tryNavigateFromStorage(),
      );
      return true; // technically scheduled — caller shouldn't fall back
    }

    _flushAttempts = 0;
    return _navigateToRegister(nav, code, storage.read<String>(_kRefTarget));
  }

  /// The **only** place in the codebase that pushes RegisterPage from
  /// a deep link. Enforces exactly-once by adding to the consumed set
  /// BEFORE the async push — even if some re-entrancy fires during the
  /// same frame, the guard in `_tryNavigateFromStorage` blocks it.
  ///
  /// Storage is cleared **at push time** rather than at register-success
  /// time so that if the user abandons the register flow and reopens the
  /// app later without re-tapping the link, we don't auto-re-open
  /// register (they'd see onboarding, which is what they'd expect).
  /// The referral code is handed to RegisterPage via route arguments,
  /// so RegisterLogic doesn't need storage to render the referrer banner.
  bool _navigateToRegister(
    NavigatorState nav,
    String code,
    String? target,
  ) {
    // Mark consumed FIRST so any nested captureReferral call during
    // this frame is a no-op.
    _consumedRefCodes.add(code);

    final role = target == 'customer'
        ? RegisterRole.customer
        : RegisterRole.companion;

    // Clear persistent storage now — the code lives on in the route
    // arguments (below) and in the consumed-set (this session), so
    // there's no reason to keep it around for a *second* app launch.
    final storage = Get.find<StorageService>();
    storage.remove(_kRefCode);
    storage.remove(_kRefTarget);

    // debugPrint('$_tag navigate: push register (role=${role.name}, code=$code)');

    // Reset the stack: xaosaoHome as the sole root, then register on
    // top. That way Back from register goes to onboarding rather than
    // to a stale splash / duplicate register.
    nav.pushNamedAndRemoveUntil(
      AppRoutes.xaosaoHome,
      (route) => false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.navigatorKey.currentState?.pushNamed(
        AppRoutes.register,
        arguments: RegisterArgs(role: role, referralCode: code),
      );
    });
    return true;
  }

  // ══════════════════════════════════════════════════════════════
  //  PROFILE DEEP LINK FLOW (type + id)
  // ══════════════════════════════════════════════════════════════

  /// Forwarded from [AppsFlyerService] when a link carries `type` + `id`.
  /// Only meaningful post-dashboard; queued until [markNavigatorReady].
  void handle(DeepLinkPayload payload) {
    if (!payload.isValid) return;
    _pending = payload;
    if (_navigatorReady) _flushProfile();
  }

  /// Called by the splash after landing on dashboard.
  void markNavigatorReady() {
    _navigatorReady = true;
    _flushProfile();
  }

  void _flushProfile() {
    final payload = _pending;
    if (payload == null) return;
    final nav = NavigationService.navigatorKey.currentState;
    if (nav == null) return; // will retry via next markNavigatorReady
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

/// Route arguments for [AppRoutes.register] when pushed via a referral
/// deep link. Includes both the role AND the referral code so the page
/// can validate and render the referrer banner without hitting storage.
///
/// Callers that just want a plain register page (e.g. login → sign-up
/// button) may still pass a bare [RegisterRole] — the route generator
/// accepts both shapes for backward compatibility.
class RegisterArgs {
  final RegisterRole role;
  final String? referralCode;
  const RegisterArgs({required this.role, this.referralCode});
}

/// Page-target categories supported by the profile deep-link router.
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
