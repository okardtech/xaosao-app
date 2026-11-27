/// "Ask admin" — the assistant that finds someone from a plain-language
/// request, as xs_backend's assistant module reports it.
library;

/// One person the assistant suggested.
class AssistantMatch {
  final String id;
  final String name;
  final String? profile;
  final int? age;
  final double rating;
  final String? address;

  /// Cheapest service rate we can show, for the card's price line.
  final int? fromPrice;

  /// Straight-line distance from the asking customer, in km.
  ///
  /// Null when either side has no coordinates on file — the server
  /// would rather send nothing than a made-up figure next to a real
  /// person, and so this card shows nothing rather than "0 km".
  final double? distanceKm;

  const AssistantMatch({
    required this.id,
    required this.name,
    this.profile,
    this.age,
    this.rating = 0,
    this.address,
    this.fromPrice,
    this.distanceKm,
  });

  factory AssistantMatch.fromJson(Map<String, dynamic> json) => AssistantMatch(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    profile: json['profile']?.toString(),
    age: (json['age'] as num?)?.toInt(),
    rating: (json['rating'] as num?)?.toDouble() ?? 0,
    address: json['address']?.toString(),
    fromPrice: (json['fromPrice'] as num?)?.toInt(),
    distanceKm: (json['distanceKm'] as num?)?.toDouble(),
  );
}

/// What the assistant answered: a sentence, and who it found.
class AssistantReply {
  final String reply;

  /// 'search' when it looked for people; anything else means it was
  /// chatting and `matches` is empty.
  final String intent;
  final List<AssistantMatch> matches;

  const AssistantReply({
    required this.reply,
    required this.intent,
    required this.matches,
  });

  factory AssistantReply.fromJson(Map<String, dynamic> json) => AssistantReply(
    reply: json['reply']?.toString() ?? '',
    intent: json['intent']?.toString() ?? 'chat',
    matches: (json['matches'] as List?)
            ?.map((m) => AssistantMatch.fromJson(m as Map<String, dynamic>))
            .toList() ??
        const [],
  );
}

/// One turn in the saved thread.
///
/// An admin picking someone by hand arrives here as an `assistant` turn:
/// the customer does not need to care which side chose it.
class AssistantTurn {
  /// 'user' or 'assistant'.
  final String role;
  final String text;
  final List<AssistantMatch> matches;

  const AssistantTurn({
    required this.role,
    required this.text,
    this.matches = const [],
  });

  bool get isUser => role == 'user';

  factory AssistantTurn.fromJson(Map<String, dynamic> json) => AssistantTurn(
    role: json['role']?.toString() ?? 'assistant',
    text: json['text']?.toString() ?? '',
    matches: (json['matches'] as List?)
            ?.map((m) => AssistantMatch.fromJson(m as Map<String, dynamic>))
            .toList() ??
        const [],
  );

  /// What `POST /assistant/ask` wants back as history.
  Map<String, dynamic> toHistoryJson() => {
    'role': isUser ? 'user' : 'assistant',
    // The endpoint caps each turn at 500 characters and rejects the
    // whole request if any one is longer.
    'text': text.length > 500 ? text.substring(0, 500) : text,
  };
}
