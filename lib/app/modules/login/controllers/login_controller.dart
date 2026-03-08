import 'package:campers_closet/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final rememberMe = false.obs;

  final emailError = ''.obs;
  final passwordError = ''.obs;

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void login() {
    Get.offAllNamed(Routes.NAVBAR);
  }

  void forgotPassword() {
    Get.toNamed(Routes.FORGET_PASSWORD);
  }

  void goToSignUp() {
    Get.offNamed(Routes.SIGNUP);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
