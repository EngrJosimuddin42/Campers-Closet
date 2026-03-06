import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/constants/app_sizes.dart';
import 'package:campers_closet/app/constants/app_text_style.dart';
import 'package:campers_closet/app/routes/app_pages.dart';
import 'package:campers_closet/app/widgets/custom_button.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150.h),
              SvgPicture.asset(AppLogos.welcomelogo, width: 134.w, height: 134.h),
              SizedBox(height: 20.h),
              Text(
                'All Packed',
                style: AppTextStyles.title52_700(
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: 13.h),
              Text(
                'Manage packing, closets, and reminders in one place.',
                textAlign: TextAlign.center,
                style: AppTextStyles.title19_300(
                  color: AppColors.secondaryText,
                ),
              ),
              SizedBox(height: 155.h),
              CustomButton(
                onTap: () => Get.toNamed(Routes.SIGNUP),
                text: "Create Account",
              ),
              SizedBox(height: 21.h),
              Row(
                spacing: 16.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I already have an account",
                    style: AppTextStyles.title15_400(
                      color: AppColors.primaryText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.LOGIN),
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: AppColors.buttonPrimaryColor,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ).paddingBottom(60.h),
            ],
          ).paddingHorizontal(AppSizes.defaultPadding.w),
        ),
      ),
    );
  }
}