import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/common/common.dart';

import '../app.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

class FcmManager {
  static void requestPermission() {
    FirebaseMessaging.instance.requestPermission();
  }

  static void requestPermissionOneSignal() {
    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }

  static Future<String> getPushToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      return token;
    }
    return '';
  }

  static void initialize(WidgetRef ref) async {
    Logger logger = Logger();
    logger.d('FcmManager initialize');
    final token = await FirebaseMessaging.instance.getToken();
    logger.d(token);
    if (token != null) {
      ref.read(loginControllerProvider.notifier).updateFcmToken(token);
      logger.d('fcm token updated');
    }

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
