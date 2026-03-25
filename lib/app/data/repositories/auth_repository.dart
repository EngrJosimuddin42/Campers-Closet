import 'package:campers_closet/app/core/network/api_exception.dart';
import 'package:campers_closet/app/core/utils/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

import '../services/api_service.dart';
import '../../core/storage/token_storage.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final TokenStorage _storage = TokenStorage();

  // Login Response
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {"email": email, "password": password},
      );

      final bool success = response.data["success"] ?? false;
      if (!success) {
        throw response.data["message"] ?? "Login failed";
      }

      final data = response.data["data"];
      _storage.saveTokens(data["access_token"], data["refresh_token"]);
      final box = GetStorage();
      await box.write('user_data', data['user']);
      print("User saved to storage: ${data['user']}");
      return data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Logout Response
  Future<void> logout() async {
    try {
      final String? refreshToken = _storage.refreshToken;
      if (refreshToken == null) {
        _storage.clearTokens();
        return;
      }
      final response = await _apiService.post(
        ApiConstants.logout,
        data: {
          "refresh": refreshToken,
        },
      );
      debugPrint("Logout Response: ${response.data}");
    } on DioException catch (e) {
      debugPrint("Logout API Error: ${handleDioError(e)}");
    } finally {
      _storage.clearTokens();
      await GetStorage().remove('user_data');
    }
  }

  // Token Refresh
  Future<void> refreshToken() async {
    try {
      final String? refresh = _storage.refreshToken;
      if (refresh == null) return;

      final response = await _apiService.post(
        ApiConstants.refreshTokenEndpoint,
        data: {"refresh": refresh},
      );

      final bool success = response.data["success"] ?? false;
      if (success) {
        final newAccessToken = response.data["data"]["access_token"];
        _storage.saveTokens(newAccessToken, refresh);
        debugPrint("Token refreshed successfully");
      }
    } on DioException catch (e) {
      debugPrint("Token refresh failed: ${handleDioError(e)}");
      rethrow;
    }
  }

  // Signup Response
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
      final bool success = response.data["success"] ?? false;
      if (!success) {
        final message = response.data["message"] ?? "Signup failed";
        throw Exception(message);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    try {
      final response = await _apiService.post(
        ApiConstants.verifyOtp,
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
        ApiConstants.requestOtp,
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

  // Forgot Password Response
  Future<void> requestPasswordReset(String email) async {
    try {
      final response = await _apiService.post(
        ApiConstants.requestPasswordReset,
        data: {
          "email": email,
          "purpose": "password_reset",
        },
      );

      final bool success = response.data["success"] ?? false;
      if (!success) {
        throw response.data["message"] ?? "Failed to send reset code";
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  //  reset_token  data return
  Future<Map<String, dynamic>> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.verifyResetOtp,
        data: {
          "email": email,
          "otp": otp,
          "purpose": "password_reset",
        },
      );

      final bool success = response.data["success"] ?? false;
      if (!success) {
        throw response.data["message"] ?? "OTP verification failed";
      }

      return response.data["data"];
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> confirmPasswordReset({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
    required String resetToken,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.setNewPassword,
        data: {
          "email": email,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
          "reset_token": resetToken,
        },
      );

      final bool success = response.data["success"] ?? false;
      if (!success) {
        throw response.data["message"] ?? "Failed to reset password";
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // updateProfile response
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? imagePath,
  }) async {
    try {
      Map<String, dynamic> data = {};
      if (fullName != null) data["full_name"] = fullName;

      if (imagePath != null) {
        data["profile_pic"] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      }
      FormData formData = FormData.fromMap(data);
      final response = await _apiService.patch(
        ApiConstants.profileUpdate,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

}