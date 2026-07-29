import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xaosao/utils/l10n.dart';

/// Which register flow a referral link is intended for.
///
/// The distinction is carried on the URL via `?target=` for anyone reading
/// the link directly, but AppsFlyer's OneLink routing still keys off the
/// original `?code=` param (that's what opens the app).
enum ReferralTarget { model, customer }

class ShareUtils {
  static const _onelinkBase = 'https://xaosao.onelink.me/TfaF/ieh44kax';

  /// Legacy shape kept because OneLink is configured to open the app when
  /// it sees `?code=`. Adding a `deep_link_value=` param broke that path
  /// (clicks fell through to the web fallback), so we stay on this scheme.
  static String buildReferralLink(String refCode) =>
      '$_onelinkBase?code=$refCode';

  /// Model-facing referral link — same shape as [buildReferralLink] with
  /// a `target=model` marker on the URL.
  static String buildModelReferralLink(String refCode) =>
      '$_onelinkBase?code=$refCode&target=model';

  /// Customer-facing referral link.
  static String buildCustomerReferralLink(String refCode) =>
      '$_onelinkBase?code=$refCode&target=customer';

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
