import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/design_constants.dart';
import '../wakeup/wakeup_status.dart';
import 'wake_write_screen.dart';
import 'wake_you_feed_screen.dart';

class WakeYouScreen extends ConsumerStatefulWidget {
  const WakeYouScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeYouScreenState();
}

class _WakeYouScreenState extends ConsumerState<WakeYouScreen> {
  final bool isWakeYou = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wake You')),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            50.heightBox,
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.blue, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
              ]),
              child: const Text('Wake You Screen'),
            ),
            SizedBox(
              // color: Colors.amber,
              height: 300,
              child: ListView.builder(
                itemCount: 2,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(WakeWriteScreen.routeName);
                    },
                    child: AnimatedOpacity(
                      opacity: isWakeYou ? 1.0 : 0.9,
                      duration: const Duration(seconds: 1),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.rabbitspeak,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
                            ]),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WakeUpStatus("길동이${AppLocalizations.of(context)!.wakeupyou}"),
                              AnimatedOpacity(
                                opacity: isWakeYou ? 1.0 : 0.3,
                                duration: const Duration(seconds: 1),
                                child: const Image(
                                  image: AssetImage('assets/images/rabbitwake.png'),
                                  height: Constants.pngSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).pSymmetric(h: 15, v: 15),
                    ),
                  );
                },
              ),
            ),
            const Expanded(child: WakeYouFeedScreen()),
          ],
        ),
      ),
    );
  }
}
