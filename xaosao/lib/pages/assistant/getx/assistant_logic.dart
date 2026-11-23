import 'package:get/get.dart';
import 'package:xaosao/models/assistant_model.dart';
import 'package:xaosao/repository/assistant_repo.dart';

import 'assistant_state.dart';

/// "Ask admin" — describe who you want, get people back.
///
/// The server does the understanding and the matching. This keeps the
/// thread on screen, posts what the customer typed, and shows the
/// answer. It never invents a match or filters anything itself.
class AssistantLogic extends GetxController {
  final _repo = AssistantRepo();
  final Rx<AssistantPageState> _state = const AssistantPageState().obs;
  AssistantPageState get state => _state.value;
  void _update(AssistantPageState s) => _state.value = s;

  /// The opening line, supplied by the sheet so it can be translated.
  late String greeting;

  void start(String greetingText) {
    greeting = greetingText;
    _update(
      state.copyWith(
        turns: [AssistantTurn(role: 'assistant', text: greetingText)],
      ),
    );
    loadHistory();
  }

  /// The saved thread, including anything an admin sent while the
  /// customer was away. Replaces the greeting rather than appending to
  /// it, so a returning customer sees where they left off.
  Future<void> loadHistory() async {
    _update(state.copyWith(loadingHistory: true));
    try {
      final res = await _repo.history();
      final saved = res.data ?? const <AssistantTurn>[];
      if (res.success && saved.isNotEmpty) {
        _update(state.copyWith(turns: saved, loadingHistory: false));
      } else {
        _update(state.copyWith(loadingHistory: false));
      }
    } catch (_) {
      // No saved thread is not an error worth showing: the greeting is
      // already on screen and the customer can simply ask.
      _update(state.copyWith(loadingHistory: false));
    }
  }

  Future<void> send(String message) async {
    final text = message.trim();
    if (text.isEmpty || state.asking) return;

    // Show what they said straight away. Waiting for the round trip to
    // echo their own words back reads as a dropped message.
    final withUser = [
      ...state.turns,
      AssistantTurn(role: 'user', text: text),
    ];
    _update(state.copyWith(turns: withUser, asking: true, clearError: true));

    try {
      final res = await _repo.ask(message: text, history: withUser);
      if (res.success && res.data != null) {
        _update(
          state.copyWith(
            turns: [
              ...withUser,
              AssistantTurn(
                role: 'assistant',
                text: res.data!.reply,
                matches: res.data!.matches,
              ),
            ],
            asking: false,
          ),
        );
      } else {
        _update(
          state.copyWith(
            asking: false,
            error: res.laMessage ?? res.message,
          ),
        );
      }
    } catch (e) {
      _update(state.copyWith(asking: false, error: e.toString()));
    }
  }
}
