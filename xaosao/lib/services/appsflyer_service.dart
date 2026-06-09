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
import 'storage_service.dart';

class AppsFlyerService extends GetxService {
  static const _devKey = 's9xWA3UhoYsAmq2ovtVsLo';
  static const _iosAppId = 'YOUR_IOS_APP_ID';

  late AppsflyerSdk _sdk;

  final Rx<String?> incomingRefCode = Rx<String?>(null);

  Future<AppsFlyerService> init() async {
    final options = AppsFlyerOptions(
      afDevKey: _devKey,
      appId: _iosAppId,
      showDebug: true,
      timeToWaitForATTUserAuthorization: 15,
    );

    _sdk = AppsflyerSdk(options);

    _sdk.onDeepLinking((DeepLinkResult res) {
      if (res.status == Status.FOUND) {
        final refCode = res.deepLink?.getStringValue('code');
        if (refCode != null && refCode.isNotEmpty) {
          incomingRefCode.value = refCode;
          Get.find<StorageService>().write('pending_ref_code', refCode);
        }
      }
    });

    await _sdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    return this;
  }

  static String buildShareLink(String refCode) =>
      'https://xaosao.onelink.me/TfaF/ieh44kax?code=$refCode';
}

// a6fc87a0-bc3b-4990-b595-10ca1ad1abe1