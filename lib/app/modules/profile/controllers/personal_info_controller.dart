// ─── Controller ───────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalInfoController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();

  final fullNameError = ''.obs;
  final emailError = ''.obs;
  final dobError = ''.obs;

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
            primary: Color(0xFF1A73E8),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF1C2B4A),
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

  void save() {
    bool valid = true;

    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Full name is required';
      valid = false;
    } else {
      fullNameError.value = '';
    }

    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email address is required';
      valid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Enter a valid email address';
      valid = false;
    } else {
      emailError.value = '';
    }

    if (dobController.text.trim().isEmpty) {
      dobError.value = 'Date of birth is required';
      valid = false;
    } else {
      dobError.value = '';
    }

    if (valid) {
      Get.snackbar(
        'Saved',
        'Personal info updated successfully',
        backgroundColor: const Color(0xFF1A73E8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12,
      );
    }
  }
}