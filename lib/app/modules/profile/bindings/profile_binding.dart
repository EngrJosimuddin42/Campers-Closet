import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart'; // পাথটি আপনার প্রোজেক্ট অনুযায়ী চেক করে নিন
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}