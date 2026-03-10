import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/modules/closet/controllers/item_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBar extends StatelessWidget {
  final ItemsController ctrl;
  const FilterBar({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tabs = ctrl.filterTabs;
      return SizedBox(
        height: 32.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(tabs.length, (i) {
              final tab = tabs[i];
              final count = ctrl.countFor(tab);
              return Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 10.w),
                child: Obx(() {
                  final active = ctrl.selectedFilter.value == tab;
                  return GestureDetector(
                    onTap: () => ctrl.setFilter(tab),
                    child: InnerShadow(
                      shadows: [
                        Shadow(
                          color: AppColors.successColor.withValues(alpha: 0.4),
                          blurRadius: 15.r,
                        ),
                      ],
                      child: AnimatedContainer(
                        height: 32.h,
                        constraints: BoxConstraints(minWidth: 24.w),
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: active ? AppColors.successColor : Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$tab ($count)",
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: active
                                    ? Colors.white
                                    : AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      );
    });
  }
}
