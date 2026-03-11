import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/modules/closet/controllers/mylist_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyListView extends StatelessWidget {
  const MyListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MylistController>();

    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Row(
              children: [
                _StatCard(
                  count: ctrl.activeLists.length,
                  label: 'ACTIVE',
                  color: const Color(0xFF009966),
                ),
                SizedBox(width: 10.w),
                _StatCard(
                  count: ctrl.completedLists.length,
                  label: 'COMPLETED',
                  color: AppColors.buttonPrimaryColor,
                ),
                SizedBox(width: 10.w),
                _StatCard(
                  count: ctrl.pastLists.length,
                  label: 'PAST',
                  color: AppColors.secondaryText,
                  muted: true,
                ),
              ],
            ),
            SizedBox(height: 24.h),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Packing Lists',
                          style: GoogleFonts.sora(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        GestureDetector(
                          onTap: ctrl.createNew,
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                size: 16.sp,
                                color: const Color(0xFF2B7FFF),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Create New',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2B7FFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    ...ctrl.allLists.map(
                      (list) => _PackingListCard(list: list),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final bool muted;

  const _StatCard({
    required this.count,
    required this.label,
    required this.color,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: muted
              ? const Color(0xFFF7F7F7)
              : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 1), width: 1),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: GoogleFonts.sora(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final bool withIcon;

  const _Tag({required this.label, required this.color, this.withIcon = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (withIcon) ...[
            Icon(Icons.check_circle_outline, size: 11.sp, color: color),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PackingListCard extends StatelessWidget {
  final PackingListModel list;
  const _PackingListCard({required this.list});

  // 👇 Map replaces switch — same result, less boilerplate
  static const _categoryColors = {
    'CAMP': Color(0xFF22C55E),
    'TRAVEL': Color(0xFF7C3AED),
  };
  static const _defaultCategoryColor = Color(0xFF2B7FFF);

  Color get _categoryColor =>
      _categoryColors[list.category] ?? _defaultCategoryColor;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${DateFormat('MMM d').format(list.startDate)} - ${DateFormat('MMM d').format(list.endDate)}';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Tag(label: list.category, color: _categoryColor),
                if (list.isCompleted) ...[
                  SizedBox(width: 6.w),
                  const _Tag(
                    label: 'COMPLETE',
                    color: Color(0xFF2B7FFF),
                    withIcon: true,
                  ),
                ],
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'DATES',
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: const Color(0xFF90A1B9),
                      ),
                    ),
                    Text(
                      dateStr,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              list.title,
              style: GoogleFonts.sora(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              list.location,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: const Color(0xFF90A1B9),
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF90A1B9),
                  ),
                ),
                Text(
                  '${list.packedItems} / ${list.totalItems} items',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: LinearProgressIndicator(
                value: list.progress,
                minHeight: 6.h,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(
                  list.isCompleted
                      ? const Color(0xFF2B7FFF)
                      : const Color(0xFF22C55E),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      list.isCompleted ? 'View Details' : 'Continue Packing',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 16.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
