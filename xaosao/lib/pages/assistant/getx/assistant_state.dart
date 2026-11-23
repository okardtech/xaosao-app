import 'package:xaosao/models/assistant_model.dart';

class AssistantPageState {
  /// The thread on screen, oldest first.
  final List<AssistantTurn> turns;

  /// True while the server is working out an answer.
  final bool asking;

  /// True while the saved thread is being fetched, so the greeting is
  /// not shown and then immediately replaced.
  final bool loadingHistory;

  final String? error;

  const AssistantPageState({
    this.turns = const [],
    this.asking = false,
    this.loadingHistory = false,
    this.error,
  });

  /// Nothing has been said yet beyond the opening line — the moment to
  /// offer suggestions.
  bool get isFresh => turns.length <= 1;

  AssistantPageState copyWith({
    List<AssistantTurn>? turns,
    bool? asking,
    bool? loadingHistory,
    String? error,
    bool clearError = false,
  }) => AssistantPageState(
    turns: turns ?? this.turns,
    asking: asking ?? this.asking,
    loadingHistory: loadingHistory ?? this.loadingHistory,
    error: clearError ? null : (error ?? this.error),
  );
}
