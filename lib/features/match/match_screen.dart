import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import '../../core/constants/design_constants.dart';
import 'drawer.dart';
import 'match_controller.dart';

class MatchScreen extends ConsumerStatefulWidget {
  static String routeName = "Matchscreen";
  static String routeURL = "/match";
  const MatchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  var logger = Logger();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _honeyCodeController = TextEditingController();

  int randomNum = 0;

  @override
  void dispose() {
    _honeyCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //singlechildscrollview 위젯이 이동한다
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.myAppBarBackgroundPink,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.connectto,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: AppColors.myBackgroundPink,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              "서로의 초대코드를 입력하면 연결돼요.",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            ref.watch(getMatchCodeFutureProvider).when(
                  data: (data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "내 초대코드 (1시간 유효) ",
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          enabled: false,

                          initialValue: data.vertifynumber.toString(),

                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          maxLength: 6,
                          // textInputAction: wow,반드시 설ㅓ할 것 enter누르면 편하니
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[900],
                            labelStyle: const TextStyle(color: Colors.black),
                            focusColor: Colors.red,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => const Text("error"),
                  loading: () => const Loader(),
                ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "상대의 초대코드를 전달받았나요?",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  style: const TextStyle(fontSize: 20, color: Colors.white),
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
                      if (value.length < 6 || value.length > 6
                          // || value == wow
                          ) {
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
                    // labelText: '초대코드 입력',
                    labelStyle: const TextStyle(color: Colors.grey),

                    hintText: '000000',
                    hintStyle:
                        const TextStyle(fontSize: 20, color: Colors.grey),
                    focusColor: Colors.red,
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.black, width: 2.0),
                    // ),
                    // enabledBorder: const OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.green, width: 2.0),
                    // ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(AppColors.myPink),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Color(0xFFD72499))),
                    ),
                  ),
                  onPressed: () {
                    // to delete
                    // ref
                    //     .watch(matchConrollerProvider.notifier)
                    //     .matchProcess();
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
                                logger.d(data.uid);
                                // PEaTihL8yRdGEknlFfQ9F7XdoUt2 apple
                                _honeyCodeController.clear();
                                showSnackBar(context, "inviteed");
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
      endDrawer: ProfileDrawer(ref: ref),
    );
  }
}
