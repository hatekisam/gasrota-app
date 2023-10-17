import 'dart:io';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grasrota/models/storedData.dart';
import 'package:image_picker/image_picker.dart';

import 'constants.dart';

final _formKey = GlobalKey<FormState>();

File? imageFile;
Future handleChooseImageFromGallery() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.image,
    // allowedExtensions: ['png'],
  );

  if (result?.files.single.path != null) {
    imageFile = File(result!.files.single.path!);
  }

  // try {
  //   File _file = File(await ImagePicker()
  //       .pickImage(
  //           source: ImageSource.gallery,
  //           imageQuality: 60,
  //           maxHeight: 150,
  //           maxWidth: 150)
  //       .then((pickedFile) => pickedFile!.path));
  //   imageFile = _file;
  // } catch (e) {
  //   print(e);
  // }
}

addNewModalBottomSheet(
    scafctn, context, bool sendContact, AlgoliaObjectSnapshot? currContent) {
  String newOrgName = currContent != null
      ? currContent.data["navn"] != null
          ? currContent.data["navn"]
          : ""
      : "";
  String newOrgKonto = "";
  String newOrgNr = currContent != null
      ? currContent.data["orgNr"] != null
          ? currContent.data["orgNr"].toString()
          : ""
      : "";
  String place = currContent != null
      ? currContent.data["place"] != null
          ? currContent.data["place"].toLowerCase()
          : ""
      : "";

  String contName = currContent != null
      ? currContent.data["contactName"] != null
          ? currContent.data["contactName"]
          : ""
      : "";
  String contEmail = currContent != null
      ? currContent.data["contactMail"] != null
          ? currContent.data["contactMail"]
          : ""
      : "";
  String contTlf = currContent != null
      ? currContent.data["contactTlf"] != null
          ? currContent.data["contactTlf"]
          : ""
      : "";

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius:
              const BorderRadius.vertical(top: const Radius.circular(20.0))),
      builder: (BuildContext bc) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setModalState /*You can rename this!*/) {
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(top: 30, left: 30, right: 30,
                        bottom: MediaQuery.of(context).viewInsets.bottom >= 30 ? MediaQuery.of(context).viewInsets.bottom : 30),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            icon: const Icon(Icons.close_rounded, size: 45),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                      Text(
                        sendContact ? "Kontakt din org." : "Fyll inn org. info",
                        textScaleFactor: 1.0,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        initialValue: newOrgName,
                        decoration:
                            textInputDecoration.copyWith(hintText: "Org. Navn"),
                        validator: (val) => val!.length < 2
                            ? "Fyll inn navnet på din org."
                            : null,
                        onChanged: (val) {
                          newOrgName = val;
                        },
                      ),
                      sendContact
                          ? const SizedBox()
                          : Column(
                              children: [
                                const SizedBox(height: 20),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () async {
                                    handleChooseImageFromGallery()
                                        .then((v) => {setModalState(() {})});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                          backgroundImage: imageFile != null
                                              ? FileImage(imageFile!)
                                              : AssetImage(
                                                      "assets/profilePic.png")
                                                  as ImageProvider),
                                      title: Text(
                                        imageFile == null
                                            ? "Last opp logo (valgfritt)"
                                            : "Endre",
                                        textScaleFactor: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  initialValue: place,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: "Kommune (valgfritt)"),
                                  onChanged: (val) {
                                    place = val;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textInputAction: TextInputAction.next,
                                  initialValue: newOrgNr,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: "Org. nr"),
                                  validator: (val) => val!.length < 4
                                      ? "Fyll inn et org. nr"
                                      : null,
                                  onChanged: (val) {
                                    newOrgNr = val;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textInputAction: TextInputAction.next,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: "Kontonummer"),
                                  validator: (val) => val!.length != 11
                                      ? "Fyll inn et konto. nr"
                                      : null,
                                  onChanged: (val) {
                                    newOrgKonto = val;
                                  },
                                ),
                              ],
                            ),
                      const SizedBox(height: 20),
                      const Text(
                        "Kontaktperson",
                        textScaleFactor: 1.0,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        initialValue: contName,
                        decoration: textInputDecoration.copyWith(
                            hintText: "Fornavn Etternavn"),
                        validator: (val) =>
                            val!.length < 4 ? "Fullt navn" : null,
                        onChanged: (val) {
                          contName = val;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        initialValue: contEmail,
                        textInputAction: TextInputAction.next,
                        decoration:
                            textInputDecoration.copyWith(hintText: "Email"),
                        validator: (val) => val!.isEmpty || !val.contains("@")
                            ? "Fyll inn en email"
                            : null,
                        onChanged: (val) {
                          contEmail = val;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: contTlf,
                        decoration:
                            textInputDecoration.copyWith(hintText: "Tlf."),
                        validator: (val) =>
                            val!.length != 8 ? "Fyll inn et tlf. nr" : null,
                        onChanged: (val) {
                          contTlf = val;
                        },
                      ),
                      const SizedBox(height: 25),
                      !sendContact
                          ? const Text(
                              "Husk at du står ansvarlig for at informasjonen som blir gitt er korrekt. Grasrota fra sier seg eventuelt ansvar ved feilaktig opplyst informasjon.",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (sendContact) {
                              var date = DateTime.now();
                              var data = {
                                "name": contName,
                                "to": contEmail,
                                "tlf": contTlf,
                                "orgName": newOrgName,
                                "time": date.year.toString() +
                                    "-" +
                                    date.month.toString() +
                                    "-" +
                                    date.day.toString()
                              };
                              if (currContent != null) {
                                await FirebaseFirestore.instance
                                    .collection("newOrg")
                                    .doc(currContent.objectID)
                                    .set(data);
                              } else {
                                await FirebaseFirestore.instance
                                    .collection("newOrg")
                                    .add(data)
                                    .then((doc) {
                                  FirebaseFirestore.instance
                                      .collection("newOrg")
                                      .doc(doc.id)
                                      .set({"navn": newOrgName});
                                });
                              }

                              actionRespons(
                                  "Etterspørsel lagt til", scafctn, true);
                            } else {
                              var dataForUpload = {
                                "contactName": contName,
                                "contactMail": contEmail,
                                "contactTlf": contTlf,
                                "navn": newOrgName,
                                "score": 0.0,
                                "orgNr": int.parse(newOrgNr),
                                "place": place,
                                "totScore": 0,
                                "numberOfUsers": 0,
                                "isActive": false
                              };

                              if (imageFile != null) {
                                Reference reference = FirebaseStorage.instance
                                    .ref()
                                    .child("orgs/" + getRandomString(5));

                                UploadTask uploadTask =
                                    reference.putFile(imageFile!);
                                uploadTask.then((res) async {
                                  String downlaodUrl =
                                      await res.ref.getDownloadURL();
                                  print(downlaodUrl);
                                  dataForUpload["img"] = downlaodUrl;
                                  if (currContent != null) {
                                    await FirebaseFirestore.instance
                                        .collection("org")
                                        .doc(currContent.objectID)
                                        .update(dataForUpload)
                                        .then((doc) {
                                      StoredData.adminOrg =
                                          currContent.objectID;
                                      FirebaseFirestore.instance
                                          .collection("newOrg")
                                          .doc(currContent.objectID)
                                          .delete()
                                          .catchError((err) => print(err));
                                    });
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection("org")
                                        .doc(newOrgNr)
                                        .set(dataForUpload)
                                        .then((doc) {
                                      StoredData.adminOrg = newOrgNr;
                                      FirebaseFirestore.instance
                                          .collection("accountNr")
                                          .doc(newOrgNr)
                                          .set({
                                        "kontoNr": newOrgKonto,
                                      });
                                    });
                                  }
                                });
                              } else {
                                if (currContent != null) {
                                  await FirebaseFirestore.instance
                                      .collection("org")
                                      .doc(currContent.objectID)
                                      .update(dataForUpload)
                                      .then((doc) {
                                    StoredData.adminOrg = currContent.objectID;
                                    FirebaseFirestore.instance
                                        .collection("accountNr")
                                        .doc(currContent.objectID)
                                        .set({
                                      "kontoNr": newOrgKonto,
                                    });
                                    FirebaseFirestore.instance
                                        .collection("newOrg")
                                        .doc(currContent.objectID)
                                        .delete()
                                        .catchError((err) => print(err));
                                  });
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection("org")
                                      .doc(newOrgNr)
                                      .set(dataForUpload)
                                      .then((doc) {
                                    StoredData.adminOrg = newOrgNr;
                                    FirebaseFirestore.instance
                                        .collection("accountNr")
                                        .doc(newOrgNr)
                                        .set({
                                      "kontoNr": newOrgKonto,
                                    });
                                  });
                                }
                              }

                              actionRespons(
                                  "Fullført org. oppsett", scafctn, true);
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(18),
                          child: const Text(
                            "Ferdig",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
                      SizedBox(height: sendContact ? 200 : 10)
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      });
}

settingModalBottomSheet(BuildContext scafctn, BuildContext context,
    AlgoliaObjectSnapshot? currContent) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(30),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              Text(
                currContent != null
                    ? "Vi trenger litt info om " +
                        currContent.data["navn"] +
                        "."
                    : "Vi trenger litt info om din org.",
                textScaleFactor: 1.0,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                "Velg en av boksene",
                textScaleFactor: 1.0,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => addNewModalBottomSheet(
                          scafctn, context, true, currContent),
                      child: Container(
                        width: 110,
                        height: 80,
                        alignment: Alignment.center,
                        child: const Text(
                          "Kontakt din org.",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      )),
                  TextButton(
                      onPressed: () => addNewModalBottomSheet(
                          scafctn, context, false, currContent),
                      child: Container(
                        width: 110,
                        height: 80,
                        alignment: Alignment.center,
                        child: const Text(
                          "Fyll inn org. info",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      )),
                ],
              ),
            ],
          ),
        );
      });
}
