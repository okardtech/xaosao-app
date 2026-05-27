import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:xaosao/pages/feedback/getx/feedback_logic.dart';
import 'package:xaosao/pages/home/getx/home_logic.dart';
import 'package:xaosao/pages/model_discover/getx/model_discover_logic.dart';
import 'package:xaosao/pages/notification/getx/notification_setting_logic.dart';
import 'package:xaosao/pages/profile/getx/profile_logic.dart';
import 'package:xaosao/pages/services_manage/getx/service_logic.dart';
import 'package:xaosao/services/storage_service.dart';
import '../constants/api_constants.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storageService.read<String>('token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Attempt token refresh
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        // Retry original request with new token
        final token = _storageService.read<String>('token');
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        try {
          final dio = Dio();
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (_) {}
      }
      // Refresh failed — logout user
      _handleLogout();
    }
    handler.next(err);
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = _storageService.read<String>('refresh_token');
      final isClient = _storageService.read<String>('role');
      final token = _storageService.read<String>('token');
      if (refreshToken == null) return false;

      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final response = await dio.post(
        isClient == "customer"
            ? ApiConstants.cleintRefreshToken
            : ApiConstants.modelRefreshToken,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final newToken = response.data['data']['token'];
        final newRefresh = response.data['data']['refreshToken'];
        await _storageService.write('token', newToken);
        await _storageService.write('refresh_token', newRefresh);
        return true;
      }
    } catch (_) {}
    return false;
  }

  void _handleLogout() async {
    await _storageService.remove('token');
    await _storageService.remove('refresh_token');
    _deleteUserControllers();
    Get.offAllNamed('/login');
  }

  void _deleteUserControllers() {
    Get.delete<HomeLogic>(force: true);
    Get.delete<ProfileLogic>(force: true);
    Get.delete<ServiceLogic>(force: true);
    Get.delete<FeedbackLogic>(force: true);
    Get.delete<NotifSettingLogic>(force: true);
    Get.delete<ModelDiscoverLogic>(force: true);
  }
}
