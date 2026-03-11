import 'package:campers_closet/app/modules/signup/controllers/otp_verification_controller.dart';
import 'package:get/get.dart';

import '../controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
    Get.lazyPut<OtpVerificationController>(() => OtpVerificationController());
  }
}
