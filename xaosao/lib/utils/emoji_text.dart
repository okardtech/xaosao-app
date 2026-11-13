// `characters` is re-exported by flutter/widgets.dart, so the grapheme-cluster
// extension comes for free without adding a direct pubspec dependency.
import 'package:flutter/widgets.dart';

/// Detects messages that are nothing but emoji, so chat can render them big
/// and chrome-free the way WhatsApp and Messenger do.
///
/// ## Why grapheme clusters and not a regex over the whole string
///
/// A single emoji is frequently several code points: a family is five
/// pictographs joined by ZERO WIDTH JOINERs, a flag is two regional
/// indicators, "👍🏽" is a hand plus a skin-tone modifier, "1️⃣" is the ASCII
/// digit plus VARIATION SELECTOR-16 plus COMBINING ENCLOSING KEYCAP. Counting
/// code points would report "👨‍👩‍👧‍👦" as five emoji and shrink it for no
/// reason, so this walks user-perceived characters ([Characters]) instead and
/// asks whether each one is built purely from emoji code points.
class EmojiText {
  EmojiText._();

  /// Emoji-only messages at or below this count get the oversized treatment.
  /// Beyond it they are ordinary text: a wall of thirty huge emoji would
  /// shove every other message off the screen.
  static const int maxLargeCount = 3;

  /// Number of emoji in [text] when it contains NOTHING else, otherwise 0.
  ///
  /// Whitespace between emoji is tolerated ("👍 🎉" counts as two), because
  /// users separate them while typing. Any other character — a letter, a
  /// digit that is not part of a keycap, punctuation — makes this 0, so the
  /// message keeps the normal bubble.
  static int emojiOnlyCount(String? text) {
    if (text == null) return 0;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;

    var count = 0;
    for (final cluster in trimmed.characters) {
      if (cluster.trim().isEmpty) continue; // spacing between emoji
      if (!_isEmojiCluster(cluster)) return 0;
      count++;
    }
    return count;
  }

  /// True when the message should render as oversized, bubble-less emoji.
  static bool isLargeEmoji(String? text) {
    final n = emojiOnlyCount(text);
    return n > 0 && n <= maxLargeCount;
  }

  /// Font size for an emoji-only message of [count] emoji, or null when it
  /// should use the regular text style.
  ///
  /// Shrinks as the count grows so two or three emoji still fit the bubble
  /// width instead of wrapping — the same taper both WhatsApp and Messenger
  /// apply. Returned in logical points; the caller applies `.sp`.
  static double? largeFontSize(int count) {
    switch (count) {
      case 1:
        return 46;
      case 2:
        return 36;
      case 3:
        return 28;
      default:
        return null;
    }
  }

  // ── Internals ───────────────────────────────────────────────────────────

  static bool _isEmojiCluster(String cluster) {
    final runes = cluster.runes.toList();
    if (runes.isEmpty) return false;
    // Keycap sequences ("1️⃣", "#️⃣") start with a plain ASCII digit or
    // '#'/'*', which is obviously not emoji on its own. The enclosing keycap
    // is what makes the cluster one.
    if (runes.contains(0x20E3)) return true;
    return runes.every(_isEmojiRune);
  }

  /// Code points that may appear inside an emoji cluster.
  ///
  /// Deliberately excludes every range that holds ordinary writing — Latin,
  /// Lao (U+0E80–U+0EFF), Thai (U+0E00–U+0E7F) and CJK are all outside these
  /// bounds, so real messages in this app's languages never match.
  static bool _isEmojiRune(int r) {
    // Pictographs, emoticons, transport, supplemental symbols, extended-A.
    // Regional indicators (flags) and skin-tone modifiers live in here too.
    if (r >= 0x1F000 && r <= 0x1FAFF) return true;

    if (r >= 0x2600 && r <= 0x27BF) return true; // misc symbols, dingbats
    if (r >= 0x2B00 && r <= 0x2BFF) return true; // arrows, stars
    if (r >= 0x2190 && r <= 0x21FF) return true; // arrows
    if (r >= 0x2300 && r <= 0x23FF) return true; // watch, hourglass, controls
    if (r >= 0x25A0 && r <= 0x25FF) return true; // geometric shapes
    if (r >= 0x2900 && r <= 0x297F) return true; // supplemental arrows

    if (r >= 0xFE00 && r <= 0xFE0F) return true; // variation selectors
    if (r == 0x200D) return true; // ZERO WIDTH JOINER
    if (r == 0x20E3) return true; // COMBINING ENCLOSING KEYCAP

    // Scattered singletons that are emoji by long-standing convention.
    const singles = <int>{
      0x00A9, // ©
      0x00AE, // ®
      0x203C, // ‼
      0x2049, // ⁉
      0x2122, // ™
      0x2139, // ℹ
      0x24C2, // Ⓜ
      0x3030, // 〰
      0x303D, // 〽
      0x3297, // ㊗
      0x3299, // ㊙
    };
    return singles.contains(r);
  }
}
