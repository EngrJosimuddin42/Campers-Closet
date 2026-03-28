import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class ChildSignupController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var fullNameError = ''.obs;
  var emailError = ''.obs;
  var dobError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var acceptedTerms = false.obs;
  var isLoading = false.obs;

  void toggleTerms() => acceptedTerms.value = !acceptedTerms.value;

  bool _validate() {
    fullNameError.value =
    fullNameController.text.trim().isEmpty ? 'Name is required' : '';
    emailError.value =
    emailController.text.trim().isEmpty ? 'Email is required' : '';
    dobError.value =
    dobController.text.trim().isEmpty ? 'Date of birth is required' : '';
    passwordError.value =
    passwordController.text.isEmpty ? 'Password is required' : '';
    confirmPasswordError.value =
    confirmPasswordController.text != passwordController.text
        ? 'Passwords do not match'
        : '';

    if (fullNameError.value.isNotEmpty ||
        emailError.value.isNotEmpty ||
        dobError.value.isNotEmpty ||
        passwordError.value.isNotEmpty ||
        confirmPasswordError.value.isNotEmpty) {
      return false;
    }

    if (!acceptedTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please accept terms & conditions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }


  Future<void> validateAndAdd() async {
    if (isLoading.value) return;
    if (!_validate()) return;

    try {
      isLoading.value = true;

      await _authRepo.childSignup(
        email: emailController.text.trim(),
        fullName: fullNameController.text.trim(),
        dateOfBirth: dobController.text.trim(),
        password: passwordController.text,
        passwordConfirm: confirmPasswordController.text,
      );

      isLoading.value = false;
      Get.back(result: true);

    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
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