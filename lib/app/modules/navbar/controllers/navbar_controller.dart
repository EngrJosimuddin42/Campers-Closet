import 'package:campers_closet/app/modules/scanner/views/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  final RxInt selectedTab = 0.obs;

  final homeNavKey = GlobalKey<NavigatorState>();
  final closetNavKey = GlobalKey<NavigatorState>();
  final calendarNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();

  late final List<GlobalKey<NavigatorState>> navKeys;

  @override
  void onInit() {
    super.onInit();
    navKeys = [homeNavKey, closetNavKey, calendarNavKey, profileNavKey];
  }

  /// 0=Home  1=Closet  2=Calendar  3=Profile
  void changeTab(int index) {
    if (index == selectedTab.value) {
      navKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      selectedTab.value = index;
    }
  }

  void onScanPressed() {
    Get.to(
      () => const ScannerView(),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 300),
    );
  }

  bool handleBackPress() {
    final currentKey = navKeys[selectedTab.value];
    if (currentKey.currentState?.canPop() ?? false) {
      currentKey.currentState?.pop();
      return false;
    }
    return true;
  }
}
