import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentWeekTimeline extends StatelessWidget {
  /// 1 = Monday (default), 7 = Sunday.
  final int startWeekday;

  const CurrentWeekTimeline({super.key, this.startWeekday = 1});

  List<DateTime> getCurrentWeek() {
    final now = DateTime.now();

    // Find start of week based on [startWeekday]
    final difference = (now.weekday - startWeekday) % 7;
    final startOfWeek = now.subtract(Duration(days: difference));

    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weekDates = getCurrentWeek();
    final weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(weekDates.length, (index) {
          final date = weekDates[index];
          final bool isToday = DateUtils.isSameDay(date, today);

          // Map weekday names based on the chosen start day
          final weekdayName = weekDays[(date.weekday - 1) % 7];

          return GestureDetector(
            onTap: () {
              // Add tap handler if needed
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weekdayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : (date.isBefore(today)
                              ? Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest
                              : Colors.transparent),
                    border: (isToday || date.isAfter(today))
                        ? Border.all(
                            color: isToday
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            width: isToday ? 2 : 1.5,
                          )
                        : null,
                  ),
                  child: Text(
                    DateFormat('d').format(date),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
