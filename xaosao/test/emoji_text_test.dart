import 'package:flutter_test/flutter_test.dart';
import 'package:xaosao/utils/emoji_text.dart';

void main() {
  group('emojiOnlyCount', () {
    test('counts single-codepoint emoji', () {
      expect(EmojiText.emojiOnlyCount('👍'), 1);
      expect(EmojiText.emojiOnlyCount('👍🎉'), 2);
      expect(EmojiText.emojiOnlyCount('👍🎉❤️'), 3);
      expect(EmojiText.emojiOnlyCount('👍🎉❤️🔥'), 4);
    });

    test('tolerates whitespace between emoji', () {
      expect(EmojiText.emojiOnlyCount('👍 🎉'), 2);
      expect(EmojiText.emojiOnlyCount('  👍   🎉  '), 2);
      expect(EmojiText.emojiOnlyCount('👍\n🎉'), 2);
    });

    // The whole reason for walking grapheme clusters instead of code points.
    test('multi-codepoint emoji count as ONE', () {
      expect(EmojiText.emojiOnlyCount('👨‍👩‍👧‍👦'), 1, reason: 'ZWJ family');
      expect(EmojiText.emojiOnlyCount('👍🏽'), 1, reason: 'skin tone modifier');
      expect(EmojiText.emojiOnlyCount('🇱🇦'), 1, reason: 'flag / regional pair');
      expect(EmojiText.emojiOnlyCount('❤️'), 1, reason: 'variation selector');
      expect(EmojiText.emojiOnlyCount('1️⃣'), 1, reason: 'keycap sequence');
      expect(EmojiText.emojiOnlyCount('👩‍💻'), 1, reason: 'profession ZWJ');
    });

    test('anything other than emoji disqualifies the message', () {
      for (final text in <String>[
        'hello',
        'ok 👍',
        '👍 ok',
        'ສະບາຍດີ',
        'สวัสดี 👍',
        '555',
        '!',
        '👍!',
        '12',
        'a',
        '',
        '   ',
      ]) {
        expect(
          EmojiText.emojiOnlyCount(text),
          0,
          reason: 'should be 0 for: "$text"',
        );
      }
      expect(EmojiText.emojiOnlyCount(null), 0);
    });

    // Lao is the app's default locale; Thai is a supported one. Neither may
    // ever be mistaken for emoji.
    test('Lao and Thai script never match the emoji ranges', () {
      expect(EmojiText.emojiOnlyCount('ສະບາຍດີບໍ່'), 0);
      expect(EmojiText.emojiOnlyCount('ສົ່ງຕຳແໜ່ງ'), 0);
      expect(EmojiText.emojiOnlyCount('ตำแหน่งปัจจุบัน'), 0);
      expect(EmojiText.emojiOnlyCount('มื้อ'), 0);
    });
  });

  group('isLargeEmoji', () {
    test('1 to 3 emoji get the oversized treatment', () {
      expect(EmojiText.isLargeEmoji('👍'), isTrue);
      expect(EmojiText.isLargeEmoji('👍🎉'), isTrue);
      expect(EmojiText.isLargeEmoji('👍🎉❤️'), isTrue);
    });

    test('4 or more fall back to a normal bubble', () {
      expect(EmojiText.isLargeEmoji('👍🎉❤️🔥'), isFalse);
      expect(EmojiText.isLargeEmoji('👍👍👍👍👍👍👍👍👍👍'), isFalse);
    });

    test('mixed or plain text is never large', () {
      expect(EmojiText.isLargeEmoji('ok 👍'), isFalse);
      expect(EmojiText.isLargeEmoji('hello'), isFalse);
      expect(EmojiText.isLargeEmoji(null), isFalse);
    });
  });

  group('largeFontSize', () {
    test('tapers as the count grows, null past the threshold', () {
      final one = EmojiText.largeFontSize(1)!;
      final two = EmojiText.largeFontSize(2)!;
      final three = EmojiText.largeFontSize(3)!;

      expect(one, greaterThan(two));
      expect(two, greaterThan(three));
      // Still clearly bigger than body text (12.5) at the smallest step.
      expect(three, greaterThan(20));
      expect(EmojiText.largeFontSize(EmojiText.maxLargeCount + 1), isNull);
      expect(EmojiText.largeFontSize(0), isNull);
    });
  });
}
