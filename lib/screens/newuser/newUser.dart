import 'package:flutter/material.dart';

class NewUser extends StatefulWidget {
  final Function notNew;
  NewUser({required this.notNew});

  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "hei, du er en ny bruker",
            textScaleFactor: 1.0,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                widget.notNew();
              },
              child: Container(
                width: 150,
                height: 50,
                child: Center(
                  child: Text("Gå videre ->",
                      textScaleFactor: 1.0,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10)),
              ))
        ],
      )),
    );
  }
}