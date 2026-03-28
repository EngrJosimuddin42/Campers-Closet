import 'package:get/get.dart';
import '../controllers/child_signup_controller.dart';

class ChildSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChildSignupController>(
          () => ChildSignupController(),
      fenix: true,
    );
  }
}