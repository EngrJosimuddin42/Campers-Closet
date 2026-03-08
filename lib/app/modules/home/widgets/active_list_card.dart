import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ActiveListCard extends StatelessWidget {
  const ActiveListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.r),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
            colors: [
              AppColors.primaryText,
              AppColors.primaryText,
              AppColors.buttonPrimaryColor,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIVE LIST',
                        style: GoogleFonts.sora(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: const Color(0xFF51A2FF),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Summer Camp – July',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sora(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Circular Icon Button
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppLogos.list,
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: GoogleFonts.sora(color: Colors.white, fontSize: 14.sp),
                ),
                Text(
                  '18 / 32 items',
                  style: GoogleFonts.sora(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: 18 / 32,
                minHeight: 8.h,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.buttonPrimaryColor,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // White Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryText,
                minimumSize: Size(double.infinity, 44.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue Packing',
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  const Icon(
                    Icons.arrow_forward,
                    size: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
