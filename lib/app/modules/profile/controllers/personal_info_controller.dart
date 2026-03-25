import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PersonalInfoController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();

  final fullNameError = ''.obs;
  final emailError = ''.obs;
  final dobError = ''.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final box = GetStorage();
    final userData = box.read('user_data');

    if (userData != null) {
      fullNameController.text = userData['full_name'] ?? '';
      emailController.text = userData['email'] ?? '';
      dobController.text = userData['date_of_birth'] ?? '';
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.onClose();
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: const Color(0xFF1A73E8),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: const Color(0xFF1C2B4A),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dobController.text =
      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  void save() async {
    if (!_validate()) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final box = GetStorage();
      Map<String, dynamic> updatedData = {
        'full_name': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'date_of_birth': dobController.text.trim(),
      };

      await box.write('user_data', updatedData);

      Get.snackbar(
        'Success',
        'Personal info updated successfully',
        backgroundColor: const Color(0xFF1A73E8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      Get.snackbar('Error', 'Update failed: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validate() {
    bool valid = true;
    fullNameError.value = '';
    emailError.value = '';
    dobError.value = '';

    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Full name is required';
      valid = false;
    }
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email address is required';
      valid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Enter a valid email address';
      valid = false;
    }
    if (dobController.text.trim().isEmpty) {
      dobError.value = 'Date of birth is required';
      valid = false;
    }
    return valid;
  }
}