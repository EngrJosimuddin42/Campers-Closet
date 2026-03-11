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
    final ctrl = Get.find<PersonalInfoController>();

    ctrl.fullNameController.text = 'Heather';
    ctrl.emailController.text = 'heather.parent@example.com';
    ctrl.dobController.text = '22/12/2026';

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
                    child: Icon(
                      Icons.arrow_back,
                      size: 22.sp,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Accounts',
                    style: GoogleFonts.sora(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              // ── Full Name
              LabeledTextField(
                label: 'FULL NAME',
                controller: ctrl.fullNameController,
                prefixIcon: AppLogos.person,
                hintText: 'Enter your full name',
                errorMessage: ctrl.fullNameError,
                textInputAction: TextInputAction.next,
              ),

              // ── Email Address
              LabeledTextField(
                label: 'EMAIL ADDRESS',
                controller: ctrl.emailController,
                prefixIcon: AppLogos.mail,
                hintText: 'Enter your email address',
                errorMessage: ctrl.emailError,
                isEmail: true,
                textInputAction: TextInputAction.next,
              ),

              GestureDetector(
                onTap: () => ctrl.pickDate(context),
                child: AbsorbPointer(
                  child: LabeledTextField(
                    label: 'DATE OF BIRTH',
                    controller: ctrl.dobController,
                    prefixIcon: AppLogos.calendar,
                    hintText: 'DD/MM/YYYY',
                    errorMessage: ctrl.dobError,
                    textInputAction: TextInputAction.done,
                    bottomPadding: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
