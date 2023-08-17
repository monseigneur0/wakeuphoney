import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    print("duration1 $duration");
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

    final startTime =
        ref.watch(getMatchCodeViewProvider).whenData((value) => value.time);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text("match upppppppp"),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
          Text(
            ref.watch(getMatchCodeViewProvider).when(
                  data: (data) => data.vertifynumber.toString(),
                  error: (error, stackTrace) {
                    print("error getMatchCodeViewProvider   $error ");
                    ref
                        .watch(getNewMatchCodeViewProvider)
                        .whenData((value) => value.vertifynumber.toString());
                    return "error ";
                  },
                  loading: () => "const Loader()",
                ),
            style: const TextStyle(color: Colors.white, fontSize: 50),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.grey[800])),
            onPressed: () {
              setState(() {
                isRunning ? null : onStartPressed();
                print("onceClicked $onceClickedMatch2");
                onceClickedMatch2
                    ? null
                    : ref.watch(matchConrollerProvider.notifier).matchProcess();
                onceClickedMatch2
                    ? totalSeconds = leftTime
                    : totalSeconds = tenMinutes;
                ref.watch(onceClickedMatch.notifier).state = true;
              });
            },
            child: Text(AppLocalizations.of(context)!.generateauthcode),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "상대의 초대코드를 전달받았나요?",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "") {
                        return 'Please enter invite code';
                      } else {
                        if (value.length < 6 || value.length > 6) {
                          return '6 numbers required';
                        }
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _honeyCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Write 6 numbers',
                      hintText: '123456',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFFD72499))),
            onPressed: () {
              if (_honeyCodeController.text.isNotEmpty) {
                final int honeyCode = int.parse(_honeyCodeController.text);
                if (_formKey.currentState!.validate()) {
                  ref
                      .watch(checkMatchProcessProvider(honeyCode))
                      .when(data: if(data.hasValue) {
                        showSnackBar(context, "inviteed");
                        _honeyCodeController.clear();
                        // PEaTihL8yRdGEknlFfQ9F7XdoUt2 apple
                        ref
                        .watch(matchConrollerProvider.notifier)
                        .matchCoupleIdProcessDone(honeyCode);
                      }, error: (error, stacktrace) =>  showSnackBar(context, "no invited honey");, 
                            loading: () => const Loader();
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.connectwith),
          ),
        ],
      ),
    );
  }
}
