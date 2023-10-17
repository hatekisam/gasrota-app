import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final userStat = prefs.getBool('isNewUser') ?? true;
  final savedTokenKey = "savedToken";
  final savedToken = prefs.getString(savedTokenKey);

  if (savedToken != null && savedToken.isNotEmpty && savedToken.length > 20)
      return savedToken;

  final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getTokenCal');

  dynamic resp = await callable.call(<String, dynamic>{});
  print("TAG_ANDRA Response: " + resp.data);

  var decoResp = json.decode(resp.data);
  print("TAG_ANDRA Decoded: " + decoResp["access_token"]);

  token = {
    "token": decoResp["access_token"],
    "expire": decoResp["expires_on"]
  };

  prefs.setString(savedTokenKey, token!["token"]);

  return token!["token"];

  // if (!userStat) {
  //   int currTime = DateTime
  //       .now()
  //       .millisecondsSinceEpoch;
  //
  //   if (savedToken != null && savedToken.isNotEmpty)
  //     return savedToken;
  //
  //   //DateTime.parse(token!["expire"]).microsecondsSinceEpoch < currTime
  //
  //   if (token!.containsKey("token")) {
  //     if (token!["token"] == "null") {
  //       final HttpsCallable callable =
  //       FirebaseFunctions.instance.httpsCallable('getTokenCal');
  //       dynamic resp = await callable.call(<String, dynamic>{});
  //       print("TAG_ANDRA token response1 " + resp.data);
  //       var decoResp = json.decode(resp.data);
  //       print("TAG_ANDRA deco response1 " + decoResp["access_token"]);
  //       token = {
  //         "token": decoResp["access_token"],
  //         "expire": decoResp["expires_on"]
  //       };
  //
  //       prefs.setString("savedToken", token!["token"]);
  //
  //       return token!["token"];
  //     } else {
  //       return token!["token"];
  //     }
  //   } else if (savedToken == null || savedToken.isEmpty) {
  //     final HttpsCallable callable =
  //     FirebaseFunctions.instance.httpsCallable('getTokenCal');
  //     dynamic resp = await callable.call(<String, dynamic>{});
  //     print("TAG_ANDRA token response2 " + resp.data);
  //     var decoResp = json.decode(resp.data);
  //     print("TAG_ANDRA deco response2 " + decoResp["access_token"]);
  //     token = {
  //       "token": decoResp["access_token"],
  //       "expire": decoResp["expires_on"]
  //     };
  //
  //     prefs.setString("savedToken", token!["token"]);
  //
  //     return token!["token"];
  //   } else {
  //     return savedToken;
  //   }
  // } else {
  //   prefs.setBool('isNewUser', false);
  //   return "nyuser";
  // }
  //}

  //return "nyuser";
}
