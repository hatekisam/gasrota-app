import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/screens/result/resultlist.dart';
import 'package:grasrota/services/database.dart';
import 'package:grasrota/shared/constants.dart';

class Result extends StatefulWidget {
  final UserModal user;
  Result({required this.user});

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  QuerySnapshot? questionSnapshot;

  @override
  void initState() {
    DatabaseService(uid: widget.user.uid).getQuizesStats().then((value) {
      questionSnapshot = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 203, 238, 1),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: const Radius.circular(40),
              bottomRight: const Radius.circular(40),
            ),
            child: Image.asset("assets/bakgrunn.png"),
          ),
          questionSnapshot != null && questionSnapshot!.docs.isNotEmpty
              ? Container(
                  child: ResultList(quizes: questionSnapshot!),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 220),
                  child: const Text(
                    "Listen er tom",
                    textScaleFactor: 1.0,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
          back(context),
        ],
      ),
    );
  }
}
