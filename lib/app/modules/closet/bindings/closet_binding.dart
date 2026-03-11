import 'package:campers_closet/app/modules/closet/controllers/mylist_controller.dart';
import 'package:get/get.dart';
import '../controllers/closet_controller.dart';

class ClosetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MylistController>(() => MylistController());
    Get.lazyPut<ClosetController>(() => ClosetController());
  }
}
