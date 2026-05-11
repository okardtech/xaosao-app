import 'package:xaosao/models/login_model.dart';
import 'package:xaosao/utils/date_time_formatter.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/profile_model.dart';
import '../services/base_repo.dart';

class LoginRepo extends BaseRepository {
  Future<ApiResponse<LoginModel>> login({
    required bool isCustomer,
    required String phoneNumber,
    required String password,
  }) async {
    final Map<String, dynamic> bodyRequest = {
      "whatsapp": phoneNumber,
      "password": password,
    };
    return safeCall(
      () => api.post(
        isCustomer ? ApiConstants.clientLogin : ApiConstants.modelLogin,
        data: bodyRequest,
      ),
      fromJson: (json) => LoginModel.fromJson(json),
    );
  }

  Future<ApiResponse<CustomerProfileModel>> customProfile() async {
    return safeCall(
      () => api.get(ApiConstants.clientProfile),
      fromJson: (json) => CustomerProfileModel.fromJson(json),
      authRequired: true,
    );
  }

  Future<ApiResponse<ModelProfileModel>> modelProfile() async {
    return safeCall(
      () => api.get(ApiConstants.modelProfile),
      fromJson: (json) => ModelProfileModel.fromJson(json),
      authRequired: true,
    );
  }

  Future<ApiResponse<bool>> updateInfo({
    required bool isClient,
    required String firstName,
    required String lastName,
    required String gener,
    required DateTime dob,
    String? addresss,
  }) async {
    final bodyRequest = {
      "firstName": firstName,
      "lastName": lastName,
      "dob": DateTimeFormatter.dobFormatter(dob),
      "gender": gener,
      if (addresss != null) "address": addresss,
    };
    return safeCall(
      () => api.patch(
        isClient ? ApiConstants.clientProfile : ApiConstants.modelProfile,
        data: bodyRequest,
      ),
      fromJson: (json) => true,
      authRequired: true,
    );
  }
}
