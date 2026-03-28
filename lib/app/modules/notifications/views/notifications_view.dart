import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back, color: Colors.black, size: 22.sp),
                  ),
                  SizedBox(width: 16.w),
                  Text('Notifications',
                      style: GoogleFonts.sora(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E))),
                  const Spacer(),
                  GestureDetector(
                    onTap: ctrl.markAllAsRead,
                    child: Text('Mark all as read',
                        style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2B7FFF))),
                  ),
                ],
              ),
            ),

            // Filter Tabs
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  _filterChip(ctrl, 'All (${ctrl.notifications.length})', 0),
                  SizedBox(width: 10.w),
                  _filterChip(ctrl, 'Unread (${ctrl.unreadCount})', 1),
                ],
              ),
            )),

            // List
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (ctrl.filteredNotifications.isEmpty) {
                  return Center(
                    child: Text('No notifications found',
                        style: GoogleFonts.inter()),
                  );
                }
                return RefreshIndicator(
                  onRefresh: ctrl.fetchNotifications,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: ctrl.filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final item = ctrl.filteredNotifications[index];
                      return _NotificationCard(
                        item: item,
                        onTap: () => ctrl.markAsRead(item['id'].toString()),
                        onMarkRead: () => ctrl.markAsRead(item['id'].toString()),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(NotificationsController ctrl, String label, int index) {
    return Obx(() {
      final isSelected = ctrl.selectedFilterIndex.value == index;
      return GestureDetector(
        onTap: () => ctrl.selectedFilterIndex.value = index,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2B7FFF) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF64748B))),
        ),
      );
    });
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;

  const _NotificationCard({
    required this.item,
    required this.onTap,
    required this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnread = item['is_read'] == false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B7FFF).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.notifications_outlined,
                      color: const Color(0xFF2B7FFF), size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'] ?? '',
                          style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E))),
                      SizedBox(height: 6.h),
                      Text(item['message'] ?? item['body'] ?? '',
                          style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: const Color(0xFF64748B),
                              height: 1.4)),
                    ],
                  ),
                ),
                if (isUnread)
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                        color: Color(0xFF2B7FFF), shape: BoxShape.circle),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                SizedBox(width: 56.w),
                Text(item['created_at'] ?? '',
                    style: GoogleFonts.inter(
                        fontSize: 12.sp, color: const Color(0xFF94A3B8))),
                const Spacer(),
                if (isUnread)
                  GestureDetector(
                    onTap: onMarkRead,
                    child: Text('Mark as read',
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2B7FFF))),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}