import 'package:flutter/material.dart';

class WeekSum extends StatelessWidget {
  final String week, score, year;
  WeekSum({required this.score, required this.week, required this.year});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 30),
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width - 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.orange,
          
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text("Score: ",textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Text(score,textScaleFactor: 1.0, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Text("Uke: ",textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Text(week,textScaleFactor: 1.0, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Text("År: ",textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Text(year,textScaleFactor: 1.0, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ]));
  }
}
