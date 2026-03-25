import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt unreadNotificationCount = 0.obs;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUnreadNotificationCount();
  }

  Future<void> fetchUnreadNotificationCount() async {
    try {

      unreadNotificationCount.value = 2;
    } catch (e) {
      print('❌ Failed to load notification count: $e');
      unreadNotificationCount.value = 0;
    }
  }
  void increment() => count.value++;

  void refreshNotificationCount() {
    fetchUnreadNotificationCount();
  }
}