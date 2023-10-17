import 'package:flutter/material.dart';
import 'package:grasrota/models/quiz.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/screens/index/quizTile.dart';
import 'package:provider/provider.dart';

class QuizList extends StatelessWidget {
  final UserModal user;
  final Map? cred;
  QuizList({required this.user, required this.cred});

  @override
  Widget build(BuildContext context) {
    final quizes = Provider.of<List<QuizMod>>(context);
    final dateNow = DateTime.now();

    // print('aaaaaaaaaaaaaaaaaaaaaa ${quizes}');

    if (quizes == null) {
      return Container(
        child: Text(""),
      );
    } else {
      return Container(
          margin: const EdgeInsets.only(top: 320),
          child: quizes.length > 0
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: quizes.length,
                  shrinkWrap: true,
                  itemBuilder: (ctn, index) {
                    return QuizTile(
                        quiz: quizes[index], dateTime: dateNow, user: user, cred: cred);
                  },
                )
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
                  child: Center(child: Text("Ingen Spill I Dag ;(", style: const TextStyle(fontSize: 20),)),
                ));
    }
  }
}
