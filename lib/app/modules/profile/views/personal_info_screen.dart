import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/modules/profile/controllers/personal_info_controller.dart';
import 'package:campers_closet/app/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalInfoController ctrl = Get.put(PersonalInfoController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 6.h, 24.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back, size: 22.sp, color: const Color(0xFF1A1A2E)),
                  ),
                  SizedBox(width: 12.w),
                  Text('Personal Info', style: GoogleFonts.sora(fontSize: 22.sp, fontWeight: FontWeight.w700)),
                  const Spacer(),

                  Obx(() => GestureDetector(
                    onTap: ctrl.isLoading.value ? null : () => ctrl.save(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A73E8),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: ctrl.isLoading.value
                          ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('Save', style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.white)),
                    ),
                  )),
                ],
              ),

              SizedBox(height: 30.h),

              LabeledTextField(
                label: 'FULL NAME',
                controller: ctrl.fullNameController,
                prefixIcon: AppLogos.user,
                hintText: 'Enter your full name',
                errorMessage: ctrl.fullNameError,
                textInputAction: TextInputAction.next,
              ),

              LabeledTextField(
                label: 'EMAIL ADDRESS',
                controller: ctrl.emailController,
                prefixIcon: AppLogos.mail,
                hintText: 'Enter your email address',
                errorMessage: ctrl.emailError,
                isEmail: true,
                textInputAction: TextInputAction.next,
                readOnly: true,
              ),

              GestureDetector(
                onTap: () => ctrl.pickDate(context),
                child: AbsorbPointer(
                  child:LabeledTextField(
                    label: 'DATE OF BIRTH',
                    controller: ctrl.dobController,
                    prefixIcon: AppLogos.calendar,
                    hintText: 'DD/MM/YYYY',
                    errorMessage: ctrl.dobError,
                    textInputAction: TextInputAction.done,
                    bottomPadding: 0,
                  )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
