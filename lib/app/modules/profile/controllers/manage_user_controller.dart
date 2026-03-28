import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/utils/api_constants.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class AccountModel {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;

  const AccountModel({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
  });
}

class ManageUsersController extends GetxController {
  final _box = GetStorage();

  final ApiService _apiService = ApiService();
  final RxInt selectedIndex = 0.obs;
  final accounts = <AccountModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  bool childAddedSuccessfully = false;

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }


  Future<void> fetchAccounts() async {
    print('Fetching accounts...');
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _apiService.get(
        ApiConstants.fetchAccounts,
      );
      try{
        // Accurate way to fetch first child's email
        response.statusCode;
        print('first child email: ${response.data['data']['children'][0]['email']}');
        print(response.data['message']);
      }catch(e){
        print('error in first child email: $e');
      }


      print(">>> Status: ${response.statusCode}");
      print(">>> data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data;

        if (responseData['success'] == true) {

          _parseAccounts(responseData['data']);
        } else {
          errorMessage.value = responseData['message'] ?? 'Failed';
        }
      } else {
        _fallbackFromStorage();
      }
    } catch (e) {
      print(">>> Error logic: $e");
      _fallbackFromStorage();
    } finally {
      isLoading.value = false;
    }
  }



  void _parseAccounts(Map<String, dynamic> data) {
    accounts.clear();

    // Parent section
    var p = data['parent'];

    if (p != null && p is Map) {
      accounts.add(AccountModel(
        id: (p['id'] ?? '').toString(),
        name: p['full_name'] ?? 'Parent',
        role: _capitalize(p['role'] ?? 'Parent'),
        avatarUrl: (p['profile_pic'] ?? '').toString(),
      ));
    }

    // Children section
    var childrenList = data['children'];
    if (childrenList != null && childrenList is List) {
      for (var child in childrenList) {
        if (child is Map) {
          accounts.add(AccountModel(
            id: (child['id'] ?? '').toString(),
            name: child['full_name'] ?? 'Child',
            role: _capitalize(child['role'] ?? 'Child'),
            avatarUrl: (child['profile_pic'] ?? '').toString(),
          ));
        }
      }
    }
    print('finally printing accounts:\n\n$accounts\n\n\n');

    accounts.refresh();
  }



  void _fallbackFromStorage() {
    accounts.clear();

    final userData = _box.read('user_data');
    if (userData != null && userData is Map) {
      final Map<String, dynamic> user = Map<String, dynamic>.from(userData);
      accounts.add(AccountModel(
        id: (user['id'] ?? user['pk'] ?? '').toString(),
        name: (user['full_name'] ?? 'Parent').toString(),
        role: 'Parent',
        avatarUrl: (user['profile_pic'] ?? '').toString(),
      ));
    }

    final dynamic rawList = _box.read('child_accounts');
    final List childList = (rawList is List) ? rawList : [];

    for (var child in childList) {
      if (child == null || child is! Map) continue;
      final Map<String, dynamic> c = Map<String, dynamic>.from(child);
      accounts.add(AccountModel(
        id: (c['id'] ?? c['pk'] ?? '').toString(),
        name: (c['full_name'] ?? 'Child').toString(),
        role: 'Kid',
        avatarUrl: (c['profile_pic'] ?? '').toString(),
      ));
    }

    if (accounts.isNotEmpty) _saveActiveAccount(0);
    accounts.refresh();
  }

  void selectAccount(int index) {
    selectedIndex.value = index;
    _saveActiveAccount(index);
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