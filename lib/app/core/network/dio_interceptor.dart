import 'dart:async';
import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import '../utils/api_constants.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;
  final TokenStorage tokenStorage = TokenStorage();

  // Lock to prevent concurrent token refresh calls
  bool _isRefreshing = false;
  final List<Completer<String?>> _pendingRequests = [];

  DioInterceptor(this.dio);

  /// Add access token to every request
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenStorage.accessToken;

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  /// Handle errors
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final path = err.requestOptions.path;

    // Prevent retry loop on the refresh endpoint itself
    if (err.response?.statusCode == 401 &&
        path != ApiConstants.refreshTokenEndpoint) {
      try {
        final newToken = await _getRefreshedToken();

        if (newToken != null) {
          err.requestOptions.headers["Authorization"] = "Bearer $newToken";

          final response = await dio.fetch(err.requestOptions);

          return handler.resolve(response);
        }
      } catch (_) {}
    }

    handler.next(err);
  }

  /// Ensures only one refresh request runs at a time.
  /// Other 401s wait for it to complete.
  Future<String?> _getRefreshedToken() async {
    if (_isRefreshing) {
      // Queue this request until refresh completes
      final completer = Completer<String?>();
      _pendingRequests.add(completer);
      return completer.future;
    }

    _isRefreshing = true;

    try {
      final newToken = await _refreshToken();

      // Resolve all queued requests with the new token
      for (final completer in _pendingRequests) {
        completer.complete(newToken);
      }

      return newToken;
    } catch (e) {
      // Reject all queued requests
      for (final completer in _pendingRequests) {
        completer.complete(null);
      }
      return null;
    } finally {
      _isRefreshing = false;
      _pendingRequests.clear();
    }
  }

  /// Refresh token API call
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
    } catch (e) {
      tokenStorage.clearTokens();
      return null;
    }
  }
}
