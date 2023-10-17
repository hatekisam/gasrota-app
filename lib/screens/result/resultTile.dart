import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultTile extends StatelessWidget {
  final DocumentSnapshot quiz;
  final String month;
  ResultTile({required this.quiz, required this.month});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width - 45,
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
                  quiz["date"].split("-")[2] != null
                      ? quiz["date"].split("-")[2]
                      : "0",
                      textScaleFactor: 1.0,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(17, 198, 230, 1),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                month == null ? "" : month,
                textScaleFactor: 1.0,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(17, 198, 230, 1),
                ),
              ),
            ],
          ),
          const SizedBox(width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                          (quiz["correct"] + quiz["incorrect"])
                              .toString(),
                              textScaleFactor: 1.0,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Besvart",
                      textScaleFactor: 1.0,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500]))
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(quiz["correct"].toString(),
                      textScaleFactor: 1.0,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      Text("Riktig",
                      textScaleFactor: 1.0,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500]))
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(quiz["incorrect"].toString(),
                      textScaleFactor: 1.0,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      Text("Feil",
                      textScaleFactor: 1.0,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500]))
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.grey.withOpacity(.5),
                height: 1.5,
                width: MediaQuery.of(context).size.width * .47,
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: quiz["score"].toString(),
                    style: const TextStyle(
                      color: const Color.fromRGBO(34, 134, 177, 1),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: " poeng",
                    style: const TextStyle(
                      color: const Color.fromRGBO(34, 134, 177, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}
