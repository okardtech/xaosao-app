import 'package:xaosao/models/models_hot.dart';

import '../constants/api_constants.dart';
import '../models/Recommended_model.dart';
import '../models/api_response.dart';
import '../models/customer_public_profile.dart';
import '../services/base_repo.dart';

class DiscoverRepo extends BaseRepository {
  Future<ApiResponse<List<ModelsHot>>> getModelsHot() async {
    return safeCall(
      () => api.get(ApiConstants.modelsHot),
      fromJson: (json) =>
          (json as List).map((e) => ModelsHot.fromJson(e)).toList(),
    );
  }

  Future<ApiResponse<List<RecommendedModel>>> getRecommended({
    required int page,
    required int limit,
    required double maxDistanceKm,
    // String? genderType,
    String? search,
    String? status, //new,nearby, , vip, popular
  }) async {
    String url =
        '${ApiConstants.recommended}?page=$page&limit=$limit&maxDistanceKm=$maxDistanceKm';
    // if (genderType != null) url += '&gender=$genderType';
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
    required int page,
    required int limit,
    required double maxDistanceKm,
    // String? genderType,
    String? search,
    String? status, //new,nearby, , vip, popular
  }) async {
    String url =
        '${ApiConstants.online}?page=$page&limit=$limit&maxDistanceKm=$maxDistanceKm';
    // if (genderType != null) url += '&gender=$genderType';
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
    required int page,
    required int limit,
    String? genderType,
    String? filter,
    String? search,
  }) async {
    // filter is have status is here : all(it's mean set null to api ), for-you,who-like-me,i-liked
    String url = '${ApiConstants.modelDiscover}?page=$page&limit=$limit';
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
    required int page,
    required int limit,
    String? filter,
    String? search,
  }) async {
    // filter: null=all, vip, liked-by-me, who-liked-me, nearby, new, popular
    String url = '${ApiConstants.discover}?page=$page&limit=$limit';
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

  Future<ApiResponse<RecommendedModel>> getRecommendedById({
    required String modelId,
  }) async {
    String url = '${ApiConstants.modeAvailable}/$modelId/profile';
    return safeCall(
      () => api.get(url),
      authRequired: true,
      fromJson: (json) => RecommendedModel.fromJson(json),
    );
  }

  Future<ApiResponse<CustomerPublicProfile>> getCustomerById({
    required String customerId,
  }) async {
    final url = '${ApiConstants.modelDiscoverCustomer}/$customerId';
    return safeCall(
      () => api.get(url),
      authRequired: true,
      fromJson: (json) =>
          CustomerPublicProfile.fromJson((json['data'] ?? json) as Map<String, dynamic>),
    );
  }
}
