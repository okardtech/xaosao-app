import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';

/// iOS 14.5+ App Tracking Transparency helper.
///
/// Wraps the [AppTrackingTransparency] plugin with:
///   • Platform guard — Android is a no-op.
///   • Once-per-install semantics — the OS itself only shows the ATT
///     dialog on `TrackingStatus.notDetermined`, so subsequent calls
///     are cheap no-ops.
///   • Short pre-prompt delay — Apple recommends letting the UI render
///     before the system dialog appears, both for a smoother look and
///     to raise the "Allow" rate.
///
/// The result is used by [AppsFlyerService] (via the SDK's
/// `timeToWaitForATTUserAuthorization: 15` option — that timer only
/// resolves once ATT is either granted, denied, or times out).
///
/// Call [ensureRequested] once early in app startup, before any code
/// that depends on the IDFA being available (i.e. before AppsFlyer
/// starts fetching attribution data).
class AttHelper {
  AttHelper._();

  static bool _requested = false;

  /// Shows the ATT system dialog if the user hasn't answered yet.
  /// No-op on Android and on subsequent calls in the same session.
  ///
  /// Returns the final tracking status so callers can log / branch
  /// (e.g. show a fallback banner explaining why attribution is
  /// limited). Callers can ignore the return safely.
  static Future<TrackingStatus> ensureRequested() async {
    if (!Platform.isIOS) return TrackingStatus.notSupported;
    if (_requested) {
      return AppTrackingTransparency.trackingAuthorizationStatus;
    }
    _requested = true;

    try {
      final current =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      if (current != TrackingStatus.notDetermined) {
        // User already decided in a previous session — nothing to prompt.
        return current;
      }

      // Apple UX guidance: give the app a beat to render before the
      // system alert covers it. 500ms is enough for the splash to
      // appear and settle.
      await Future.delayed(const Duration(milliseconds: 500));
      final result =
          await AppTrackingTransparency.requestTrackingAuthorization();
      debugPrint('[ATT] user decision: $result');
      return result;
    } catch (e) {
      debugPrint('[ATT] failed to request: $e');
      return TrackingStatus.notDetermined;
    }
  }
}
