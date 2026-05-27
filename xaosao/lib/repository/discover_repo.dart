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
    String? search,
    String? status, //new,nearby, , vip, popular
  }) async {
    String url =
        '${ApiConstants.recommended}?skip=$skip&limit=$limit&maxDistanceKm=$maxDistanceKm';
    if (genderType != null) url += '&gender=$genderType';
    if (search != null) url += '&search=$search';
    if (status != null) url += '&sort=$status';
    return safeCall(
      () => api.get(url),
      authRequired: true,
      fromJson: (json) => (json['data'] as List)
          .map((e) => RecommendedModel.fromJson(e))
          .toList(),
    );
  }

  Future<ApiResponse<List<RecommendedModel>>> getOnline({
    required int skip,
    required int limit,
    required double maxDistanceKm,
    String? genderType,
    String? search,
    String? status, //new,nearby, , vip, popular
  }) async {
    String url =
        '${ApiConstants.online}?skip=$skip&limit=$limit&maxDistanceKm=$maxDistanceKm';
    if (genderType != null) url += '&gender=$genderType';
    if (search != null) url += '&search=$search';
    if (status != null) url += '&sort=$status';
    return safeCall(
      () => api.get(url),
      authRequired: true,
      fromJson: (json) => (json['data'] as List)
          .map((e) => RecommendedModel.fromJson(e))
          .toList(),
    );
  }

  Future<ApiResponse<List<RecommendedModel>>> getModelDiscover({
    required int skip,
    required int limit,
    String? genderType,
    String? filter,
    String? search,
  }) async {
    // filter is have status is here : all(it's mean set null to api ), for-you,who-like-me,i-liked
    String url = '${ApiConstants.modelDiscover}?skip=$skip&limit=$limit';
    if (genderType != null) url += '&gender=$genderType';
    if (filter != null) url += '&filter=$filter';
    if (search != null) url += '&search=$search';
    return safeCall(
      () => api.get(url),
      authRequired: true,
      fromJson: (json) => (json['data'] as List)
          .map((e) => RecommendedModel.fromJson(e))
          .toList(),
    );
  }

  Future<ApiResponse<List<RecommendedModel>>> getdiscover({
    required int skip,
    required int limit,
    String? filter,
    String? search,
  }) async {
    // filter: null=all, vip, liked-by-me, who-liked-me, nearby, new, popular
    String url = '${ApiConstants.discover}?skip=$skip&limit=$limit';
    if (filter != null) url += '&filter=$filter';
    if (search != null) url += '&search=$search';
    return safeCall(
      () => api.get(url),
      authRequired: true,
      fromJson: (json) => (json['data'] as List)
          .map((e) => RecommendedModel.fromJson(e))
          .toList(),
    );
  }
}
