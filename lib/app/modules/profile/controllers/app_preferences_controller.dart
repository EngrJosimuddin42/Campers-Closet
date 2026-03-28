import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';

class AppPreferencesController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final _box = GetStorage();

  // Change Password Controllers
  final oldPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  var biometrics = true.obs;
  var pushNotifications = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    oldPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.onClose();
  }

  void toggleBiometrics(bool value) => biometrics.value = value;
  void toggleNotifications(bool value) => pushNotifications.value = value;

  // Change Password Logic
  Future<void> changePassword() async {

    if (oldPassCtrl.text.isEmpty || newPassCtrl.text.isEmpty || confirmPassCtrl.text.isEmpty) {
      Get.snackbar('Required', 'All fields are required',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (newPassCtrl.text != confirmPassCtrl.text) {
      Get.snackbar('Error', 'New passwords do not match',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      Map<String, dynamic> body = {
        "old_password": oldPassCtrl.text.trim(),
        "new_password": newPassCtrl.text.trim(),
        "confirm_password": confirmPassCtrl.text.trim(),
      };

      await _authRepo.changePassword(body);
      Get.back();
      oldPassCtrl.clear();
      newPassCtrl.clear();
      confirmPassCtrl.clear();

      Get.snackbar('Success', 'Password changed successfully',
          backgroundColor: Colors.green, colorText: Colors.white);

    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Delete Account Logic
  Future<void> confirmDelete() async {
    try {
      isLoading.value = true;

      final activeAccount = _box.read('active_account');
      print("DEBUG active_account: $activeAccount");

      final String userId = (activeAccount?['id'] ?? '').toString().trim();
      final String role = (activeAccount?['role'] ?? '').toString();

      if (userId.isEmpty || userId == 'null') {
        throw 'No active account found. Please select an account first.';
      }

      await _authRepo.deleteAccount(userId);

      if (role == 'Parent') {
        await _box.erase();
      } else {
        final List childList = _box.read('child_accounts') ?? [];
        childList.removeWhere(
              (c) => (c['id'] ?? c['pk']).toString() == userId,
        );
        await _box.write('child_accounts', childList);
        await _box.remove('active_account');
      }

      if (Get.isOverlaysOpen) Get.back();
      await Future.delayed(const Duration(milliseconds: 200));
      Get.offAllNamed('/login');

      Get.snackbar(
        'Success',
        'Account deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}