import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/modules/calendar/widgets/custom_calendar.dart';
import 'package:campers_closet/app/modules/calendar/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/calendar_controller.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CalendarController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calendar',
                    style: GoogleFonts.sora(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Packing milestones & trip dates',
                    style: GoogleFonts.sora(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              Expanded(
                child: Obx(
                  () => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Calendar — passes marked dates and selected date
                        CustomCalendar(
                          selectedDate: ctrl.selectedDate.value,
                          markedDate: ctrl.markedDates,
                          onDateSelected: ctrl.onDateSelected,
                        ),

                        SizedBox(height: 30.h),

                        // Events section
                        Obx(() {
                          final hasEventsToday = ctrl.filteredEvents.any(
                            (e) =>
                                e.date.year == ctrl.selectedDate.value.year &&
                                e.date.month == ctrl.selectedDate.value.month &&
                                e.date.day == ctrl.selectedDate.value.day,
                          );

                          return Row(
                            children: [
                              Text(
                                hasEventsToday
                                    ? 'Events on this day'
                                    : 'Upcoming Events',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${ctrl.selectedDate.value.day} ${_monthShort(ctrl.selectedDate.value.month)}',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2B7FFF),
                                ),
                              ),
                            ],
                          );
                        }),

                        SizedBox(height: 8.h),

                        // Filtered events
                        if (ctrl.filteredEvents.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: Center(
                              child: Text(
                                'No upcoming events',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF90A1B9),
                                ),
                              ),
                            ),
                          )
                        else
                          ...ctrl.filteredEvents.map(
                            (event) => EventCard(
                              type: event.isDeadline
                                  ? EventCardType.deadline
                                  : EventCardType.event,
                              title: event.title,
                              subtitle: event.subtitle,
                              dateLabel: event.dateLabel,
                              badgeMonth: event.badgeMonth,
                              badgeDay: event.badgeDay,
                              eventIcon: Icons.inventory_2_outlined,
                            ),
                          ),

                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthShort(int month) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[month - 1];
  }
}
