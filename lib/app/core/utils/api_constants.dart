class ApiConstants {
  static const baseUrl = "http://3.225.98.180/api/v1/";

  // Auth Endpoints
  static const signup = "/user/signup/parent/";
  static const childSignup = "/user/signup/child/";
  static const login = "/user/login/";
  static const logout = "/user/logout/";
  static const profileUpdate = "/user/profile/update/";
  static const String deleteAccount = '/user/profile/delete/';
  static const String changePassword = "/user/change-password/";

  // OTP & Verification
  static const verifyOtp = "/user/verify-otp/";
  static const requestOtp = "/user/request-otp/";
  static const requestPasswordReset = "/user/request-password-reset/";
  static const verifyResetOtp = "/user/verify-password-reset-otp/";
  static const setNewPassword = "/user/set-new-password/";
  static const usersList = "/user/list/";
  static const fetchAccounts = "/user/profile/manage-account/";

  // Token & Timeouts
  static const refreshTokenEndpoint = "/refresh-token";
  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);
}