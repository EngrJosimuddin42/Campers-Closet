import 'package:campers_closet/app/modules/closet/controllers/closet_controller.dart';
import 'package:campers_closet/app/modules/closet/controllers/item_controller.dart';
import 'package:get/get.dart';

import '../controllers/navbar_controller.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarController>(() => NavbarController());
    Get.lazyPut<ClosetController>(() => ClosetController());
    Get.lazyPut<ItemsController>(() => ItemsController());
  }
}
