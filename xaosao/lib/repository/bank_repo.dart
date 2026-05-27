import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/bank_account_model.dart';
import '../services/base_repo.dart';

class BankRepo extends BaseRepository {
  Future<ApiResponse<List<BankAccountModel>>> getBankAccount() {
    return safeCall(
      () => api.get(ApiConstants.modelBankAccount),
      fromJson: (json) => (json as List)
          .map((e) => BankAccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<bool>> createBankAccount({
    required String filePath,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    return safeCall(
      () => api.upload(
        ApiConstants.modelBankAccount,
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<bool>> updateBankAccount({
    required String id,
    required String filePath,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    return safeCall(
      () => api.patchUpload(
        '${ApiConstants.modelBankAccount}/$id',
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<bool>> deleteBankAccount(String id) {
    return safeCall(
      () => api.delete('${ApiConstants.modelBankAccount}/$id'),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<bool>> defaultBankAccount(String id) {
    return safeCall(
      () => api.post('${ApiConstants.modelBankAccount}/$id/default'),
      fromJson: (json) => true,
    );
  }
}
