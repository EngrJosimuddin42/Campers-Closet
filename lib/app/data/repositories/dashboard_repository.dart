import 'package:campers_closet/app/core/network/api_exception.dart';
import 'package:campers_closet/app/core/utils/api_constants.dart';
import 'package:campers_closet/app/data/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class DashboardRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getClosetStats() async {
    try {
      final box = GetStorage();
      final activeData = box.read('active_user_data');
      final userData = box.read('user_data');

      // If child selected ?child=id
      final String? childId = activeData != null
          ? (activeData['id'] ?? activeData['pk'])?.toString()
          : null;

      final String loginRole =
      (userData?['role'] ?? '').toString().toLowerCase();

      final endpoint = (loginRole == 'parent' && childId != null)
          ? '${ApiConstants.closetStats}?child=$childId'
          : ApiConstants.closetStats;

      final response = await _apiService.get(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}