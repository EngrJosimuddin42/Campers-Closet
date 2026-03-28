import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/controllers/manage_user_controller.dart';

class PersonalInfoController extends GetxController {
  final AuthRepository _authRepo = Get.isRegistered<AuthRepository>()
      ? Get.find<AuthRepository>()
      : Get.put(AuthRepository());

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

  void loadUserData() async {
    try {
      final box = GetStorage();
      final activeData = box.read('active_user_data');
      final String? childId = activeData != null
          ? (activeData['id'] ?? activeData['pk'])?.toString()
          : null;

      //  Server থেকে fresh data আনো
      final response = await _authRepo.fetchProfile(childId: childId);

      if (response['success'] == true) {
        final data = response['data'];
        fullNameController.text = data['full_name'] ?? '';
        emailController.text = data['email'] ?? '';
        dobController.text = data['date_of_birth'] ?? '';

        //  Local storage update করো
        if (activeData != null) {
          await box.write('active_user_data', {
            ...Map<String, dynamic>.from(activeData),
            ...Map<String, dynamic>.from(data),
          });
        } else {
          await box.write('user_data', data);
        }
      }
    } catch (e) {
      // fallback — local storage থেকে load করো
      final box = GetStorage();
      final activeData = box.read('active_user_data');
      final userData = activeData ?? box.read('user_data');
      if (userData != null) {
        fullNameController.text = userData['full_name'] ?? '';
        emailController.text = userData['email'] ?? '';
        dobController.text = userData['date_of_birth'] ?? '';
      }
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

  // DOB format: DD/MM/YYYY → YYYY-MM-DD
  String _formatDob(String dob) {
    try {
      final parts = dob.split('/');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
      }
    } catch (_) {}
    return dob;
  }

  void save() async {
    if (!_validate()) return;
    try {
      isLoading.value = true;

      final box = GetStorage();
      final activeData = box.read('active_user_data');
      final isChild = activeData != null;

      // Child হলে id নাও, Parent হলে null
      final String? childId = isChild
          ? (activeData['id'] ?? activeData['pk'])?.toString()
          : null;

      final Map<String, dynamic> updatedFields = {
        'full_name': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'date_of_birth': dobController.text.trim(),
      };

      final response = await _authRepo.updateProfile(
        fullName: fullNameController.text.trim(),
        dateOfBirth: _formatDob(dobController.text.trim()),
        childId: childId,
      );

      if (response['success'] != true) {
        Get.snackbar('Error', response['message'] ?? 'Update failed',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Local storage update
      if (isChild) {
        final updated = {
          ...Map<String, dynamic>.from(activeData),
          ...updatedFields,
        };
        await box.write('active_user_data', updated);
        if (childId != null) {
          await box.write('account_data_$childId', updated);
        }
      } else {
        final userData =
        Map<String, dynamic>.from(box.read('user_data') ?? {});
        final updated = {...userData, ...updatedFields};
        await box.write('user_data', updated);
        await box.write('active_user_data', updated);
        final parentId = (userData['id'] ?? userData['pk'])?.toString();
        if (parentId != null) {
          await box.write('account_data_$parentId', updated);
        }
      }

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().loadUserData();
      }
      if (Get.isRegistered<ManageUsersController>()) {
        Get.find<ManageUsersController>().refreshSelectedAccount();
      }

      Get.snackbar(
        'Success',
        'Personal info updated successfully',
        backgroundColor: const Color(0xFF1A73E8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Update failed: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
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