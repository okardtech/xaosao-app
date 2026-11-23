import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/assistant_model.dart';
import '../services/base_repo.dart';

/// "Ask admin". Customer-only — xs_backend returns 403 for a model
/// token, because models browse customers through their own screen.
class AssistantRepo extends BaseRepository {
  Future<ApiResponse<AssistantReply>> ask({
    required String message,
    required List<AssistantTurn> history,
  }) {
    return safeCall(
      () => api.post(
        ApiConstants.assistantAsk,
        data: {
          'message': message,
          // Recent turns only, so follow-ups like "younger than that"
          // resolve without posting the whole thread every time.
          'history': history
              .skip(history.length > 8 ? history.length - 8 : 0)
              .map((t) => t.toHistoryJson())
              .toList(),
        },
      ),
      fromJson: (json) => AssistantReply.fromJson(json as Map<String, dynamic>),
    );
  }

  /// The saved thread, oldest first. Reading it clears the unread badge
  /// on the server, so only call it when the sheet is actually opened.
  Future<ApiResponse<List<AssistantTurn>>> history() {
    return safeCall(
      () => api.get(ApiConstants.assistantHistory),
      fromJson: (json) {
        final messages = (json as Map<String, dynamic>)['messages'] as List?;
        return messages
                ?.map((m) => AssistantTurn.fromJson(m as Map<String, dynamic>))
                .toList() ??
            <AssistantTurn>[];
      },
    );
  }
}
