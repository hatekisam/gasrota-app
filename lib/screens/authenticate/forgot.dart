import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grasrota/screens/authenticate/sign_in.dart';
import 'package:grasrota/services/auth.dart';
import 'package:grasrota/shared/constants.dart';
import 'package:grasrota/shared/loading.dart';

class Forgot extends StatefulWidget {
  final Function toggleView;
  Forgot({required this.toggleView});

  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () {
              setState(() {
                widget.toggleView(1);
              });
              return new Future(() => true);
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
                        children: <Widget>[
                          //Image.asset("assets/logo.png", width: 100),
                          const SizedBox(height: 20),
                          MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              textScaleFactor: 1.0,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: textInputDecoration.copyWith(
                                  hintText: "Email"),
                              validator: (val) =>
                                  val!.isEmpty ? "Skriv inn en email" : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 225,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: const LinearGradient(
                                      colors: [Colors.cyan, Colors.greenAccent],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                ),
                                child: Text("Nullstill",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                              onTap: () async {
                                HapticFeedback.heavyImpact();
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.resetPassword(email);
                                  if (result == null) {
                                    setState(() {
                                      error = "Sjekk mailen din!";
                                      loading = false;
                                    });
                                  }
                                }
                              }),
                          const SizedBox(height: 20),
                          Text(error,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "husker passord? ",
                                  style: const TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: "logg inn",
                                  style: const TextStyle(
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold,
                                      height: 2.5),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      HapticFeedback.heavyImpact();
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                animation2) =>
                                                SignIn(
                                                    toggleView:
                                                    widget.toggleView)),
                                      );
                                    },
                                ),
                              ],
                            ),
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
