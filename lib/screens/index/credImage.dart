import 'package:flutter/material.dart';

class CredImage extends StatelessWidget {
  final Map? cred;
  final double width;
  CredImage({required this.cred, required this.width});

  @override
  Widget build(BuildContext context) {
    //final difference = quiz.endTime.toDate().difference(dateTime).inDays;

    return ClipRRect(
      borderRadius: BorderRadius.circular(300.0),
      child: cred != null && cred!["img"] != null && cred!["img"] != ""
          ? Image.network(
              cred!["img"],
              height: width,
              width: width,
              fit: BoxFit.cover,
            )
          : Image.asset(
              "assets/icon.png",
              height: width,
              width: width,
              fit: BoxFit.cover,
            ),
    );
  }
}
