import 'package:flutter/material.dart';
import 'package:grasrota/models/quizinfo.dart';
// import 'package:grasrota/screens/quiz/answerTile.dart';
import 'package:grasrota/screens/quiz/quizwidgets.dart';

class AllAnswer extends StatefulWidget {
  final Function nextQuestion;
  final QuizInfo curQuiz;
  AllAnswer({required this.curQuiz, required this.nextQuestion});

  @override
  _AllAnswerState createState() => _AllAnswerState();
}

class _AllAnswerState extends State<AllAnswer> {

  @override
  Widget build(BuildContext context) {
    void changeAnswerState(int newnr) {
      setState(() {
        nr = newnr;
        isAnswerd = false;
        widget.nextQuestion(nr);
      });
    }

    return Column(
      children: [
        Container(
          child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                padding: const EdgeInsets.all(30),
                crossAxisCount: 2,
                children: [
                  // AnswerTile(
                  //   isAnswerd: changeAnswerState,
                  //   opt: "A",
                  //   answ: widget.curQuiz.ans1,
                  //   col: Colors.orange,
                  //   isCorrect: widget.curQuiz.ans1 == widget.curQuiz.answer,
                  // ),
                  // AnswerTile(
                  //   isAnswerd: changeAnswerState,
                  //   opt: "B",
                  //   answ: widget.curQuiz.ans2,
                  //   col: Colors.cyan,
                  //   isCorrect: widget.curQuiz.ans2 == widget.curQuiz.answer,
                  // ),
                  // AnswerTile(
                  //   isAnswerd: changeAnswerState,
                  //   opt: "C",
                  //   answ: widget.curQuiz.ans3,
                  //   col: Colors.green,
                  //   isCorrect: widget.curQuiz.ans3 == widget.curQuiz.answer,
                  // ),
                  // AnswerTile(
                  //   isAnswerd: changeAnswerState,
                  //   opt: "D",
                  //   answ: widget.curQuiz.ans4,
                  //   col: Colors.pink,
                  //   isCorrect: widget.curQuiz.ans4 == widget.curQuiz.answer,
                  // ),
                ],
              ),
        ),
      ],
    );
  }
}
