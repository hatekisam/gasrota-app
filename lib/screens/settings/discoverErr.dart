import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscoverErr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: "error",
                      child: Container(
                        color: Colors.yellow[600],
                        height: 150,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 30, top: 60),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(10)),
                          child: Transform.translate(
                            offset: const Offset(5, 0),
                            child: const Icon(Icons.arrow_back_ios,
                                color: Colors.white, size: 30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Transform.translate(
                  offset: Offset(0, -78),
                  child: const Text(
                    "Oppdaget en feil",
                    textScaleFactor: 1.0,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text("Emne",
                          textScaleFactor: 1.0,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black)),
                      const Text(
                        "Kort om problemet",
                        textScaleFactor: 1.0,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text("Melding",
                          textScaleFactor: 1.0,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black)),
                      const Text(
                        "Grundig beskrivelse av hvordan man kan gjenskape feilen",
                        textScaleFactor: 1.0,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),
                      const Text(
                        "Ved å sende denne mailen aksepterer du at noen fra Grasrota teamet tar en undersøkelse av profilen din.",
                        textScaleFactor: 1.0,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () async {
                          launch("mailto:post@grasrota.com");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 55,
                          width: 175,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              border: Border.all(width: 4, color: Colors.cyan)),
                          child: Text(
                            "Fortsett til mail",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
