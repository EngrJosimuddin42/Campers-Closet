import 'package:campers_closet/app/modules/calendar/controllers/calendar_controller.dart';
import 'package:campers_closet/app/modules/closet/controllers/closet_controller.dart';
import 'package:campers_closet/app/modules/closet/controllers/item_controller.dart';
import 'package:campers_closet/app/modules/closet/controllers/mylist_controller.dart';
import 'package:campers_closet/app/modules/closet/controllers/tetmplate_controller.dart';
import 'package:campers_closet/app/modules/profile/controllers/manage_user_controller.dart';
import 'package:campers_closet/app/modules/profile/controllers/personal_info_controller.dart';
import 'package:get/get.dart';

import '../controllers/navbar_controller.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarController>(() => NavbarController());
    Get.lazyPut<ClosetController>(() => ClosetController());
    Get.lazyPut<ItemsController>(() => ItemsController());
    Get.lazyPut<MylistController>(() => MylistController());
    Get.lazyPut<TemplateController>(() => TemplateController());
    Get.lazyPut<CalendarController>(() => CalendarController());
    Get.lazyPut<ClosetController>(() => ClosetController());
    Get.lazyPut<ItemsController>(() => ItemsController());
    Get.lazyPut<MylistController>(() => MylistController());
    Get.lazyPut<TemplateController>(() => TemplateController());
    Get.lazyPut<PersonalInfoController>(() => PersonalInfoController());
    Get.lazyPut<ManageUsersController>(() => ManageUsersController());
  }
}
