import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/utils/api_constants.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../profile/controllers/profile_controller.dart';

class AccountModel {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final Map<String, dynamic> rawData;

  const AccountModel({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.rawData,
  });
}

class ManageUsersController extends GetxController {
  final _box = GetStorage();
  final ApiService _apiService = ApiService();
  final RxBool isParentLoggedIn = false.obs;
  final RxInt selectedIndex = 0.obs;
  final accounts = <AccountModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginRole();
    fetchAccounts();
  }

  void _checkLoginRole() {
    final box = GetStorage();
    final loginUser = box.read('user_data');
    print('>>> _checkLoginRole called');
    print('>>> loginUser: $loginUser');
    print('>>> role field: ${loginUser?['role']}');
    final String role = (loginUser?['role'] ?? '').toString().toLowerCase();
    isParentLoggedIn.value = role == 'parent';
    print('>>> isParentLoggedIn: ${isParentLoggedIn.value}');
  }

  Future<void> fetchAccounts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _apiService.get(ApiConstants.fetchAccounts);

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          _parseAccounts(responseData['data']);
        } else {
          errorMessage.value = responseData['message'] ?? 'Failed';
        }
      } else {
        _fallbackFromStorage();
      }
    } catch (e) {
      print(">>> Error: $e");
      _fallbackFromStorage();
    } finally {
      isLoading.value = false;
    }
  }

  void _parseAccounts(Map<String, dynamic> data) {
    accounts.clear();

    final p = data['parent'];
    if (p != null && p is Map) {
      accounts.add(AccountModel(
        id: (p['id'] ?? '').toString(),
        name: p['full_name'] ?? 'Parent',
        role: _capitalize(p['role'] ?? 'Parent'),
        avatarUrl: (p['profile_pic'] ?? '').toString(),
        rawData: Map<String, dynamic>.from(p),
      ));
    }

    final childrenList = data['children'];
    if (childrenList != null && childrenList is List) {
      for (var child in childrenList) {
        if (child is Map) {
          accounts.add(AccountModel(
            id: (child['id'] ?? '').toString(),
            name: child['full_name'] ?? 'Child',
            role: _capitalize(child['role'] ?? 'Child'),
            avatarUrl: (child['profile_pic'] ?? '').toString(),
            rawData: Map<String, dynamic>.from(child),
          ));
        }
      }
    }

    _restoreSelectedIndex();
    accounts.refresh();
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().updateAccountsCount(accounts.length);
    }
  }

  void _fallbackFromStorage() {
    accounts.clear();

    final userData = _box.read('user_data');
    if (userData != null && userData is Map) {
      final user = Map<String, dynamic>.from(userData);
      accounts.add(AccountModel(
        id: (user['id'] ?? user['pk'] ?? '').toString(),
        name: (user['full_name'] ?? 'Parent').toString(),
        role: 'Parent',
        avatarUrl: (user['profile_pic'] ?? '').toString(),
        rawData: user,
      ));
    }

    final dynamic rawList = _box.read('child_accounts');
    final List childList = (rawList is List) ? rawList : [];
    for (var child in childList) {
      if (child == null || child is! Map) continue;
      final c = Map<String, dynamic>.from(child);
      accounts.add(AccountModel(
        id: (c['id'] ?? c['pk'] ?? '').toString(),
        name: (c['full_name'] ?? 'Child').toString(),
        role: 'Kid',
        avatarUrl: (c['profile_pic'] ?? '').toString(),
        rawData: c,
      ));
    }

    _restoreSelectedIndex();
    accounts.refresh();
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().updateAccountsCount(accounts.length);
    }
  }

  void _restoreSelectedIndex() {
    final active = _box.read('active_account');
    if (active == null || accounts.isEmpty) {
      selectedIndex.value = 0;
      _saveActiveAccount(0);
      return;
    }

    final savedId = active['id']?.toString();
    final idx = accounts.indexWhere((a) => a.id == savedId);
    selectedIndex.value = idx != -1 ? idx : 0;

    for (int i = 0; i < accounts.length; i++) {
      final old = accounts[i];
      final savedData = _box.read('account_data_${old.id}');
      if (savedData != null) {
        accounts[i] = AccountModel(
          id: old.id,
          name: (savedData['full_name'] ?? old.name).toString(),
          role: old.role,
          avatarUrl: old.avatarUrl,
          rawData: Map<String, dynamic>.from(savedData),
        );
      }
    }
    final selectedAccount = accounts[selectedIndex.value];
    final selectedSavedData = _box.read('account_data_${selectedAccount.id}');
    if (selectedSavedData != null) {
      _box.write('active_user_data', selectedSavedData);
    }
  }

  void selectAccount(int index) {
    if (index >= accounts.length) return;
    selectedIndex.value = index;
    _saveActiveAccount(index);

    final account = accounts[index];

    final savedData = _box.read('account_data_${account.id}');
    final dataToUse = savedData ?? account.rawData;
    _box.write('active_user_data', dataToUse);

    accounts.refresh();

    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().loadUserData();
      Get.find<ProfileController>().updateAccountsCount(accounts.length);
    }
  }

  void refreshSelectedAccount() {
    final activeData = _box.read('active_user_data');
    if (activeData == null || selectedIndex.value >= accounts.length) return;

    final idx = selectedIndex.value;
    final old = accounts[idx];

    accounts[idx] = AccountModel(
      id: old.id,
      name: (activeData['full_name'] ?? old.name).toString(),
      role: old.role,
      avatarUrl: old.avatarUrl,
      rawData: Map<String, dynamic>.from(activeData),
    );

    accounts.refresh();
  }

  void _saveActiveAccount(int index) {
    if (accounts.isEmpty) return;
    final account = accounts[index];
    _box.write('active_account', {
      'id': account.id,
      'name': account.name,
      'role': account.role,
    });
  }

  Future<void> addChildAccount() async {
    final result = await Get.toNamed(Routes.CHILD_SIGNUP);
    if (result == true) {
      await fetchAccounts();
      Get.snackbar(
        'Success',
        'Child account added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}