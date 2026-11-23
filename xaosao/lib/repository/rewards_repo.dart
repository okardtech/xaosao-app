import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/checkin_model.dart';
import '../services/base_repo.dart';

/// Daily check-in. Model-only — xs_backend refuses these for a customer
/// token with 403, so the card is never shown on the customer side.
class RewardsRepo extends BaseRepository {
  Future<ApiResponse<CheckinInfo>> getCheckin() {
    return safeCall(
      () => api.get(ApiConstants.rewardsCheckin),
      fromJson: (json) => CheckinInfo.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<CheckinClaim>> claimCheckin() {
    return safeCall(
      () => api.post(ApiConstants.rewardsCheckinClaim),
      fromJson: (json) => CheckinClaim.fromJson(json as Map<String, dynamic>),
    );
  }
}
