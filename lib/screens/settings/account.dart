import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/screens/settings/subscription.dart';
import 'package:grasrota/services/auth.dart';
import 'package:grasrota/shared/constants.dart';
import 'package:grasrota/shared/getToken.dart';
import 'package:image_picker/image_picker.dart';

import '../index/credImage.dart';

class Account extends StatefulWidget {
  final UserModal user;
  final Map? cred;
  Account({required this.user, required this.cred});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _formKey = GlobalKey<FormState>();
  File? imageFile;
  late String username, email;
  late String initEmail;
  bool isLoading = false;

  bool isImgChanged = false;
  bool isDelete = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;

  handleChooseImageFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
        // allowedExtensions: ['png'],
      );

      if (result?.files.single.path != null) {
        setState(() {
          this.imageFile = File(result!.files.single.path!);
          isImgChanged = true;
        });
      }

      // File _file = File(await ImagePicker()
      //     .pickImage(
      //         source: ImageSource.gallery,
      //         imageQuality: 70,
      //         maxHeight: 150,
      //         maxWidth: 150)
      //     .then((pickedFile) => pickedFile!.path));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    user = _auth.currentUser!;
    initEmail = user.email!;
    email = user.email!;
    super.initState();
  }

  updateImg(BuildContext scafCont) async {
    String downlaodUrl = "";

    if (imageFile != null) {
      Reference reference =
          FirebaseStorage.instance.ref().child("images/" + user.uid);

      UploadTask uploadTask = reference.putFile(imageFile!);
      uploadTask.then((res) async {
        downlaodUrl = await res.ref.getDownloadURL();

        if (downlaodUrl != "" || downlaodUrl != null) {
          await FirebaseFirestore.instance
              .collection("org")
              .doc(widget.user.org)
              .collection("users")
              .doc(user.uid)
              .update({"image": downlaodUrl});
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .update({"image": downlaodUrl}).then((val) {
            setState(() {
              isLoading = false;
              isImgChanged = false;
            });
            actionRespons("Profilbildet ditt er oppdatert", scafCont, true);
          });
        }
      });
    }
  }

  disableLoading(String newMail) {
    initEmail = newMail;
    setState(() {
      isLoading = false;
      isDelete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (scafCtn) => SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(children: [
                    Stack(
                      children: [
                        Hero(
                          tag: "konto",
                          child: Container(
                            padding: const EdgeInsets.only(top: 20),
                            color: Colors.green.withOpacity(.8),
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            height: 150,
                            child: const Text(
                              "Konto",
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
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(right: 30, top: 60),
                          child: CredImage(cred: widget.cred, width: 50),
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
                      offset: Offset(0, -38),
                      child: Container(
                        width: 110,
                        height: 110,
                        child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.white,
                            iconSize: 30,
                            onPressed: () {
                              handleChooseImageFromGallery();
                            }),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: getProfileColor(widget.user.price),
                                width: 5),
                            shape: BoxShape.circle,
                            color: Colors.black,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.8),
                                  BlendMode.dstATop),
                              image: imageFile == null
                                  ? widget.user.profileImg != ""
                                      ? NetworkImage(widget.user.profileImg)
                                      : const AssetImage(
                                              "assets/profilePic.png")
                                          as ImageProvider
                                  : FileImage(imageFile!),
                            )),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 5),
                              child: Text(
                                "Brukernavn",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800]),
                                textScaleFactor: 1.0,
                              )),
                          TextFormField(
                            readOnly: true,
                            initialValue: widget.user.name,
                            decoration: textInputDecoration.copyWith(
                                hintText: "Brukernavn"),
                            validator: (val) =>
                                val!.isEmpty ? "Fyll inn et brukernavn" : null,
                            onChanged: (val) {
                              setState(() => username = val);
                            },
                          ),
                          const SizedBox(height: 20),
                          Container(
                              alignment: Alignment.centerLeft,
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 5),
                              child: Text(
                                "Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800]),
                                textScaleFactor: 1.0,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            readOnly: user.displayName == null ? false : true,
                            initialValue: user.email,
                            decoration:
                                textInputDecoration.copyWith(hintText: "Email"),
                            validator: (val) =>
                                val!.isEmpty || !val.contains("@")
                                    ? "Fyll inn en email"
                                    : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          // user.displayName == null
                          //     ? const SizedBox()
                          //     : const Text(
                          //         "Brukere med facebook logg inn, kan ikke endre mailen sin",
                          //         style: const TextStyle(
                          //             fontSize: 13,
                          //             fontStyle: FontStyle.italic),
                          //         textScaleFactor: 1.0,
                          //         textAlign: TextAlign.center,
                          //       ),
                          const SizedBox(height: 70),
                          isLoading
                              ? const SpinKitWave(
                                  color: Colors.cyan,
                                  size: 37,
                                )
                              : TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (initEmail == email) {
                                      if (isImgChanged) {
                                        updateImg(scafCtn);
                                      } else {
                                        setState(() => isDelete = true);
                                      }
                                    } else {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => isDelete = true);
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 40),
                                    alignment: Alignment.center,
                                    height: 45,
                                    width: initEmail == email && !isImgChanged
                                        ? 125
                                        : 135,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(80),
                                        gradient: LinearGradient(
                                            colors: initEmail == email &&
                                                    !isImgChanged
                                                ? [
                                                    (Colors.red[700])!,
                                                    (Colors.red[700])!
                                                  ]
                                                : const [
                                                    Colors.cyan,
                                                    Colors.greenAccent
                                                  ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight)),
                                    child: Text(
                                      initEmail == email && !isImgChanged
                                          ? "Slett Konto"
                                          : "Lagre Endring",
                                      textScaleFactor: 1.0,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                        ],
                      ),
                    ),
                  ]),
                ),
                isDelete
                    ? InkWell(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          setState(() {
                            isDelete = !isDelete;
                            isLoading = false;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.black.withOpacity(0.4),
                          child: Center(
                              child: Container(
                            height: 400,
                            width: 300,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: MediaQuery(
                                    data: MediaQuery.of(context).copyWith(
                                      textScaleFactor: 1.0,
                                    ),
                                    child: PopUpConfirm(
                                        orgId: widget.user.org,
                                        user: user,
                                        scafCont: scafCtn,
                                        newMail: email,
                                        disFun: disableLoading,
                                        editMail: initEmail == email
                                            ? false
                                            : true))),
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
        ));
  }
}

class PopUpConfirm extends StatefulWidget {
  @required
  final String orgId, newMail;
  @required
  final User user;
  @required
  final BuildContext scafCont;
  @required
  final bool editMail;
  @required
  final Function disFun;
  PopUpConfirm(
      {required this.orgId,
      required this.user,
      required this.scafCont,
      required this.editMail,
      required this.newMail,
      required this.disFun});

  @override
  _PopUpConfirmState createState() => _PopUpConfirmState();
}

class _PopUpConfirmState extends State<PopUpConfirm> {
  final _formKey2 = GlobalKey<FormState>();
  late String confEmail, confPassword;
  String error = "";

  int sideIndex = 0;
  bool isLoading = false;
  final currentDate = new DateTime.now();
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  dynamic result;

  Future<Map> getCredInfo() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("credent")
        .doc(widget.user.uid)
        .get();

    return {"credent": doc.data()};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCredInfo(),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            return Form(
              key: _formKey2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  sideIndex == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Logg Inn",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(widget.editMail
                                ? "for å endre mailen"
                                : "for å bekrefte sletting av brukeren"),
                            const SizedBox(height: 20),
                            widget.user.displayName == null
                                ? Column(
                                    children: [
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: textInputDecoration
                                            .copyWith(hintText: "Email"),
                                        validator: (val) => val!.isEmpty
                                            ? "Skriv inn en email"
                                            : null,
                                        onChanged: (val) {
                                          setState(() => confEmail = val);
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        decoration: textInputDecoration
                                            .copyWith(hintText: "Passord"),
                                        obscureText: true,
                                        validator: (val) => val!.length < 6
                                            ? "Skriv inn et passord på 6+ tegn"
                                            : null,
                                        onChanged: (val) {
                                          setState(() => confPassword = val);
                                        },
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            Text(error,
                                textScaleFactor: 1.0,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 16),
                                textAlign: TextAlign.center),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              const Text(
                                "Ved å slette brukeren din vil:",
                                textScaleFactor: 1.0,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                  "* Din personlige data bli fjernet fra våre servere",
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 10),
                              snapshot.data!["credent"] != null
                                  ? Column(children: [
                                      const Text(
                                          "* Abonnomentet ditt bli avsluttet.",
                                          textScaleFactor: 1.0,
                                          textAlign: TextAlign.center),
                                      const SizedBox(height: 10),
                                      ((DateTime.parse(snapshot.data!["credent"]["chargeTime"].toDate().toString())
                                                          .difference(
                                                              currentDate)
                                                          .inDays
                                                          .abs() <=
                                                      30 &&
                                                  DateTime.parse(snapshot
                                                              .data!["credent"]
                                                                  ["chargeTime"]
                                                              .toDate()
                                                              .toString())
                                                          .difference(
                                                              currentDate)
                                                          .inDays
                                                          .abs() >=
                                                      25) ||
                                              DateTime.parse(snapshot
                                                          .data!["credent"]
                                                              ["chargeTime"]
                                                          .toDate()
                                                          .toString())
                                                      .day ==
                                                  currentDate.day)
                                          ? const Text(
                                              "* Du får refundert den siste belastningen",
                                              textScaleFactor: 1.0,
                                              textAlign: TextAlign.center)
                                          : const SizedBox()
                                    ])
                                  : const SizedBox(),
                            ]),
                  const SizedBox(height: 20),
                  isLoading
                      ? SpinKitWave(
                          color: widget.editMail || sideIndex == 0
                              ? Colors.cyan
                              : Colors.red[700],
                          size: 37,
                        )
                      : widget.user.displayName != null && sideIndex == 0
                          ? SignInButton(Buttons.Facebook,
                              text: "Logg inn med Facebook",
                              onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                        //       FacebookLoginResult fresult =
                        //           await _auth.signInWithFacebook();
                        //       final String token = fresult.accessToken.token;
                        //       final credential =
                        //           FacebookAuthProvider.credential(token);
                        //       result =
                        //           await auth.signInWithCredential(credential);
                        //       if (result == null) {
                        //         setState(() {
                        //           error = "noe gikk galt";
                        //           isLoading = false;
                        //         });
                        //       } else {
                        //         setState(() {
                        //           isLoading = false;
                        //           sideIndex = 1;
                        //         });
                        //       }
                            })
                          : InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: 125,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: LinearGradient(
                                      colors: sideIndex == 0
                                          ? const [
                                              Colors.cyan,
                                              Colors.greenAccent
                                            ]
                                          : [
                                              Colors.red[700]!,
                                              Colors.red[700]!
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                ),
                                child: Text(
                                    widget.editMail
                                        ? "Endre"
                                        : sideIndex == 0
                                            ? "Neste"
                                            : "Slett Konto",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ),
                              onTap: () async {
                                HapticFeedback.heavyImpact();
                                if (_formKey2.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    if (widget.user.displayName == null) {
                                      AuthCredential credentials =
                                          EmailAuthProvider.credential(
                                              email: confEmail,
                                              password: confPassword);
                                      result = await widget.user
                                          .reauthenticateWithCredential(
                                              credentials);
                                    }
                                    if (result != null) {
                                      if (!widget.editMail) {
                                        if (sideIndex == 0) {
                                          setState(() {
                                            sideIndex = 1;
                                            isLoading = false;
                                          });
                                        } else if (sideIndex == 1) {
                                          await getToken()
                                              .then((tokenJSON) async {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            final HttpsCallable callable =
                                                FirebaseFunctions.instance
                                                    .httpsCallable('refund');

                                            await callable
                                                .call(<String, dynamic>{
                                              "uid": result.user.uid,
                                              "token": tokenJSON,
                                              "isDelete": true,
                                              "idToken":
                                                  await result.user.getIdToken()
                                            }).then((e) async {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              subScriResp = e.data;
                                              if (subScriResp ==
                                                  "Suksess! Abonnement er avsluttet") {
                                                subScriResp =
                                                    "Brukeren din er nå slettet. Håper å se deg igjen :)";
                                              }
                                              await FirebaseFirestore.instance
                                                  .collection("org")
                                                  .doc(widget.orgId)
                                                  .collection("users")
                                                  .doc(result.user.uid)
                                                  .delete()
                                                  .then((doc) async {
                                                await result.user.delete();
                                                await AuthService().signOut();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                            });
                                          });
                                        }
                                      } else {
                                        widget.user
                                            .updateEmail(widget.newMail)
                                            .then((v) {
                                          widget.disFun(widget.newMail);
                                          actionRespons(
                                              "Mailen din er oppdatert",
                                              widget.scafCont,
                                              true);
                                        }).catchError((err) {
                                          print(err);
                                          setState(() {
                                            isLoading = false;
                                            error = "noe gikk galt";
                                          });
                                        });
                                      }
                                    }
                                  } catch (e) {
                                    print(e.toString());
                                    setState(() {
                                      isLoading = false;
                                      error = "feil email eller passord";
                                    });
                                  }
                                }
                              }),
                ],
              ),
            );
          }
          return SpinKitDoubleBounce(
            color: Colors.cyan,
            size: 37,
          );
        });
  }
}
