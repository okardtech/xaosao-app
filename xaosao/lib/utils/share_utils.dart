import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xaosao/utils/l10n.dart';

/// Which register flow a referral link is intended for.
///
/// Carried on the URL via BOTH `?target=` (human-readable) and
/// `?deep_link_sub1=` (AppsFlyer canonical). The canonical key is what
/// survives probabilistic fingerprint matching on deferred deep links
/// (install-then-open), so we always emit both.
enum ReferralTarget { model, customer }

class ShareUtils {
  static const _onelinkBase = 'https://xaosao.onelink.me/TfaF/8oxhsd7d';

  /// Builds a OneLink referral URL that resolves on **both** direct
  /// AND deferred install paths.
  ///
  /// URL includes ALL FOUR params on purpose:
  ///
  ///   • `deep_link_value` / `deep_link_sub1` — AppsFlyer canonical
  ///     keys. Required for **deferred** deep links because
  ///     probabilistic fingerprint matching only preserves these.
  ///   • `code` / `target` — required for **direct** deep links on
  ///     this OneLink template. Empirical: URLs with only canonical
  ///     keys were NOT opening the app on installed devices — the
  ///     `code` param appears to be what triggers the template's
  ///     deep-linking behaviour (likely tied to the "Additional
  ///     parameters" mapping in the AppsFlyer Console).
  ///
  /// Do NOT drop either pair without testing both:
  ///   1. Installed device → tap link → app opens on register
  ///   2. Fresh install → tap link → install → open → register
  static String _build(String refCode, {String? target}) {
    final buf = StringBuffer(
      '$_onelinkBase?deep_link_value=$refCode&code=$refCode',
    );
    if (target != null && target.isNotEmpty) {
      buf.write('&deep_link_sub1=$target&target=$target');
    }
    return buf.toString();
  }

  static String buildReferralLink(String refCode) => _build(refCode);

  /// Model-facing referral link.
  static String buildModelReferralLink(String refCode) =>
      _build(refCode, target: 'model');

  /// Customer-facing referral link.
  static String buildCustomerReferralLink(String refCode) =>
      _build(refCode, target: 'customer');

  static Future<void> shareReferralLink(String refCode) async {
    final link = buildReferralLink(refCode);
    await Share.share(
      '${l10n.shareInviteMessage}\n\n$link',
      subject: l10n.shareInviteSubject,
    );
  }

  static Future<void> shareLink({
    required String link,
    required String message,
    String? subject,
  }) async {
    await Share.share('$message\n\n$link', subject: subject);
  }

  static Future<void> copyToClipboard(String text) =>
      Clipboard.setData(ClipboardData(text: text));
}
