import '../constants/api_constants.dart';
import '../models/add_service_model.dart';
import '../models/api_response.dart';
import '../models/notification_model.dart';
import '../models/service_model.dart';
import '../services/base_repo.dart';

class SettingRepo extends BaseRepository {
  Future<ApiResponse<List<ServiceModel>>> getServiceAvailable() {
    return safeCall(
      () => api.get(ApiConstants.serviceAvailable),
      fromJson: (json) => (json as List)
          .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<AddServiceModel>> addService({
    required String serviceId,
    required double customHourlyRate,
    String? serviceLocation,
  }) {
    return safeCall(
      () => api.post(
        '${ApiConstants.modelService}/apply',
        data: {
          "serviceId": serviceId,
          "customHourlyRate": customHourlyRate,
          if (serviceLocation != null && serviceLocation.isNotEmpty)
            "serviceLocation": serviceLocation,
        },
      ),
      fromJson: (json) => AddServiceModel.fromJson(json),
    );
  }

  Future<ApiResponse<AddServiceModel>> updateService({
    required String serviceId,
    required double customHourlyRate,
    String? serviceLocation,
  }) {
    return safeCall(
      () => api.patch(
        '${ApiConstants.modelService}/$serviceId',
        data: {
          "customHourlyRate": customHourlyRate,
          if (serviceLocation != null && serviceLocation.isNotEmpty)
            "serviceLocation": serviceLocation,
        },
      ),
      fromJson: (json) => AddServiceModel.fromJson(json),
    );
  }

  Future<ApiResponse<AddServiceModel>> addMassageService({
    required String serviceId,
    required List<Map<String, dynamic>> massageVariants,
    String? serviceLocation,
  }) {
    return safeCall(
      () => api.post(
        '${ApiConstants.modelService}/apply',
        data: {
          "serviceId": serviceId,
          "massageVariants": massageVariants,
          if (serviceLocation != null && serviceLocation.isNotEmpty)
            "serviceLocation": serviceLocation,
        },
      ),
      fromJson: (json) => AddServiceModel.fromJson(json),
    );
  }

  Future<ApiResponse<AddServiceModel>> updateMassageService({
    required String modelServiceId,
    required List<Map<String, dynamic>> massageVariants,
    String? serviceLocation,
  }) {
    return safeCall(
      () => api.patch(
        '${ApiConstants.modelService}/$modelServiceId',
        data: {
          "massageVariants": massageVariants,
          if (serviceLocation != null && serviceLocation.isNotEmpty)
            "serviceLocation": serviceLocation,
        },
      ),
      fromJson: (json) => AddServiceModel.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> deleteService({required String serviceId}) {
    return safeCall(
      () => api.delete('${ApiConstants.modelService}/$serviceId'),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<NotificationModel>> myNotifcation() {
    return safeCall(
      () => api.get(ApiConstants.notification),
      fromJson: (json) => NotificationModel.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> updateNotification({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    bool? whatsappEnabled,
  }) {
    return safeCall(
      () => api.put(
        ApiConstants.notification,
        data: {
          "push_enabled": pushEnabled ?? false,
          "email_enabled": emailEnabled ?? false,
          "sms_enabled": smsEnabled ?? false,
          "whatsapp_enabled": whatsappEnabled ?? false,
        },
      ),
      fromJson: (json) => true,
    );
  }
}
