import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/referral_mdoel.dart';
import '../models/refferal_validate_model.dart';
import '../services/base_repo.dart';

class ReferralRepo extends BaseRepository {
  Future<ApiResponse<ReferralModel>> getReferral() {
    return safeCall(
      () => api.get('${ApiConstants.referral}'),
      fromJson: (json) => ReferralModel.fromJson(json),
    );
  }

  Future<ApiResponse<ReferralValidateModel>> referralValidate({
    required String code,
  }) {
    return safeCall(
      () => api.get('${ApiConstants.referralValidate}/$code'),
      fromJson: (json) => ReferralValidateModel.fromJson(json),
    );
  }
}
