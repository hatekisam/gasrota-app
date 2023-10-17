import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:grasrota/models/quiz.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/screens/quiz/quiz.dart';
import 'package:grasrota/shared/constants.dart';

class QuizTile extends StatelessWidget {
  final QuizMod quiz;
  final DateTime dateTime;
  final UserModal user;
  final Map? cred;
  QuizTile({required this.quiz, required this.dateTime, required this.user, required this.cred});

  @override
  Widget build(BuildContext context) {

      return
        user.played.contains(quiz.id)
        ? SizedBox()
        : Container(
        margin: const EdgeInsets.only(bottom: 30),
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width - 45,
        height: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 4,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 5, color: const Color.fromRGBO(17, 198, 230, 1)),
                  ),
                  child: Text(
                    quiz.date.split("-")[2],
                    textScaleFactor: 1.0,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(17, 198, 230, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  getMonth(int.parse(quiz.date.split("-")[1])),
                  textScaleFactor: 1.0,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(17, 198, 230, 1),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Ukens quiz",
                  textScaleFactor: 1.0,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                user.played.contains(quiz.id)
                    ? const SizedBox()
                    : TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Quiz(
                              quizId: quiz.id,
                              user: user,
                              date: quiz.date,
                              week: quiz.week,
                              cred: cred,
                            )));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 37,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(colors: const [
                        Colors.yellow,
                        Colors.orangeAccent
                      ]),
                    ),
                    child: const Text(
                      "START",
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  }
}
