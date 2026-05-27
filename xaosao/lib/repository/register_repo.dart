import 'package:dio/dio.dart';
import 'package:xaosao/services/base_repo.dart';
import 'package:xaosao/models/api_response.dart';
import 'package:xaosao/constants/api_constants.dart';
import 'package:xaosao/utils/date_time_formatter.dart';
import '../models/service_model.dart';
import '../models/sign_up_model.dart';
import 'dart:developer' as developer;

// ═══════════════════════════════════════════════════════════════
class RegisterRepo extends BaseRepository {
  Future<ApiResponse<SignUpModel>> registerCustomer({
    required String filePath,
    required String firstname,
    required String lastname,
    required String whatsapp,
    required DateTime dob,
    required String gender,
    required String password,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'profile': await MultipartFile.fromFile(filePath),
      'firstName': firstname,
      'lastName': lastname,
      'whatsapp': whatsapp,
      'gender': gender,
      'dob': DateTimeFormatter.dobFormatter(dob),
      'password': password,
    });
    return safeCall(
      () => api.upload(
        ApiConstants.clientRegister,
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (j) {
        developer.log('$j', name: 'Register');
        return SignUpModel.fromJson(j);
      },
    );
  }

  Future<ApiResponse<SignUpModel>> registerModel({
    required String filePath,
    required String firstname,
    required String lastname,
    required String address,
    required String whatsapp,
    required DateTime dob,
    required String gender,
    required String password,
    required List<Map<String, dynamic>> services,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'profile': await MultipartFile.fromFile(filePath),
      'firstName': firstname,
      'lastName': lastname,
      'whatsapp': whatsapp,
      'gender': gender,
      'dob': DateTimeFormatter.dobFormatter(dob),
      'password': password,
      'address': address,
      'services': services,
    });
    return safeCall(
      () => api.upload(
        ApiConstants.modelRegister,
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (j) {
        developer.log('$j', name: 'Register');
        return SignUpModel.fromJson(j);
      },
    );
  }

  Future<ApiResponse<bool>> verifyOtp({
    required String phone,
    required String otp,
    required bool isCustomer,
  }) {
    return safeCall(
      () => api.post(
        isCustomer ? ApiConstants.clientVerifyOTP : ApiConstants.modelVerifyOTP,
        data: {'whatsapp': phone, 'otp': otp},
      ),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<bool>> resendOtp({
    required String phone,
    required bool isCustomer,
  }) {
    return safeCall(
      () => api.post(
        isCustomer ? ApiConstants.clientResendOTP : ApiConstants.modelResendOTP,
        data: {'whatsapp': phone},
      ),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<List<ServiceModel>>> servicePublic() {
    return safeCall(
      () => api.get(ApiConstants.servicePublic),
      fromJson: (json) => (json as List)
          .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<bool>> deleteAccount({required bool isCustomer}) {
    return safeCall(
      () => api.delete(
        isCustomer
            ? ApiConstants.clientDeleteAccount
            : ApiConstants.modelDeleteAccount,
      ),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<bool>> changePassword({
    required bool isCustomer,
    required String currentPass,
    required String newPass,
  }) {
    return safeCall(
      () => api.patch(
        isCustomer
            ? ApiConstants.clientChangePass
            : ApiConstants.modelChangePass,
        data: {"oldPassword": currentPass, "newPassword": newPass},
      ),
      fromJson: (json) => true,
    );
  }
}
