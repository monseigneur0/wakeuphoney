import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import 'match_controller.dart';

class MatchUpScreen extends ConsumerStatefulWidget {
  static String routeName = "Matchupscreen";
  static String routeURL = "/matchup";
  const MatchUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MatchUpScreenState();
}

class _MatchUpScreenState extends ConsumerState<MatchUpScreen> {
  static const tenMinutes = 3600;
  int totalSeconds = tenMinutes;
  bool isRunning = false;
  bool onceClickedMatch3 = false;

  late Timer timer;

//시간용
  void onTick(Timer timer) {
    if (totalSeconds < 1) {
      if (mounted) {
        setState(() {
          // totalSeconds = tenMinutes;
          onPausePressed();
        });
      }
    } else {
      if (mounted) {
        setState(() {});
      }
      totalSeconds = totalSeconds - 1;
      ref.watch(leftSecondsMatch.notifier).state = totalSeconds;
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  String format(int seconds) {
    if (ref.watch(leftSecondsMatch) <= seconds) {
      seconds = ref.watch(leftSecondsMatch);
    }

    var duration = Duration(seconds: seconds);
    // print("duration1 $duration");
    return duration.toString().split(".").first.substring(2, 7);
  }
//시간용 끝

  final TextEditingController _honeyCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    onStartPressed();
  }

  @override
  void dispose() {
    totalSeconds = 0;
    _honeyCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leftTime = ref.watch(leftSecondsMatch);
    final onceClickedMatch2 = ref.watch(onceClickedMatch);
    late String wow;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text("match upppppppp"),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "서로의 초대코드를 입력하면 연결돼요.",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "내 초대코드 (남은시간) ${format(totalSeconds)} ",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              enabled: false,
              initialValue: ref.watch(getMatchCodeViewProvider).when(
                    data: (data) => wow = data.vertifynumber.toString(),
                    error: (error, stackTrace) => "error",
                    loading: () => "Loading",
                  ),
              style: const TextStyle(fontSize: 40, color: Colors.white),
              maxLength: 6,
              // textInputAction: wow,반드시 설ㅓ할 것
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                labelStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(fontSize: 30, color: Colors.white),
                focusColor: Colors.red,
                border: InputBorder.none,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey[800])),
                  onPressed: () {
                    setState(() {
                      isRunning ? null : onStartPressed();
                      print("onceClicked $onceClickedMatch2");
                      onceClickedMatch2
                          ? null
                          : ref
                              .watch(matchConrollerProvider.notifier)
                              .matchProcess();
                      onceClickedMatch2
                          ? totalSeconds = leftTime
                          : totalSeconds = tenMinutes;
                      ref.watch(onceClickedMatch.notifier).state = true;
                    });
                  },
                  child: const Icon(Icons.refresh),
                  // child: Text(AppLocalizations.of(context)!.generateauthcode),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "상대의 초대코드를 전달받았나요?",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.black,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  // textInputAction: wow,반드시 설ㅓ할 것
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "") {
                      return null;
                    } else {
                      if (value.length < 6 ||
                          value.length > 6 ||
                          value == wow) {
                        return null;
                      }
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _honeyCodeController,
                  cursorColor: Colors.white,

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    labelText: '초대코드 입력',
                    labelStyle: const TextStyle(color: Colors.grey),

                    hintText: '000000',
                    hintStyle:
                        const TextStyle(fontSize: 30, color: Colors.grey),
                    focusColor: Colors.red,
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.black, width: 2.0),
                    // ),
                    // enabledBorder: const OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.green, width: 2.0),
                    // ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFFD72499))),
                  onPressed: () {
                    if (_honeyCodeController.text.isNotEmpty) {
                      final int honeyCode =
                          int.parse(_honeyCodeController.text);
                      if (_formKey.currentState!.validate()) {
                        ref.watch(checkMatchProcessProvider(honeyCode)).when(
                            data: (data) {
                              if (data.uid.isNotEmpty) {
                                ref
                                    .watch(matchConrollerProvider.notifier)
                                    .matchCoupleIdProcessDone(data.uid);
                                print(data.uid);
                                // PEaTihL8yRdGEknlFfQ9F7XdoUt2 apple
                                _honeyCodeController.clear();
                                showSnackBar(context, "inviteed");
                                Navigator.pop(context);
                              }
                            },
                            error: (error, stacktrace) =>
                                showSnackBar(context, "no invited honey"),
                            loading: () => const Loader());
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.connectwith),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
