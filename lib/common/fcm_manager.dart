import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';

import '../app.dart';

class FcmManager {
  static void requestPermission() {
    FirebaseMessaging.instance.requestPermission();
  }

  static Future<String> getPushToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      return token;
    }
    return '';
  }

  static void initialize() async {
    Logger logger = Logger();
    final token = await FirebaseMessaging.instance.getToken();
    logger.d(token);

    //Foreground
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title;
      if (title == null) {
        return;
      }
      logger.d(title);

      showToast(title);
    });

    //Background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      App.scaffoldMessengerKey.currentContext!.showToast(msg: message.notification?.title ?? "no title");
      // App.navigatorKey.currentState!.go(message.data['screen']);
    });

    //When app is closed -> initial launch
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await sleepUntil(
          () => App.scaffoldMessengerKey.currentContext != null && App.scaffoldMessengerKey.currentContext!.mounted);
      App.scaffoldMessengerKey.currentContext!.showToast(msg: initialMessage.notification?.title ?? "no title");
    }
  }
}

Future sleepUntil(bool Function() predict, [Duration duration = const Duration(milliseconds: 100)]) async {
  while (!predict()) {
    await Future.delayed(duration);
  }
}
