import 'package:xaosao/services/base_repo.dart';

import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/call_models.dart';

/// Per-minute calls. A thin wrapper: every rule that decides money lives
/// in xs_backend, so the app and the website behave identically.
class CallRepo extends BaseRepository {
  Future<ApiResponse<CallRate>> rate(String modelId) => safeCall(
        () => api.get(ApiConstants.callRate(modelId)),
        fromJson: (j) => CallRate.fromJson(j as Map<String, dynamic>),
      );

  /// "Let her know I want to call" — a push only; no room, no charge.
  Future<ApiResponse<CallNotice>> notify(String modelId) => safeCall(
        () => api.post(ApiConstants.callNotify(modelId), data: {}),
        fromJson: (j) => CallNotice.fromJson(j as Map<String, dynamic>),
      );

  /// Customer: holds the money, opens the room and rings the model.
  Future<ApiResponse<CallJoin>> start({
    required String modelId,
    required String callType,
  }) =>
      safeCall(
        () => api.post(
          ApiConstants.calls,
          data: {'model_id': modelId, 'call_type': callType},
        ),
        fromJson: (j) => CallJoin.fromJson(
          j as Map<String, dynamic>,
          fallbackType: callType,
        ),
      );

  /// Model: answer a ringing call; returns her own room credentials.
  Future<ApiResponse<CallJoin>> answer(String sessionId) => safeCall(
        () => api.post(ApiConstants.callAnswer(sessionId), data: {}),
        fromJson: (j) => CallJoin.fromJson(j as Map<String, dynamic>),
      );

  Future<ApiResponse<void>> decline(String sessionId) =>
      safeCall(() => api.post(ApiConstants.callDecline(sessionId), data: {}));

  Future<ApiResponse<CallSummary>> hangup(String sessionId) => safeCall(
        () => api.post(ApiConstants.callHangup(sessionId), data: {}),
        fromJson: (j) => CallSummary.fromJson(j as Map<String, dynamic>),
      );

  Future<ApiResponse<CallState>> state(String sessionId) => safeCall(
        () => api.get(ApiConstants.callState(sessionId)),
        fromJson: (j) => CallState.fromJson(j as Map<String, dynamic>),
      );

  /// A fresh media token to rejoin a live call after a dropped connection.
  Future<ApiResponse<CallJoin>> token(String sessionId) => safeCall(
        () => api.get(ApiConstants.callToken(sessionId)),
        fromJson: (j) => CallJoin.fromJson(j as Map<String, dynamic>),
      );
}
