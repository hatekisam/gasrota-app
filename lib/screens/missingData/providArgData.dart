import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grasrota/models/storedData.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/services/database.dart';
import 'package:grasrota/shared/constants.dart';
import 'package:grasrota/shared/search_list.dart';

class ProvideArgData extends StatefulWidget {
  final UserModal user;
  ProvideArgData({required this.user});

  @override
  _ProvideArgDataState createState() => _ProvideArgDataState();
}

class _ProvideArgDataState extends State<ProvideArgData> {
  final _formKey = GlobalKey<FormState>();
  String search = "";
  String tlf = "";
  int price = 0;
  bool hasClicked = false;
  bool hasClicked2 = false;
  bool isLoading = false;

  @override
  void initState() {
    StoredData.choosenOrg = "";
    StoredData.isAdmin = false;
    super.initState();
  }

  addTlfOrAmount() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Vi mangler litt info",
                textScaleFactor: 1.0,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              widget.user.tlf == null
                  ? TextFormField(
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration:
                          textInputDecoration.copyWith(hintText: "Tlf."),
                      validator: (val) =>
                          val!.length != 8 ? "Fyll inn ditt tlf. nr" : null,
                      onChanged: (val) {
                        setState(() => tlf = val);
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              widget.user.price == 0
                  ? Row(
                      children: [
                        Container(
                          width: 130,
                          child: TextFormField(
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: textInputDecoration.copyWith(
                                hintText: "Bidrag"),
                            validator: (val) =>
                                val!.isEmpty || int.parse(val) < 50
                                    ? "min 50kr"
                                    : null,
                            onChanged: (val) {
                              setState(() => price = int.parse(val));
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "KR.   hver måned",
                          textScaleFactor: 1.0,
                        )
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              isLoading
                  ? const SpinKitWave(
                      color: Colors.cyan,
                      size: 37,
                    )
                  : InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        height: 41,
                        width: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: const LinearGradient(
                              colors: [Colors.cyan, Colors.greenAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                        ),
                        child: Text("Fullfør",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ),
                      onTap: () async {
                        HapticFeedback.heavyImpact();
                        if (_formKey.currentState!.validate() && !hasClicked) {
                          setState(() {
                            isLoading = true;
                          });
                          hasClicked = true;
                          await DatabaseService(uid: widget.user.uid)
                              .updateTlf(tlf, price);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }),
            ],
          ),
        ),
      ),
    );
  }

  addOrg(scafCtn) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SearchList(
          scaffoldCtn: scafCtn,
          minusHeight: 325,
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
                  height: 41,
                  width: 145,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.greenAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: Text("Fullfør",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
                onTap: () async {
                  HapticFeedback.heavyImpact();
                  setState(() {
                    isLoading = true;
                  });
                  if (!hasClicked2) {
                    final HttpsCallable callable =
                        FirebaseFunctions.instance.httpsCallable("updateOrg");

                    await callable.call(<String, dynamic>{
                      "uid": widget.user.uid,
                      "score": widget.user.score,
                      "name": widget.user.name,
                      "image": widget.user.profileImg,
                      "org": StoredData.choosenOrg,
                    });
                    if (StoredData.choosenOrg == StoredData.adminOrg) {
                      StoredData.isAdmin = true;
                    }
                    await DatabaseService(uid: widget.user.uid)
                        .updateOrg(StoredData.choosenOrg, StoredData.isAdmin);
                    setState(() {
                      hasClicked2 = true;
                      isLoading = false;
                    });
                  }
                }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (scafCtn) =>
              widget.user.org != "" ? addTlfOrAmount() : addOrg(scafCtn),
        ));
  }
}
