import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grasrota/screens/result/resultTile.dart';
import 'package:grasrota/screens/result/weekSum.dart';
import 'package:grasrota/shared/constants.dart';

class ResultList extends StatefulWidget {
  final QuerySnapshot quizes;
  ResultList({required this.quizes});

  @override
  _ResultListState createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {
  final Map<String, int> weeks = {};

  @override
  void initState() {
    widget.quizes.docs.forEach((doc) {
      String listName = doc["week"].toString() +
          "-" +
          doc["date"].split("-")[0];
      if (weeks[listName] != null) {
        weeks.update(listName, (value) => value + doc["score"] as int);
      } else {
        weeks[listName] = doc["score"];
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 130),
      itemCount: widget.quizes.docs.length,
      itemBuilder: (ctn, index) {
        if (index == 0 ||
            (widget.quizes.docs[index]["week"] !=
                widget.quizes.docs[index - 1]["week"])) {
          String listName =
              widget.quizes.docs[index]["week"].toString() +
                  "-" +
                  widget.quizes.docs[index]["date"].split("-")[0];
          return Column(
            children: [
              WeekSum(score: weeks[listName].toString(), week: widget.quizes.docs[index]["week"].toString(),year: widget.quizes.docs[index]["date"].split("-")[0],),
              ResultTile(quiz: widget.quizes.docs[index], month: getMonth(int.parse(widget.quizes.docs[index]["date"].split("-")[1])))
            ],
          );
        } else {
          return ResultTile(quiz: widget.quizes.docs[index], month: getMonth(int.parse(widget.quizes.docs[index]["date"].split("-")[1])));
        }
      },
    );
  }
}
