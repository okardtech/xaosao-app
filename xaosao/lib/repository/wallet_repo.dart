import 'package:dio/dio.dart';
import 'package:xaosao/services/base_repo.dart';

import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/customer_wallet_model.dart';
import '../models/model_wallet_model.dart';
import '../models/top_up_model.dart';
import '../models/transactions_model.dart';

class PackageRepo extends BaseRepository {
  Future<ApiResponse<CustomerWalletModel>> customerWallet() {
    return safeCall(
      () => api.get(ApiConstants.clientWallet),
      fromJson: (json) => CustomerWalletModel.fromJson(json),
    );
  }

  Future<ApiResponse<TopUpModel>> customerTopUp({
    required int amount,
    required String filePath,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'amount': amount,
      'files': await MultipartFile.fromFile(filePath),
    });
    return safeCall(
      () => api.upload(
        ApiConstants.clientTopup,
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (json) => TopUpModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<TransactionsModel>>> getTransactions({
    required bool isCustomer,
    required String limit,
    required String page,
    String? status, // all(null), pending,approved,rejected,completed,refunded
  }) {
    String baseUrl =
        '${isCustomer ? ApiConstants.clientTransactions : ApiConstants.modelTransactions}?page=$page&limit=$limit';
    String url = status != null ? '$baseUrl&status=$status' : baseUrl;
    return safeCall(
      () => api.get(url),
      fromJson: (json) => (json as List)
          .map(
            (item) => TransactionsModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Future<ApiResponse<ModelWalletModel>> modelWallet() {
    return safeCall(
      () => api.get(ApiConstants.modelWallet),
      fromJson: (json) => ModelWalletModel.fromJson(json),
    );
  }

  Future<ApiResponse<TopUpModel>> modelWithdraw({
    required int amount,
    required String bankAccount,
  }) {
    return safeCall(
      () => api.post(
        ApiConstants.modelWithdraw,
        data: {"amount": amount, "bankAccount": bankAccount},
      ),
      fromJson: (json) => TopUpModel.fromJson(json),
    );
  }

  Future<ApiResponse<String>> systemQR() {
    return safeCall(
      () => api.get(ApiConstants.systemQR),
      fromJson: (json) => (json['url']),
    );
  }
}
