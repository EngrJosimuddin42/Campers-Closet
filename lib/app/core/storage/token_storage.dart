import 'package:get_storage/get_storage.dart';

class TokenStorage {

  final _box = GetStorage();

  static const accessTokenKey = "access_token";
  static const refreshTokenKey = "refresh_token";

  String? get accessToken => _box.read(accessTokenKey);

  String? get refreshToken => _box.read(refreshTokenKey);

  void saveTokens(String accessToken, String refreshToken) {
    _box.write(accessTokenKey, accessToken);
    _box.write(refreshTokenKey, refreshToken);
  }

  void clearTokens() {
    _box.remove(accessTokenKey);
    _box.remove(refreshTokenKey);
  }
}