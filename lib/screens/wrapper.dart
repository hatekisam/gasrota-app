import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:grasrota/models/storedData.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/screens/authenticate/authenticate.dart';
import 'package:grasrota/screens/index/index.dart';
import 'package:grasrota/screens/missingData/missingCred.dart';
import 'package:grasrota/screens/missingData/providArgData.dart';
import 'package:grasrota/screens/settings/subscription.dart';
import 'package:grasrota/services/database.dart';
import 'package:grasrota/shared/getToken.dart';
import 'package:grasrota/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Wrapper extends StatefulWidget {
  final bool isWaiting;
  final String statusMld;
  Wrapper({this.isWaiting = false, this.statusMld = ""});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future checkCharge(UserModal? user) async {
    try {
      if (user != null) {
        if (user.isAdmin) {
          return "CHARGED";
        } else {
          if (StoredData.checkedStat == null ||
              DateTime.now()
                      .difference(StoredData.checkedStat ?? DateTime(0))
                      .inHours >=
                  1) {
                      return getToken().then((tokenJSON) async {
                        try {
                          final HttpsCallable callable =
                              FirebaseFunctions.instance.httpsCallable('checkCharge');
                          dynamic resp = await callable.call(<String, dynamic>{
                            "idToken": user.uidtoken,
                            "token": tokenJSON,
                          });
                          // print('&&&&&&&&&&&&&&&&&&&&&&&&&&&' + resp.data.toString());
                          if (resp.data == "DUE" || resp.data == "CHARGED") {
                            StoredData.checkedStat = DateTime.now();
                          }
                          return resp.data;
                        } catch (e) {
                          return FirebaseFirestore.instance
                              .collection("credent")
                              .doc()
                              .get()
                              .then((doc) {
                            return "";
                          }).catchError((onError) {
                            if (onError.code == 'permission-denied') {
                              return "nyabon";
                            }
                          });
                        }
                      });
          } else {
            print("du må vente");
            return "vent";
          }
        }
      }
    } catch (e) {
      return "";
    }
  }

  late bool waitingForAgre;
  bool retryFut = true;

  @override
  void initState() {
    handleDynamicLinks();
    super.initState();
  }

  UserModal? user;

  @override
  Widget build(BuildContext context) {
    waitingForAgre = widget.isWaiting;
    user = Provider.of<UserModal>(context);
    //this.initDynamicLinks(user);
    if (user == null) {
      return Authenticate();
    } else {
      return FutureBuilder(
        future: checkCharge(user),
        builder: (context, snapshot) {
          print('********************************95686106');
          print(snapshot.connectionState);
          print('********************************97538802');
          if (snapshot.connectionState == ConnectionState.done) {
            // debugPrint('111111111111111111111111111--' + snapshot.data.toString());
            if (snapshot.data == "DUE" ||
                snapshot.data == "CHARGED" ||
                snapshot.data == "vent" ||
                user!.isAdmin ||
                _deepLinkBypass) {
              return FutureBuilder(
                  future: DatabaseService(uid: "").isOrgActive(user!.org),
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      print('snapshot $snapshot');
                      print('org ${user!.org}');

                      if (snapshot.data == true) {
                        return IndexGrasrota();
                      } else {
                        print("TAG_ANDRA Moj Token " + user!.uidtoken);
                        launchUrl(Uri.parse(("https://grasrota.com/lisens?t=" +
                            user!.uidtoken)));

                        FirebaseFirestore.instance
                            .collection("org")
                            .doc(user!.org)
                            .snapshots()
                            .listen((DocumentSnapshot documentSnapshot) async {
                          if (documentSnapshot.get("isActive") == true) {
                            await closeInAppWebView().then((value) {
                              setState(() {});
                            });
                          }
                        });
                      }
                    }
                    return Loading();
                  });
            } else if (user!.org == "" || user!.price == 0) {
              // hvis brukeren mangler noe nyttig info
              print('22222222222222222222222222222222222');
              return ProvideArgData(user: user!);
            } else if (snapshot.data == "PENDING" && retryFut ||
                (widget.isWaiting && snapshot.data != "CANCELLED") &&
                    snapshot.data != "nyabon") {
              Future.delayed(Duration(seconds: 10), () {
                setState(() {
                  retryFut = false;
                });
                print("retry");
              });
            } else if (!waitingForAgre && retryFut ||
                snapshot.data == "CANCELLED") {
              print('retryFut----' + retryFut.toString());
              print('waitingForAgre----' + waitingForAgre.toString());
              print('CANCELLED----' + snapshot.data.toString());
              return MissingCred(user: user!);
            }
          }

          print(snapshot.data);
          String mld;
          if (snapshot.data == "PENDING") {
            mld = "Verifiserer abonnomentet ditt...";
          } else if (widget.statusMld != null) {
            mld = widget.statusMld;
          } else {
            mld = "";
          }
          return Loading(
            isWaiting: widget.isWaiting,
            mld: mld,
          );
        },
      );
    }
  }

/*
  void initDynamicLinks(user) async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      if (deepLink.path.contains("changeAgree") && user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Subscription(user: user)));
      }
    }

    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        if (deepLink.path.contains("agreeCon")) {
          setState(() {
            //_deepLinkBypass = true;
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Wrapper(
                        isWaiting: true,
                        statusMld: "Lager abonnoment...",
                      )));
        } else if (deepLink.path.contains("changeAgree") && user != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Subscription(user: user)));
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }
  */

  // void handleDynamicLinks() async {
  //   ///To bring INTO FOREGROUND FROM DYNAMIC LINK.
  //   FirebaseDynamicLinks.instance.onLink;
  //
  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   _handleDeepLink(data!);
  // }

  void handleDynamicLinks() async {
    // To bring INTO FOREGROUND FROM DYNAMIC LINK.
    FirebaseDynamicLinks.instance.onLink;

    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      _handleDeepLink(data);
    }
  }


  bool _deepLinkBypass = false;
  _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri? deepLink = data.link;
    print(deepLink);
    if (deepLink != null) {
      if (deepLink.path.contains("agreementConfirm")) {
        // setState(() {
        //   _deepLinkBypass = true;
        // });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Wrapper(
                      isWaiting: true,
                      statusMld: "Lager abonnoment...",
                    )));
      } else if (deepLink.path.contains("changeAgree") && user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Subscription(user: user!)));
      }
    }
  }
}
