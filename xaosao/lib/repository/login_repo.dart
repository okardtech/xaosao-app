import 'dart:io';

import 'package:xaosao/models/login_model.dart';
import 'package:xaosao/utils/date_time_formatter.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/profile_model.dart';
import '../services/base_repo.dart';
import '../services/notification_service.dart';

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
    // Send this phone's push token with the login, so the server registers
    // the phone in the same step: a model who signs in here can then be
    // called and rung straight away.
    final pushToken = await NotificationService.deviceTokenForLogin();
    if (pushToken != null) {
      bodyRequest["device_token"] = pushToken;
      bodyRequest["platform"] = Platform.isAndroid ? 'android' : 'ios';
    }
    Future<ApiResponse<LoginModel>> send() => safeCall(
          () => api.post(
            isCustomer ? ApiConstants.clientLogin : ApiConstants.modelLogin,
            data: bodyRequest,
          ),
          fromJson: (json) => LoginModel.fromJson(json),
        );
    final res = await send();
    // A server older than this app rejects the unknown push fields; sign
    // in without them rather than lock the user out (the app registers
    // the phone separately after login anyway).
    final msg = res.message ?? '';
    if (!res.success &&
        bodyRequest.containsKey('device_token') &&
        (msg.contains('device_token') || msg.contains('platform'))) {
      bodyRequest
        ..remove('device_token')
        ..remove('platform');
      return send();
    }
    return res;
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

  Future<ApiResponse<bool>> updateLocation({
    required double latitude,
    required double longitude,
  }) {
    return safeCall(
      () => api.patch(
        ApiConstants.meLocation,
        data: {'latitude': latitude, 'longitude': longitude},
      ),
      fromJson: (json){
        // print('Location update response: $json'); // Debug log
        return true;
      },
    );
  }

}
