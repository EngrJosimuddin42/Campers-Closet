import 'package:cached_network_image/cached_network_image.dart';
import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/modules/closet/models/packing_item.dart';
import 'package:campers_closet/app/widgets/custom_button.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          color: Colors.white,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[50],
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                    ),
                    SizedBox(height: 20.h),
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Usage & History',
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              'Used In',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: AppColors.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10.h),

                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: item.usedIn
                                  .map((trip) => _TripChip(label: trip))
                                  .toList(),
                            ),

                            SizedBox(height: 16.h),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 20,
                                    color: AppColors.secondaryText,
                                  ),
                                  SizedBox(width: 12.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Used',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          color: AppColors.secondaryText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        item.lastUsed,
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryText,
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
                    ),
                    SizedBox(height: 24.h),

                    CustomButton(
                      onTap: () {},
                      text: 'Shop Similar Item',
                      height: 52.h,
                      textStyle: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      svgIcon: AppLogos.shop,
                    ),
                    SizedBox(height: 12.h),
                    CustomButton(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24.r),
                            ),
                          ),
                          builder: (context) => _AddToPackingListSheet(),
                        );
                      },
                      text: 'Add to Packing List',
                      height: 52.h,
                      textStyle: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                      svgIcon: AppLogos.addList,
                      color: Colors.white,
                      logoColor: AppColors.primaryText,
                    ),
                    SizedBox(height: 24.h),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            _ActionRow(
                              svgIcon: AppLogos.edit,
                              label: 'Edit Item Details',
                              onTap: () {},
                            ),
                            _ActionRow(
                              svgIcon: AppLogos.trash,
                              label: 'Delete Item',
                              color: const Color(0xFFE53935),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ).paddingBottom(50.h),
                  ],
                ),
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

class _TripChip extends StatelessWidget {
  final String label;
  const _TripChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDCEAFD),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A73E8),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String svgIcon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionRow({
    required this.svgIcon,
    required this.label,
    required this.onTap,
    this.color = const Color(0xFF1C1C1E),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Row(
          children: [
            SvgPicture.asset(
              svgIcon,
              width: 20.sp,
              height: 20.sp,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackingListRow extends StatelessWidget {
  final String name;
  final String location;
  final String tag;
  final Color tagColor;
  final VoidCallback onTap;

  const _PackingListRow({
    required this.name,
    required this.location,
    required this.tag,
    required this.tagColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      location,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: tagColor,
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

class _AddToPackingListSheet extends StatelessWidget {
  // Replace with real data from your controller
  final List<Map<String, String>> lists = const [
    {
      'name': 'Summer Camp 2026',
      'location': 'Lake Winnebago, WI',
      'tag': 'CAMP',
      'tagColor': '0xFF4CAF50',
    },
    {
      'name': 'Ski Weekend 2025',
      'location': 'Aspen, CO',
      'tag': 'TRAVEL',
      'tagColor': '0xFFCE93D8',
    },
  ];

  const _AddToPackingListSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Add to Packing List',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 16.h),

          ...lists.map(
            (list) => _PackingListRow(
              name: list['name']!,
              location: list['location']!,
              tag: list['tag']!,
              tagColor: Color(int.parse(list['tagColor']!)),
              onTap: () => Get.back(),
            ),
          ),

          SizedBox(height: 8.h),

          // ── Create New List button ──────────────────────────────
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 20.sp, color: AppColors.primaryText),
                  SizedBox(width: 8.w),
                  Text(
                    'Create New List',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
