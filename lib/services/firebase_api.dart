import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grasrota/screens/quiz/quizwidgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../models/usermodal.dart';
import '../screens/authenticate/authenticate.dart';
import '../screens/index/index.dart';
import '../utils.dart';

class FirebaseApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();
  static UserModal? user;
  static BuildContext? context;

  static final _androidChannel = const AndroidNotificationChannel(
      'High_impotance_channel', 'High Importance notifications',
      description: "This channel is used for impotant notification",
      importance: Importance.defaultImportance);

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title:  ${message.notification!.title}');
    print('Body:  ${message.notification!.body}');
    print('Payload:  ${message.data}');
  }

  static void handleNotification(RemoteMessage? message) {
    if (message == null) return null;
    user = Provider.of<UserModal>(context!);
    //this.initDynamicLinks(user);
    if (user == null) {
      Utils.navigatorKey.currentState!.push(
        PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Authenticate()),
      );
    } else {
      Utils.navigatorKey.currentState!.push(
        PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => IndexGrasrota()),
      );
    }
  }

  static Future initLocalNotifications() async {
    FirebaseMessaging.instance.subscribeToTopic('allUsers');
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher.png');

    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        final message = RemoteMessage.fromMap(jsonDecode(details.toString()));
        handleNotification(message);
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  static initPushNotification() async {
    FirebaseMessaging.instance.subscribeToTopic('allUsers');
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if (notification == null) return;

      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@drawable/ic_launcher.png'),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  static Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    // final FCMToken = await _firebaseMessaging.getToken();
    initPushNotification();
    initLocalNotifications();

    print('object');
    // print('fcmtoken $FCMToken');
  }
}
