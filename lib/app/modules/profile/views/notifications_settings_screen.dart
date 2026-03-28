import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../data/repositories/notification_repository.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  final _box = GetStorage();
  bool _notificationsEnabled = true;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _notificationsEnabled = _box.read('notifications_enabled') ?? true;
      _isLoading = false;
    });
    try {
      final response = await NotificationRepository().getNotificationSettings();
      if (response['success'] == true) {
        final data = response['data'];
        setState(() {
          _notificationsEnabled = data['enabled'] ?? true;
        });
        await _box.write('notifications_enabled', _notificationsEnabled);
      }
    } catch (e) {
      debugPrint("Error loading settings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16.sp,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.sora(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enable Notifications Card
            _NotificationOptionCard(
              icon: Icons.notifications_active_rounded,
              iconColor: const Color(0xFF2B7FFF),
              title: 'Enable Notifications',
              subtitle: 'Get reminders and\nmilestone updates',
              isSelected: _notificationsEnabled,
              onTap: () => setState(() => _notificationsEnabled = true),
            ),
            SizedBox(height: 12.h),
            // Disable Notifications Card
            _NotificationOptionCard(
              icon: Icons.notifications_off_outlined,
              iconColor: const Color(0xFF90A1B9),
              title: 'Disable Notifications',
              subtitle: "You won't receive any\nnotifications",
              isSelected: !_notificationsEnabled,
              onTap: () => setState(() => _notificationsEnabled = false),
            ),
            SizedBox(height: 24.h),
            // What you'll get section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What you'll get:",
                    style: GoogleFonts.sora(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _BulletItem('Daily cooking reminders'),
                  SizedBox(height: 8.h),
                  _BulletItem('Milestone achievement celebrations'),
                  SizedBox(height: 8.h),
                  _BulletItem('Weekly savings summaries'),
                ],
              ),
            ),
            const Spacer(),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        await NotificationRepository().updateNotificationSettings(_notificationsEnabled);
                        await _box.write('notifications_enabled', _notificationsEnabled);
                        Get.back();
                        Get.snackbar('Saved',
                          _notificationsEnabled ? 'Notifications enabled' : 'Notifications disabled',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF2B7FFF),
                          colorText: Colors.white,
                        );
                      } catch (e) {
                        Get.snackbar('Error', e.toString(),
                            backgroundColor: Colors.red, colorText: Colors.white);
                      }
                    },
                    child: Container(
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B7FFF),
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2B7FFF).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Save',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _NotificationOptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _NotificationOptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0x1A2F80ED).withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0x1A2F80ED)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2B7FFF).withValues(alpha: 0.15)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(52.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF2B7FFF) : iconColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.sora(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF2B7FFF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 14.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h, right: 8.w),
          width: 6.w,
          height: 6.w,
          decoration: const BoxDecoration(
            color: Color(0xFF2B7FFF),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}