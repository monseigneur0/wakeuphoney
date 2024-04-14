import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:wakeuphoney/common/common.dart';

//샘플 페이지 디자인용
class AlarmNewScreen extends StatelessWidget {
  static String routeName = "alarmnewring";
  static String routeURL = "/alarmnewring";

  const AlarmNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("이렇게 보일 거에요"),
              Text(
                DateFormat("yyyy년 MM월 dd일 ").format(DateTime.now()),
                style: const TextStyle(fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                        child: Image(
                          image: const AssetImage("assets/images/rabbitalarm.jpeg"),
                          height: MediaQuery.of(context).size.width * .8,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.wakeupletter,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Image(
                        image: const AssetImage("assets/ic_launcher.png"),
                        height: MediaQuery.of(context).size.width / 4,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: const ButtonStyle(
                          iconSize: MaterialStatePropertyAll(30),
                          backgroundColor: MaterialStatePropertyAll(Colors.grey),
                        ),
                        onPressed: () {
                          context.pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                          child: const Text(
                            "종료하기",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                      // hasCoupleId.when(
                      //   data: (data) {
                      //     return
                      ElevatedButton(
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColors.myPink)),
                        onPressed: () {
                          // context.goNamed(ResponseScreen.routeName);
                          context.pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                          child: const Text(
                            "답장하기",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                      // },
                      // error: (error, stackTrace) => Container(),
                      // loading: () => const Loader(),
                      // ),
                    ],
                    // CachedNetworkImage(
                    //       imageUrl: user.couplePhotoURL!),
                  ),
                  30.heightBox,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
