import 'package:flutter_test/flutter_test.dart';
import 'package:xaosao/models/chat_location.dart';
import 'package:xaosao/models/chat_message_model.dart';

ChatMessageModel _msg(
  String? text, {
  String type = 'text',
  Map<String, dynamic>? metadata,
}) => ChatMessageModel(
  id: 'm1',
  messageText: text,
  messageType: type,
  metadata: metadata,
);

void main() {
  group('ChatLocation.fromMessage', () {
    test('parses the URL this app sends', () {
      const sent = ChatLocation(latitude: 17.96542, longitude: 102.61135);
      final parsed = ChatLocation.fromMessage(_msg(sent.shareUrl));

      expect(parsed, isNotNull);
      expect(parsed!.latitude, closeTo(17.96542, 1e-9));
      expect(parsed.longitude, closeTo(102.61135, 1e-9));
      expect(parsed.caption, isNull);
    });

    test('parses other common Google/Apple maps link shapes', () {
      final shapes = <String>[
        'https://maps.google.com/?q=17.9654,102.6113',
        'https://www.google.com/maps/@17.9654,102.6113,15z',
        'https://maps.apple.com/?ll=17.9654,102.6113',
        'https://www.google.com/maps/dir/?api=1&destination=17.9654,102.6113',
      ];
      for (final url in shapes) {
        final parsed = ChatLocation.fromMessage(_msg(url));
        expect(parsed, isNotNull, reason: url);
        expect(parsed!.latitude, closeTo(17.9654, 1e-6), reason: url);
        expect(parsed.longitude, closeTo(102.6113, 1e-6), reason: url);
      }
    });

    test('keeps surrounding text as the caption', () {
      final parsed = ChatLocation.fromMessage(
        _msg('meet me here https://maps.google.com/?q=17.9,102.6 ok?'),
      );
      expect(parsed, isNotNull);
      expect(parsed!.caption, 'meet me here ok?');
    });

    test('negative coordinates survive', () {
      final parsed = ChatLocation.fromMessage(
        _msg('https://maps.google.com/?q=-33.8688,-151.2093'),
      );
      expect(parsed!.latitude, closeTo(-33.8688, 1e-9));
      expect(parsed.longitude, closeTo(-151.2093, 1e-9));
    });

    // The maps host is what stops ordinary chatter becoming a map card.
    test('plain text with numbers is NOT a location', () {
      for (final text in <String>[
        '17.9654,102.6113',
        'call me at 12,34',
        'https://example.com/?q=17.9654,102.6113',
        'see https://www.google.com/search?q=restaurants',
        '',
      ]) {
        expect(
          ChatLocation.fromMessage(_msg(text)),
          isNull,
          reason: 'should not parse: $text',
        );
        expect(ChatLocation.isLocationText(text), isFalse, reason: text);
      }
      expect(ChatLocation.fromMessage(_msg(null)), isNull);
    });

    test('out-of-range coordinates are rejected', () {
      expect(
        ChatLocation.fromMessage(_msg('https://maps.google.com/?q=99.5,200.1')),
        isNull,
      );
    });

    test('metadata wins over the text, so a native location type upgrades '
        'bubbles with no client change', () {
      final parsed = ChatLocation.fromMessage(
        _msg(
          'https://maps.google.com/?q=1.0,1.0',
          type: 'location',
          metadata: {'latitude': 17.5, 'longitude': 102.5},
        ),
      );
      expect(parsed!.latitude, 17.5);
      expect(parsed.longitude, 102.5);
    });

    test('metadata accepts string numbers and lat/lng aliases', () {
      final parsed = ChatLocation.fromMessage(
        _msg(null, type: 'location', metadata: {'lat': '17.5', 'lng': '102.5'}),
      );
      expect(parsed!.latitude, 17.5);
      expect(parsed.longitude, 102.5);
    });

    test('incomplete metadata falls through instead of throwing', () {
      expect(
        ChatLocation.fromMessage(
          _msg(null, type: 'location', metadata: {'latitude': 17.5}),
        ),
        isNull,
      );
    });
  });

  group('ChatLocation output', () {
    test('shareUrl round-trips through the parser', () {
      const original = ChatLocation(latitude: -12.3456, longitude: 78.9012);
      final parsed = ChatLocation.fromMessage(_msg(original.shareUrl));
      expect(parsed!.latitude, original.latitude);
      expect(parsed.longitude, original.longitude);
    });

    test('prettyCoords is trimmed to 5 decimals', () {
      const loc = ChatLocation(latitude: 17.965421234, longitude: 102.6113567);
      expect(loc.prettyCoords, '17.96542, 102.61136');
    });
  });
}
