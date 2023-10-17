import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:grasrota/screens/authenticate/register.dart';
import 'package:grasrota/screens/authenticate/sign_in.dart';
import 'package:grasrota/services/auth.dart';
import 'package:grasrota/shared/button.dart';
import 'package:grasrota/shared/loading.dart';
import 'package:flutter/services.dart';

class Welcome extends StatefulWidget {
  final Function toggleView;
  Welcome({required this.toggleView});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : WillPopScope(
            // ignore: missing_return
            onWillPop: () {
              return widget.toggleView(0);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Image.asset("assets/logo2.png"),
                          ),
                          // const SizedBox(height: 20),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: const Text(
                                "Velkommen til Grasrota",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                            ),
                          ),

                          Align(
                            child: const Text(
                              "appen som gjør det enkelt og gøy å delta i ukentlig quiz konkurranse!",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 60),
                          MyButton(
                            text: "Kom i gang",
                            onTap: () async {
                              HapticFeedback.heavyImpact();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignIn(toggleView: widget.toggleView)),
                              );
                              //widget.toggleView(1);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
