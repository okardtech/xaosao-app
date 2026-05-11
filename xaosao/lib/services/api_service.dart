import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:xaosao/services/app_expception.dart';
import 'package:xaosao/services/auth_interceptor.dart';
import 'package:xaosao/services/logg_interceptor.dart';

import '../constants/api_constants.dart';

class ApiService extends GetxService {
  late final Dio _dio;

  Dio get dio => _dio;

  Future<ApiService> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.accept,
        },
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.addAll([AuthInterceptor(), LoggingInterceptor()]);

    return this;
  }

  // ─── GET ────────────────────────────────────────────────────────────────────
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── POST ───────────────────────────────────────────────────────────────────
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── PUT ────────────────────────────────────────────────────────────────────
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── PATCH ──────────────────────────────────────────────────────────────────
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── DELETE ─────────────────────────────────────────────────────────────────
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── UPLOAD (multipart) ─────────────────────────────────────────────────────
  Future<Response> upload(
    String path, {
    required FormData formData,
    void Function(int, int)? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: options ?? Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patchUpload(
    String path, {
    required FormData formData,
    void Function(int, int)? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: options ?? Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── ERROR HANDLER ──────────────────────────────────────────────────────────
  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response);
      case DioExceptionType.cancel:
        return const UnknownException(message: 'Request cancelled.');
      default:
        return UnknownException(message: error.message ?? 'Unknown error');
    }
  }

  AppException _handleStatusCode(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final message = _extractMessage(response?.data);
    final data = response?.data;

    switch (statusCode) {
      case 401:
        return UnauthorizedException(message: message ?? 'Unauthorized.');
      case 403:
        return ForbiddenException(message: message ?? 'Forbidden.');
      case 404:
        return NotFoundException(message: message ?? 'Not found.');
      case 422:
        return ValidationException(
          message: message ?? 'Validation failed.',
          errors: data is Map<String, dynamic> ? data['errors'] : null,
          data: data,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          message: message ?? 'Server error.',
          statusCode: statusCode,
        );
      default:
        return ServerException(
          message: message ?? 'Unexpected error.',
          statusCode: statusCode,
          data: data,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString();
    }
    return null;
  }
}
