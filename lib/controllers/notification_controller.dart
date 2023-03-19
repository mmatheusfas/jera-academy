import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController {
  Future initializeNotification(FlutterLocalNotificationsPlugin notification) async {
    var androidInitialize = const AndroidInitializationSettings("mipmap/ic_launcher");
    var initializationSettings = InitializationSettings(android: androidInitialize);

    await notification.initialize(initializationSettings);
  }

  Future showNotification({var id = 0, required String title, required String body, var payLoad, required FlutterLocalNotificationsPlugin plugin}) async {
    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
      'android_channel_id',
      'android_channel',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var noti = NotificationDetails(android: androidDetails);
    await plugin.show(0, title, body, noti);
  }
}
