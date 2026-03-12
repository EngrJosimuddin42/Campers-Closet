import 'package:campers_closet/app/constants/app_images.dart';
import 'package:campers_closet/app/constants/app_strings.dart';
import 'package:campers_closet/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/onboarding_model.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  final List<OnboardingModel> pages = [
    OnboardingModel(
      title: AppStrings.onBoarding1title,
      description: AppStrings.onBoarding1description,
      imagePath: AppImages.onboarding1,
    ),
    OnboardingModel(
      title: AppStrings.onBoarding2title,
      description: AppStrings.onBoarding2description,
      imagePath: AppImages.onboarding2,
    ),
    OnboardingModel(
      title: AppStrings.onBoarding3title,
      description: AppStrings.onBoarding3description,
      imagePath: AppImages.onboarding3,
    ),
  ];

  int currentIndex = 0;

  void onPageChanged(int index) {
    currentIndex = index;
    update();
  }

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      GetStorage().write('has_seen_onboarding', true);
      Get.offAllNamed(Routes.WELCOME);
    }
  }

  bool get isLastPage => currentIndex == pages.length - 1;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
