import 'package:campers_closet/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import 'manage_user_controller.dart';

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
      final activeUserData = _box.read('active_user_data');
      final userData = _box.read('user_data');

      final String userId = (
          activeAccount?['id'] ??
              activeUserData?['id'] ??
              activeUserData?['pk'] ??
              userData?['id'] ??
              userData?['pk'] ??
              ''
      ).toString().trim();

      final String selectedRole = (
          activeAccount?['role'] ??
              activeUserData?['role'] ??
              'Parent'
      ).toString();

      final String loginRole = (userData?['role'] ?? '').toString().toLowerCase();

      if (userId.isEmpty || userId == 'null') {
        throw 'No active account found.';
      }

      final bool isChild = selectedRole.toLowerCase() != 'parent';

      await _authRepo.deleteAccount(userId, isChild: isChild);

      if (!isChild) {

        await _box.erase();
        Get.back();
        await Future.delayed(const Duration(milliseconds: 300));
        Get.offAllNamed('/login');
      } else {
        final List childList = List.from(_box.read('child_accounts') ?? []);
        childList.removeWhere(
              (c) => c != null && (c['id'] ?? c['pk'])?.toString() == userId,
        );
        await _box.write('child_accounts', childList);
        await _box.remove('active_account');
        await _box.remove('active_user_data');

        Get.back(); // dialog close
        await Future.delayed(const Duration(milliseconds: 300));
        Get.back(); // preferences screen close
        await Future.delayed(const Duration(milliseconds: 200));

        if (loginRole == 'child') {
          await _box.erase();
          Get.offAllNamed('/login');
        } else {

          final parentData = _box.read('user_data');
          if (parentData != null) {
            await _box.write('active_user_data', parentData);
          }
          if (Get.isRegistered<ManageUsersController>()) {
            await Get.find<ManageUsersController>().fetchAccounts();
          }
          if (Get.isRegistered<ProfileController>()) {
            Get.find<ProfileController>().loadUserData();
          }
          Get.snackbar(
            'Success', 'Account deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      print("DEBUG error: $e");
      Get.snackbar(
        'Error', e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}