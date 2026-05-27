import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:xaosao/services/api_service.dart';
import 'package:xaosao/services/app_expception.dart';
import 'package:xaosao/services/storage_service.dart';

import '../models/api_response.dart';

abstract class BaseRepository {
  final ApiService _apiService = Get.find<ApiService>();

  ApiService get api => _apiService;

  Future<ApiResponse<T>> safeCall<T>(
    Future<Response> Function() call, {
    T Function(dynamic json)? fromJson,
    bool authRequired = false, // ← ເພີ່ມຕົວນີ້
  }) async {
    try {
      final options = authRequired ? _authOptions() : null;
      final response = await call();
      final body = response.data as Map<String, dynamic>? ?? {};

      return ApiResponse<T>(
        success:
            body['success'] ??
            (response.statusCode != null && response.statusCode! < 300),
        message: body['message']?.toString(),
        laMessage: body['la_message']?.toString(),
        data: body['data'] != null && fromJson != null
            ? fromJson(body['data'])
            : null,
        statusCode: response.statusCode,
      );
    } on AppException catch (e) {
      return ApiResponse<T>(
        success: false,
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      return ApiResponse<T>(success: false, message: e.toString());
    }
  }

  // ສ້າງ Options ທີ່ມີ Token
  Options _authOptions() {
    final storageService = Get.find<StorageService>();
    final token = storageService.read<String>('token');
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<ApiResponse<PaginatedResponse<T>>> safePaginatedCall<T>(
    Future<Response> Function() call,
    T Function(Map<String, dynamic>) fromJson, {
    bool authRequired = false, // ← ເພີ່ມຕົວນີ້ດ້ວຍ
  }) async {
    try {
      final response = await call();
      final body = response.data as Map<String, dynamic>? ?? {};
      final paginated = PaginatedResponse<T>.fromJson(body, fromJson);

      return ApiResponse<PaginatedResponse<T>>(
        success: true,
        data: paginated,
        statusCode: response.statusCode,
      );
    } on AppException catch (e) {
      return ApiResponse<PaginatedResponse<T>>(
        success: false,
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      return ApiResponse<PaginatedResponse<T>>(
        success: false,
        message: e.toString(),
      );
    }
  }
}
