import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/dashboard_repository.dart';

class HomeController extends GetxController {
  final NotificationRepository _notifRepo = NotificationRepository();
  final DashboardRepository _dashRepo = DashboardRepository();

  final RxInt unreadNotificationCount = 0.obs;
  final RxInt totalItems = 0.obs;
  final RxList<Map<String, dynamic>> categoryStats = <Map<String, dynamic>>[].obs;
  final RxBool isClosetLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUnreadNotificationCount();
    fetchClosetStats();
  }

  String get greetingMessage {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get userName {
    final box = GetStorage();
    final activeData = box.read('active_user_data');
    final userData = box.read('user_data');
    final data = activeData ?? userData;
    final fullName = (data?['full_name'] ?? '').toString();
    return fullName.split(' ').first;
  }

  Future<void> fetchUnreadNotificationCount() async {
    try {
      final response = await _notifRepo.getNotifications();
      if (response['success'] == true) {
        final data = response['data'];
        final List raw = (data is List) ? data : (data['results'] ?? []);
        unreadNotificationCount.value =
            raw.where((n) => n['is_read'] == false).length;
      }
    } catch (e) {
      print('❌ Failed to load notification count: $e');
      unreadNotificationCount.value = 0;
    }
  }

  Future<void> fetchClosetStats() async {
    try {
      isClosetLoading.value = true;
      final response = await _dashRepo.getClosetStats();
      if (response['success'] == true) {
        final data = response['data'];
        totalItems.value = data['total_items'] ?? 0;
        final List raw = data['brand_category_stats'] ?? [];
        categoryStats.value =
            raw.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      print('❌ Failed to load closet stats: $e');
    } finally {
      isClosetLoading.value = false;
    }
  }

  void refreshNotificationCount() {
    fetchUnreadNotificationCount();
  }

  void refreshClosetStats() {
    fetchClosetStats();
  }
}