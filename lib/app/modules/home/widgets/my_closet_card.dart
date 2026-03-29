import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../navbar/controllers/navbar_controller.dart';

class MyClosetCard extends StatelessWidget {
  const MyClosetCard({super.key});

  IconData _getIcon(String code) {
    switch (code) {
      case 'cloth': return Icons.checkroom_outlined;
      case 'toiletries': return Icons.soap_outlined;
      case 'gear': return Icons.backpack_outlined;
      default: return Icons.category_outlined;
    }
  }

  Color _getColor(String code) {
    switch (code) {
      case 'cloth': return AppColors.buttonPrimaryColor;
      case 'toiletries': return const Color(0xFF9810FA);
      case 'gear': return const Color(0xFFEC003F);
      default: return Colors.grey;
    }
  }

  String _getSvgIcon(String code) {
    switch (code) {
      case 'cloth': return AppLogos.clothes;
      case 'toiletries': return AppLogos.toiletries;
      case 'gear': return AppLogos.gear;
      default: return AppLogos.clothes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Closet',
                style: GoogleFonts.sora(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText)),
            SizedBox(height: 24.h),

            //  Total items
            Obx(() => Text(
              ctrl.totalItems.value.toString(),
              style: GoogleFonts.sora(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText),
            )),
            SizedBox(height: 4.h),
            Text('items saved',
                style: GoogleFonts.inter(
                    fontSize: 16.sp, color: AppColors.secondaryText)),
            SizedBox(height: 24.h),

            //  Category list
            Obx(() {
              if (ctrl.isClosetLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (ctrl.categoryStats.isEmpty) {
                return Text('No categories found',
                    style: GoogleFonts.inter(color: AppColors.secondaryText));
              }
              return Column(
                children: ctrl.categoryStats.map((cat) {
                  final code = cat['code'] ?? '';
                  return _buildCategoryItem(
                    _getSvgIcon(code),
                    cat['name'] ?? '',
                    (cat['item_count'] ?? 0).toString(),
                    _getColor(code),
                  );
                }).toList(),
              );
            }),

            SizedBox(height: 24.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.find<NavbarController>().changeTab(1);
                    },

                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: const BorderSide(color: Color(0xFFDBEBFF)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r)),
                    ),
                    child: Text('View All Clothes',
                        style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.buttonPrimaryColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.find<NavbarController>().onScanPressed();
                      },

                      icon: SvgPicture.asset(AppLogos.camera,
                          width: 22,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn)),
                      label: Text('Scan Item',
                          style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
      String icon, String label, String count, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: color.withValues(alpha: 0.15),
            child: SvgPicture.asset(icon,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
          ),
          SizedBox(width: 16.w),
          Text(label,
              style: GoogleFonts.sora(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText)),
          const Spacer(),
          Text(count,
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText)),
        ],
      ),
    );
  }
}