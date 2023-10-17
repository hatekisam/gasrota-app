import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grasrota/screens/settings/subscription.dart';

import 'forgot.dart';
import 'register.dart';
import 'sign_in.dart';
import 'welcome.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  int showSignIn = 4;
  void toggleView(int val) {
    setState(() => showSignIn = val);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (subScriResp != "") {
      return Scaffold(
          body: Center(
              child: InkWell(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    setState(() {
                      subScriResp = "";
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                        child: Container(
                      height: 310,
                      width: 300,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                textScaleFactor: 1.0,
                              ),
                              child: PopUpInfo(
                                msg: subScriResp,
                              ))),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[50],
                      ),
                    )),
                  ))));
    } else {
      if (showSignIn == 1) {
        return SignIn(toggleView: toggleView);
      } else if (showSignIn == 2) {
        return Forgot(toggleView: toggleView);
      } else if (showSignIn == 3) {
        return Register(toggleView: toggleView);
      } else if (showSignIn == 4) {
        return Welcome(toggleView: toggleView);
      }
      return Welcome(toggleView: toggleView);
    }
  }
}

class PopUpInfo extends StatelessWidget {
  final String msg;
  PopUpInfo({required this.msg});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              msg,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
            const Text("Trykk hvor som helst for å lukke",
                textScaleFactor: 1.0, textAlign: TextAlign.center),
          ],
        ),
      ],
    );
  }
}
