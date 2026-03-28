import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/constants/app_sizes.dart';
import 'package:campers_closet/app/constants/app_text_style.dart';
import 'package:campers_closet/app/modules/signup/widgets/labeled_date_picker.dart';
import 'package:campers_closet/app/widgets/custom_button.dart';
import 'package:campers_closet/app/widgets/custom_checkbox.dart';
import 'package:campers_closet/app/widgets/labeled_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:exui/exui.dart';
import '../controllers/child_signup_controller.dart';

class ChildSignupView extends StatelessWidget {
  const ChildSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChildSignupController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),

              Text(
                "Add kid account",
                style: AppTextStyles.title30_400(color: AppColors.primaryText),
              ),
              Text(
                "Please fill up your Information",
                style: AppTextStyles.title15_300(color: AppColors.secondaryText),
              ),
              SizedBox(height: 20.h),

              // Name
              LabeledTextField(
                label: "Name",
                controller: controller.fullNameController,
                prefixIcon: AppLogos.person,
                hintText: "Enter Full Name",
                errorMessage: controller.fullNameError,
              ),

              // Email
              LabeledTextField(
                label: "Email",
                controller: controller.emailController,
                prefixIcon: AppLogos.mail,
                hintText: "Enter Email Address",
                isEmail: true,
                errorMessage: controller.emailError,
              ),

              // Date of Birth
              LabeledDatePicker(
                label: "Date of Birth",
                controller: controller.dobController,
                prefixIcon: AppLogos.calendar,
                hintText: "DD/MM/YY",
                errorMessage: controller.dobError,
              ),

              // Password
              LabeledTextField(
                label: "Password",
                controller: controller.passwordController,
                prefixIcon: AppLogos.locklogo,
                hintText: "Enter Your Password",
                isPassword: true,
                errorMessage: controller.passwordError,
              ),

              // Confirm Password
              LabeledTextField(
                label: "Confirm Password",
                controller: controller.confirmPasswordController,
                prefixIcon: AppLogos.locklogo,
                hintText: "Confirm Your Password",
                isPassword: true,
                textInputAction: TextInputAction.done,
                errorMessage: controller.confirmPasswordError,
              ),

              _termsAndPolicy(controller).paddingBottom(30.h),

              Obx(() => CustomButton(
                onTap: controller.validateAndAdd,
                text: controller.isLoading.value ? 'Adding...' : 'Add',
                loading: controller.isLoading.value,
                fontSize: 18.sp,
                height: 44.h,
                radius: 16.r,
              )),

              SizedBox(height: 30.h),
            ],
          ).paddingHorizontal(AppSizes.defaultPadding),
        ),
      ),
    );
  }

  Widget _termsAndPolicy(ChildSignupController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => InkWell(
          onTap: () => controller.toggleTerms(),
          child: CustomCheckbox(value: controller.acceptedTerms.value),
        )),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.sora(
                color: AppColors.primaryText,
                fontSize: 12.sp,
              ),
              children: [
                const TextSpan(text: "I agree with "),
                TextSpan(
                  text: "terms & conditions ",
                  style: GoogleFonts.sora(
                    color: AppColors.buttonPrimaryColor,
                    fontSize: 12.sp,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: "and "),
                TextSpan(
                  text: "privacy policy",
                  style: GoogleFonts.sora(
                    color: AppColors.buttonPrimaryColor,
                    fontSize: 12.sp,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}