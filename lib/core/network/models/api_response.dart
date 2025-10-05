class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null 
          ? fromJsonT(json['data']) 
          : null,
      statusCode: json['statusCode'],
      errors: json['errors'] != null 
          ? Map<String, dynamic>.from(json['errors']) 
          : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value)? toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data!) : data,
      'statusCode': statusCode,
      'errors': errors,
    };
  }

  factory ApiResponse.success({
    required T data,
    String message = 'Success',
  }) =>
      ApiResponse<T>(
        success: true,
        message: message,
        data: data,
      );

  factory ApiResponse.error({
    required String message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) =>
      ApiResponse<T>(
        success: false,
        message: message,
        statusCode: statusCode,
        errors: errors,
      );
}

class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => fromJsonT(item))
              .toList() ??
          [],
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 10,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'data': data.map((item) => toJsonT(item)).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }
} 