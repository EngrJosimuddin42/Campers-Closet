import 'package:campers_closet/app/core/storage/token_storage.dart';
import 'package:campers_closet/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final TokenStorage _storage = TokenStorage();
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), jumpNextScreen);
  }

  void jumpNextScreen() {
    debugPrint('>>> jumpNextScreen called');
    debugPrint('>>> hasSeenOnboarding: ${_box.read('has_seen_onboarding')}');
    debugPrint('>>> accessToken: ${_storage.accessToken}');
    print('>>> isLoggedIn: ${_storage.accessToken != null}');

    final hasSeenOnboarding = _box.read('has_seen_onboarding') ?? false;
    final isLoggedIn = _storage.accessToken != null;

    if (!hasSeenOnboarding) {
      Get.offAllNamed(Routes.ONBOARDING);
    } else if (isLoggedIn) {
      Get.offAllNamed(Routes.NAVBAR);
    } else {
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}
