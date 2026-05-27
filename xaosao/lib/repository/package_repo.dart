import 'package:dio/dio.dart';
import 'package:xaosao/services/base_repo.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/package_active_model.dart';
import '../models/package_history_model.dart';
import '../models/package_hour_model.dart';
import '../models/package_model.dart';

class PackageRepo extends BaseRepository {
  Future<ApiResponse<PackageModel>> getPackage() {
    return safeCall(
      () => api.get(ApiConstants.package),
      fromJson: (json) => PackageModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<PackageHistoryModel>>> getPackageHistory({
    required String limit,
    required String page,
    String? status, // active, expired, pending, canceled, upgraded, completed
  }) {
    String url = '${ApiConstants.packageHistory}?skip=$page&limit=$limit';
    if (status != null) url += '&status=$status';
    return safeCall(
      () => api.get(url),
      fromJson: (json) => (json['data'] as List)
          .map(
            (item) =>
                PackageHistoryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Future<ApiResponse<PackageActiveModel>> packageActive() {
    return safeCall(
      () => api.get(ApiConstants.packageActive),
      fromJson: (json) => PackageActiveModel.fromJson(json),
    );
  }

  Future<ApiResponse<PackageHourModel>> packageHour() {
    return safeCall(
      () => api.get(ApiConstants.packageHour),
      fromJson: (json) => PackageHourModel.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> subcriptionPaid({required String planId}) {
    return safeCall(
      () => api.post(ApiConstants.subcriptionPaid, data: {"planId": planId}),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<bool>> subcriptionNoBalance({
    required String planId,
    required int amount,
    required String filePath,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'planId':planId,
      'amount': amount,
      'paymentSlip': await MultipartFile.fromFile(filePath),
    });
    return safeCall(
      () => api.upload(
        ApiConstants.subcriptionNoBalance,
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (json) => true,
    );
  }
}
