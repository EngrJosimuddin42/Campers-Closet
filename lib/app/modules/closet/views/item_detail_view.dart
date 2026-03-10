import 'package:cached_network_image/cached_network_image.dart';
import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/modules/closet/models/packing_item.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemDetailView extends StatelessWidget {
  final PackingItem item;

  const ItemDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            _backButton(),
            SizedBox(height: 24.h),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      height: 328.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 328.h,
                        color: const Color(0xFFEEF1F8),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: const Color(0xFF1A73E8),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 328.h,
                        color: const Color(0xFFEEF1F8),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 60,
                              color: Color(0xFFB0BAD3),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Image not available',
                              style: TextStyle(
                                color: Color(0xFFB0BAD3),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _CategoryBadge(label: item.category),
                            _CategoryBadge(label: item.subCategory),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          item.name,
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          height: 68.h,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.subCategory.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              Text(
                                item.quantity.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          spacing: 16.w,
                          children: [
                            Expanded(
                              child: _AttributeCell(
                                label: 'SIZE',
                                value: item.size,
                              ),
                            ),
                            Expanded(
                              child: _ColorCell(
                                label: 'COLOR',
                                color: item.dotColor,
                              ),
                            ),
                            Expanded(
                              child: _AttributeCell(
                                label: 'BRAND',
                                value: item.brand,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).paddingHorizontal(24.w),
      ),
    );
  }

  Row _backButton() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, size: 20),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ),
        SizedBox(width: 8.w),
        Text(
          "Back to Items",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}


class _CategoryBadge extends StatelessWidget {
  final String label;
  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}


class _BaseCell extends StatelessWidget {
  final String label;
  final Widget child;
  const _BaseCell({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Color(0xFFF62748E),
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _AttributeCell extends StatelessWidget {
  final String label;
  final String value;
  const _AttributeCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return _BaseCell(
      label: label,
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ColorCell extends StatelessWidget {
  final String label;
  final Color color;
  const _ColorCell({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return _BaseCell(
      label: label,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
