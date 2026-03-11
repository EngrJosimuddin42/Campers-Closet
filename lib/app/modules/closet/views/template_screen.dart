import 'package:cached_network_image/cached_network_image.dart';
import 'package:campers_closet/app/modules/closet/controllers/tetmplate_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../models/template_model.dart';

class TemplateView extends StatelessWidget {
  const TemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TemplateController>();

    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // ── Hero banner ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF4FF),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6E4FF),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: const Color(0xFF2B7FFF),
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Ready-Made Templates',
                    style: GoogleFonts.sora(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Start with expert-curated packing lists',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: const Color(0xFF90A1B9),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ── Section header ────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Templates',
                  style: GoogleFonts.sora(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showMaterialModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                      ),
                      builder: (context) => _FilterSheet(),
                    );
                  },
                  child: Text(
                    'Filter',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2B7FFF),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            // ── Template list ─────────────────────────────────────
            ...ctrl.templates.map(
              (t) => _TemplateCard(template: t, ctrl: ctrl),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      );
    });
  }
}

// ── Template card ─────────────────────────────────────────────────────────────

class _TemplateCard extends StatelessWidget {
  final TemplateModel template;
  final TemplateController ctrl;

  const _TemplateCard({required this.template, required this.ctrl});

  static const _bgColors = {
    'camp': Color(0xFFE6F7EE),
    'travel': Color(0xFFEEF4FF),
    'school': Color(0xFFFFF8E6),
  };
  static const _iconColors = {
    'camp': Color(0xFF22C55E),
    'travel': Color(0xFF2B7FFF),
    'school': Color(0xFFF5A623),
  };
  static const _defaultBg = Color(0xFFF3EEFF);
  static const _defaultIcon = Color(0xFF7C3AED);

  Color get _bgColor => _bgColors[template.iconCategory] ?? _defaultBg;
  Color get _iconColor => _iconColors[template.iconCategory] ?? _defaultIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(18.r),
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
          // ── Thumbnail ───────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: CachedNetworkImage(
              imageUrl: template.imageUrl,
              width: 48.w,
              height: 48.w,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 48.w,
                height: 48.w,
                color: _bgColor,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _iconColor,
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 48.w,
                height: 48.w,
                color: _bgColor,
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: _iconColor,
                  size: 24.sp,
                ),
              ),
            ),
          ),

          SizedBox(width: 14.w),

          // ── Info ────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  template.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF90A1B9),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  '~${template.itemCount} ITEMS INCLUDED',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: _iconColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          // ── View button ─────────────────────────────────────────
          GestureDetector(
            onTap: () => ctrl.useTemplate(template),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                'View',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2B7FFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter sheet (stateless via GetX obs) ─────────────────────────────────────

class _FilterSheet extends StatelessWidget {
  _FilterSheet();

  final _selectedType = RxnString();
  final _selectedUser = RxnString();

  static const _types = ['Summer', 'Winter'];
  static const _users = ['Ava Used', 'Lio Used'];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
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

            // title + close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            _SectionLabel(label: 'Type'),
            SizedBox(height: 10.h),
            ..._types.map(
              (t) => _FilterOption(
                label: t,
                selected: _selectedType.value == t,
                onTap: () =>
                    _selectedType.value = _selectedType.value == t ? null : t,
              ),
            ),

            SizedBox(height: 16.h),

            _SectionLabel(label: 'Another User Used'),
            SizedBox(height: 10.h),
            ..._users.map(
              (u) => _FilterOption(
                label: u,
                selected: _selectedUser.value == u,
                onTap: () =>
                    _selectedUser.value = _selectedUser.value == u ? null : u,
              ),
            ),

            SizedBox(height: 24.h),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _selectedType.value = null;
                      _selectedUser.value = null;
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B7FFF),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Apply',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
}

// ── Shared filter widgets ─────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A2E),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEBF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? const Color(0xFF2B7FFF) : Colors.grey[200]!,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: selected ? const Color(0xFF2B7FFF) : const Color(0xFF1A1A2E),
          ),
        ),
      ),
    );
  }
}
