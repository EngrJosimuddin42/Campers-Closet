import 'package:campers_closet/app/core/network/api_exception.dart';
import 'package:campers_closet/app/core/utils/api_constants.dart';

import '../services/api_service.dart';
import '../../core/storage/token_storage.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final TokenStorage _storage = TokenStorage();

  Future login({required String email, required String password}) async {
    try {
      final response = await _apiService.post(
        "/login",
        data: {"email": email, "password": password},
      );

      final accessToken = response.data["access_token"];
      final refreshToken = response.data["refresh_token"];

      _storage.saveTokens(accessToken, refreshToken);

      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  void logout() {
    _storage.clearTokens();
  }

  Future<void> signup({
    required String email,
    required String fullName,
    required String dateOfBirth,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.signup,
        data: {
          "email": email,
          "full_name": fullName,
          "date_of_birth": dateOfBirth,
          "password": password,
          "password_confirm": passwordConfirm,
        },
      );

      // API returns 201 with success:true, no token yet (email verification pending)
      final bool success = response.data["success"] ?? false;

      if (!success) {
        throw response.data["message"] ?? "Signup failed";
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    try {
      final response = await _apiService.post(
        "/user/verify-otp/",
        data: {"email": email, "otp": otp, "purpose": "email_verification"},
      );

      final bool success = response.data["success"] ?? false;
      if (!success) {
        throw response.data["message"] ?? "Verification failed";
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> resendOtp({required String email}) async {
    try {
      final response = await _apiService.post(
        "/user/request-otp/",
        data: {"email": email, "purpose": "email_verification"},
      );

      final bool success = response.data["success"] ?? false;
      if (!success) {
        throw response.data["message"] ?? "Failed to resend code";
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
