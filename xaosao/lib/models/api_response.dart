class ApiResponse<T> {
  final bool success;
  final String? message;
  final String? laMessage;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.success,
    this.message,
    this.laMessage,
    this.data,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'],
      laMessage: json['la_message'],
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      statusCode: json['statusCode'],
      errors: json['errors'],
    );
  }

  bool get hasData => data != null;
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  @override
  String toString() =>
      'ApiResponse(success: $success, message: $message, statusCode: $statusCode)';
}

class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final List items = data['items'] ?? data['data'] ?? [];

    return PaginatedResponse<T>(
      items: items.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      currentPage: data['currentPage'] ?? data['current_page'] ?? 1,
      totalPages: data['totalPages'] ?? data['last_page'] ?? 1,
      totalItems: data['totalItems'] ?? data['total'] ?? 0,
      perPage: data['perPage'] ?? data['per_page'] ?? 10,
      hasNextPage: data['hasNextPage'] ?? false,
      hasPreviousPage: data['hasPreviousPage'] ?? false,
    );
  }
}