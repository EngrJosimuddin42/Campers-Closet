import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/constants/app_text_style.dart';
import 'package:campers_closet/app/routes/app_pages.dart';
import 'package:campers_closet/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BackLoginView extends StatelessWidget {
  const BackLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 235.h),
                SvgPicture.asset(AppLogos.applogo, width: 100.w, height: 65.h),
                SizedBox(height: 30.h),
                Text(
                  'Password changed',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title30_400(
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Your password has been changed successfully',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title14_500(
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(height: 50.h),
                CustomButton(
                  onTap: () {
                   FocusManager.instance.primaryFocus?.unfocus();
                  Get.offAllNamed(Routes.LOGIN);
              },
                  text: 'Back to Login',
                  fontSize: 18.sp,
                  height: 44.h,
                  radius: 16.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
