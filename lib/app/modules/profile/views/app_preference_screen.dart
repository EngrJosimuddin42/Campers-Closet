import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_logos.dart';
import '../controllers/app_preferences_controller.dart';

class AppPreferencesScreen extends StatelessWidget {
  const AppPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPreferencesController ctrl = Get.put(AppPreferencesController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Colors.black, size: 22.sp),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'App Preferences',
                    style: GoogleFonts.sora(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 28.h),

              // --- Appearance ---
              _SectionLabel(label: 'APPEARANCE'),
              SizedBox(height: 10.h),
              _PrefsCard(
                children: [
                  _OptionTile(
                    icon: Icons.palette_outlined,
                    iconColor: const Color(0xFF7C3AED),
                    label: 'Theme',
                    trailingText: 'System',
                    isFirst: true,
                    onTap: () {},
                  ),
                  _Divider(),
                  _OptionTile(
                    icon: Icons.language_outlined,
                    iconColor: const Color(0xFF2B7FFF),
                    label: 'Language',
                    trailingText: 'English',
                    isLast: true,
                    onTap: () {},
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // --- Security ---
              _SectionLabel(label: 'SECURITY'),
              SizedBox(height: 10.h),
              _PrefsCard(
                children: [
                  _OptionTile(
                    icon: Icons.lock_outline_rounded,
                    iconColor: const Color(0xFFF5A623),
                    label: 'Change Password',
                    isFirst: true,
                    isLast: true,
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // --- Danger Zone ---
              _SectionLabel(label: 'DANGER ZONE'),
              SizedBox(height: 10.h),
              _PrefsCard(
                children: [
                  _ActionTile(
                    iconPath: AppLogos.alerttriangle,
                    iconColor: const Color(0xFFE53935),
                    label: 'Delete Account',
                    subtitle: 'Permanently remove your account and data',
                    isFirst: true,
                    isLast: true,
                    isDestructive: true,
                    onTap: () => _showDeleteConfirmation(context, ctrl),
                  ),
                ],
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  // Change Password Dialog
  void _showChangePasswordDialog(BuildContext context) {
    final AppPreferencesController ctrl = Get.find<AppPreferencesController>();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Change Password', style: GoogleFonts.sora(fontWeight: FontWeight.w600, fontSize: 16.sp)),
                  GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.close, size: 20)),
                ],
              ),
              Text('Change your password', style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey)),
              SizedBox(height: 20.h),
              _buildField('Old Password', 'Type Old Password', controller: ctrl.oldPassCtrl),
              _buildField('New Password', 'Type New Password', controller: ctrl.newPassCtrl),
              _buildField('Retype Password', 'Confirm New Password', controller: ctrl.confirmPassCtrl),

              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: _btn('Cancel', isGrey: true, onTap: () => Get.back()),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Obx(() => _btn(
                      ctrl.isLoading.value ? 'Saving...' : 'Save',
                      onTap: ctrl.isLoading.value ? null : () => ctrl.changePassword(),
                    )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildField(String label, String hint, {required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          obscureText: true,
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey[400]),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey[200]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey[200]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Color(0xFF2B7FFF))),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _btn(String label, {bool isGrey = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isGrey ? const Color(0xFFF1F5F9) : const Color(0xFF2B7FFF),
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isGrey ? Colors.black54 : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Delete Dialog
  void _showDeleteConfirmation(BuildContext context, AppPreferencesController ctrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.report_problem_outlined,
                    color: const Color(0xFFE53935),
                    size: 35.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Delete Account?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sora(
                    fontWeight: FontWeight.w600,
                    fontSize: 22.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'This action cannot be undone. All your closet items, packing lists, and account data will be permanently deleted.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),
                Obx(() => GestureDetector(
                  onTap: ctrl.isLoading.value ? null : () => ctrl.confirmDelete(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: ctrl.isLoading.value
                        ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                        : Text(
                      'Yes, Delete My Account',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                )),
                SizedBox(height: 12.h),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF475569),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String iconPath;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final bool isFirst;
  final bool isLast;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionTile({
    required this.iconPath,
    required this.iconColor,
    required this.label,
    this.subtitle,
    this.isFirst = false,
    this.isLast = false,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(18.r) : Radius.zero,
          bottom: isLast ? Radius.circular(18.r) : Radius.zero,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  width: 20.w,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDestructive
                            ? const Color(0xFFE53935)
                            : const Color(0xFF1A1A2E),
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: isDestructive
                              ? const Color(0xFFE53935).withValues(alpha: 0.8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: const Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// --- Helper Widgets ---
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Text(label, style: GoogleFonts.inter(fontSize: 11.sp, fontWeight: FontWeight.w700, color: const Color(0xFF94A3B8), letterSpacing: 1));
  }
}

class _PrefsCard extends StatelessWidget {
  final List<Widget> children;
  const _PrefsCard({required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(children: children),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? trailingText;
  final bool isFirst, isLast;
  final VoidCallback onTap;

  const _OptionTile({required this.icon, required this.iconColor, required this.label, this.trailingText, this.isFirst = false, this.isLast = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10.r)),
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
      title: Text(label, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) Text(trailingText!, style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey)),
          SizedBox(width: 4.w),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, indent: 60.w, endIndent: 20.w, color: const Color(0xFFF1F5F9));
  }
}