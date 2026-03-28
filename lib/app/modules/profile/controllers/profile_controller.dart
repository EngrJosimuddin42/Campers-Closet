import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../login/controllers/login_controller.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepo = Get.isRegistered<AuthRepository>()
      ? Get.find<AuthRepository>()
      : Get.put(AuthRepository());

  var userData = {}.obs;
  var isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
    loadUserData();
  }

  // accounts count — storage থেকে
  int get accountsCount {
    final box = GetStorage();
    final List childList = box.read('child_accounts') ?? [];
    return 1 + childList.length;
  }

  void loadUserData() {
    final box = GetStorage();
    final storedData = box.read('user_data');

    if (storedData != null) {
      userData.value = storedData;
      print("Profile Loaded: ${userData.value['full_name']}");
    } else {
      print("No data found in GetStorage for 'user_data'");
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
        final response = await _authRepo.updateProfile(
          imagePath: image.path,
        );

        print("Update Profile Response: $response");

        if (response['success'] == true) {
          final updatedUser = response['data'];
          final box = GetStorage();
          await box.write('user_data', updatedUser);
          userData.value = Map<String, dynamic>.from(updatedUser);
          userData.refresh();

          Get.snackbar("Success", "Profile updated successfully!");
        } else {
          Get.snackbar("Error", response['message'] ?? "Update failed");
        }
      }
    } catch (e) {
      print("Upload error: $e");
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
        decoration: const InputDecoration(
          hintText: "Enter your name",
        ),
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

      final response = await _authRepo.updateProfile(
        fullName: name,
      );

      if (response['success'] == true) {
        final updatedUser = response['data'];
        if (updatedUser != null) {
          userData.value = Map<String, dynamic>.from(updatedUser);
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
      print("Token refreshed before logout");

      await _authRepo.logout();
      print("Logout successful");

    } catch (e) {

      print("Logout error (ignored): $e");
    } finally {

      await box.erase();
      print("Local storage cleared");

      if (Get.isRegistered<LoginController>()) {
        Get.delete<LoginController>(force: true);
      }

      Get.offAllNamed('/login');
    }
  }
}