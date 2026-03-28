import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../storage/token_storage.dart';
import '../utils/api_constants.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;
  final TokenStorage tokenStorage = TokenStorage();

  bool _isRefreshing = false;
  final List<Completer<String?>> _pendingRequests = [];

  DioInterceptor(this.dio);

  // Add access token to every request
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenStorage.accessToken;

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  // Handle errors
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final path = err.requestOptions.path;

    if (err.response?.statusCode == 401 &&
        path != ApiConstants.refreshTokenEndpoint) {
      try {
        final newToken = await _getRefreshedToken();

        if (newToken != null) {
          err.requestOptions.headers["Authorization"] = "Bearer $newToken";
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } else {
          _handleSessionExpired();
          return handler.reject(err);
        }
      } catch (_) {
        _handleSessionExpired();
        return handler.reject(err);
      }
    }

    handler.next(err);
  }

  // Session expired হলে login screen এ redirect
  void _handleSessionExpired() {
    tokenStorage.clearTokens();
    GetStorage().remove('user_data');

    Get.offAllNamed('/login');
    Get.snackbar(
      'Session Expired',
      'Please login again',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  // Ensures only one refresh request runs at a time.
  Future<String?> _getRefreshedToken() async {
    if (_isRefreshing) {
      final completer = Completer<String?>();
      _pendingRequests.add(completer);
      return completer.future;
    }

    _isRefreshing = true;

    try {
      final newToken = await _refreshToken();

      for (final completer in _pendingRequests) {
        completer.complete(newToken);
      }

      return newToken;
    } catch (e) {
      for (final completer in _pendingRequests) {
        completer.complete(null);
      }
      return null;
    } finally {
      _isRefreshing = false;
      _pendingRequests.clear();
    }
  }

  // Refresh token API call
  Future<String?> _refreshToken() async {
    final refreshToken = tokenStorage.refreshToken;

    if (refreshToken == null) return null;

    try {
      final response = await dio.post(
        ApiConstants.refreshTokenEndpoint,
        data: {"refresh_token": refreshToken},
      );

      final newAccessToken = response.data["access_token"];
      final newRefreshToken = response.data["refresh_token"];

      tokenStorage.saveTokens(newAccessToken, newRefreshToken);

      return newAccessToken;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        tokenStorage.clearTokens();
      }
      return null;
    }
  }
}