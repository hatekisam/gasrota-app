// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:grasrota/screens/quiz/allanswer.dart';
// import 'package:grasrota/screens/quiz/quizwidgets.dart';
// // import 'package:pimp_my_button/pimp_my_button.dart';
//
// class AnswerTile extends StatefulWidget {
//   final Function isAnswerd;
//   final String answ;
//   final String opt;
//   final Color col;
//   final bool isCorrect;
//   AnswerTile(
//       {required this.col,
//       required this.opt,
//       required this.answ,
//       required this.isAnswerd,
//       required this.isCorrect});
//   @override
//   _AnswerTileState createState() => _AnswerTileState();
// }
//
// class _AnswerTileState extends State<AnswerTile> {
//   Border bord = Border.all(color: Colors.transparent, width: 5);
//   Color cardBacColor = Colors.white;
//   dynamic cardContent;
//
//   @override
//   Widget build(BuildContext context) {
//     if (!isAnswerd) {
//       cardBacColor = Colors.white;
//       bord = Border.all(color: Colors.transparent, width: 5);
//       cardContent = Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 22,
//             backgroundColor: widget.col,
//             child: Text(
//               widget.opt,
//               textScaleFactor: 1.0,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           Text(
//             widget.answ,
//             textScaleFactor: 1.0,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       );
//     }
//   return ;
//     // return PimpedButton(
//         // particle: Rectangle2DemoParticle(),
//         // pimpedWidgetBuilder: (context, cont) {
//         //   return InkWell(
//         //     onTap: () {
//         //       HapticFeedback.heavyImpact();
//         //       if (!isAnswerd) {
//         //         setState(() {
//         //           if (widget.isCorrect) {
//         //             bord = Border.all(color: Colors.green, width: 5);
//         //             cardBacColor = Colors.green;
//         //             cont.forward(from: 0.0);
//         //           } else {
//         //             bord = Border.all(color: Colors.red, width: 5);
//         //             cardBacColor = Colors.red;
//         //           }
//         //           cardContent = Center(
//         //             child: Icon(
//         //               widget.isCorrect ? Icons.done : Icons.close,
//         //               size: 40,
//         //               color: Colors.white,
//         //             ),
//         //           );
//         //           Future.delayed(const Duration(milliseconds: 1250), () {
//         //             widget.isAnswerd(widget.isCorrect ? 1 : 0);
//         //           });
//         //           isAnswerd = true;
//         //           controller.stop();
//         //         });
//         //       }
//         //     },
//         //     child: Container(
//         //         decoration: BoxDecoration(
//         //           borderRadius: BorderRadius.circular(20),
//         //           color: cardBacColor,
//         //           border: bord,
//         //           boxShadow: [
//         //             BoxShadow(
//         //               blurRadius: 5,
//         //               color: Colors.black.withOpacity(0.07),
//         //               spreadRadius: 4,
//         //               offset: const Offset(0, 3),
//         //             )
//         //           ],
//         //         ),
//         //         child: cardContent),
//         //   );
//         // }
//         // );
//   }
// }
