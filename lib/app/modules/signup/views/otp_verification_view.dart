import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/constants/app_text_style.dart';
import 'package:campers_closet/app/modules/signup/controllers/otp_verification_controller.dart';
import 'package:campers_closet/app/widgets/custom_button.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpVerificationController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 166.h),
                SvgPicture.asset(AppLogos.applogo, width: 100.w, height: 65.h),
                SizedBox(height: 30.h),
                Text(
                  'Please check your email',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title30_400(
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 6.h),
                Obx(
                  () => Text(
                    'We\'ve sent a code to ${controller.userEmail.value}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title14_500(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Pinput(
                  controller: controller.otpController,
                  length: 4,
                  separatorBuilder: (index) => SizedBox(width: 17.w),
                  defaultPinTheme: PinTheme(
                    width: 40.w,
                    height: 50.h,
                    textStyle: AppTextStyles.title20_500(
                      color: AppColors.primaryText,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.borderColor),
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 40.w,
                    height: 50.h,
                    textStyle: AppTextStyles.title20_500(
                      color: AppColors.primaryText,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.primaryText,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  onChanged: controller.onOtpChanged,
                  onCompleted: (value) {
                    controller.validateAndSubmitOtp();
                  },
                ),
                SizedBox(height: 30.h),
                Obx(
                  () => CustomButton(
                    onTap: controller.isLoadingOtp.value
                        ? null
                        : controller.validateAndSubmitOtp,
                    text: controller.isLoadingOtp.value
                        ? 'Submitting...'
                        : 'Submit Code',
                    fontSize: 18.sp,
                    height: 44.h,
                    radius: 16.r,
                  ),
                ),
                SizedBox(height: 20.h),
                // Timer and Resend code option
                Obx(
                  () => controller.canResend.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Didn\'t receive the code? ',
                              style: AppTextStyles.title12_400(
                                color: AppColors.primaryText,
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.isLoadingOtp.value
                                  ? null
                                  : controller.resendOtp,
                              child: Text(
                                'Resend',
                                style: AppTextStyles.title12_400(
                                  color: AppColors.buttonPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Send code again ',
                              style: AppTextStyles.title12_400(
                                color: AppColors.primaryText,
                              ),
                            ),
                            Text(
                              controller.formattedTime,
                              style: AppTextStyles.title12_400(
                                color: AppColors.buttonPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ).paddingBottom(50.h),
        ),
      ),
    );
  }
}
