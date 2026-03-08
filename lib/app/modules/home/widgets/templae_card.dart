import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TemplateCard extends StatelessWidget {
  final String title;
  final int itemCount;
  final String imageUrl;

  const TemplateCard({
    super.key,
    required this.title,
    required this.itemCount,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.r),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 116.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '~$itemCount items',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Text and Button Section
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7F9FC),
                        foregroundColor: AppColors.primaryText,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        'USE TEMPLATE',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
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
