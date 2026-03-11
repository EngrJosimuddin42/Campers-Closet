import 'package:get/get.dart';

class CalendarEvent {
  final String title;
  final String subtitle;
  final String dateLabel;
  final DateTime date;
  final bool isDeadline;
  final String? badgeMonth;
  final String? badgeDay;

  const CalendarEvent({
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.date,
    this.isDeadline = false,
    this.badgeMonth,
    this.badgeDay,
  });
}

class CalendarController extends GetxController {
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final List<CalendarEvent> allEvents = [
    CalendarEvent(
      title: "Deadline: Oliver's Camp",
      subtitle: 'Final packing checklist due',
      dateLabel: 'JAN 12',
      date: DateTime(2026, 1, 12),
      isDeadline: true,
      badgeMonth: 'JUL',
      badgeDay: '15',
    ),
    CalendarEvent(
      title: 'Summer Camp Starts',
      subtitle: 'Arrive at Winnebago Lodge',
      dateLabel: 'JAN 15',
      date: DateTime(2026, 1, 15),
    ),
    CalendarEvent(
      title: 'Gear Check',
      subtitle: 'Review all packed equipment',
      dateLabel: 'JAN 15',
      date: DateTime(2026, 1, 15),
    ),
    CalendarEvent(
      title: 'Doctor Appointment',
      subtitle: 'Pre-camp health checkup',
      dateLabel: 'FEB 3',
      date: DateTime(2026, 2, 3),
    ),
  ];

  List<CalendarEvent> get filteredEvents {
    // Events on the selected day
    final dayEvents = allEvents
        .where(
          (e) =>
              e.date.year == selectedDate.value.year &&
              e.date.month == selectedDate.value.month &&
              e.date.day == selectedDate.value.day,
        )
        .toList();

    // If selected day has events, show them
    if (dayEvents.isNotEmpty) return dayEvents;

    // Otherwise show upcoming events from selected date onward
    final upcoming =
        allEvents
            .where(
              (e) =>
                  e.date.isAfter(selectedDate.value) ||
                  (e.date.year == selectedDate.value.year &&
                      e.date.month == selectedDate.value.month &&
                      e.date.day == selectedDate.value.day),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date)); 

    return upcoming;
  }

  Set<DateTime> get markedDates {
    return allEvents
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet();
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
  }
}
