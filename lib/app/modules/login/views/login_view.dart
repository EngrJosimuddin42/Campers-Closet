import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/constants/app_sizes.dart';
import 'package:campers_closet/app/constants/app_text_style.dart';
import 'package:campers_closet/app/modules/login/controllers/login_controller.dart';
import 'package:campers_closet/app/widgets/custom_button.dart';
import 'package:campers_closet/app/widgets/custom_checkbox.dart';
import 'package:campers_closet/app/widgets/labeled_text_field.dart';
import 'package:campers_closet/app/widgets/or_divider.dart';
import 'package:campers_closet/app/widgets/social_button.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 55.h),
              SvgPicture.asset(AppLogos.applogo, width: 100.w, height: 65.h),
              SizedBox(height: 30.h),

              Text(
                "Welcome Back!",
                style: AppTextStyles.title30_400(color: AppColors.primaryText),
              ),

              SizedBox(height: 10.h),

              Text(
                "Login to your account",
                style: AppTextStyles.title12_400(
                  color: AppColors.secondaryText,
                ),
              ),

              SizedBox(height: 40.h),

              /// Email
              LabeledTextField(
                label: "Email",
                controller: controller.emailController,
                prefixIcon: AppLogos.mail,
                hintText: "Enter your email",
                bottomPadding: 20,
                errorMessage: controller.emailError,
              ),

              /// Password
              LabeledTextField(
                label: "Password",
                controller: controller.passwordController,
                prefixIcon: AppLogos.locklogo,
                hintText: "Enter your password",
                isPassword: true,
                textInputAction: TextInputAction.done,
                bottomPadding: 12,
                errorMessage: controller.passwordError,
              ),

              Row(
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: controller.toggleRememberMe,
                      child: Row(
                        children: [
                          CustomCheckbox(value: controller.rememberMe.value),
                          SizedBox(width: 8.w),
                          Text(
                            "Remember me",
                            style: AppTextStyles.title12_400(
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => controller.forgotPassword(),
                    child: Text(
                      "Forgot Password?",
                      style: AppTextStyles.title12_400(
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Obx(
                () => CustomButton(
                  onTap: controller.isLoading.value ? null : controller.login,
                  text: controller.isLoading.value
                      ? 'Signing in...'
                      : 'Sign In',
                  loading: controller.isLoading.value,
                  fontSize: 18.sp,
                  height: 44.h,
                  radius: 16.r,
                ),
              ),

              SizedBox(height: 30.h),
              const OrDivider(),
              SizedBox(height: 25.h),

              const SocialAuthButtons(
                googleIcon: AppLogos.googlelogo,
                appleIcon: AppLogos.applelogo,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.title12_400(
                      color: AppColors.primaryText,
                    ),
                  ),
                  InkWell(
                    onTap: controller.goToSignUp,
                    child: Text(
                      "Sign Up",
                      style: AppTextStyles.title12_400(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ).paddingTop(25.h),
            ],
          ).paddingHorizontal(AppSizes.defaultPadding).paddingBottom(50.h),
        ),
      ),
    );
  }
}
