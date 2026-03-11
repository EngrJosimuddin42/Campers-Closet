// scan_result_screen.dart
import 'dart:io';

import 'package:campers_closet/app/modules/scanner/controllers/scan_result_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanResultScreen extends StatelessWidget {
  final String? imagePath;
  const ScanResultScreen({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ScanResultController(imagePath: imagePath));
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 22.sp,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Result card
                    Container(
                      padding: EdgeInsets.all(16.w),
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
                              // Image
                              Container(
                                width: 90.w,
                                height: 90.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F0FF),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14.r),
                                  child:
                                      ctrl.imagePath != null &&
                                          ctrl.imagePath!.isNotEmpty
                                      ? Image.file(
                                          File(
                                            ctrl.imagePath!,
                                          ), 
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.image_outlined,
                                          color: const Color(0xFF2B7FFF),
                                          size: 36.sp,
                                        ),
                                ),
                              ),

                              SizedBox(width: 14.w),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // AI Match badge
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.auto_awesome,
                                          color: const Color(0xFF2B7FFF),
                                          size: 13.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Obx(
                                          () => Text(
                                            'AI MATCH (${ctrl.aiMatchPercent.value}%)',
                                            style: GoogleFonts.inter(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF2B7FFF),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.h),

                                    // Editable name
                                    TextField(
                                      controller: ctrl.nameController,
                                      style: GoogleFonts.sora(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1A2E),
                                      ),
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10.h),

                          // Retake
                          GestureDetector(
                            onTap: ctrl.retake,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 14.sp,
                                  color: const Color(0xFF90A1B9),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'RETAKE',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    color: const Color(0xFF90A1B9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Category
                    const _SectionLabel('CATEGORY'),
                    SizedBox(height: 10.h),
                    Obx(
                      () => Row(
                        children: ctrl.categories
                            .map(
                              (cat) => Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: GestureDetector(
                                  onTap: () => ctrl.selectCategory(cat),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 18.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ctrl.selectedCategory.value == cat
                                          ? const Color(0xFF1A1A2E)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color:
                                            ctrl.selectedCategory.value == cat
                                            ? const Color(0xFF1A1A2E)
                                            : const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                    child: Text(
                                      cat,
                                      style: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            ctrl.selectedCategory.value == cat
                                            ? Colors.white
                                            : const Color(0xFF90A1B9),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Quantity
                    const _SectionLabel('QUANTITY'),
                    SizedBox(height: 10.h),
                    Obx(
                      () => Row(
                        children: [
                          _QtyButton(
                            icon: Icons.remove,
                            onTap: ctrl.decrementQty,
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            '${ctrl.quantity.value}',
                            style: GoogleFonts.sora(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          _QtyButton(
                            icon: Icons.add,
                            onTap: ctrl.incrementQty,
                            isAdd: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Size / Color / Brand row
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _DetailField(
                            label: 'SIZE',
                            child: TextField(
                              controller: ctrl.sizeController,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sora(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1A2E),
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          _VerticalDivider(),
                          _DetailField(
                            label: 'COLOR',
                            child: Obx(
                              () => Container(
                                width: 22.w,
                                height: 22.w,
                                decoration: BoxDecoration(
                                  color: _hexToColor(ctrl.color.value),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          _VerticalDivider(),
                          _DetailField(
                            label: 'BRAND',
                            child: TextField(
                              controller: ctrl.brandController,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Notes section
                    const _SectionLabel('NOTES'),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: ctrl.notesController,
                        maxLines: 4,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: const Color(0xFF1A1A2E),
                          height: 1.6,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Add any extra details — condition, where you bought it, special instructions...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: const Color(0xFFCBD5E1),
                            height: 1.6,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              color: const Color(0xFFF7F7F7),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: ctrl.addToCloset,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B7FFF),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Add To Closet',
                            style: GoogleFonts.sora(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'This item will be saved to your private inventory.',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF90A1B9),
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

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.blue;
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: const Color(0xFF90A1B9),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isAdd;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: isAdd ? const Color(0xFF2B7FFF) : const Color(0xFFF1F5F9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: isAdd ? Colors.white : const Color(0xFF1A1A2E),
        ),
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final Widget child;

  const _DetailField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: const Color(0xFF90A1B9),
            ),
          ),
          SizedBox(height: 6.h),
          child,
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40.h,
      color: const Color(0xFFF1F5F9),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
    );
  }
}
