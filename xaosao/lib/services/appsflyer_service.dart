/*
 ══════════════════════════════════════════════════════════════════
  NATIVE SETUP — run once per platform
 ══════════════════════════════════════════════════════════════════

 ── ANDROID  (android/app/src/main/AndroidManifest.xml) ──────────
  Inside <application>:
    <receiver
      android:name="com.appsflyer.SingleInstallBroadcastReceiver"
      android:exported="true">
      <intent-filter>
        <action android:name="com.android.vending.INSTALL_REFERRER"/>
      </intent-filter>
    </receiver>

  android/app/build.gradle → minSdkVersion 21

 ── iOS  (ios/Runner/Info.plist) ─────────────────────────────────
  Add:
    <key>NSUserTrackingUsageDescription</key>
    <string>This identifier will be used to personalise ads for you.</string>

  Xcode → Runner → Signing & Capabilities → + Associated Domains:
    applinks:xaosao.onelink.me

 ── KEYS to replace ──────────────────────────────────────────────
  _devKey  : AppsFlyer dashboard → App Settings → Dev Key
  _iosAppId: Apple App Store numeric ID (digits only, no "id" prefix)
 ══════════════════════════════════════════════════════════════════
*/

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:get/get.dart';
import 'deep_link_service.dart';

/// Thin adapter over [AppsflyerSdk] — its ONLY job is to translate
/// `onDeepLinking` events into calls on [DeepLinkService]. All routing,
/// dedup and persistence lives there so the AppsFlyer SDK stays a
/// leaf dependency.
class AppsFlyerService extends GetxService {
  static const _devKey = 's9xWA3UhoYsAmq2ovtVsLo';
  static const _iosAppId = '6792675259';

  late final AppsflyerSdk _sdk;

  /// Exposed for legacy callers (e.g. `Obx` listeners that need to react
  /// to an incoming referral outside the deep-link nav flow). Not used
  /// by the routing pipeline itself.
  final Rx<String?> incomingRefCode = Rx<String?>(null);

  Future<AppsFlyerService> init() async {
    final options = AppsFlyerOptions(
      afDevKey: _devKey,
      appId: _iosAppId,
      showDebug: true,
      timeToWaitForATTUserAuthorization: 15,
    );

    _sdk = AppsflyerSdk(options);

    // Register the callbacks BEFORE initSdk so we never miss a fast
    // cold-start payload. All handlers ultimately funnel through
    // [DeepLinkService.captureReferral] whose `_consumedRefCodes` set
    // guarantees exactly-once navigation even if the same referral is
    // delivered via multiple channels.
    //
    // Two channels are needed because AppsFlyer delivers the payload
    // on different callbacks depending on the install path:
    //
    //   • `onDeepLinking` (UDL)          — fires on every direct deep
    //                                      link (installed app tap).
    //                                      Also fires on some deferred
    //                                      installs but NOT reliably —
    //                                      especially on Android when
    //                                      App Links aren't set up.
    //   • `onInstallConversionData`      — fires ONCE, on first launch
    //                                      after install, with the
    //                                      attribution payload. Our
    //                                      second-channel recovery for
    //                                      deferred deep links that UDL
    //                                      dropped.
    _sdk.onDeepLinking(_onDeepLink);
    _sdk.onInstallConversionData(_onInstallConversionData);

    // `onDeepLinking` (UDL) already covers every attribution event we
    // care about post-install — leaving `onAppOpenAttribution` on would
    // fire a second callback for the same link. Not a correctness bug
    // (dedup lives in DeepLinkService) but it's noise in logs.
    await _sdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: false,
      registerOnDeepLinkingCallback: true,
    );

    return this;
  }

  /// Fires once on first launch after install with the attribution
  /// payload. On a fresh-install referral tap this is often the ONLY
  /// callback that carries the code (UDL may not fire until second
  /// launch on some Android configurations), so we mirror the same
  /// referral extraction as [_onDeepLink].
  ///
  /// The `data` map matches the raw AppsFlyer conversion payload —
  /// keys of interest:
  ///   • `af_status`         — "Organic" / "Non-organic"
  ///   • `media_source`      — attribution channel
  ///   • `deep_link_value`   — canonical referral code (survives
  ///                            probabilistic fingerprint matching)
  ///   • `deep_link_sub1`    — canonical target (model/customer)
  ///   • `code` / `target`   — custom params on the OneLink URL
  ///                            (kept in the map when direct match
  ///                            preserves the URL query string)
  void _onInstallConversionData(dynamic data) {
    // debugPrint('$_tag onInstallConversionData: $data');
    if (data is! Map) return;

    // Only act on non-organic installs — organic ones have no referrer.
    final status = data['af_status']?.toString();
    if (status != null && status.toLowerCase() == 'organic') {
      // debugPrint('$_tag conversion data organic — no referral to extract');
      return;
    }

    final code = _stringOrNull(data['code']) ??
        _stringOrNull(data['deep_link_value']);
    final target = _stringOrNull(data['target']) ??
        _stringOrNull(data['deep_link_sub1']);

    if (code == null || code.isEmpty) {
      // debugPrint('$_tag conversion data: no referral code');
      return;
    }

    // debugPrint('$_tag conversion referral code=$code target=$target');
    incomingRefCode.value = code;
    Get.find<DeepLinkService>().captureReferral(code: code, target: target);
  }

  static String? _stringOrNull(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  void _onDeepLink(DeepLinkResult res) {
    // debugPrint('$_tag onDeepLinking status=${res.status}');
    if (res.status != Status.FOUND) return;
    final link = res.deepLink;
    if (link == null) {
      // debugPrint('$_tag deepLink payload is null');
      return;
    }

    final deepLink = Get.find<DeepLinkService>();

    // ── 1. Referral link (?code=…&target=…) ──────────────────
    // Referral links never double as profile deep links — if a code
    // is present we hand off and return.
    //
    // CRITICAL: on **deferred** deep links (install-then-open, no
    // Universal / App Link match) AppsFlyer resolves the payload via
    // probabilistic fingerprint matching. That path *only* preserves
    // AppsFlyer's canonical keys — `deep_link_value` and
    // `deep_link_sub1..sub10` — custom query params like `code` and
    // `target` are dropped. Falling back to those keys lets the same
    // link work whether it arrived via direct match (URL preserved)
    // or via fingerprint match (only canonical keys preserved).
    //
    // URLs built by [buildShareLink] include *both* naming schemes so
    // this fallback fires without any Custom Parameter Mapping being
    // configured in the AppsFlyer console.
    final refCode = link.getStringValue('code') ??
        link.getStringValue('deep_link_value');
    final target = link.getStringValue('target') ??
        link.getStringValue('deep_link_sub1');
    if (refCode != null && refCode.isNotEmpty) {
      // debugPrint('$_tag referral code=$refCode target=$target');
      incomingRefCode.value = refCode;
      deepLink.captureReferral(code: refCode, target: target);
      return;
    }

    // ── 2. Profile deep link (?type=…&id=…) ──────────────────
    // Same fallback pattern: prefer explicit keys, fall back to
    // AppsFlyer canonical keys for deferred / fingerprint matches.
    final rawType =
        link.getStringValue('type') ?? link.getStringValue('deep_link_value');
    final id =
        link.getStringValue('id') ?? link.getStringValue('deep_link_sub1');
    final parsedType = DeepLinkType.tryParse(rawType);
    if (parsedType != null && id != null && id.isNotEmpty) {
      // debugPrint('$_tag page deep-link type=${parsedType.wire} id=$id');
      deepLink.handle(DeepLinkPayload(type: parsedType, id: id));
    }
  }

  /// Builds a OneLink URL that resolves on both direct and deferred
  /// install paths. Includes all four params (canonical + custom)
  /// because empirically direct match on this template requires
  /// `code` / `target` while deferred requires `deep_link_value` /
  /// `deep_link_sub1`.
  ///
  /// See [ShareUtils._build] for the full rationale.
  static String buildShareLink(String refCode, {String? target}) {
    final buf = StringBuffer(
      'https://xaosao.onelink.me/TfaF/8oxhsd7d'
      '?deep_link_value=$refCode'
      '&code=$refCode',
    );
    if (target != null && target.isNotEmpty) {
      buf.write('&deep_link_sub1=$target&target=$target');
    }
    return buf.toString();
  }
}

// a6fc87a0-bc3b-4990-b595-10ca1ad1abe1