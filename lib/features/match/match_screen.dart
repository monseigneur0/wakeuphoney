import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import '../profile/couple_profile_screen.dart';
import 'match_controller.dart';

class MatchScreen extends ConsumerStatefulWidget {
  static String routeName = "Matchscreen";
  static String routeURL = "/match";
  const MatchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  bool _visible = false;

  static const tenMinutes = 600;
  int totalSeconds = tenMinutes;
  bool isRunning = false;
  bool onceClickedMatch3 = false;

  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds < 1) {
      if (mounted) {
        setState(() {
          // totalSeconds = tenMinutes;
          onPausePressed();
          _visible = false;
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
    print("duration $duration");
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  void initState() {
    super.initState();
    _visible = false;
  }

  final TextEditingController _honeyCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final leftTime = ref.watch(leftSecondsMatch);
    final onceClickedMatch2 = ref.watch(onceClickedMatch);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.connectto,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/alarmbearno.png',
                height: 100,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _visible
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == "") {
                                return 'Please enter honey code';
                              } else {
                                if (value.length < 6 || value.length > 6) {
                                  return 'not 6 numbers';
                                }
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _honeyCodeController,
                            decoration: const InputDecoration(
                              labelText: 'Write 6 numbers',
                              hintText: '123456',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            _visible
                ? Container()
                : ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFFD72499))),
                    onPressed: () {
                      if (_honeyCodeController.text.isNotEmpty) {
                        final int honeyCode =
                            int.parse(_honeyCodeController.text);
                        if (_formKey.currentState!.validate()) {
                          if (ref
                              .watch(checkMatchProcessProvider(honeyCode))
                              .hasValue) {
                            showSnackBar(context, "matched");
                            ref
                                .watch(checkMatchProcessProvider(honeyCode))
                                .when(
                                  data: (data) => ref
                                      .watch(coupleIdStateProvider.notifier)
                                      .state = data.uid,
                                  error: (error, stackTrace) {
                                    print("error$error ");
                                  },
                                  loading: () => const Loader(),
                                );
                            _honeyCodeController.clear();
                            ref
                                .watch(matchConrollerProvider.notifier)
                                .matchCoupleIdProcessDone(honeyCode);
                          } else {
                            showSnackBar(context, "no matching honey");
                          }
                        }
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.connectwith),
                  ),
            const SizedBox(
              height: 50,
            ),
            _visible
                ? Container()
                : ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.grey[800])),
                    onPressed: () {
                      // Call setState. This tells Flutter to rebuild the
                      // UI with the changes.
                      setState(() {
                        _visible = !_visible;
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
                    child: Text(AppLocalizations.of(context)!.generateauthcode),
                  ),
            AnimatedOpacity(
              // If the widget is visible, animate to 0.0 (invisible).
              // If the widget is hidden, animate to 1.0 (fully visible).
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100000),
              // The green box must be a child of the AnimatedOpacity widget.
              child: Column(
                children: [
                  Text(
                    ref.watch(getMatchCodeViewProvider).when(
                          data: (data) => (data.vertifynumber.toString()),
                          error: (error, stackTrace) {
                            print("error getMatchCodeViewProvider   $error ");
                            return "error ";
                          },
                          loading: () => "const Loader()",
                        ),
                    style: const TextStyle(color: Colors.white, fontSize: 50),
                  ),
                  // Text(
                  //   ref.watch(getMatchCodeViewProvider).when(
                  //         data: (data) => (data.time.toString()),
                  //         error: (error, stackTrace) {
                  //           print(
                  //               "error getMatchCodeViewProvider   $error ");
                  //           return "error ";
                  //         },
                  //         loading: () => "const Loader()",
                  //       ),
                  // ),
                  Text(
                    format(totalSeconds),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            !_visible
                ? Container()
                : ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFFD72499))),
                    onPressed: () {
                      isRunning ? null : onStartPressed();
                      // Call setState. This tells Flutter to rebuild the
                      // UI with the changes.
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                    child: const Text("view honey code")),
          ],
        ),
      ),
      endDrawer: ProfileDrawer(ref: ref),
    );
  }
}
