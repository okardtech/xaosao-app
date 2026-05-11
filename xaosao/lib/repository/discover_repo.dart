import 'package:xaosao/models/models_hot.dart';

import '../constants/api_constants.dart';
import '../models/Recommended_model.dart';
import '../models/api_response.dart';
import '../services/base_repo.dart';

class DiscoverRepo extends BaseRepository {
  Future<ApiResponse<List<ModelsHot>>> getModelsHot() async {
    return safeCall(
      () => api.get('${ApiConstants.modelsHot}'),
      fromJson: (json) =>
          (json as List).map((e) => ModelsHot.fromJson(e)).toList(),
    );
  }

  Future<ApiResponse<List<RecommendedModel>>> getRecommended({
    required int skip,
    required int limit,
    required double maxDistanceKm,
    String? genderType,
  }) async {
    String url =
        '${ApiConstants.recommended}?skip=$skip&limit=$limit&maxDistanceKm=$maxDistanceKm';
    if (genderType != null) url += '&gender=$genderType';
    return safeCall(
      () => api.get(url),
      authRequired: true,
      fromJson: (json) =>
          (json['data'] as List).map((e) => RecommendedModel.fromJson(e)).toList(),
    );
  }

  Future<ApiResponse<List<RecommendedModel>>> getOnline({
    required int skip,
    required int limit,
    required double maxDistanceKm,
    String? genderType,
  }) async {
    String url =
        '${ApiConstants.online}?skip=$skip&limit=$limit&maxDistanceKm=$maxDistanceKm';
    if (genderType != null) url += '&gender=$genderType';
    return safeCall(
      () => api.get(url),
      authRequired: true,
      fromJson: (json) => (json['data'] as List)
          .map((e) => RecommendedModel.fromJson(e))
          .toList(),
    );
  }
}
