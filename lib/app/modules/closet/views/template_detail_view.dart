import 'package:cached_network_image/cached_network_image.dart';
import 'package:campers_closet/app/modules/closet/controllers/tetmplate_controller.dart';
import 'package:campers_closet/app/modules/closet/models/template_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TemplateItemModel {
  final String name;
  final String imageUrl;
  final int quantity;
  final bool isRecommended;

  const TemplateItemModel({
    required this.name,
    required this.imageUrl,
    required this.quantity,
    this.isRecommended = false,
  });
}

class TemplateSectionModel {
  final String title;
  final IconData icon;
  final List<TemplateItemModel> items;

  const TemplateSectionModel({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class TemplateDetailView extends StatelessWidget {
  final TemplateModel template;

  const TemplateDetailView({super.key, required this.template});

  // Replace with controller data when API is ready
  List<TemplateSectionModel> get _sections => [
    TemplateSectionModel(
      title: 'Clothes',
      icon: Icons.checkroom_outlined,
      items: [
        TemplateItemModel(
          name: 'T-shirts',
          imageUrl:
              'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=100&auto=format&fit=crop',
          quantity: 14,
          isRecommended: true,
        ),
        TemplateItemModel(
          name: 'Shorts',
          imageUrl:
              'https://images.unsplash.com/photo-1591195853828-11db59a44f43?w=100&auto=format&fit=crop',
          quantity: 4,
          isRecommended: true,
        ),
        TemplateItemModel(
          name: 'Underwear',
          imageUrl:
              'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=100&auto=format&fit=crop',
          quantity: 11,
        ),
        TemplateItemModel(
          name: 'Swim Trunks',
          imageUrl:
              'https://images.unsplash.com/photo-1562886877-1f5ec43c5b50?w=100&auto=format&fit=crop',
          quantity: 2,
        ),
      ],
    ),
    TemplateSectionModel(
      title: 'Toiletries',
      icon: Icons.water_drop_outlined,
      items: [
        TemplateItemModel(
          name: 'Toothbrush',
          imageUrl:
              'https://images.unsplash.com/photo-1559590879-c25c8d361c1f?w=100&auto=format&fit=crop',
          quantity: 4,
          isRecommended: true,
        ),
        TemplateItemModel(
          name: 'Shampoo',
          imageUrl:
              'https://images.unsplash.com/photo-1585232351009-aa87e24a9805?w=100&auto=format&fit=crop',
          quantity: 11,
        ),
      ],
    ),
    TemplateSectionModel(
      title: 'Gear',
      icon: Icons.backpack_outlined,
      items: [
        TemplateItemModel(
          name: 'Sleeping Bag',
          imageUrl:
              'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=100&auto=format&fit=crop',
          quantity: 2,
          isRecommended: true,
        ),
        TemplateItemModel(
          name: 'Flashlight',
          imageUrl:
              'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=100&auto=format&fit=crop',
          quantity: 2,
        ),
      ],
    ),
  ];

  int get _totalItems => _sections.fold(0, (sum, s) => sum + s.items.length);

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  const _BackButton(),
                  SizedBox(height: 16.h),
                  _HeaderCard(
                    template: template,
                    totalItems: _totalItems,
                    bgColor: _bgColor,
                    iconColor: _iconColor,
                  ),
                  SizedBox(height: 24.h),
                  ..._sections.map((s) => _SectionBlock(section: s)),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          // ── Sticky bottom button ───────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Get.dialog(
                  _EditTemplateDialog(template: template),
                  barrierDismissible: true,
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Use this template',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Back button ───────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            'Back',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header card ───────────────────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  final TemplateModel template;
  final int totalItems;
  final Color bgColor;
  final Color iconColor;

  const _HeaderCard({
    required this.template,
    required this.totalItems,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: template.imageUrl,
                  width: 44.w,
                  height: 44.w,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 44.w,
                    height: 44.w,
                    color: iconColor.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: iconColor,
                      size: 22.sp,
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 44.w,
                    height: 44.w,
                    color: iconColor.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: iconColor,
                      size: 22.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.title,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
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
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'TOTAL ITEMS: $totalItems',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section block ─────────────────────────────────────────────────────────────

class _SectionBlock extends StatelessWidget {
  final TemplateSectionModel section;
  const _SectionBlock({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(section.icon, size: 18.sp, color: const Color(0xFF90A1B9)),
            SizedBox(width: 8.w),
            Text(
              section.title,
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: section.items.asMap().entries.map((entry) {
              final isLast = entry.key == section.items.length - 1;
              return Column(
                children: [
                  _TemplateItemRow(item: entry.value),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 16.w + 44.w + 12.w,
                      color: Colors.grey[100],
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

// ── Item row ──────────────────────────────────────────────────────────────────

class _TemplateItemRow extends StatelessWidget {
  final TemplateItemModel item;
  const _TemplateItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 44.w,
              height: 44.w,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 44.w,
                height: 44.w,
                color: const Color(0xFFF1F5F9),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 44.w,
                height: 44.w,
                color: const Color(0xFFF1F5F9),
                child: Icon(
                  Icons.image_outlined,
                  size: 20.sp,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '${item.quantity} pcs',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF90A1B9),
                  ),
                ),
              ],
            ),
          ),
          if (item.isRecommended)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF2FF),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'RECOMMENDED',
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: const Color(0xFF2B7FFF),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Dialog ────────────────────────────────────────────────────────────────────

class _EditTemplateDialog extends StatelessWidget {
  final TemplateModel template;

  _EditTemplateDialog({required this.template});

  final _tripNameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _startDate = Rxn<DateTime>();
  final _endDate = Rxn<DateTime>();

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      isStart ? _startDate.value = picked : _endDate.value = picked;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Pre-fill trip name
    _tripNameCtrl.text = template.title;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit template detail',
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Type all detail',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: const Color(0xFF90A1B9),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 30.w,
                    height: 30.w,
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

            Divider(height: 24.h, color: Colors.grey[200]),

            // ── Trip name ──────────────────────────────────────────
            Text(
              'TRIP NAME',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: const Color(0xFF90A1B9),
              ),
            ),
            SizedBox(height: 8.h),
            _InputField(controller: _tripNameCtrl, hint: '7-Day Summer Camp'),

            SizedBox(height: 16.h),

            // ── Location ───────────────────────────────────────────
            Text(
              'Location',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 8.h),
            _InputField(controller: _locationCtrl, hint: 'E.g :  Bangladesh'),

            SizedBox(height: 16.h),

            // ── Date row ───────────────────────────────────────────
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: 'Start Date',
                      value: _formatDate(_startDate.value),
                      onTap: () => _pickDate(context, true),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _DateField(
                      label: 'End Date',
                      value: _formatDate(_endDate.value),
                      onTap: () => _pickDate(context, false),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ── Save button ────────────────────────────────────────
            GestureDetector(
              onTap: () {
                // TODO: pass data to controller
                Get.back();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B7FFF),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Save',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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

// ── Shared input field ────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _InputField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 14.sp,
          color: const Color(0xFF90A1B9),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF2B7FFF)),
        ),
      ),
    );
  }
}

// ── Date field ────────────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16.sp,
                  color: const Color(0xFF90A1B9),
                ),
                SizedBox(width: 8.w),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
