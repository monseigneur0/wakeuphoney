import 'package:alarm/alarm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

import 'package:wakeuphoney/common/common.dart';

class AlarmEditScreen extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  const AlarmEditScreen({Key? key, this.alarmSettings}) : super(key: key);

  @override
  State<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  bool loading = false;

  late bool creating;
  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late bool showNotification;
  late String assetAudio;

  late List<bool> days;

  // late AlarmDaySettings alarmDaySettings = AlarmDaySettings(alarmSettings: widget.alarmSettings);

  late TimeOfDay selectedTime;
  late Time _time;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      selectedTime = TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minute);
      loopAudio = true;
      vibrate = true;
      volume = null;
      showNotification = true;
      assetAudio = 'assets/marimba.mp3';
      days = <bool>[
        true,
        false,
        true,
        false,
        true,
        false,
        true,
      ];
    } else {
      selectedTime = TimeOfDay(
        hour: widget.alarmSettings!.dateTime.hour,
        minute: widget.alarmSettings!.dateTime.minute,
      );
      selectedDateTime = widget.alarmSettings!.dateTime;
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volume;
      showNotification =
          widget.alarmSettings!.notificationTitle.isNotEmpty && widget.alarmSettings!.notificationBody.isNotEmpty;
      assetAudio = widget.alarmSettings!.assetAudioPath;
      // days = widget.alarmSettings!.days;
    }
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == 2) {
      return 'After tomorrow';
    } else {
      return 'In $difference days';
    }
  }

  Future<void> pickTime() async {
    _time = Time(hour: selectedTime.hour, minute: selectedTime.minute);
    final res = await Navigator.of(context).push(showPicker(
      showSecondSelector: false,
      context: context,
      value: _time,
      onChange: onTimeChanged,
      minuteInterval: TimePickerInterval.ONE,
      iosStylePicker: true,
      minHour: 0,
      maxHour: 23,
      is24HrFormat: true,
      width: 360,
      // dialogInsetPadding:
      //     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
      hourLabel: ':',
      minuteLabel: ' ',
      // Optional onChange to receive value as DateTime
      onChangeDateTime: (DateTime dateTime) {
        // logger.d(dateTime);
        logger.d("[debug datetime]:  $dateTime");
      },
    ));
    logger.d(_time);

    //     showTimePicker(
    //   initialTime: selectedTime,
    //   context: context,
    // );
    if (res != null) {
      setState(() {
        selectedTime = _time.toTimeOfDay();
      });
    }
  }

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  AlarmSettings buildAlarmSettings() {
    final now = DateTime.now();
    final id = creating ? DateTime.now().millisecondsSinceEpoch % 100000 : widget.alarmSettings!.id;

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: volume,
      notificationTitle: 'wakeupgomalarm'.tr(),
      notificationBody: 'alarmringletter'.tr(),
      assetAudioPath: assetAudio,
      // days: days,
    );
    logger.d(alarmSettings);
    return alarmSettings;
  }

  void saveAlarm() {
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res) Navigator.pop(context, true);
    });
    setState(() => loading = false);
  }

  Future<void> deleteAlarm() async {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res) Navigator.pop(context, true);
    });
  }

  String intDayToEnglish(int day) {
    if (day % 7 == DateTime.monday % 7) return 'Monday';
    if (day % 7 == DateTime.tuesday % 7) return 'Tueday';
    if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
    if (day % 7 == DateTime.thursday % 7) return 'Thursday';
    if (day % 7 == DateTime.friday % 7) return 'Friday';
    if (day % 7 == DateTime.saturday % 7) return 'Saturday';
    if (day % 7 == DateTime.sunday % 7) return 'Sunday';
    throw '🐞 This should never have happened: $day';
  }

  printIntAsDay(int day) {
    logger.d('Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    // final DateSymbols dateSymbols = dateTimeSymbolMap()['$locale'];
    // final textDirection = getTextDirection(locale);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
                ]),
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'cancel'.tr(),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.primary600),
                  ),
                ).pSymmetric(h: 10, v: 5),
              ),
              Text(
                getDay(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black.withOpacity(0.8)),
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
                ]),
                child: TextButton(
                  onPressed: saveAlarm,
                  child: loading
                      ? const CircularProgressIndicator()
                      : Text(
                          'save'.tr(),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.primary600),
                        ),
                ).pSymmetric(h: 10, v: 5),
              )
            ],
          ),

          GestureDetector(
            onTap: pickTime,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
              ]),
              child: Text(
                selectedTime.format(context),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          // WeekdaySelector(
          //   onChanged: (v) {
          //     printIntAsDay(v);
          //     setState(() {
          //       days[v % 7] = !days[v % 7];
          //     });
          //     print(days);
          //   },
          //   values: days,
          //   // intl package uses 0 for Monday, but DateTime uses 1 for Monday,
          //   // so we need to make sure the values match
          //   firstDayOfWeek: dateSymbols.FIRSTDAYOFWEEK + 1,
          //   shortWeekdays: dateSymbols.STANDALONENARROWWEEKDAYS,
          //   weekdays: dateSymbols.STANDALONEWEEKDAYS,
          //   textDirection: textDirection,
          // ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'loopalarmaudio'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: loopAudio,
                  onChanged: (value) => setState(() => loopAudio = value),
                ),
              ],
            ).pSymmetric(h: 20, v: 10),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'vibrate'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: vibrate,
                  onChanged: (value) => setState(() => vibrate = value),
                ),
              ],
            ).pSymmetric(h: 20, v: 10),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'customvolume'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: volume != null,
                  onChanged: (value) => setState(() => volume = value ? 0.8 : null),
                ),
              ],
            ).pSymmetric(h: 20, v: 10),
          ),
          SizedBox(
            height: 30,
            child: volume != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        volume! > 0.7
                            ? Icons.volume_up_rounded
                            : volume! > 0.1
                                ? Icons.volume_down_rounded
                                : Icons.volume_mute_rounded,
                      ),
                      Expanded(
                        child: Slider(
                          value: volume!,
                          onChanged: (value) {
                            setState(() => volume = value);
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'sound'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (kDebugMode) Text('wow${assetAudio.split('/').last}'),
                DropdownButton(
                  value: assetAudio,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'assets/marimba.mp3',
                      child: Text('Marimba'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'assets/nature.mp3',
                      child: Text('Nature'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'assets/childhood.mp3',
                      child: Text('Childhood'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'assets/happylife.mp3',
                      child: Text('Happy Life'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'assets/mozart.mp3',
                      child: Text('Mozart'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'assets/nokia.mp3',
                      child: Text('Nokia'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'assets/one_piece.mp3',
                      child: Text('One Piece'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'assets/star_wars.mp3',
                      child: Text('Star Wars'),
                    ),
                  ],
                  onChanged: (value) => setState(() => assetAudio = value!),
                ),
              ],
            ).pSymmetric(h: 20, v: 10),
          ),
          if (!creating)
            TextButton(
              onPressed: deleteAlarm,
              child: Text(
                'deletealarm'.tr(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}

// TextDirection getTextDirection(Locale locale) {
//   // See GlobalWidgetsLocalizations
//   // TODO: there must be a better way to figure out whether a locale is RTL or LTR
//   const rtlLanguages = ['ar', 'fa', 'he', 'ps', 'sd', 'ur'];
//   return rtlLanguages.contains(locale.languageCode) ? TextDirection.rtl : TextDirection.ltr;
// }