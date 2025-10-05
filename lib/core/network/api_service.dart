import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class ApiService {
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Add Supabase auth headers if using Edge Functions
        if (AppConstants.useSupabaseFunctions) ...{
          'Authorization': 'Bearer ${AppConstants.supabaseAnonKey}',
          'apikey': AppConstants.supabaseAnonKey,
        },
      },
    ));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(AppConstants.authTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          _handleError(error);
          handler.next(error);
        },
      ),
    );
  }
  
  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';
        throw ApiException(message, statusCode);
      case DioExceptionType.cancel:
        throw NetworkException('Request cancelled');
      case DioExceptionType.connectionError:
        throw NetworkException('No internet connection');
      default:
        throw NetworkException('Unknown error occurred');
    }
  }
  
  // GET request
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
  
  // POST request
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
  
  // PUT request
  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
  
  // PATCH request
  Future<dynamic> patch(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
  
  // DELETE request
  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
  
  // File upload
  Future<dynamic> uploadFile(String path, String filePath, String fieldName) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post(path, data: formData);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
}

// Custom exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, this.statusCode);
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
