import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grasrota/models/quiz.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/screens/index/quizlist.dart';
import 'package:grasrota/screens/profile/profile.dart';
import 'package:grasrota/services/database.dart';
import 'package:grasrota/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'credImage.dart';

class IndexGrasrota extends StatefulWidget {
  @override
  _IndexGrasrotaState createState() => _IndexGrasrotaState();
}

class _IndexGrasrotaState extends State<IndexGrasrota>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.96, end: 1);

  Map? cred;
  late UserModal user;

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     user = Provider.of<UserModal>(context);
  //   });

  //   _controller = AnimationController(
  //       duration: const Duration(milliseconds: 1500), vsync: this);
  //   _controller.repeat(reverse: true);
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Map> getCredInfo(org) async {
    DocumentSnapshot orgDoc =
        await FirebaseFirestore.instance.collection("org").doc(org).get();
    Map da = orgDoc.data() as Map;
    Map newCred = {"img": da["img"], "score": da["score"], "title": da["navn"]};
    setState(() {
      cred = newCred;
    });
    return newCred;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      user = Provider.of<UserModal>(context);
    });

    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserModal>(context);
    getCredInfo(user.org);
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Stack(
          //overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: const Radius.circular(40),
                bottomRight: const Radius.circular(40),
              ),
              child: Image.asset("assets/bakgrunn.png"),
            ),
            Transform.translate(
                offset: Offset(0, 80),
                child: ScaleTransition(
                  scale: _tween.animate(CurvedAnimation(
                      parent: _controller, curve: Curves.elasticOut)),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(0, 190, 225, 1),
                    radius: MediaQuery.of(context).size.width * .26,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .42,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 13,
                            color: const Color.fromRGBO(17, 198, 230, 1)),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Poeng",
                            style: TextStyle(
                              color: const Color.fromRGBO(34, 134, 177, 1),
                              fontSize: 17,
                            ),
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: user.score.toString(),
                                style: const TextStyle(
                                  color: const Color.fromRGBO(34, 134, 177, 1),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            if (cred != null) ...[
              Transform.translate(
                offset: Offset(0, 310),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(55.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CredImage(cred: cred, width: 30),
                        const SizedBox(width: 10),
                        Text(
                          cred!["title"].length > 20
                              ? cred!["title"].substring(0, 20) + '...'
                              : cred!["title"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            Transform.translate(
              offset: Offset(0, 60),
              child: StreamProvider<List<QuizMod>>.value(
                initialData: [],
                value: DatabaseService().quizStream,
                child: QuizList(user: user, cred: cred),
              ),
            ),
            Positioned(
              top: 60,
              right: 30,
              child: InkWell(
                child: Hero(
                  tag: "profImg",
                  child: Container(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: user.profileImg != ""
                          ? NetworkImage(user.profileImg)
                          : AssetImage("assets/profilePic.png")
                              as ImageProvider,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: getProfileColor(user.price), width: 3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Profile(user: user, cred: cred)));
                },
              ),
            ),
            Positioned(
              top: 65,
              left: 30,
              child: InkWell(
                child: Column(
                  children: [
                    const Icon(
                      Icons.ios_share_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(height: 10),
                    Text("Del",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))
                  ],
                ),
                onTap: () {
                  HapticFeedback.heavyImpact();
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  Share.share("https://grasrota2.page.link/app",
                      subject: "Denne måneden har jeg samlet " +
                          user.score.toString() +
                          " poeng",
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
