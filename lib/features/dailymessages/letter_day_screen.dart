import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wakeuphoney/core/utils.dart';

import '../../core/common/loader.dart';
import '../../core/providers/providers.dart';
import 'daily_controller.dart';
import 'letter_create_screen.dart';

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
  static String routeName = 'letter_day';
  static String routeURL = '/letter_day';

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

  DateTime _focusedDay = DateTime.now();

  late Map<DateTime, List<Event>> kEventSource;

  final kEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

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
      if (selectedDay.isBefore(DateTime.now())) {
        showSnackBar(context, "편지는 내일부터 쓸 수 있어요");
        return;
      }
      if (_writeDays.contains(selectedDay)) {
        showSnackBar(context, "이미 편지를 썼어요");
      } else {
        ref.watch(selectedDate.notifier).state =
            DateFormat.yMMMd().format(selectedDay);
        ref.watch(selectedDateTime.notifier).state = selectedDay;
        context.pushNamed(LetterCreateScreen.routeName);
      }
      print(_selectedDays);
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);

    print("_onDaySelected");
  }

  final String iOSId4 = 'ca-app-pub-5897230132206634/2698132449';
  final String androidId4 = 'ca-app-pub-5897230132206634/2588066206';
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

    BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? iOSId4 : androidId4,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // logger.d('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    ).load();
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
        title: const Text(
          '편지를 보낼 날짜를 고르세요',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: lettersList.when(
              data: (data) {
                for (var letter in data) {
                  _writeDays.add(letter.messagedatetime);
                }
                return TableCalendar<Event>(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  eventLoader: _getEventsForDay,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month'
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  selectedDayPredicate: (day) {
                    // Use values from Set to mark multiple days as selected
                    return _writeDays.contains(day);
                  },
                  onDaySelected: _onDaySelected,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  daysOfWeekHeight: 25,
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
          ),
          // const SizedBox(height: 8.0),
          // Expanded(
          //   child: ValueListenableBuilder<List<Event>>(
          //     valueListenable: _selectedEvents,
          //     builder: (context, value, _) {
          //       return ListView.builder(
          //         itemCount: value.length,
          //         itemBuilder: (context, index) {
          //           return Container(
          //             margin: const EdgeInsets.symmetric(
          //               horizontal: 12.0,
          //               vertical: 4.0,
          //             ),
          //             decoration: BoxDecoration(
          //               border: Border.all(),
          //               borderRadius: BorderRadius.circular(12.0),
          //             ),
          //             child: ListTile(
          //               onTap: () => print('${value[index]}'),
          //               title: Text('${value[index]}'),
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
          if (_bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height > 800 ? 300 : 150,
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
    );
  }
}
