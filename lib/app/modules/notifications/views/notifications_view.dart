import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  int _selectedFilterIndex = 0;

  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      icon: Icons.assignment_outlined,
      iconColor: const Color(0xFF2B7FFF),
      title: 'Packing List Reminder',
      subtitle: 'Summer Camp 2026 trip is in 3 days. You have 14 items left to pack.',
      time: '2h ago',
      isUnread: true,
      category: 'TODAY',
    ),
    _NotificationItem(
      icon: Icons.camera_alt_outlined,
      iconColor: const Color(0xFF7C3AED),
      title: 'New Item Added',
      subtitle: 'Blue Cotton T-shirt was successfully added to your closet.',
      time: '5h ago',
      isUnread: true,
      category: 'YESTERDAY',
    ),
    _NotificationItem(
      icon: Icons.calendar_today_outlined,
      iconColor: const Color(0xFF10B981),
      title: 'Trip Coming Up',
      subtitle: 'Don\'t forget! Summer Camp 2026 starts on July 15th.',
      time: '1d ago',
      isUnread: false,
      category: 'YESTERDAY',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // ফিল্টার অনুযায়ী কাউন্ট বের করা
    int unreadCount = _notifications.where((n) => n.isUnread).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Colors.black, size: 22.sp),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Notifications',
                    style: GoogleFonts.sora(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        for (var n in _notifications) {
                          n.isUnread = false;
                        }
                      });
                    },
                    child: Text(
                      'Mark all as read',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2B7FFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Filter Tabs ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  _filterChip('All (${_notifications.length})', 0),
                  SizedBox(width: 10.w),
                  _filterChip('Unread ($unreadCount)', 1),
                ],
              ),
            ),

            // --- Notifications List ---
            Expanded(
              child: _notifications.isEmpty
                  ? Center(child: Text("No notifications found", style: GoogleFonts.inter()))
                  : ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  if (_hasCategory('TODAY')) ...[
                    _sectionHeader('TODAY'),
                    _buildListByCategory('TODAY'),
                  ],
                  SizedBox(height: 10.h),
                  if (_hasCategory('YESTERDAY')) ...[
                    _sectionHeader('YESTERDAY'),
                    _buildListByCategory('YESTERDAY'),
                  ],
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ক্যাটাগরিতে কোনো ডাটা আছে কি না চেক করা (ফিল্টার অনুযায়ী)
  bool _hasCategory(String category) {
    var list = _notifications.where((n) => n.category == category);
    if (_selectedFilterIndex == 1) {
      list = list.where((n) => n.isUnread);
    }
    return list.isNotEmpty;
  }

  Widget _filterChip(String label, int index) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2B7FFF) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF94A3B8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildListByCategory(String category) {
    List<_NotificationItem> filtered = _notifications.where((n) => n.category == category).toList();

    // ফিল্টার যদি Unread হয়
    if (_selectedFilterIndex == 1) {
      filtered = filtered.where((n) => n.isUnread).toList();
    }

    return Column(
      children: filtered.map((item) => _NotificationCard(
        item: item,
        onTap: () {
          setState(() => item.isUnread = false);
        },
        onMarkRead: () {
          setState(() => item.isUnread = false);
        },
        onDelete: () {
          setState(() => _notifications.remove(item));
        },
      )).toList(),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final String category;
  bool isUnread;

  _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
    required this.category,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.item,
    required this.onTap,
    required this.onMarkRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                    color: item.iconColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: const Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.isUnread)
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2B7FFF),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                SizedBox(width: 56.w),
                Text(
                  item.time,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const Spacer(),
                if (item.isUnread)
                  GestureDetector(
                    onTap: onMarkRead,
                    child: Text(
                      'Mark as read',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2B7FFF),
                      ),
                    ),
                  ),
                SizedBox(width: 14.w),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.delete_outline, color: const Color(0xFF94A3B8), size: 18.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}