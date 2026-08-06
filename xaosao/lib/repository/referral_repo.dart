import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/comission_model.dart';
import '../models/referral_mdoel.dart';
import '../models/refferal_validate_model.dart';
import '../services/base_repo.dart';

class ReferralRepo extends BaseRepository {
  Future<ApiResponse<ReferralModel>> getReferral() {
    return safeCall(
      () => api.get(ApiConstants.referral),
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

  Future<ApiResponse<List<ComissionModel>>> referralCommissions({
    required int limit,
    required int page,
  }) {
    return safeCall(
      () => api.get(
        '${ApiConstants.referralComission}?limit=$limit&page=$page&type=all',
      ),
      fromJson: (json) => (json as List)
          .map((item) => ComissionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
