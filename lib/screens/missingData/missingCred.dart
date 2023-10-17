import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grasrota/models/storedData.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/services/auth.dart';
import 'package:grasrota/shared/constants.dart';
import 'package:grasrota/shared/getToken.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../wrapper.dart';

class MissingCred extends StatefulWidget {
  final UserModal user;
  MissingCred({required this.user});

  @override
  _MissingCredState createState() => _MissingCredState();
}

class _MissingCredState extends State<MissingCred> {
  bool _isLoading = false;
  bool _loadWeb = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/confirm.png",
            height: 180,
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 5),
            child: const Text(
              "Du må bekrefte Fast Betaling for å kunne bruke appen vår.",
              textScaleFactor: 1.0,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 35),
          _isLoading
              ? SpinKitWave(
                  color: Colors.orange[900],
                  size: 37,
                )
              : TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _launchInApp();
                  },
                  child: Image.asset(
                    "assets/vippsknapp.png",
                    width: 210,
                  )),
          const SizedBox(height: 70),
          TextButton(
              onPressed: () async {
                await AuthService().signOut();
              },
              child: const Text(
                "AVBRYT",
                textScaleFactor: 1.0,
              ))
        ],
      ),
    );
  }

  _launchInApp() async {
    print("lag ny");
    StoredData.checkedStat = null;

    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString("savedToken") ?? await getToken();

    // await savedToken.then((tokenJSON) async {
      print('TAG_ANDRA token saved $savedToken');
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable("getNewAgree");

      // print("TAG_ANDRA Request ${callable.toString()}");

      var sub = getRandomString(9);

      print("TAG_ANDRA UserIdToken ${widget.user.uidtoken}");
      print("TAG_ANDRA tlf ${widget.user.tlf}");
      print("TAG_ANDRA price ${widget.user.price}");
      print("TAG_ANDRA token ${savedToken}");
      print("TAG_ANDRA sub ${sub}");
      print("TAG_ANDRA loadWeb ${_loadWeb}");

      dynamic res = await callable.call(<String, dynamic>{
        "idToken": widget.user.uidtoken,
        "tlf": widget.user.tlf,
        "price": widget.user.price,
        "token": savedToken,
        "sub": sub,
        "loadWeb": _loadWeb,
      }).then((value) {
        print("TAG_ANDRA Sta je mrtvi value? ${value.toString()}");
        print('TAG_ANDRA Data from value ${value.data}');
        // forceSafariVC: _loadWeb, forceWebView: _loadWeb
        launch(value.data, forceSafariVC: _loadWeb, forceWebView: _loadWeb)
            .then((value) {
          print('TAG_ANDRA resultfrompament $value');

          if (value == true) {
            setState(() {
              _isLoading = false;
            });

            // print(value);

            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Wrapper(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
          } else {
            print('TAG_ANDRA payment failed');
          }
        }).catchError((err) {
          setState(() {
            print("TAG_ANDRA Catch missing set web to true ehaaa");
            _loadWeb = true;
          });
        });
      }).catchError((err) {
        _isLoading = false;
        print("TAG_ANDRA Catch callable.call error " + err.toString());

      });


    //print(res.data);
    //});
  }
}
