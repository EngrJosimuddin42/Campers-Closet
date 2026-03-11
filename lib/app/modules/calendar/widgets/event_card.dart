import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum EventCardType { deadline, event }

class EventCard extends StatelessWidget {
  final EventCardType type;
  final String title;
  final String subtitle;
  final String dateLabel; // e.g. "JAN 12"
  final String? badgeMonth; // e.g. "JUL" — only for deadline type
  final String? badgeDay; // e.g. "15" — only for deadline type
  final IconData? eventIcon; // only for event type

  const EventCard({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    this.badgeMonth,
    this.badgeDay,
    this.eventIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDeadline = type == EventCardType.deadline;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDeadline
              ? const Color(0xFFF5A623) // orange
              : const Color(0xFF2B7FFF), // blue
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            // Left badge
            if (isDeadline)
              _DeadlineBadge(month: badgeMonth ?? '', day: badgeDay ?? '')
            else
              _EventIconBadge(icon: eventIcon ?? Icons.inventory_2_outlined),

            SizedBox(width: 14.w),

            // Title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF90A1B9),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Date label
            Text(
              dateLabel,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF90A1B9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeadlineBadge extends StatelessWidget {
  final String month;
  final String day;

  const _DeadlineBadge({required this.month, required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFF), // light purple
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            month,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7C3AED),
            ),
          ),
          Text(
            day,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF7C3AED),
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventIconBadge extends StatelessWidget {
  final IconData icon;

  const _EventIconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, color: const Color(0xFF2B7FFF), size: 24.sp),
    );
  }
}
