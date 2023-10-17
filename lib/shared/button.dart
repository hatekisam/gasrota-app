import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grasrota/shared/colors.dart';

class MyButton extends StatelessWidget {
  late String text;
  void Function()? onTap;

  MyButton({Key? key, required this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: AppColor.btnColor,
          // gradient: const LinearGradient(
          //     colors: const [Colors.cyan, Colors.greenAccent],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight),
        ),
        child: Text(text,
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
      onTap: onTap,
    );
  }
}
