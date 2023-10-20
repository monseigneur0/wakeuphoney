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

class Match3Screen extends ConsumerStatefulWidget {
  static String routeName = "Match3screen";
  static String routeURL = "/match3";
  const Match3Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Match3ScreenState();
}

class _Match3ScreenState extends ConsumerState<Match3Screen> {
  var logger = Logger();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _honeyCodeController = TextEditingController();
  final node = FocusNode();

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
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "서로의 초대코드를 입력하면 연결돼요.",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            ref.watch(getMatchCodeFutureProvider).when(
                  data: (data) {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "내 초대코드 (남은시간) ",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => const Text("error"),
                  loading: () => const Loader(),
                ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "상대의 초대코드를 전달받았나요?",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              child: TextFormField(
                key: _formKey,
                style: const TextStyle(fontSize: 30, color: Colors.white),
                keyboardType: TextInputType.number,
                maxLength: 6,
                // textInputAction: wow,반드시 설ㅓ할 것
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],

                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _honeyCodeController,
                cursorColor: Colors.white,

                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintText: '000000',
                  hintStyle: const TextStyle(fontSize: 30, color: Colors.grey),
                  focusColor: Colors.red,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
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
                        const MaterialStatePropertyAll(Color(0xFFD72499)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Color(0xFFD72499))),
                    ),
                  ),
                  onPressed: () {},
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
