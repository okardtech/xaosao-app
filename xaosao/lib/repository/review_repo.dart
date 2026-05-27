import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/model_available.dart';
import '../models/review_model.dart';
import '../models/service_model.dart';
import '../services/base_repo.dart';

class ReviewRepo extends BaseRepository {
  Future<ApiResponse<List<ReviewModel>>> getReview({
    required String modelId,
    required String limit,
    required String page,
  }) {
    return safeCall(
      () => api.get(
        '${ApiConstants.reviewList}/$modelId?page=$page&limit=$limit',
      ),
      fromJson: (json) => (json as List)
          .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<bool>> addReview({
    required String modelId,
    required double rating,
    required String title,
    required String desc,
  }) {
    return safeCall(
      () => api.post(
        ApiConstants.addReview,
        data: {
          "modelId": modelId,
          "rating": rating,
          "title": title,
          "reviewText": desc,
          "isAnonymous": false,
        },
      ),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<List<ModelAvailable>>> modelAvailable({
    required String modelId,
  }) {
    return safeCall(
      () => api.get('${ApiConstants.modeAvailable}/$modelId/profile'),
      fromJson: (json) => (json['services'] as List)
          .map((item) => ModelAvailable.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<bool>> addLike({
    required bool isClient,
    required String id, // customerId when !isClient, modelId when isClient
  }) {
    return safeCall(
      () => api.post(
        '${isClient ? ApiConstants.clientLike : ApiConstants.modelLike}$id',
        data: {"action": "LIKE"},
      ),
      fromJson: (json) => true,
    );
  }
}
