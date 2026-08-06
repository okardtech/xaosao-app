import 'package:flutter/material.dart';
// VersionStatus lives in a sub-directory of new_version_plus and isn't
// re-exported from the top-level library file, so we import it directly.
import 'package:new_version_plus/model/version_status.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xaosao/widgets/update_available_sheet.dart';

// ═══════════════════════════════════════════════════════════════
//  version_checker.dart
//
//  Public entry point for "is there a new build on the store?"
//  checks. Wraps `new_version_plus` with a beautiful custom sheet
//  ([UpdateAvailableSheet]) and a re-entry guard so multiple pages
//  can safely call it.
//
//  Dismiss cadence:
//    • If the user taps "ພາຍຫຼັງ", the sheet is suppressed for the
//      REST OF THAT SESSION ONLY. Cold-restarting the app clears the
//      flag and the sheet shows again (as long as the store still
//      has a newer version).
//    • Nothing is persisted to disk — no cooldown, no timestamps.
//
//  Typical use — from a page's initState after first frame:
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      if (mounted) VersionChecker.showIfUpdateAvailable(context);
//    });
//
//  Force-update usage (non-dismissible sheet):
//    VersionChecker.showIfUpdateAvailable(context, forceUpdate: true);
//
//  Custom UI usage — get the raw status and roll your own dialog:
//    final status = await VersionChecker.check();
//    if (status?.canUpdate == true) { ... }
// ═══════════════════════════════════════════════════════════════
class VersionChecker {
  VersionChecker._();

  // Store identifiers — both platforms use the same reverse-DNS ID.
  // Matches android/app/build.gradle.kts applicationId.
  static const _appId = 'com.xaosao.mobile';

  // In-memory session-only dismiss flag. Cleared on cold start.
  static bool _dismissedThisSession = false;

  // Re-entry guard — prevents concurrent runs from multiple pages.
  static bool _running = false;

  // ─────────────────────────────────────────────────────────────
  //  Public API
  // ─────────────────────────────────────────────────────────────

  /// Fetch the store version status. Returns null on failure (offline,
  /// store lookup error, etc.). Safe to call anywhere — never throws.
  static Future<VersionStatus?> check() async {
    try {
      final checker = NewVersionPlus(iOSId: _appId, androidId: _appId);
      return await checker.getVersionStatus();
    } catch (_) {
      return null;
    }
  }

  /// Check for an update and, if one exists, show the update sheet.
  ///
  /// Callable from any page. Shown on every cold start (session-only
  /// dismiss). If the user taps "ອັບເດດດຽວນີ້", the store URL is
  /// launched externally.
  ///
  /// Returns:
  ///   true  → user tapped Update and the store URL was launched
  ///   false → no update, sheet dismissed, or check failed
  static Future<bool> showIfUpdateAvailable(
    BuildContext context, {
    bool forceUpdate = false,
  }) async {
    if (_running) return false;
    _running = true;
    try {
      // Session-only guard — do not persist across cold starts.
      // Force-update mode bypasses it (always shows).
      if (!forceUpdate && _dismissedThisSession) return false;

      final status = await check();
      if (status == null || !status.canUpdate) return false;

      if (!context.mounted) return false;
      final tappedUpdate = await UpdateAvailableSheet.show(
        context,
        localVersion: status.localVersion,
        storeVersion: status.storeVersion,
        releaseNotes: status.releaseNotes,
        forceUpdate: forceUpdate,
      );

      if (tappedUpdate) {
        await _launchStore(status.appStoreLink);
        return true;
      }

      // User tapped "ພາຍຫຼັງ" — suppress for the rest of this session.
      // Next cold start clears the flag and the sheet shows again.
      _dismissedThisSession = true;
      return false;
    } catch (_) {
      return false;
    } finally {
      _running = false;
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  Internals
  // ─────────────────────────────────────────────────────────────

  static Future<void> _launchStore(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Silent: URL malformed or no browser — user will see the sheet
      // again on next cold start.
    }
  }
}
