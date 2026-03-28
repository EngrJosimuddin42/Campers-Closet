import 'package:campers_closet/app/core/utils/api_constants.dart';
import 'package:dio/dio.dart';
import 'dio_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {"Content-Type": "application/json"},
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    dio.interceptors.add(DioInterceptor(dio));
  }
}
