import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grasrota/models/storedData.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/screens/wrapper.dart';
import 'package:grasrota/services/database.dart';
import 'package:grasrota/services/firebase_api.dart';
import 'package:grasrota/shared/getToken.dart';
import 'package:grasrota/shared/loading.dart';
import 'package:grasrota/utils.dart';
import 'package:provider/provider.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
late Map? token = {};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _firebaseMessaging.subscribeToTopic('allUsers');
  await FirebaseApi.initNotifications();

  //firebaseCloudMessaging_Listeners();
  StoredData.checkedStat = null;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void notNewUser() {
    setState(() {});
  }

  Future getUserToken() async {
    User? user = FirebaseAuth.instance.currentUser!;

    if (user != null) {
      return user.getIdToken().then((token) => token).catchError((err) => "");
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return FutureBuilder(
        future: getToken(),
        builder: (cnt, snapshot) {
          if (snapshot.hasData) {;
            /*if (snapshot.data == "nyuser") {
              return Materi*/
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  return FutureBuilder(
                      future: getUserToken(),
                      builder: (context, snapshot2) {
                        switch (snapshot2.connectionState) {
                          case ConnectionState.done:
                            return StreamProvider<UserModal?>.value(
                                value: DatabaseService().userDataStream(
                                    snapshot.data, snapshot2.data.toString()),
                                // ignore: missing_return
                                catchError: (context, obj) {},
                                initialData: UserModal(
                                    isAdmin: false,
                                    uid: "",
                                    name: "",
                                    org: "",
                                    played: [],
                                    price: 0,
                                    profileImg: "",
                                    score: 0,
                                    tlf: "",
                                    uidtoken: ""),
                                child: MaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  home: Wrapper(),
                                  navigatorKey: Utils.navigatorKey,
                                ));
                          default:
                            return MaterialApp(home: Loading());
                        }
                      });
                });
            //}
          }
          return MaterialApp(home: Loading() //Text("har ikke data main.dart"),
              );
        });
  }
}

// ignore: non_constant_identifier_names
void firebaseCloudMessaging_Listeners() {
  if (Platform.isIOS) iOS_Permission();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    print('on message $message');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("onMessageOpenedApp: $message");
  });

  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    print("onBackgroundMessage: $message");
  });
}

// ignore: non_constant_identifier_names
void iOS_Permission() {
  FirebaseMessaging.instance
      .requestPermission(sound: true, badge: true, alert: true);
}
