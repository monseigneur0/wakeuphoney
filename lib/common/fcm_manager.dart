import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/core/utils.dart';

import '../main.dart';

class FcmManager {
  static void requestPermission() {
    FirebaseMessaging.instance.requestPermission();
  }

  static void initialize() async {
    final token = await FirebaseMessaging.instance.getToken();
    // print(token);

    //Foreground
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title;
      if (title == null) {
        return;
      }
      showToast(title);
    });

    //Background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      WakeUpHoney.navigatorKey.currentContext!.showToast(msg: message.notification?.title ?? "no title");
      // WakeUpHoney.navigatorKey.currentState!.go(message.data['screen']);
    });

    //When app is closed -> initial launch
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await sleepUntil(
          () => WakeUpHoney.navigatorKey.currentContext != null && WakeUpHoney.navigatorKey.currentContext!.mounted);
      WakeUpHoney.navigatorKey.currentContext!.showToast(msg: initialMessage.notification?.title ?? "no title");
    }
  }
}

Future sleepUntil(bool Function() predict, [Duration duration = const Duration(milliseconds: 100)]) async {
  while (!predict()) {
    await Future.delayed(duration);
  }
}
