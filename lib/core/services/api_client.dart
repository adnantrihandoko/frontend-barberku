import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:barberku_app/core/constants/app_constants.dart';
import 'package:barberku_app/core/utils/logger.dart';

class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;

  const ApiResponse({this.data, this.message, this.statusCode});

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;

  factory ApiResponse.fromResponse(
    Response response, {
    T? Function(dynamic json)? fromJson,
  }) {
    final body = response.data;
    if (body is Map<String, dynamic>) {
      final rawData = body['data'];
      return ApiResponse(
        data: rawData != null && fromJson != null ? fromJson(rawData) : rawData as T?,
        message: body['message'] as String?,
        statusCode: response.statusCode,
      );
    }
    return ApiResponse(
      data: body as T?,
      statusCode: response.statusCode,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(message: message, statusCode: statusCode);
  }
}

class ApiClient {
  final FlutterSecureStorage _storage;
  late final Dio _dio;

  ApiClient({
    FlutterSecureStorage? storage,
    Dio? dio,
  }) : _storage = storage ?? const FlutterSecureStorage() {
    _dio = dio ?? _createDio();
  }

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.addAll([
      _authInterceptor(),
      _logInterceptor(),
      _responseInterceptor(),
    ]);

    return dio;
  }

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: AppConstants.keyAuthToken);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    );
  }

  InterceptorsWrapper _logInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        AppLogger.d('[API] ${options.method} ${options.uri}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        AppLogger.d('[API] ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
      },
      onError: (error, handler) {
        AppLogger.e('[API] ${error.response?.statusCode} ${error.requestOptions.uri}: ${error.message}');
        handler.next(error);
      },
    );
  }

  InterceptorsWrapper _responseInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          AppLogger.w('[API] Unauthorized - token may be expired');
        }
        handler.next(error);
      },
    );
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T? Function(dynamic json)? fromJson,
  }) async {
    return _execute(() => _dio.get(path, queryParameters: queryParameters), fromJson: fromJson);
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T? Function(dynamic json)? fromJson,
  }) async {
    return _execute(
      () => _dio.post(path, data: data, queryParameters: queryParameters),
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T? Function(dynamic json)? fromJson,
  }) async {
    return _execute(
      () => _dio.put(path, data: data, queryParameters: queryParameters),
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T? Function(dynamic json)? fromJson,
  }) async {
    return _execute(
      () => _dio.delete(path, data: data, queryParameters: queryParameters),
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> _execute<T>(
    Future<Response> Function() request, {
    T? Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await request();
      return ApiResponse.fromResponse(response, fromJson: fromJson);
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response!.data as Map<String, dynamic>)['message'] as String?
          : e.message;
      return ApiResponse.error(
        message ?? 'An unexpected error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        e.toString(),
      );
    }
  }
}
