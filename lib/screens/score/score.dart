import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grasrota/models/userscore.dart';
import 'package:grasrota/screens/score/topTile.dart';
import 'package:grasrota/shared/constants.dart';
import 'package:grasrota/screens/score/scoreTile.dart';
import 'package:provider/provider.dart';

import '../index/credImage.dart';

class Score extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? firstPlc, secondPlc, thirdPlc;
  final Map? cred;
  Score(
      {required this.firstPlc,
      required this.secondPlc,
      required this.thirdPlc,
      required this.cred});

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<List<UserScore>>(context);
    return Scaffold(
        backgroundColor: const Color.fromRGBO(10, 203, 238, 1),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: const Radius.circular(40),
                          bottomRight: const Radius.circular(40),
                        ),
                        child: Image.asset("assets/bakgrunn.png"),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 75),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CredImage(cred: widget.cred, width: 30),
                            const SizedBox(width: 10),
                            const Text(
                              "Spillere i klubben",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 140),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            widget.secondPlc != null
                                ? TopTile(
                                    nr: "2",
                                    score:
                                        widget.secondPlc!["score"].toString(),
                                    col: const Color.fromRGBO(9, 157, 184, 1),
                                    height: 180,
                                    img: widget.secondPlc!["image"],
                                    name: widget.secondPlc!["name"],
                                  )
                                : const SizedBox(),
                            widget.firstPlc != null
                                ? TopTile(
                                    nr: "1",
                                    score: widget.firstPlc!["score"].toString(),
                                    col: const Color.fromRGBO(17, 126, 146, 1),
                                    height: 220,
                                    img: widget.firstPlc!["image"],
                                    name: widget.firstPlc!["name"],
                                  )
                                : const SizedBox(),
                            widget.thirdPlc != null
                                ? TopTile(
                                    nr: "3",
                                    score: widget.thirdPlc!["score"].toString(),
                                    col: const Color.fromRGBO(69, 171, 190, 1),
                                    height: 150,
                                    img: widget.thirdPlc!["image"],
                                    name: widget.thirdPlc!["name"],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: user != null && user.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height -
                                            504),
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: user.length,
                                  itemBuilder: (ctn, index) {
                                    return ScoreTile(
                                        user: user[index], index: index + 4);
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 504,
                            alignment: Alignment.center,
                            child: const Text(
                              "Ingen flere medlemmer",
                              textScaleFactor: 1.0,
                            )),
                  ),
                ],
              ),
            ),
            back(context),
          ],
        ));
  }
}
