import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/modules/closet/controllers/item_controller.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsCtrl = Get.find<ItemsController>();

    return Obx(() {
      final subCategories = itemsCtrl.subCategoryTabs;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Category',
            style: GoogleFonts.inter(
              color: AppColors.secondaryText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8),
          Card(
            child: DropdownFlutter<String>(
              hintText: itemsCtrl.selectedSubCategory.value == 'All'
                  ? 'Select'
                  : itemsCtrl.selectedSubCategory.value,
              items: subCategories,
              onChanged: (value) {
                itemsCtrl.setSubCategory(value ?? 'All');
              },
            ),
          ),
        ],
      ).paddingHorizontal(24).paddingBottom(8.h);
    });
  }
}
