import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:vibration/vibration.dart';
// import 'package:audioplayers/audioplayers.dart';

back(ctn) {
  return Positioned(
    top: 60,
    left: 30,
    child: InkWell(
      onTap: () {
        HapticFeedback.heavyImpact();
        Navigator.pop(ctn);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(10)),
        child: Transform.translate(
          offset: const Offset(5, 0),
          child:
              const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
        ),
      ),
    ),
  );
}

settingCard(String title, IconData icon, Color color, String hero) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
    child: ListTile(
      title: Text(
        title,
        textScaleFactor: 1.0,
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[800]),
      ),
      leading: Hero(
          tag: hero,
          child: Container(
            child: Icon(
              icon,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: color),
            padding: const EdgeInsets.all(6),
          )),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[800]),
    ),
  );
}

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  hintStyle: TextStyle(
    fontSize: 14,
  ),
  filled: true,
  enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.cyan, width: 2.0)),
);

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

actionRespons(String txt, dynamic context, bool succeded) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
      duration: const Duration(seconds: 4),
      backgroundColor: succeded ? Colors.green : Colors.red));
}

getMonth(int monthNum) {
  const listMonth = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "Mai",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Okt",
    "Nov",
    "Des"
  ];
  return listMonth[monthNum - 1];
}

getProfileColor(int price) {
  switch (price ~/ 100) {
    case 100:
      return Color(0xffcd7f32);
    case 150:
      return Color(0xffc0c0c0);
    case 200:
      return Color(0xffd4af37);
    case 250:
      return Color(0xffe5e4e2);
    default:
      return Colors.white;
  }
}

// startEffect() {
//   Vibration.vibrate(duration: 250, amplitude: 128);
//   AudioPlayer().play(AssetSource('audio/click_sound.mp3'));
// }
