import 'package:campers_closet/app/data/repositories/auth_repository.dart';
import 'package:campers_closet/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class OtpVerificationController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final otpController = TextEditingController();

  // Email passed from signup screen
  var userEmail = ''.obs;

  // OTP state
  var otpValue = ''.obs;
  var isLoadingOtp = false.obs;

  // Resend timer (60 seconds)
  var canResend = false.obs;
  var secondsRemaining = 60.obs;
  Timer? _timer;

  String get formattedTime {
    final minutes = (secondsRemaining.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onInit() {
    super.onInit();

    // Get email passed via Get.toNamed arguments
    final args = Get.arguments;
    if (args != null && args['email'] != null) {
      userEmail.value = args['email'];
    }

    _startTimer();
  }

  void onOtpChanged(String value) {
    otpValue.value = value;
  }

  void _startTimer() {
    canResend.value = false;
    secondsRemaining.value = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value <= 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  Future<void> validateAndSubmitOtp() async {
    final otp = otpController.text.trim();

    if (otp.length < 4) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter the 4-digit code sent to your email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    try {
      isLoadingOtp.value = true;

      await _authRepository.verifyOtp(
        email: userEmail.value,
        otp: otp,
      );

      Get.snackbar(
        'Email Verified',
        'Your email has been verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
        margin: const EdgeInsets.all(16),
      );

      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Verification Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoadingOtp.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      isLoadingOtp.value = true;

      await _authRepository.resendOtp(email: userEmail.value);

      otpController.clear();
      otpValue.value = '';
      _startTimer();

      Get.snackbar(
        'Code Sent',
        'A new verification code has been sent to your email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Resend Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoadingOtp.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }
}