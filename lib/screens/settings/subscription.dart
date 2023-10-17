import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/services/auth.dart';
import 'package:grasrota/shared/getToken.dart';

class Subscription extends StatefulWidget {
  final UserModal user;
  Subscription({required this.user});

  @override
  _SubscribtionState createState() => _SubscribtionState();
}

class _SubscribtionState extends State<Subscription> {
  bool isLoading = false;
  bool _enabled = false;
  int newValue = 0;
  final currentDate = new DateTime.now();

  bool isDelete = false;

  Future<Map> getCredInfo() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("credent")
        .doc(widget.user.uid)
        .get();

    DocumentSnapshot orgDoc = await FirebaseFirestore.instance
        .collection("org")
        .doc(widget.user.org)
        .get();

    return {"credent": doc.data(), "org": orgDoc.data()};
  }

  @override
  void initState() {
    newValue = (widget.user.price ~/ 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Stack(
          children: [
            Column(children: [
              Stack(
                children: [
                  Hero(
                    tag: "abon",
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      color: Colors.deepPurple[400]!.withOpacity(.8),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 150,
                      child: const Text(
                        "Abonnement",
                        textScaleFactor: 1.0,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
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
              FutureBuilder(
                  future: getCredInfo(),
                  builder: (context, AsyncSnapshot<Map> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Transform.translate(
                            offset: Offset(0, -24),
                            child: Chip(
                              avatar: CircleAvatar(
                                radius: 8,
                                backgroundColor: snapshot.data!["credent"]
                                        ["isActive"]
                                    ? Colors.green[800]
                                    : Colors.red[800],
                              ),
                              label: Text(
                                snapshot.data!["credent"]["isActive"]
                                    ? "Aktiv"
                                    : "Stoppet",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: snapshot.data!["credent"]["isActive"]
                                        ? Colors.green[800]
                                        : Colors.red[800],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Fysisk Produkt Kjøpt av Grasrota",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_enabled) {
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.user.uid)
                                            .update({"price": newValue * 100});
                                      }
                                      _enabled = !_enabled;
                                    });
                                  },
                                  child: CircleAvatar(
                                      child: _enabled
                                          ? const Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                      backgroundColor: _enabled
                                          ? Colors.green
                                          : Colors.blueGrey)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                InkWell(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    _enabled
                                        ? setState(() => newValue = 100)
                                        : 0;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: newValue == 100
                                                ? Color(0xffcd7f32)
                                                : Colors.transparent,
                                            width: 4)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    height: 100,
                                    width: 100,
                                    child: Card(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text("Bronse",
                                              textScaleFactor: 1.0,
                                              style: TextStyle()),
                                          const Text("100kr",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    _enabled
                                        ? setState(() => newValue = 150)
                                        : null;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: newValue == 150
                                                ? Color(0xffc0c0c0)
                                                : Colors.transparent,
                                            width: 4)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    height: 100,
                                    width: 100,
                                    child: Card(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text("Sølv",
                                              textScaleFactor: 1.0,
                                              style: TextStyle()),
                                          const Text("150kr",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    _enabled
                                        ? setState(() => newValue = 200)
                                        : null;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: newValue == 200
                                                ? Color(0xffd4af37)
                                                : Colors.transparent,
                                            width: 4)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    height: 100,
                                    width: 100,
                                    child: Card(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text("Gull",
                                              textScaleFactor: 1.0,
                                              style: TextStyle()),
                                          const Text("200kr",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    _enabled
                                        ? setState(() => newValue = 250)
                                        : null;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: newValue == 250
                                                ? Color(0xffe5e4e2)
                                                : Colors.transparent,
                                            width: 4)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    height: 100,
                                    width: 100,
                                    child: Card(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text("Platinum",
                                              textScaleFactor: 1.0,
                                              style: TextStyle()),
                                          const Text("250kr",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 270,
                            child: ListTile(
                                title: Text(
                                  snapshot.data!["org"]["navn"]
                                      .toString()
                                      .toUpperCase(),
                                  textScaleFactor: 1.0,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                trailing: snapshot.hasData &&
                                        (snapshot.data!["org"] as Map)
                                            .containsKey("img") &&
                                        snapshot.data!["org"]["img"] != ""
                                    ? Image.network(
                                        snapshot.data!["org"]["img"],
                                        width: 35,
                                        height: 35,
                                      )
                                    : const SizedBox()),
                          ),
                          const SizedBox(height: 50),
                          isLoading
                              ? SpinKitWave(
                                  color: !snapshot.data!["credent"]["isActive"]
                                      ? Colors.green[800]
                                      : Colors.red[800],
                                  size: 37,
                                )
                              : TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await getToken().then((tokenJSON) async {
                                      final HttpsCallable callable =
                                          FirebaseFunctions.instance
                                              .httpsCallable(
                                                  'updateAgreeStatus');

                                      await callable.call(<String, dynamic>{
                                        "idToken": widget.user.uidtoken,
                                        "argId": snapshot.data!["credent"]
                                            ["argId"],
                                        "price": newValue,
                                        "token": tokenJSON,
                                        "isActive": snapshot.data!["credent"]
                                            ["isActive"]
                                      }).catchError((e) {
                                        isLoading = false;
                                      }).then((value) {
                                        // print('**********************************' + value.data);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      border: Border.all(
                                          width: 4,
                                          color: snapshot.data!["credent"]
                                                  ["isActive"]
                                              ? (Colors.red[800])!
                                              : (Colors.green[800])!),
                                    ),
                                    child: Text(
                                      snapshot.data!["credent"]["isActive"]
                                          ? "AVSLUTT"
                                          : "START",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: snapshot.data!["credent"]
                                                  ["isActive"]
                                              ? Colors.red[800]
                                              : Colors.green[800],
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                          const SizedBox(height: 25),
                          (DateTime.parse(snapshot.data!["credent"]
                                                      ["chargeTime"]
                                                  .toDate()
                                                  .toString())
                                              .difference(currentDate)
                                              .inDays
                                              .abs() <=
                                          30 &&
                                      DateTime.parse(snapshot.data!["credent"]
                                                      ["chargeTime"]
                                                  .toDate()
                                                  .toString())
                                              .difference(currentDate)
                                              .inDays
                                              .abs() >=
                                          25) &&
                                  !snapshot.data!["credent"]["isActive"]
                              ? TextButton(
                                  //24 tilsvarer 5 dager
                                  onPressed: () {
                                    setState(() {
                                      isDelete = !isDelete;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      color: Colors.grey,
                                    ),
                                    child: const Text(
                                      "REFUSJON",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Container(
                            margin: EdgeInsets.all(30),
                            child: snapshot.data!["credent"]["isActive"]
                                ? const SizedBox()
                                : const Text(
                                    "Du vil ikke bli belastet mens abonnementet ditt er 'stoppet', men kan bare benytte deg av appen vår ut perioden.",
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        margin: const EdgeInsets.only(top: 100),
                        child: const SpinKitDoubleBounce(
                          color: Colors.cyan,
                          size: 50,
                        ),
                      );
                    }
                  }),
            ]),
            isDelete
                ? InkWell(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      setState(() {
                        isDelete = !isDelete;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black.withOpacity(0.4),
                      child: Center(
                          child: Container(
                        height: 310,
                        width: 300,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  textScaleFactor: 1.0,
                                ),
                                child: PopUpRefund(user: widget.user))),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[50],
                        ),
                      )),
                    ))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

String subScriResp = "";

class PopUpRefund extends StatefulWidget {
  final UserModal user;
  PopUpRefund({required this.user});

  @override
  _PopUpRefundState createState() => _PopUpRefundState();
}

class _PopUpRefundState extends State<PopUpRefund> {
  bool isLoading = false;

  @override
  void initState() {
    subScriResp = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Ved å foreta refunsjon vil:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text("* Abonnementet ditt bli avsluttet.",
                textScaleFactor: 1.0, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            const Text(
                "* Du få tilbake det utbetalte beløpet for denne perioden.",
                textScaleFactor: 1.0,
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
          ],
        ),
        const SizedBox(height: 20),
        isLoading
            ? const SpinKitWave(
                color: Colors.cyan,
                size: 37,
              )
            : InkWell(
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  width: 125,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: LinearGradient(
                        colors: const [Colors.cyan, Colors.greenAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: Text("Refunder",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
                onTap: () async {
                  HapticFeedback.heavyImpact();
                  await getToken().then((tokenJSON) async {
                    setState(() {
                      isLoading = true;
                    });

                    final HttpsCallable callable =
                        FirebaseFunctions.instance.httpsCallable('refund');

                    await callable.call(<String, dynamic>{
                      "idToken": widget.user.uidtoken,
                      "token": tokenJSON,
                      "isDelete": false,
                    }).then((e) async {
                      setState(() {
                        isLoading = false;
                      });
                      subScriResp = e.data;
                      if (subScriResp == "Suksess! Abonnement er avsluttet") {
                        subScriResp += " og sist betalte beløp vil refunderes";
                        await FirebaseFirestore.instance
                            .collection("credent")
                            .doc(widget.user.uid)
                            .delete()
                            .then((value) async {
                          await AuthService().signOut();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      }
                    });
                  });
                }),
      ],
    );
  }
}
