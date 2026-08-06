import 'package:share_plus/share_plus.dart';
import 'package:xaosao/services/deep_link_service.dart';
import 'package:xaosao/utils/l10n.dart';

/// Reusable AppsFlyer OneLink builder + share helpers for sharing
/// in-app destinations (companion profile, model detail) so the link
/// opens the specific page when the receiver has the app installed.
///
/// Params we send on every link:
///   • `type` / `id`                   — our keys, read by [DeepLinkService]
///   • `deep_link_value` / `deep_link_sub1` — AppsFlyer's canonical keys,
///     recommended for cross-platform OneLink resolution
class DeepLinkShare {
  DeepLinkShare._();

  // Same OneLink template as the existing referral flow.
  static const String _oneLinkBase = 'https://xaosao.onelink.me/TfaF/8oxhsd7d';

  /// Build a sharable OneLink that — when opened on a device with the
  /// app installed — deep-links to the matching in-app page.
  static String build({required DeepLinkType type, required String id}) {
    final params = <String, String>{
      'type': type.wire,
      'id': id,
      'deep_link_value': type.wire,
      'deep_link_sub1': id,
    };
    final qs = params.entries
        .map(
          (e) =>
              '${Uri.encodeQueryComponent(e.key)}='
              '${Uri.encodeQueryComponent(e.value)}',
        )
        .join('&');
    return '$_oneLinkBase?$qs';
  }

  /// Open the system share sheet for a companion profile.
  static Future<void> shareCompanion({
    required String companionId,
    String? displayName,
  }) async {
    final link = build(type: DeepLinkType.companion, id: companionId);
    await SharePlus.instance.share(
      ShareParams(text: _composeBody(displayName, link), subject: 'Xaosao'),
    );
  }

  /// Open the system share sheet for a model/customer detail page.
  static Future<void> shareModel({
    required String modelId,
    String? displayName,
  }) async {
    final link = build(type: DeepLinkType.model, id: modelId);
    await SharePlus.instance.share(
      ShareParams(text: _composeBody(displayName, link), subject: 'Xaosao'),
    );
  }

  static String _composeBody(String? displayName, String link) {
    final who = (displayName ?? '').trim();
    return who.isEmpty
        ? '${l10n.deepLinkShareSelf}\n$link'
        : '${l10n.deepLinkShareOther(who)}\n$link';
  }
}
