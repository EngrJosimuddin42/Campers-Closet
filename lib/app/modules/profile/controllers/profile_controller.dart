import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/manage_user_controller.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepo = Get.isRegistered<AuthRepository>()
      ? Get.find<AuthRepository>()
      : Get.put(AuthRepository());

  var userData = {}.obs;
  var isLoading = false.obs;
  final RxInt accountsCount = 1.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    final mc = Get.isRegistered<ManageUsersController>()
        ? Get.find<ManageUsersController>()
        : Get.put(ManageUsersController(), permanent: true);
    ever(mc.accounts, (_) {
      updateAccountsCount(mc.accounts.length);
    });
  }

  void loadUserData() {
    final box = GetStorage();
    final loginUser = box.read('user_data');
    print('>>> loadUserData called');
    print('>>> user_data: $loginUser');
    print('>>> role: ${loginUser?['role']}');

    final activeAccount = box.read('active_account');
    if (activeAccount == null) {
      box.remove('active_user_data');
    }

    final activeData = box.read('active_user_data');
    final storedData = activeData ?? loginUser;

    if (storedData != null) {
      userData.value = Map<String, dynamic>.from(storedData);
    }

    final String loginRole = (loginUser?['role'] ?? '').toString().toLowerCase();

    if (loginRole == 'parent') {
      if (Get.isRegistered<ManageUsersController>()) {
        accountsCount.value = Get.find<ManageUsersController>().accounts.length;
      } else {
        accountsCount.value = 1;
      }
    } else {
      accountsCount.value = 1;
    }
  }

  void updateAccountsCount(int count) {
    final box = GetStorage();
    final loginUser = box.read('user_data');
    final String loginRole = (loginUser?['role'] ?? '').toString().toLowerCase();

    if (loginRole == 'parent') {
      accountsCount.value = count;
    } else {
      accountsCount.value = 1;
    }
  }

  Future<void> uploadProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (image != null) {
        isLoading.value = true;

        final box = GetStorage();
        final activeData = box.read('active_user_data');
        final String? childId = activeData != null
            ? (activeData['id'] ?? activeData['pk'])?.toString()
            : null;

        final response = await _authRepo.updateProfile(
          imagePath: image.path,
          childId: childId,
        );

        if (response['success'] == true) {
          final updatedUser = response['data'];
          if (activeData != null) {
            // child
            final updated = {
              ...Map<String, dynamic>.from(activeData),
              ...Map<String, dynamic>.from(updatedUser ?? {}),
            };
            await box.write('active_user_data', updated);
            if (childId != null) await box.write('account_data_$childId', updated);
          } else {
            // parent
            await box.write('user_data', updatedUser);
          }
          userData.value = Map<String, dynamic>.from(updatedUser ?? {});
          userData.refresh();
          Get.snackbar("Success", "Profile updated successfully!");
        } else {
          Get.snackbar("Error", response['message'] ?? "Update failed");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image: $e");
    } finally {
      isLoading.value = false;
    }
  }


  void openEditNameDialog() {
    final TextEditingController nameController =
    TextEditingController(text: userData['full_name'] ?? '');

    Get.defaultDialog(
      title: "Edit Name",
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(hintText: "Enter your name"),
      ),
      textConfirm: "Update",
      textCancel: "Cancel",
      onConfirm: () async {
        String newName = nameController.text.trim();
        if (newName.isEmpty) return;
        Get.back();
        await updateName(newName);
      },
    );
  }


  Future<void> updateName(String name) async {
    try {
      isLoading.value = true;

      final box = GetStorage();
      final activeData = box.read('active_user_data');
      final String? childId = activeData != null
          ? (activeData['id'] ?? activeData['pk'])?.toString()
          : null;

      final response = await _authRepo.updateProfile(
        fullName: name,
        childId: childId,
      );

      if (response['success'] == true) {
        final updatedUser = response['data'];
        if (updatedUser != null) {
          if (activeData != null) {
            // child
            final updated = {
              ...Map<String, dynamic>.from(activeData),
              'full_name': name,
            };
            await box.write('active_user_data', updated);
            if (childId != null) await box.write('account_data_$childId', updated);
          } else {
            // parent
            await box.write('user_data', updatedUser);
            final accountId = (updatedUser['id'] ?? updatedUser['pk'])?.toString();
            if (accountId != null) await box.write('account_data_$accountId', updatedUser);
          }

          userData.value = Map<String, dynamic>.from(
            activeData != null
                ? {...Map<String, dynamic>.from(activeData), 'full_name': name}
                : updatedUser,
          );

          if (Get.isRegistered<ManageUsersController>()) {
            Get.find<ManageUsersController>().refreshSelectedAccount();
          }
        }
        Get.snackbar("Success", "Name updated successfully");
      } else {
        Get.snackbar("Error", response['message'] ?? "Update failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    final box = GetStorage();
    try {
      await _authRepo.refreshToken();
      await _authRepo.logout();
    } catch (e) {
      print("Logout error (ignored): $e");
    } finally {
      await box.erase(); // ✅ সব data clear — next login এ fresh start
      print("Local storage cleared");

      if (Get.isRegistered<LoginController>()) {
        Get.delete<LoginController>(force: true);
      }
      Get.offAllNamed('/login');
    }
  }
}