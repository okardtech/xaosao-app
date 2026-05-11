abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection.'});
}

class TimeoutException extends AppException {
  const TimeoutException({super.message = 'Request timed out. Please try again.'});
}

class ServerException extends AppException {
  const ServerException({super.message = 'Server error. Please try later.', super.statusCode, super.data});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Unauthorized. Please login again.', super.statusCode = 401});
}

class ForbiddenException extends AppException {
  const ForbiddenException({super.message = 'You do not have permission.', super.statusCode = 403});
}

class NotFoundException extends AppException {
  const NotFoundException({super.message = 'Resource not found.', super.statusCode = 404});
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    super.message = 'Validation failed.',
    super.statusCode = 422,
    this.errors,
    super.data,
  });
}

class UnknownException extends AppException {
  const UnknownException({super.message = 'An unexpected error occurred.', super.statusCode});
}