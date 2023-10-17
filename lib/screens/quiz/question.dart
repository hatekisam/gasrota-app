import 'package:flutter/material.dart';
import 'package:grasrota/models/quizinfo.dart';
import 'package:grasrota/screens/quiz/countdowntimer.dart';

class Question extends StatelessWidget {
  final int totaltQuest;
  final int currentQuest;
  final int questWrong;
  final int questRight;
  final QuizInfo quizInfo;
  Question(
      {required this.currentQuest,
      required this.totaltQuest,
      required this.questRight,
      required this.questWrong,
      required this.quizInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        quizInfo.src["isImage"]
            ? Container(
                height: 310,
                constraints: BoxConstraints(
                    maxHeight: 310,
                    minWidth: MediaQuery.of(context).size.width),
                child: ClipRRect(
          borderRadius: BorderRadius.only(bottomLeft: const Radius.circular(40.0), bottomRight: const Radius.circular(40.0)),
          child: Image.network(quizInfo.src["src"], fit: BoxFit.cover)),
              )
            : const SizedBox(),
        Transform.translate(
          offset: quizInfo.src["isImage"]
              ? const Offset(0, -40)
              : const Offset(0, 0),
          child: Container(
            padding: const EdgeInsets.all(25),
            width: MediaQuery.of(context).size.width - 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 4,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      questRight.toString(),
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: questRight.toDouble() / 10,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 1 - (questWrong.toDouble() / 10),
                        backgroundColor: Colors.red,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      questWrong.toString(),
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 30),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Spørsmål ${(currentQuest + 1).toString()}",
                          style: const TextStyle(
                            color: const Color.fromRGBO(34, 134, 177, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " / ${totaltQuest.toString()}",
                          style: const TextStyle(
                            color: const Color.fromRGBO(34, 134, 177, 1),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  quizInfo.question,
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Transform.translate(
            child: CountDownTimer(),
            offset: quizInfo.src["isImage"]
                ? quizInfo.question.length < 50 ? const Offset(0, -260) : const Offset(0, -280)
                : const Offset(0, -230)),
        const SizedBox(height: 20),
      ],
    );
  }
}
