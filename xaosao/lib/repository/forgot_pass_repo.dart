import 'package:xaosao/models/otp_model.dart';

import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../services/base_repo.dart';

class ForgotPassRepo extends BaseRepository {
  Future<ApiResponse<OtpModel>> forgotPassPhone({
    required bool isCustomer,
    required String phone,
  }) async {
    return safeCall(
      () => api.post(
        isCustomer
            ? ApiConstants.clientForgotPassPhone
            : ApiConstants.modelForgotPassPhone,
        data: {"whatsapp": phone},
      ),
      fromJson: (json) => OtpModel.fromJson(json),
    );
  }

  Future<ApiResponse<OtpModel>> forgotPassResnd({
    required bool isCustomer,
    required String phone,
  }) async {
    return safeCall(
      () => api.post(
        isCustomer
            ? ApiConstants.clientForgotResend
            : ApiConstants.modelForgotResend,
        data: {"whatsapp": phone},
      ),
      fromJson: (json) => OtpModel.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> forgotPassVerify({
    required bool isCustomer,
    required String phone,
    required String otp,
  }) async {
    return safeCall(
      () => api.post(
        isCustomer
            ? ApiConstants.clientForgotVerifyOTP
            : ApiConstants.modelForgotVerifyOTP,
        data: {"whatsapp": phone, "otp": otp},
      ),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<bool>> newPassword({
    required bool isCustomer,
    required String phone,
    required String newPass,
  }) async {
    return safeCall(
      () => api.post(
        isCustomer ? ApiConstants.clientNewPass : ApiConstants.modelNewPass,
        data: {"whatsapp": phone, "newPassword": newPass},
      ),
      fromJson: (json) => true,
    );
  }
}
