import 'package:campers_closet/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campers_closet/app/data/repositories/auth_repository.dart';
import 'package:intl/intl.dart';

class SignupController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Text Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Error Messages
  var fullNameError = ''.obs;
  var emailError = ''.obs;
  var dobError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;

  // Terms acceptance
  var acceptedTerms = false.obs;

  // Loading state
  var isLoading = false.obs;

  void toggleTermsAcceptance() {
    acceptedTerms.value = !acceptedTerms.value;
  }

  bool _validate() {
    bool isValid = true;

    // Reset errors
    fullNameError.value = '';
    emailError.value = '';
    dobError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';

    // Full name
    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Full name is required';
      isValid = false;
    }

    // Email
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email';
      isValid = false;
    }

    // Date of birth
    if (dobController.text.trim().isEmpty) {
      dobError.value = 'Date of birth is required';
      isValid = false;
    }

    // Password
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (password.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      isValid = false;
    }

    // Confirm password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      isValid = false;
    } else if (confirmPasswordController.text != password) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    }

    // Terms
    if (!acceptedTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please accept the terms & conditions and privacy policy',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
        margin: const EdgeInsets.all(16),
      );
      isValid = false;
    }

    return isValid;
  }

  /// Converts "DD/MM/YYYY" (from date picker) to "YYYY-MM-DD" (API format)
  String _formatDobForApi(String dob) {
    final parsed = DateFormat('dd/MM/yyyy').parse(dob);
    return DateFormat('yyyy-MM-dd').format(parsed);
  }

  Future<void> validateAndSignup() async {
    if (!_validate()) return;

    try {
      isLoading.value = true;

      await _authRepository.signup(
        email: emailController.text.trim(),
        fullName: fullNameController.text.trim(),
        dateOfBirth: _formatDobForApi(dobController.text.trim()),
        password: passwordController.text,
        passwordConfirm: confirmPasswordController.text,
      );

      Get.snackbar(
        'Account Created',
        'Please verify your email to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
        margin: const EdgeInsets.all(16),
      );

      // Go to login since email verification is required
      // In validateAndSignup(), replace Get.offAllNamed(Routes.LOGIN) with:
      Get.offAllNamed(
        Routes.OTP_VERIFICATION,
        arguments: {'email': emailController.text.trim()},
      );
    } catch (e) {
      Get.snackbar(
        'Signup Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
