import 'package:xaosao/models/chat_message_model.dart';
import 'package:xaosao/utils/l10n.dart';

/// A geographic point shared inside a chat message.
///
/// ## Why a URL rather than a dedicated message type
///
/// `POST /conversations/:id/messages` accepts only `content` plus an optional
/// `file`, and the server decides `messageType` (`text` | `image`). There is
/// no field for coordinates today, so a shared location travels as a Google
/// Maps URL inside the text body.
///
/// That is a deliberate design choice, not just a workaround:
///   * it works against the current backend with no server change;
///   * everything that is not this app — the web admin, a push-notification
///     preview, an older build, a copy-paste into another messenger — still
///     shows a tappable, genuinely useful link instead of an opaque blob;
///   * [fromMessage] reads `metadata` FIRST, so on the day the backend starts
///     sending `messageType: 'location'` with `metadata.latitude/longitude`,
///     these bubbles upgrade on their own with no client change.
class ChatLocation {
  final double latitude;
  final double longitude;

  /// Any text that accompanied the link, with the URL itself removed.
  ///
  /// This app always sends a bare URL, so it is normally null — it exists so
  /// a hand-pasted "meet me here <link>" keeps its words instead of having
  /// them swallowed by the location card.
  final String? caption;

  const ChatLocation({
    required this.latitude,
    required this.longitude,
    this.caption,
  });

  /// Coordinates inside a maps URL.
  ///
  /// The maps host is REQUIRED by the pattern: without it, an ordinary
  /// message like "12.5, 99" would be mistaken for a shared location and
  /// rendered as a map card.
  static final RegExp _coordsInMapsUrl = RegExp(
    r'https?://[^\s]*?(?:google\.[a-z.]+/maps|maps\.google\.[a-z.]+|maps\.apple\.com)'
    r'[^\s]*?(?:[?&](?:q|query|ll|daddr|destination)=|/@)'
    r'(-?\d{1,3}(?:\.\d+)?)\s*,\s*(-?\d{1,3}(?:\.\d+)?)',
    caseSensitive: false,
  );

  /// Matches the whole URL so it can be stripped out of [caption].
  static final RegExp _mapsUrl = RegExp(
    r'https?://[^\s]*?(?:google\.[a-z.]+/maps|maps\.google\.[a-z.]+|maps\.apple\.com)[^\s]*',
    caseSensitive: false,
  );

  /// Reads a location out of [msg], or null when it carries none.
  ///
  /// Order matters: a real `location` message type wins over URL sniffing,
  /// so this keeps working unchanged once the backend supports it natively.
  static ChatLocation? fromMessage(ChatMessageModel msg) {
    final fromMeta = _fromMetadata(msg.metadata);
    if (fromMeta != null) return fromMeta;
    return _fromText(msg.messageText);
  }

  static ChatLocation? _fromMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return null;
    final lat = _toDouble(metadata['latitude'] ?? metadata['lat']);
    final lng = _toDouble(
      metadata['longitude'] ?? metadata['lng'] ?? metadata['lon'],
    );
    if (lat == null || lng == null) return null;
    if (!_isValid(lat, lng)) return null;
    return ChatLocation(latitude: lat, longitude: lng);
  }

  static ChatLocation? _fromText(String? text) {
    if (text == null || text.isEmpty) return null;
    final m = _coordsInMapsUrl.firstMatch(text);
    if (m == null) return null;
    final lat = double.tryParse(m.group(1)!);
    final lng = double.tryParse(m.group(2)!);
    if (lat == null || lng == null || !_isValid(lat, lng)) return null;

    // Collapse the gap the removed URL leaves behind ("here <url> ok" must
    // not become "here  ok"). Only horizontal runs are squeezed, so a
    // multi-line caption keeps its line breaks.
    final rest = text
        .replaceAll(_mapsUrl, '')
        .replaceAll(RegExp(r'[ \t]{2,}'), ' ')
        .trim();
    return ChatLocation(
      latitude: lat,
      longitude: lng,
      caption: rest.isEmpty ? null : rest,
    );
  }

  /// True when [text] carries a shareable location — used for list previews
  /// where building the whole object would be wasteful.
  static bool isLocationText(String? text) =>
      text != null && text.isNotEmpty && _coordsInMapsUrl.hasMatch(text);

  /// What a conversation list should show instead of the raw body.
  ///
  /// The single place that decides preview text for every message kind, so
  /// the chat list, the socket handler and the optimistic send path cannot
  /// drift apart (they each used to inline their own `messageType == 'image'`
  /// ternary).
  static String? previewLabel(String? text, {String messageType = 'text'}) {
    if (messageType == 'image') return l10n.chatImagePrefix;
    if (messageType == 'location' || isLocationText(text)) {
      return l10n.chatLocationPrefix;
    }
    return text;
  }

  /// The message body sent for a shared location.
  ///
  /// Google's documented cross-platform form: it opens the native Maps app
  /// on both Android and iOS and still resolves in a desktop browser.
  String get shareUrl =>
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  /// Short human-readable coordinates for the bubble.
  String get prettyCoords =>
      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';

  static bool _isValid(double lat, double lng) =>
      lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;

  static double? _toDouble(Object? v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
