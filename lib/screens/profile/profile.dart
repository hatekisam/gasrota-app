import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/models/userscore.dart';
import 'package:grasrota/screens/index/credImage.dart';
import 'package:grasrota/screens/result/result.dart';
import 'package:grasrota/screens/score/score.dart';
import 'package:grasrota/screens/settings/settings.dart';
import 'package:grasrota/services/database.dart';
import 'package:grasrota/shared/constants.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final UserModal user;
  Map? cred;
  Profile({required this.user, required this.cred});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  QuerySnapshot? questionSnapshot;
  DatabaseService databaseService = new DatabaseService();

  @override
  void initState() {
    databaseService.getTopUser(widget.user.org).then((value) {
      questionSnapshot = value;

      //  var url = questionSnapshot.docs["image"];

      setState(() {});
    });
    super.initState();
  }

  QueryDocumentSnapshot? getImageSnap(index) {
    if (questionSnapshot == null) return null;
    if (questionSnapshot?.docs.isEmpty == true) return null;
    if ((questionSnapshot?.docs.length ?? 0) <= index) return null;
    return questionSnapshot?.docs[index];
  }

  getQuestionModelFromDatasnapshot(snapshot) {
    var url;
    if (snapshot == null) return AssetImage("assets/profilePic.png");
    setState(() {
      url = snapshot["image"];
    });
    try {
      if (url != null && url != "" && snapshot != null) {
        return NetworkImage(url);
      } else {
        return AssetImage("assets/profilePic.png");
      }
    } catch (e) {
      return AssetImage("assets/profilePic.png");
    }
  }

  Future<Map> getCredInfo() async {
    DocumentSnapshot orgDoc = await FirebaseFirestore.instance
        .collection("org")
        .doc(widget.user.org)
        .get();
    return {
      "img": orgDoc["img"],
      "score": orgDoc["score"],
      "title": orgDoc["navn"]
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 203, 238, 1),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: const Radius.circular(40),
              bottomRight: const Radius.circular(40),
            ),
            child: Image.asset("assets/bakgrunn.png"),
          ),
          back(context),
          Positioned(
              top: 60,
              right: 30,
              child: InkWell(
                onTap: () async {
                  HapticFeedback.heavyImpact();
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsPage(
                              user: widget.user, cred: widget.cred)));
                },
                child:
                    const Icon(Icons.settings, color: Colors.white, size: 40),
              )),
          Container(
            margin: EdgeInsets.only(top: 210),
            height: 330,
            padding:
                const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 8),
            width: MediaQuery.of(context).size.width - 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 4,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.user.name,
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: widget.user.score.toString(),
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
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Result(user: widget.user)));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 37,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                          colors: const [Colors.yellow, Colors.orangeAccent]),
                    ),
                    child: const Text(
                      "RESULTATER",
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.grey.withOpacity(.5),
                  height: 1.5,
                ),
                InkWell(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    HapticFeedback.heavyImpact();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StreamProvider<List<UserScore>>.value(
                                  value: questionSnapshot!.docs.length > 2
                                      ? DatabaseService().userstream(
                                          questionSnapshot!.docs[2],
                                          widget.user.org)
                                      : null,
                                  initialData: [],
                                  child: Score(
                                      firstPlc:
                                          questionSnapshot!.docs.length > 0
                                              ? questionSnapshot!.docs[0]
                                              : null,
                                      secondPlc:
                                          questionSnapshot!.docs.length > 1
                                              ? questionSnapshot!.docs[1]
                                              : null,
                                      thirdPlc:
                                          questionSnapshot!.docs.length > 2
                                              ? questionSnapshot!.docs[2]
                                              : null,
                                      cred: widget.cred)),
                        ));
                  },
                  child: ListTile(
                    title: const Text(
                      "Scoreboard",
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(-60, 0),
                          child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                  radius: 15,
                                  backgroundImage:
                                      getQuestionModelFromDatasnapshot(
                                          getImageSnap(0)))),
                        ),
                        Transform.translate(
                          offset: const Offset(-40, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: getQuestionModelFromDatasnapshot(
                                  getImageSnap(1)),
                            ),
                          ),

                          // backgroundImage: questionSnapshot != null &&
                          //         questionSnapshot!.docs.length >= 2
                          //     ? getQuestionModelFromDatasnapshot(
                          //         questionSnapshot!.docs[1])
                          //     : const AssetImage(
                          //         "assets/profilePic.png"),

                          // ),

                          // ),
                        ),
                        Transform.translate(
                          offset: const Offset(-20, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 15,

                              backgroundImage: getQuestionModelFromDatasnapshot(
                                  getImageSnap(2)),
                              // backgroundImage: questionSnapshot != null &&
                              //         questionSnapshot!.docs.length == 3
                              //     ? getQuestionModelFromDatasnapshot(
                              //         questionSnapshot!.docs[2])
                              //     : const AssetImage(
                              //         "assets/profilePic.png"),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(15, 0),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                    future: getCredInfo(),
                    builder: (context, AsyncSnapshot<Map> snapshot) {
                      if (snapshot.data != null) {
                        widget.cred = snapshot.data!;
                      }
                      return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(300.0),
                            child: CredImage(cred: snapshot.data, width: 35),
                          ),
                          title: Container(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: LinearProgressIndicator(
                                value: snapshot.hasData &&
                                        snapshot.data!["score"] != null
                                    ? snapshot.data!["score"].toDouble()
                                    : 0.0,
                                backgroundColor: Colors.grey.withOpacity(.18),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.cyan),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          trailing: Text(
                            snapshot.hasData && snapshot.data!["score"] != null
                                ? (snapshot.data!["score"] * 100)
                                        .round()
                                        .toString() +
                                    "%"
                                : "0%",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                                fontSize: 16),
                          ));
                    })
              ],
            ),
          ),
          Transform.translate(
              offset: Offset(0, 140),
              child: Hero(
                tag: "profImg",
                child: Container(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: widget.user.profileImg != ""
                            ? NetworkImage(widget.user.profileImg)
                            : AssetImage("assets/profilePic.png")
                                as ImageProvider,
                      ),
                      /* FutureBuilder(
                          future: getCredInfo(),
                          builder: (context, AsyncSnapshot<Map> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!["img"] != null &&
                                snapshot.data!["img"] != "") {
                              return Transform.translate(
                                  offset: Offset(62, 62),
                                  child: CircleAvatar(
                                    radius: 29,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(300.0),
                                          child: Image.network(
                                            snapshot.data!["img"],
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    backgroundColor: Colors.white,
                                  ));
                            }
                            return const SizedBox();
                          }),*/
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: getProfileColor(widget.user.price), width: 8),
                    shape: BoxShape.circle,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
