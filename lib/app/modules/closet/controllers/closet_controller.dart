import 'package:get/get.dart';

class ClosetController extends GetxController {
  final RxInt selectedTab = 0.obs;
  void changeTab(int i) => selectedTab.value = i;
}
