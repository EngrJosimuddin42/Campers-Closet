import 'dart:async';
import 'package:campers_closet/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';

class ForgetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  RxBool isLoading = false.obs;
  RxBool isLoadingOtp = false.obs;

  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;
  RxString confirmPasswordError = ''.obs;

  RxString userEmail = ''.obs;
  RxString resetToken = ''.obs;

  RxBool canResend = false.obs;
  RxInt secondsRemaining = 60.obs;

  Timer? timer;

  String get formattedTime {
    final minutes = (secondsRemaining.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void validateAndRequestReset() async {
    if (emailController.text.isEmpty) {
      emailError.value = "Email is required";
      return;
    }

    try {
      isLoading.value = true;
      emailError.value = '';
      userEmail.value = emailController.text.trim();

      await _authRepository.requestPasswordReset(userEmail.value);

      Get.snackbar(
        "Success",
        "Reset code sent to your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
      );

      FocusManager.instance.primaryFocus?.unfocus();
      Get.toNamed(Routes.OTP);

    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
      );
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  void startTimer() {
    canResend.value = false;
    secondsRemaining.value = 60;

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isClosed && secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        if (!isClosed) canResend.value = true;
        timer.cancel();
      }
    });
  }

  void onOtpChanged(String value) {}

  Future<void> validateAndSubmitOtp() async {
    final otp = otpController.text;

    if (otp.length != 4) {
      Get.snackbar("Error", "Please enter valid OTP");
      return;
    }

    try {
      isLoadingOtp.value = true;

      final data = await _authRepository.verifyResetOtp(
        email: userEmail.value,
        otp: otp,
      );

      resetToken.value = data['reset_token'] ?? '';
      print("Reset Token saved: ${resetToken.value}");

      Get.snackbar(
        "Success",
        "OTP Verified",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
      );

      Get.toNamed(Routes.RESET_VIEW);

    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
      );
    } finally {
      if (!isClosed) isLoadingOtp.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      isLoadingOtp.value = true;

      await _authRepository.resendOtp(email: userEmail.value);

      otpController.clear();
      startTimer();

      Get.snackbar(
        "Success",
        "OTP sent again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
      );

    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
      );
    } finally {
      if (!isClosed) isLoadingOtp.value = false;
    }
  }

  Future<void> resetPassword() async {
    passwordError.value = '';
    confirmPasswordError.value = '';

    if (passwordController.text.isEmpty) {
      passwordError.value = "Password is required";
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = "Please confirm your password";
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = "Passwords do not match";
      return;
    }

    try {
      isLoading.value = true;

      await _authRepository.confirmPasswordReset(
        email: userEmail.value,
        otp: otpController.text,
        newPassword: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        resetToken: resetToken.value,
      );

      print("Reset Token used: ${resetToken.value}");

      FocusManager.instance.primaryFocus?.unfocus();

      Get.snackbar(
        "Success",
        "Password reset successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.7),
        colorText: Colors.white,
      );

      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(Routes.LOGIN);

    } catch (e) {
      print("Reset password error: $e");
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
      );
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    timer?.cancel();
    super.onClose();
  }
}