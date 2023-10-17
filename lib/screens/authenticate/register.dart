import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grasrota/models/storedData.dart';
import 'package:grasrota/services/auth.dart';
import 'package:grasrota/shared/constants.dart';
import 'package:grasrota/shared/loading.dart';
import 'package:grasrota/shared/search_list.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  bool loading = false;
  int curIndex = 1;

  //List indexContent = [first()];


  // text field state
  String username = "";
  String email = "";
  String password = "";
  String tlf = "";
  String error = "";
  File? imageFile;
  int price = 100;
  bool iAccept = false;
  bool colorRed = false;
  bool isLoading = false;
  bool _isError = false;
  String errorMessage = "";

  handleChooseImageFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
        // allowedExtensions: ['png'],
      );

      if (result?.files.single.path != null) {
        setState(() {
          _isError = false;
          this.imageFile = File(result!.files.single.path!);
        });
      }

      // final ImagePicker _picker = ImagePicker();
      // final XFile? image = await _picker.pickImage(
      //     source: ImageSource.gallery, imageQuality: 60);

      // if (image!.path.isNotEmpty) {
      //   setState(() {
      //     this.imageFile = File(image.path);
      //   });
      // }

      /*File _file = File(await ImagePicker()
          .pickImage(
              source: ImageSource.gallery,
              
              maxHeight: 150,
              maxWidth: 150)
          .then((pickedFile) => pickedFile!.path));*/
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    StoredData.choosenOrg = "";
    StoredData.adminOrg = "";
    StoredData.isAdmin = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : WillPopScope(
            // ignore: missing_return
            onWillPop: () {
              setState(() {
                widget.toggleView(1);
              });
              return new Future(() => true);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: Builder(
                builder: (scafCtn) => ListView(
                  children: <Widget>[
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          child: const Text(
                            "1",
                            textScaleFactor: 1.0,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.cyan, shape: BoxShape.circle),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          height: 3,
                          color: Colors.black.withOpacity(.2),
                          width: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "2",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              color: curIndex > 1 ? Colors.white : Colors.cyan,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.cyan, width: 3),
                              color: curIndex > 1
                                  ? Colors.cyan
                                  : Colors.transparent,
                              shape: BoxShape.circle),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          height: 3,
                          color: Colors.black.withOpacity(.2),
                          width: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "3",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              color: curIndex > 2 ? Colors.white : Colors.cyan,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.cyan, width: 3),
                              color: curIndex > 2
                                  ? Colors.cyan
                                  : Colors.transparent,
                              shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    curIndex == 1 ? first() : SizedBox(),
                    curIndex == 2 ? second() : SizedBox(),
                    curIndex == 3 ? third(scafCtn) : SizedBox(),
                    const SizedBox(height: 15),
                    Text(error,
                        textScaleFactor: 1.0,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            print("TAG_ANDRA Button clicked ${curIndex}");
                            if (curIndex == 1) {
                              //widget.toggleView(1);
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                if (curIndex > 1) curIndex--;
                              });
                            }
                          },
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              curIndex == 1 ? "Avbryt" : "Tilbake",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: Colors.black.withOpacity(.4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withOpacity(.4),
                                    width: 3),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                                shape: BoxShape.rectangle),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (!isLoading) {
                              setState(() {
                                if (curIndex == 1) {
                                  if (imageFile == null) {
                                    setState(() {
                                      _isError = true;
                                      errorMessage = " Please select an image";
                                    });
                                  }
                                  if (_formKey.currentState!.validate()
                                      &&
                                      imageFile != null
                                  ) {
                                    setState(() {
                                      _isError = false;
                                    });
                                    curIndex++;
                                  }
                                } else if (curIndex == 2) {
                                  if (_formKey2.currentState!.validate()) {
                                    if (iAccept) {
                                      curIndex++;
                                    } else {
                                      colorRed = true;
                                    }
                                  }
                                } else if (curIndex == 3) {
                                  if (StoredData.choosenOrg != "") {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    if (StoredData.choosenOrg == StoredData.adminOrg) {
                                      StoredData.isAdmin = true;
                                    }
                                    print("TAG_ANDRA Chosen org " +
                                        StoredData.choosenOrg);

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Creating the account, please wait few seconds."),
                                    ));

                                    /*
                                    if (returnValue == null) {
                                        setState(() {
                                          error =
                                              "vennligst oppgi en gyldig email";
                                          loading = false;
                                          isLoading = false;
                                        });
                                      } else
                                     */

                                    /*
                                    if (value == null) {
                                            setState(() {
                                              error =
                                                  "vennligst oppgi en gyldig email";
                                              loading = false;
                                              isLoading = false;
                                            });
                                          } else
                                     */

                                    _auth
                                        .registerWithEmailAndPassword(
                                            email,
                                            password,
                                            username,
                                            imageFile,
                                            tlf,
                                            StoredData.choosenOrg,
                                            price,
                                            StoredData.isAdmin)
                                        .whenComplete(() => {
                                              AuthService()
                                                  .signInWithEmailAndPassword(
                                                      email, password, false)
                                                  .then((value) {
                                                if (value is String) {
                                                  setState(() {
                                                    error = value;
                                                    loading = false;
                                                    isLoading = false;
                                                  });
                                                } else {
                                                  widget.toggleView(1);
                                                }
                                              })
                                            });
                                    //     .then((returnValue) {
                                    //       if (returnValue is String) {
                                    //     setState(() {
                                    //       error = returnValue;
                                    //       loading = false;
                                    //       isLoading = false;
                                    //     });
                                    //   } else {
                                    //         print("TAG_ANDRA Ej alo vracenooooo");
                                    //     AuthService()
                                    //         .signInWithEmailAndPassword(
                                    //             email, password, false)
                                    //         .then((value) {
                                    //       if (value is String) {
                                    //         setState(() {
                                    //           error = value;
                                    //           loading = false;
                                    //           isLoading = false;
                                    //         });
                                    //       } else {
                                    //         widget.toggleView(1);
                                    //       }
                                    //     });
                                    //   }
                                    // });
                                  } else {
                                    print("velg org");
                                  }
                                }
                              });
                            }
                          },
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(18),
                            child: !isLoading
                                ? Text(
                                    curIndex == 3 ? "Fullfør" : "Neste",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                    colors: const [
                                      Colors.cyan,
                                      Colors.greenAccent
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                shape: BoxShape.rectangle),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  first() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Text(
                "Personlig info",
                textScaleFactor: 1.0,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      initialValue: email,
                      decoration:
                          textInputDecoration.copyWith(hintText: "Email"),
                      validator: (val) => val!.isEmpty || !val.contains("@")
                          ? "Fyll inn en email"
                          : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: password,
                      decoration:
                          textInputDecoration.copyWith(hintText: "Passord"),
                      obscureText: true,
                      validator: (val) => val!.length < 6
                          ? "Fyll inn et passord på 6+ tegn"
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () async {
                  await handleChooseImageFromGallery();
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundImage: imageFile != null
                            ? FileImage(imageFile!)
                            : AssetImage("assets/profilePic.png")
                                as ImageProvider),
                    title: Text(
                      imageFile == null ? "Last opp bilde" : "Endre",
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: _isError,
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ),
        ));
  }

  second() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: 20, horizontal: (screenWidth > 375 ? 50 : 20)),
        child: Form(
            key: _formKey2,
            child: Column(
              children: [
                const Text(
                  "Personlig info",
                  textScaleFactor: 1.0,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: username,
                        textInputAction: TextInputAction.next,
                        decoration: textInputDecoration.copyWith(
                            hintText: "Brukernavn"),
                        validator: (val) =>
                            val!.isEmpty ? "Fyll inn et brukernavn" : null,
                        onChanged: (val) {
                          setState(() => username = val);
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        initialValue: tlf,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
                        decoration:
                            textInputDecoration.copyWith(hintText: "Tlf."),
                        validator: (val) =>
                            val!.length != 8 ? "Fyll inn ditt tlf. nr" : null,
                        onChanged: (val) {
                          setState(() => tlf = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 90,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            setState(() => price = 100);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: price == 100
                                        ? Color(0xffcd7f32)
                                        : Colors.transparent,
                                    width: 4)),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Bronse",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(),
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 5),
                                  const Text("100kr",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            setState(
                              () => price = 150,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: price == 150
                                        ? Color(0xffc0c0c0)
                                        : Colors.transparent,
                                    width: 4)),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Sølv",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(),
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 5),
                                  const Text("150kr",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            setState(
                              () => price = 200,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: price == 200
                                        ? Color(0xffd4af37)
                                        : Colors.transparent,
                                    width: 4)),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Gull",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(),
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 5),
                                  const Text("200kr",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            setState(
                              () => price = 250,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: price == 250
                                        ? Color(0xffe5e4e2)
                                        : Colors.transparent,
                                    width: 4)),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Platinum",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(),
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 5),
                                  const Text("250kr",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      value: iAccept,
                      onChanged: (bo) {
                        setState(() {
                          iAccept = bo!;
                        });
                      },
                    ),
                    InkWell(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        setState(() {
                          iAccept = !iAccept;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          "Jeg bekrefter at jeg er 16+, og godtar våre personvernregler.",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: colorRed ? Colors.red : Colors.black),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )));
  }

  third(scafCtn) {
    return SearchList(scaffoldCtn: scafCtn, minusHeight: 445);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
