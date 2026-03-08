import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Date Box
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F4FF),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'JUL',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9810FA),
                          fontWeight: FontWeight.w700,
                          fontSize: 10.sp,
                        ),
                      ),
                      Text(
                        '15',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9810FA),
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summer Camp Starts',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      Text(
                        'Camp Green Lake, TX',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Priority',
                    style: GoogleFonts.inter(
                      color: AppColors.errorColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            // Gradient Button
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: AppColors.buttonPrimaryColor,
              ),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  AppLogos.navcalendar,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(
                  'Open Calendar',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
