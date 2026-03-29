import 'package:campers_closet/app/data/repositories/auth_repository.dart';
import 'package:campers_closet/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  var emailError = ''.obs;
  var passwordError = ''.obs;

  var rememberMe = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  bool _validate() {
    bool isValid = true;

    emailError.value = '';
    passwordError.value = '';

    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email';
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    if (!_validate()) return;

    try {
      isLoading.value = true;

      await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      Get.offAllNamed(Routes.NAVBAR);

    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(25),
        colorText: Colors.red,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    Get.toNamed(Routes.FORGET_PASSWORD);
  }

  void goToSignUp() {
    Get.toNamed(Routes.SIGNUP);
  }
}