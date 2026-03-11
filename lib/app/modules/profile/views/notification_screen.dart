import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      icon: Icons.person_add_alt_1_rounded,
      iconColor: Color(0xFF2B7FFF),
      title: 'New user joined',
      subtitle: 'Alex has been added to your workspace.',
      time: '2m ago',
      isUnread: true,
    ),
    _NotificationItem(
      icon: Icons.check_circle_outline_rounded,
      iconColor: Color(0xFF10B981),
      title: 'Task completed',
      subtitle: 'Your export request has been processed.',
      time: '1h ago',
      isUnread: true,
    ),
    _NotificationItem(
      icon: Icons.warning_amber_rounded,
      iconColor: Color(0xFFF5A623),
      title: 'Subscription expiring',
      subtitle: 'Your plan renews in 3 days.',
      time: '5h ago',
      isUnread: false,
    ),
    _NotificationItem(
      icon: Icons.security_rounded,
      iconColor: Color(0xFF7C3AED),
      title: 'Security alert',
      subtitle: 'New login detected from Chrome on macOS.',
      time: 'Yesterday',
      isUnread: false,
    ),
    _NotificationItem(
      icon: Icons.campaign_rounded,
      iconColor: Color(0xFFE53935),
      title: 'System update',
      subtitle: 'Version 2.4.0 is now available.',
      time: '2d ago',
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
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
                  SizedBox(width: 16.w),
                  Text(
                    'Notifications',
                    style: GoogleFonts.sora(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        for (final n in _notifications) {
                          n.isUnread = false;
                        }
                      });
                    },
                    child: Text(
                      'Mark all read',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2B7FFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: _notifications.isEmpty
                  ? Center(
                      child: Text(
                        'No notifications',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF90A1B9),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      itemCount: _notifications.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final item = _notifications[index];
                        return _NotificationCard(
                          item: item,
                          onDismiss: () {
                            setState(() => _notifications.removeAt(index));
                          },
                          onTap: () {
                            setState(() => item.isUnread = false);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  bool isUnread;

  _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.item,
    required this.onDismiss,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEEE),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete_outline_rounded, color: const Color(0xFFE53935), size: 22.sp),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: item.isUnread ? Colors.white : const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(16.r),
            border: item.isUnread
                ? Border.all(color: const Color(0xFF2B7FFF).withValues(alpha: 0.15), width: 1)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: item.isUnread ? 0.06 : 0.03),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: item.iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: item.isUnread ? FontWeight.w700 : FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          item.time,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: const Color(0xFF90A1B9),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF90A1B9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.isUnread) ...[
                SizedBox(width: 8.w),
                Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.only(top: 4.h),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2B7FFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}