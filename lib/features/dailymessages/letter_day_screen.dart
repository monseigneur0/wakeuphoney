import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wakeuphoney/core/utils.dart';

import '../../core/common/loader.dart';
import 'daily_controller.dart';

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class LetterDayScreen extends ConsumerStatefulWidget {
  static const routeName = 'letter_day';
  static const routeURL = '/letter_day';

  const LetterDayScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterDayScreenState();
}

class _LetterDayScreenState extends ConsumerState<LetterDayScreen> {
  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);

  final Logger logger = Logger();

  // Using a `LinkedHashSet` is recommended due to equality comparison override
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  final Set<DateTime> _writeDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  late Map<DateTime, List<Event>> kEventSource;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kEventSource = {
      for (var item in List.generate(50, (index) => index))
        DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
            item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
    }..addAll({
        kToday: [
          const Event('Today\'s Event 1'),
          const Event('Today\'s Event 2'),
        ],
      });
  }

  final kEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(kEventSource);

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Set<DateTime> days) {
    // Implementation example
    // Note that days are in selection order (same applies to events)
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      // Update values in a Set
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
        showSnackBar(context, "text");
      } else {
        _selectedDays.add(selectedDay);
      }
      print(_selectedDays);
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
    print("_onDaySelected");
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lettersList = ref.watch(getLettersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCalendar - Multi change'),
      ),
      body: Column(
        children: [
          // TableCalendar<Event>(
          //   firstDay: kFirstDay,
          //   lastDay: kLastDay,
          //   focusedDay: _focusedDay,
          //   eventLoader: _getEventsForDay,
          //   availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          //   startingDayOfWeek: StartingDayOfWeek.monday,
          //   selectedDayPredicate: (day) {
          //     // Use values from Set to mark multiple days as selected
          //     return _selectedDays.contains(day);
          //   },
          //   onDaySelected: _onDaySelected,
          //   onFormatChanged: (format) {
          //     if (_calendarFormat != format) {
          //       setState(() {
          //         _calendarFormat = format;
          //       });
          //     }
          //   },
          //   onPageChanged: (focusedDay) {
          //     _focusedDay = focusedDay;
          //   },
          // ),
          lettersList.when(
            data: (data) {
              for (var letter in data) {
                _writeDays.add(letter.messagedatetime);
              }
              return TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                eventLoader: _getEventsForDay,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) {
                  // Use values from Set to mark multiple days as selected
                  return _writeDays.contains(day);
                },
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              );
            },
            error: (error, stackTrace) {
              logger.d("error$error ");
              return const Center(
                child: Text(
                  "주고 받은 편지가 없어요",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              );
            },
            loading: () => const Loader(),
          ),
          ElevatedButton(
            child: const Text('Clear selection 1'),
            onPressed: () {
              setState(() {
                _selectedDays.clear();
                _selectedEvents.value = [];
              });
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
