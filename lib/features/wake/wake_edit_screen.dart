import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/core/constants/design_constants.dart';

//이 페이지의 목적 alarm 을 상대에게 저장하기 위함. 울리거나 할 필요 전혀 없음 나중에 두 페이지를 합하거나 안돼있으면 빈공간으로 남겨서 어서 깨우고 싶게 만들어야함
class WakeEditScreen extends ConsumerStatefulWidget {
  const WakeEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeEditScreenState();
}

class _WakeEditScreenState extends ConsumerState<WakeEditScreen> {
  bool loading = false;

  late bool creating;
  late DateTime selectedDateTime = DateTime.now();
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late bool showNotification;
  late String assetAudio;

  late List<bool> days;

  late TimeOfDay selectedTime = TimeOfDay.now();
  late Time _time;
  var logger = Logger();

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    if (difference == 0) {
      return 'Only Today';
    } else if (difference == 1) {
      return 'Only Tomorrow';
    } else if (difference == 2) {
      return 'Only After tomorrow';
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

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(8, 8))
                    ]),
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.myPink),
                  ),
                ).pSymmetric(h: 10, v: 5),
              ),
              Text(
                getDay(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black.withOpacity(0.8)),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(8, 8))
                    ]),
                child: TextButton(
                  onPressed: () {},
                  child: loading
                      ? const CircularProgressIndicator()
                      : Text(
                          AppLocalizations.of(context)!.save,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: AppColors.myPink),
                        ),
                ).pSymmetric(h: 10, v: 5),
              )
            ],
          ),

          GestureDetector(
            onTap: pickTime,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(8, 8))
                  ]),
              child: Text(
                selectedTime.format(context),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.black, fontSize: 30),
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(8, 8))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.loopalarmaudio,
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(8, 8))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.vibrate,
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(8, 8))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.customvolume,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: volume != null,
                  onChanged: (value) =>
                      setState(() => volume = value ? 0.8 : null),
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(8, 8))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.sound,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.deletealarm,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}
