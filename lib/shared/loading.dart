import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grasrota/screens/authenticate/authenticate.dart';
import 'dart:async';

import 'package:grasrota/services/auth.dart';

class Loading extends StatefulWidget {
  final bool isWaiting;
  final String mld;
  Loading({this.isWaiting = false, this.mld = ""});
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late Timer _timer;

  int _start = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            const SpinKitDoubleBounce(
              color: Colors.cyan,
              size: 50,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.mld,
                  textScaleFactor: 1.0,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
              ],
            ))
          ],
        ),
      ),
    );
  }

  // void startTimer() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) => setState(
  //       () async {
  //         if (_start < 1) {
  //           try {
  //             timer.cancel();
  //             await AuthService().signOut();
  //             print("loading: logget ut");
  //             Navigator.pushReplacement(context,
  //                 MaterialPageRoute(builder: (context) => Authenticate()));
  //           } catch (e) {
  //             print(e);
  //           }
  //         } else {
  //           _start = _start - 1;
  //         }
  //       },
  //     ),
  //   );
  // }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start < 1) {
          timer.cancel();
          // Delay the sign-out process by 1 second
          Future.delayed(Duration(seconds: 1), () async {
            try {
              await AuthService().signOut();
              print("loading: logget ut");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            } catch (e) {
              print(e);
            }
          });
        } else {
          setState(() {
            _start = _start - 1;
          });
        }
      },
    );
  }


  @override
  void initState() {
    if (!widget.isWaiting) {
      startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!widget.isWaiting) {
      _timer.cancel();
    }
    super.dispose();
  }
}
