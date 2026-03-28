import 'package:campers_closet/app/core/network/api_exception.dart';
import 'package:campers_closet/app/core/utils/api_constants.dart';
import 'package:campers_closet/app/data/services/api_service.dart';
import 'package:dio/dio.dart';

class NotificationRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getNotifications() async {
    try {
      final response = await _apiService.get(ApiConstants.notifications);
      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // single notification mark as read
  Future<void> markAsRead(String pk) async {
    try {
      final response = await _apiService.patch(
        'user/notifications/$pk/mark-read/',
      );
      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 404) {
        throw "Failed to mark as read";
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
      throw handleDioError(e);
    }
  }

  // All notifications mark as read
  Future<void> markAllAsRead() async {
    try {
      await _apiService.patch(ApiConstants.notificationsMarkAllRead);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // notification settings
  Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      final response = await _apiService.get(ApiConstants.notificationSettings);
      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // notification settings update
  Future<void> updateNotificationSettings(bool enabled) async {
    try {
      await _apiService.patch(
        ApiConstants.notificationSettings,
        data: {"enabled": enabled},
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}