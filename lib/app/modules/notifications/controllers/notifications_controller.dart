import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  final NotificationRepository _repo = NotificationRepository();

  final notifications = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final selectedFilterIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _repo.getNotifications();
      if (response['success'] == true) {
        final data = response['data'];
        final List raw = (data is List) ? data : (data['results'] ?? []);
        notifications.value = raw
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repo.markAllAsRead();
      notifications.value = notifications
          .map((n) => {...n, 'is_read': true})
          .toList();
      notifications.refresh();
    } catch (e) {
      notifications.value = notifications
          .map((n) => {...n, 'is_read': true})
          .toList();
      notifications.refresh();
    }
  }

  Future<void> markAsRead(String pk) async {
    try {
      await _repo.markAsRead(pk);
      final idx = notifications.indexWhere((n) => n['id'].toString() == pk);
      if (idx != -1) {
        notifications[idx] = {
          ...notifications[idx],
          'is_read': true,
        };
        notifications.refresh();
      }
    } catch (e) {
      final idx = notifications.indexWhere((n) => n['id'].toString() == pk);
      if (idx != -1) {
        notifications[idx] = {
          ...notifications[idx],
          'is_read': true,
        };
        notifications.refresh();
      }
    }
  }

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilterIndex.value == 1) {
      return notifications.where((n) => n['is_read'] == false).toList();
    }
    return notifications;
  }

  int get unreadCount =>
      notifications.where((n) => n['is_read'] == false).length;
}