import 'package:dio/dio.dart';

String handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return "Connection timeout. Please check your internet.";

    case DioExceptionType.sendTimeout:
      return "Request timed out. Please try again.";

    case DioExceptionType.receiveTimeout:
      return "Server took too long to respond.";

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      if (statusCode == 400) return "Bad request. Please check your input.";
      if (statusCode == 401) return "Session expired. Please log in again.";
      if (statusCode == 403) return "You don't have permission to do this.";
      if (statusCode == 404) return "Requested resource not found.";
      if (statusCode == 500) return "Server error. Please try again later.";
      return "Server error ($statusCode).";

    case DioExceptionType.cancel:
      return "Request was cancelled.";

    case DioExceptionType.connectionError:
      return "No internet connection.";

    case DioExceptionType.unknown:
      return "An unexpected error occurred.";

    default:
      return "Something went wrong. Please try again.";
  }
}
