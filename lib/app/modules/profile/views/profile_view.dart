import 'package:campers_closet/app/modules/profile/views/app_preference_screen.dart';
import 'package:campers_closet/app/modules/profile/views/manage_user_screen.dart';
import 'package:campers_closet/app/modules/profile/views/notification_screen.dart';
import 'package:campers_closet/app/modules/profile/views/personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});


  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),

            // Avatar
            Obx(() {
              String userName = controller.userData['full_name'] ?? 'User';
              String? profilePic = controller.userData['profile_pic'];

              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 128.w,
                    height: 128.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      image: DecorationImage(
                        image: (profilePic != null && profilePic.isNotEmpty)
                            ? NetworkImage(
                          profilePic.startsWith('http')
                              ? profilePic
                              : 'http://3.225.98.180${profilePic}',
                        )
                            : NetworkImage(
                          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=1A1A2E&color=fff&size=256&bold=true',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : null,
                  ),


                  GestureDetector(
                    onTap: () => controller.uploadProfileImage(),
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            }),

              SizedBox(height: 14.h),

              // Name
              Obx(() => GestureDetector(
                onTap: () {
                  controller.openEditNameDialog();
                },
                child: Text(
                  controller.userData['full_name'] ?? 'Guest User',
                  style: GoogleFonts.sora(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              )),

              SizedBox(height: 4.h),

              // Member tag
              Obx(() {
                final data = controller.userData;
                String role = data['role'] ?? 'Member';
                role = role[0].toUpperCase() + role.substring(1);
                String createdAt = data['created_at'] ?? '';
                String year = '';

                if (createdAt.isNotEmpty) {
                  try {
                    year = DateTime.parse(createdAt).year.toString();
                  } catch (e) {
                    year = '';
                  }
                }
                return Text(
                  year.isNotEmpty
                      ? '$role • Est. $year'
                      : role,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF90A1B9),
                  ),
                );
              }),
              SizedBox(height: 32.h),

              // Section label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'APPLICATION',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: const Color(0xFF90A1B9),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // Menu card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      iconColor: const Color(0xFF2B7FFF),
                      label: 'Personal Information',
                      isFirst: true,
                      onTap: () => Get.to(() => const PersonalInfoScreen()),
                    ),
                    _Divider(),
                    _MenuItem(
                      icon: Icons.people_outline_rounded,
                      iconColor: const Color(0xFF7C3AED),
                      label: 'Manage Users',
                      badge: 2,
                      onTap: () => Get.to(() => const ManageUsersScreen()),
                    ),
                    _Divider(),
                    _MenuItem(
                      icon: Icons.notifications_none_rounded,
                      iconColor: const Color(0xFFF5A623),
                      label: 'Notifications',
                      onTap: () => Get.to(() => const NotificationsScreen()),
                    ),
                    _Divider(),
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      iconColor: const Color(0xFF90A1B9),
                      label: 'App Preferences',
                      isLast: true,
                      onTap: () => Get.to(() => const AppPreferencesScreen()),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Sign out button
              GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                    title: "Sign Out",
                    middleText: "Are you sure you want to sign out?",
                    textConfirm: "Yes",
                    textCancel: "No",
                    confirmTextColor: Colors.white,
                    buttonColor: const Color(0xFFE53935),
                    onConfirm: () {
                      Get.back();
                      controller.logout();
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEEE),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      'SIGN OUT',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: const Color(0xFFE53935),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final int? badge;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.badge,
    this.isFirst = false,
    this.isLast = false,
    this.onTap,
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
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              if (badge != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B7FFF),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '$badge',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
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

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 68.w,
      endIndent: 0,
      color: const Color(0xFFF1F5F9),
    );
  }
}
