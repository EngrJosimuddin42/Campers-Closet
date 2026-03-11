import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final Set<DateTime>? markedDate;
  final ValueChanged<DateTime>? onDateSelected;

  const CustomCalendar({
    super.key,
    this.selectedDate,
    this.markedDate,
    this.onDateSelected,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _focusedMonth;
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _focusedMonth = DateTime(_selectedDate!.year, _selectedDate!.month);
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  List<DateTime?> _buildCalendarDays() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startOffset = firstDay.weekday % 7; 

    final days = <DateTime?>[];
    for (int i = 0; i < startOffset; i++) {
      days.add(null);
    }
    for (int d = 1; d <= lastDay.day; d++) {
      days.add(DateTime(_focusedMonth.year, _focusedMonth.month, d));
    }
    return days;
  }

  // bool _isToday(DateTime date) {
  //   final now = DateTime.now();
  //   return date.year == now.year &&
  //       date.month == now.month &&
  //       date.day == now.day;
  // }

  bool _isSelected(DateTime date) {
    return _selectedDate != null &&
        date.year == _selectedDate!.year &&
        date.month == _selectedDate!.month &&
        date.day == _selectedDate!.day;
  }

  bool _isMarked(DateTime date) {
  return widget.markedDate?.any((m) =>
    m.year == date.year && m.month == date.month && m.day == date.day
  ) ?? false;
}

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays();
    final monthName = _monthName(_focusedMonth.month);
    const weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$monthName ${_focusedMonth.year}',
                style: GoogleFonts.sora(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
              Row(
                children: [
                  _ArrowButton(icon: Icons.chevron_left, onTap: _prevMonth),
                  const SizedBox(width: 16),
                  _ArrowButton(icon: Icons.chevron_right, onTap: _nextMonth),
                ],
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Weekday labels
          Row(
            children: weekDays
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xfff90a1b9),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 30),

          // Days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 24,
              crossAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemCount: days.length,
            itemBuilder: (_, i) {
              final date = days[i];
              if (date == null) return const SizedBox();

              final selected = _isSelected(date);
              // final today = _isToday(date);
              final marked = _isMarked(date);

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                  widget.onDateSelected?.call(date);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: selected ? Colors.transparent : Colors.transparent,
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(color: const Color(0xFF2B7FFF), width: 1.8)
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? const Color(0xFF2B7FFF)
                              : const Color(0xFF1A1A2E),
                        ),
                      ),
                      if (marked)
                        Positioned(
                          bottom: 6,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF5A623),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month - 1];
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 24, color: Colors.grey),
    );
  }
}
