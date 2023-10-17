import 'package:algolia/algolia.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grasrota/models/storedData.dart';
import 'package:grasrota/shared/newOrg.dart';

class SearchList extends StatefulWidget {
  final BuildContext scaffoldCtn;
  final int minusHeight;
  SearchList({required this.scaffoldCtn, required this.minusHeight});
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final Algolia _algolia = Algolia.init(
     applicationId: 'E6G7DS19HZ', apiKey: '2109038c49311d1da22abdb4ffbb1697'
  );

  List<AlgoliaObjectSnapshot> results = [];
  bool isSearching = false;

  Future<List<AlgoliaObjectSnapshot>> _searchOrg(String search) async {
    if (search.length > 0) {
      AlgoliaQuery _algQuery =
          _algolia.instance.index("test").query(search).setMaxValuesPerFacet(3);
      AlgoliaQuerySnapshot querySnap = await _algQuery.getObjects();
      List<AlgoliaObjectSnapshot> res = querySnap.hits;
      return res;
    } else {
      return [];
    }
  }

  @override
  void initState() {
    StoredData.choosenOrg = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "f",
            textScaleFactor: 1.0,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 25, left: 10, right: 10),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 20, color: Colors.black.withOpacity(.05))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: TextField(
                    style: const TextStyle(fontSize: 18),
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: "Søk...",
                      icon: const Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) async {
                      if (val.length == 0) {
                        isSearching = false;
                      } else {
                        isSearching = true;
                      }

                      var res = await _searchOrg(val);

                      setState(() {
                        results = res;
                      });
                    },
                  ),
                ),
              )),
          SizedBox(height: !isSearching || results.length < 1 ? 20 : 0),
          Container(
              height:
                  MediaQuery.of(context).size.height - widget.minusHeight - 100,
              child: !isSearching
                  ? const Text(
                      "Søk",
                      textScaleFactor: 1.0,
                    )
                  : results.length > 0
                      ? OrgList(
                          scaffoldCtn: widget.scaffoldCtn, result: results)
                      : const Text(
                          "Ingen Resultater",
                          textScaleFactor: 1.0,
                        )),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "har vi glemt noen?",
                  style: TextStyle(color: Colors.black.withOpacity(.6)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      HapticFeedback.heavyImpact();
                      settingModalBottomSheet(
                          widget.scaffoldCtn, context, null);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrgList extends StatefulWidget {
  final List<AlgoliaObjectSnapshot> result;
  final BuildContext scaffoldCtn;
  OrgList({required this.result, required this.scaffoldCtn});

  @override
  _OrgListState createState() => _OrgListState();
}

class _OrgListState extends State<OrgList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: widget.result.isEmpty
            ? const SizedBox()
            : ListView.builder(
                itemBuilder: (context, index) {
                  return RadioListTile(
                    activeColor: Colors.cyan,
                    /*secondary: widget.result[index].data["image"] != "" ||
                            widget.result[index].data["image"] != null
                        ? Image.network(
                            widget.result[index].data["image"],
                            width: 38,
                            height: 38,
                            fit: BoxFit.contain,
                          )
                        : const SizedBox(),*/
                    value: widget.result[index].objectID,
                    groupValue: StoredData.choosenOrg,
                    subtitle: widget.result[index].data["place"] == null
                        ? null
                        : Text(
                            widget.result[index].data["place"].toLowerCase(),
                            textScaleFactor: 1.0,
                          ),
                    onChanged: (String? val) {
                      if (widget.result[index].data["contactName"] == "" ||
                          widget.result[index].data["contactName"] == null) {
                        settingModalBottomSheet(
                            widget.scaffoldCtn, context, widget.result[index]);
                      } else {
                        setState(() {
                          StoredData.choosenOrg = val.toString();
                        });
                      }
                    },
                    title: Text(
                      widget.result[index].data["navn"].toUpperCase(),
                      textScaleFactor: 1.0,
                    ),
                  );
                },
                itemCount: widget.result.length,
              ));
  }
}
