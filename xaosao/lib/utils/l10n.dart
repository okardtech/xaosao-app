import 'package:get/get.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/l10n/app_localizations_lo.dart';

// ═══════════════════════════════════════════════════════════════
//  l10n.dart
//
//  Convenience getter for [AppLocalizations] in places that don't
//  have a [BuildContext] — most commonly GetX controllers writing
//  snackbar / dialog copy inside async methods.
//
//  Usage from a controller:
//    import 'package:xaosao/utils/l10n.dart';
//    AppSnackbar.error(l10n.loginFailed);
//
//  If no navigator context is available yet (e.g. very early in app
//  startup before any page has mounted), we fall back to the Lao
//  ARB — matching the app's default `fallbackLocale`.
// ═══════════════════════════════════════════════════════════════

AppLocalizations get l10n {
  final ctx = Get.context;
  if (ctx != null) {
    final loc = AppLocalizations.of(ctx);
    if (loc != null) return loc;
  }
  // Fallback — no context or delegate not ready yet.
  return AppLocalizationsLo();
}
