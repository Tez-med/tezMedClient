import 'package:chuck_interceptor/chuck.dart';
import 'package:dio/dio.dart';
import 'package:tez_med_client/config/environment.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/routes/app_routes.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/data/auth/models/auth_response.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'dart:developer' as developer;

import 'package:tez_med_client/injection.dart';

class DioClient {
  final Dio _dio;
  bool _isRefreshing = false;
  final prefs = LocalStorageService();
  final chuck = getIt<Chuck>();

  DioClient(this._dio) {
    _dio.options
      ..connectTimeout = const Duration(minutes: 5)
      ..receiveTimeout = const Duration(minutes: 5)
      ..baseUrl = EnvironmentConfig.instance.apiUrl;
    if (EnvironmentConfig.instance.isDev) {
      _dio.interceptors.add(chuck.getDioInterceptor());
    }
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response == null || error.response?.statusCode != 400) {
            return handler.next(error);
          }

          final errorMessage = error.response?.data["error_message"];
          final validationError =
              error.response?.data["validations"]?[0]['error'];

          if (errorMessage == "expired jwt token") {
            developer.log("Access token expired");

            if (!_isRefreshing) {
              _isRefreshing = true;
              final refreshSuccess = await _refreshToken();
              _isRefreshing = false;

              if (refreshSuccess) {
                return _retryOriginalRequest(error.requestOptions, handler);
              } else {
                return _handleLogout(handler, error);
              }
            } else {
              await Future.delayed(const Duration(milliseconds: 500));
              return _retryOriginalRequest(error.requestOptions, handler);
            }
          } else if (validationError == "expired refresh token") {
            developer.log("Refresh token expired");
            return _handleLogout(handler, error);
          }
            developer.log(error.response?.data.toString() ?? "No error data");
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    final refreshToken = prefs.getString(StorageKeys.refreshtoken);

    try {
      final response = await _dio.post(
        "${EnvironmentConfig.instance.apiUrl}/auth/refresh",
        data: {"token": refreshToken},
      );
      developer.log("Access token refreshed: ${response.data}");

      final authData = Auth.fromJson(response.data);
      await prefs.setString(StorageKeys.accestoken, authData.accessToken);
      await prefs.setString(StorageKeys.refreshtoken, authData.refreshToken);

      return true;
    } on DioException catch (e) {
      developer.log("Failed to refresh token: ${e.response}");
      return false;
    }
  }

  Future<void> _retryOriginalRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final accessToken = prefs.getString(StorageKeys.accestoken);
      final opts = Options(
        method: requestOptions.method,
        headers: {
          ...requestOptions.headers,
          'Authorization': 'Bearer $accessToken',
        },
      );

      final response = await _dio.request(
        requestOptions.path,
        options: opts,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
      );

      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<void> _handleLogout(
    ErrorInterceptorHandler handler,
    DioException error,
  ) async {
    await prefs.removeKey(StorageKeys.accestoken);
    await prefs.removeKey(StorageKeys.refreshtoken);
    await prefs.removeKey(StorageKeys.isRegister);
    await prefs.removeKey(StorageKeys.userId);
    AppRouter.instance.replaceAll([const PhoneInputRoute()]);
    handler.next(error);
  }

  Future<Response> _request(
    String method,
    String url, {
    String? token,
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final headers = {
        "Content-Type": "application/json",
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = "Bearer $token";
      }

      final response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParams,
        options: Options(
          method: method,
          headers: headers,
        ),
      );
      return response;
    } on DioException catch (e) {
      developer.log("Request error: ${e}", name: "ERROR");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> get(
    String url, {
    String? token,
    Map<String, dynamic>? queryParams,
  }) =>
      _request('GET', url, token: token, queryParams: queryParams);

  Future<Response> post(
    String url, {
    String? token,
    dynamic data,
  }) =>
      _request('POST', url, token: token, data: data);

  Future<Response> put(
    String url, {
    String? token,
    Map<String, dynamic>? data,
  }) =>
      _request('PUT', url, token: token, data: data);

  Future<Response> delete(
    String url, {
    String? token,
    Map<String, dynamic>? data,
  }) =>
      _request('DELETE', url, token: token, data: data);
}
