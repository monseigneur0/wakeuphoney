import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wakeuphoney/common/common.dart';

import '../app.dart';

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
      App.navigatorKey.currentContext!.showToast(msg: message.notification?.title ?? "no title");
      // App.navigatorKey.currentState!.go(message.data['screen']);
    });

    //When app is closed -> initial launch
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await sleepUntil(() => App.navigatorKey.currentContext != null && App.navigatorKey.currentContext!.mounted);
      App.navigatorKey.currentContext!.showToast(msg: initialMessage.notification?.title ?? "no title");
    }
  }
}

Future sleepUntil(bool Function() predict, [Duration duration = const Duration(milliseconds: 100)]) async {
  while (!predict()) {
    await Future.delayed(duration);
  }
}
