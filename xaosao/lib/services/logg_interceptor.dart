import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────── REQUEST ────────────');
      debugPrint('│ [${options.method}] ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) debugPrint('│ Body: ${options.data}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('│ Query: ${options.queryParameters}');
      }
      debugPrint('└────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────── RESPONSE ───────────');
      debugPrint('│ [${response.statusCode}] ${response.requestOptions.uri}');
      debugPrint('│ Data: ${response.data}');
      debugPrint('└────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────── ERROR ──────────────');
      debugPrint('│ [${err.response?.statusCode}] ${err.requestOptions.uri}');
      debugPrint('│ Type: ${err.type}');
      debugPrint('│ Message: ${err.message}');
      if (err.response?.data != null) debugPrint('│ Data: ${err.response?.data}');
      debugPrint('└────────────────────────────────');
    }
    handler.next(err);
  }
}