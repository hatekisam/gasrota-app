import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/screens/quiz/quizwidgets.dart';
import 'package:grasrota/services/database.dart';
import 'package:grasrota/shared/constants.dart';
import 'package:grasrota/shared/loading.dart';

import '../index/credImage.dart';

class Quiz extends StatefulWidget {
  final String quizId;
  final String date;
  final int week;
  final UserModal user;
  final Map? cred;
  Quiz(
      {required this.quizId,
      required this.user,
      required this.date,
      required this.week,
      required this.cred});

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  QuerySnapshot? questionSnapshot;
  DatabaseService databaseService = new DatabaseService();
  int total = 0;
  late int questIndex;
  late int _correct;
  late int _incorrect;
  late double timeLeft;

  @override
  void initState() {
    databaseService.getQuizData(widget.quizId).then((value) {
      questionSnapshot = value;
      total = questionSnapshot!.docs.length;

      var userData =
          DatabaseService(uid: widget.user.uid).getUserQuizData(widget.quizId);
      userData.then((document) {
        questIndex = document["questLength"];
        _correct = document["correct"];
        _incorrect = document["incorrect"];
        setState(() {});
      }).catchError((error, stackTrace) {
        questIndex = 0;
        _correct = 0;
        _incorrect = 0;
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (questionSnapshot == null) {
      return Loading();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Stack(
            alignment: Alignment.topCenter,            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 310,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: const Radius.circular(40),
                    bottomRight: const Radius.circular(40),
                  ),
                  child:
                      Image.asset("assets/bakgrunn.png", fit: BoxFit.fitWidth),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 30, top: 60),
                child: CredImage(cred: widget.cred, width: 50),
              ),
              QuizWidgets(
                  quiz: questionSnapshot!,
                  totalt: total,
                  quizId: widget.quizId,
                  user: widget.user,
                  correct: _correct,
                  incorrect: _incorrect,
                  startCor: _correct,
                  questIndex: questIndex,
                  date: widget.date,
                  week: widget.week),
              back(context),
            ],
          ),
        ),
      );
    }
  }
}
