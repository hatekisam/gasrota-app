import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:grasrota/models/storedData.dart';
import 'package:grasrota/shared/constants.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final fb = FacebookLogin();

  // sign in with email & password
  // Future signInWithEmailAndPassword(String email, String password, bool isLogin) async {
  //   print("TAG_ANDRA Sign in with email and pass " + email + " - " + password + " - ");
  //   debugPrint("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  //   print(isLogin);
  //   debugPrint("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  //   if (!isLogin) {
  //     debugPrint("{{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}");
  //     print(isLogin);
  //     debugPrint("{{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}");
  //     Future.delayed(const Duration(milliseconds: 2000), () async {
  //       try {
  //         dynamic res = await auth.signInWithEmailAndPassword(
  //             email: email, password: password);
  //         StoredData.checkedStat = null;
  //         debugPrint("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
  //         print(res);
  //         debugPrint("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
  //
  //         return res;
  //       } on FirebaseAuthException catch (e) {
  //         print("FIREBASE AUTH EXCEPTION" + e.toString());
  //         return getAuthErrorString(e);
  //
  //       }
  //     });
  //   } else {
  //     dynamic res = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     StoredData.checkedStat = null;
  //     debugPrint('#####################################--');
  //     print(res);
  //     debugPrint('#####################################--');
  //     return res;
  //   }
  // }

  Future<dynamic> signInWithEmailAndPassword(String email, String password, bool isLogin) async {
    print("TAG_ANDRA Sign in with email and pass " + email + " - " + password + " - ");
    debugPrint("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    print(isLogin);
    debugPrint("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

    try {
      if (!isLogin) {
        debugPrint("{{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}");
        print(isLogin);
        debugPrint("{{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}");

        final res = await auth.signInWithEmailAndPassword(email: email, password: password);
        StoredData.checkedStat = null;
        debugPrint("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
        print(res);
        debugPrint("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");

        return res;
      } else {
        final res = await auth.signInWithEmailAndPassword(email: email, password: password);
        StoredData.checkedStat = null;
        debugPrint('#####################################--');
        print(res);
        debugPrint('#####################################--');

        return res;
      }
    } on FirebaseAuthException catch (e) {
      print("FIREBASE AUTH EXCEPTION" + e.toString());
      return getAuthErrorString(e);
    }
  }

  String getAuthErrorString(FirebaseAuthException e) {
    print('------------------------' + e.code);
    if (e.code == 'wrong-password') {
      return "vennligst oppgi en gyldig passord";
    } else if (e.code == 'user-not-found') {
      return "Email ikke registrert. Gå til registrerings siden.";
    } else if (e.code == 'invalid-email') {
      return "ugyldig email";
    } else if (e.code == 'email-already-exists') {
      return "Email din er registrert.";
    } else if (e.code == 'ERROR_MISSING_GOOGLE_ID_TOKEN') {
      return "Missing Google Id Token.";
    } else if (e.code == 'ERROR_GOOGLE_SIGN_IN_FAILED') {
      return "Failed to sign in with Google.";
    } else if (e.code == 'ERROR_ABORTED_BY_USER') {
      return "Sign in aborted by user❌.";
    }
    return "feil email eller passord";
  }

  Future signInWithCredential(OAuthCredential credential) async {
    try {
      dynamic res = await auth.signInWithCredential(credential);
      StoredData.checkedStat = null;
      return res;
    } on FirebaseAuthException catch (e) {
      // Future.delayed(const Duration(seconds: 2), () async {
      //   await signInWithEmailAndPassword(email, password);
      // });
      print(e);
      return getAuthErrorString(e);
    }
  }

  Future signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      try {
        print(googleUser);

        // List<String> res =
        //     await auth.fetchSignInMethodsForEmail(googleUser.email);
        // print('email: $res');
        // if (!res.contains("password")) {
        //   FirebaseAuthException e =
        //       new FirebaseAuthException(code: "user-not-found");
        //   return getAuthErrorString(e);
        // }
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null) {
          final userCredential =
              await auth.signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ));
          StoredData.checkedStat = null;
          return userCredential.user;
        } else {
          FirebaseAuthException e =
              new FirebaseAuthException(code: "ERROR_MISSING_GOOGLE_ID_TOKEN");
          return getAuthErrorString(e);
        }
      } catch (e) {
        print('Error signing in with Google: ${e.toString()}');
        return null;
      }
    } else {
      FirebaseAuthException e =
          new FirebaseAuthException(code: "ERROR_ABORTED_BY_USER");
      return getAuthErrorString(e);
    }

    // try {
    //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //   // User Existence Check
    //   if (googleUser == null) return null;
    //   List<String> res =
    //       await auth.fetchSignInMethodsForEmail(googleUser.email);
    //   print('email: $res');
    //   if (!res.contains("password")) {
    //     FirebaseAuthException e =
    //         new FirebaseAuthException(code: "user-not-found");
    //     return getAuthErrorString(e);
    //   }

    //   final GoogleSignInAuthentication? googleAuth =
    //       await googleUser.authentication;

    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth?.accessToken,
    //     idToken: googleAuth?.idToken,
    //   );

    //   return await signInWithCredential(credential);
    // } catch (e) {
    //   // Future.delayed(const Duration(seconds: 2), () async {
    //   //   await signInWithEmailAndPassword(email, password);
    //   // });
    //   print(e);
    //   return null;
    // }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      if (kDebugMode) {
        print(appleCredential.authorizationCode);
      }

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final authResult = await auth.signInWithCredential(oauthCredential);
      print(authResult.user);
      print('object ${appleCredential}');

      if (authResult.user != null) {
        final firebaseUser = authResult.user;
        final displayName =
            '${appleCredential.givenName ?? "Apple"} ${appleCredential.familyName ?? "User"}';
        final userEmail = '${appleCredential.email}';

        await firebaseUser?.updateDisplayName(displayName);
        // await firebaseUser?.updateEmail(userEmail);

        StoredData.checkedStat = null;
        return firebaseUser;
      } else {
        FirebaseAuthException e =
            new FirebaseAuthException(code: "ERROR_ABORTED_BY_USER");
        return getAuthErrorString(e);
      }
    } catch (exception) {
      if (kDebugMode) {
        print('error : ${exception.toString()}');
      }
      return null;
    }
    // try {
    //   final rawNonce = generateNonce();
    //   final nonce = sha256ofString(rawNonce);

    //   final appleCredential = await SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //     nonce: nonce,
    //   );

    //   // User Existence Check
    //   if (appleCredential.email == null) return null;
    //   List<String> res =
    //       await auth.fetchSignInMethodsForEmail(appleCredential.email!);
    //   if (!res.contains("password")) {
    //     FirebaseAuthException e =
    //         new FirebaseAuthException(code: "user-not-found");
    //     return getAuthErrorString(e);
    //   }

    //   final oauthCredential = OAuthProvider("apple.com").credential(
    //     idToken: appleCredential.identityToken,
    //     rawNonce: rawNonce,
    //   );

    //   return await signInWithCredential(oauthCredential);
    // } catch (e) {
    //   // Future.delayed(const Duration(seconds: 2), () async {
    //   //   await signInWithEmailAndPassword(email, password);
    //   // });
    //   print(e);
    //   return null;
    // }
  }

  // sign in with facebook
  Future signInWithFacebook() async {
    final FacebookLoginResult result = await fb.logIn(["email"]);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        try {
          final String token = result.accessToken.token;
          final credential = FacebookAuthProvider.credential(token);
          var userData = await auth.signInWithCredential(credential);

          //check if user is non exsisting
          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection("users")
              .doc(userData.user!.uid)
              .get();

          StoredData.checkedStat = null;
          if (!doc.exists) {
            final HttpsCallable callable =
                FirebaseFunctions.instance.httpsCallable('createFacebookUsr');

            final FirebaseMessaging _firebaseMessaging =
                FirebaseMessaging.instance;

            dynamic res = await callable.call(<String, dynamic>{
              'uid': userData.user!.uid,
              'name': userData.user!.displayName,
              'image': userData.user!.photoURL,
              'tlf': userData.user!.phoneNumber,
              'token': await _firebaseMessaging.getToken(),
            });

            return {"url": res.data};
          } else {
            return result;
          }
        } catch (e) {}
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  Future resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return null;
    }
  }

  // registrer with email & password00
  Future registerWithEmailAndPassword(
      String email,
      String password,
      String username,
      File? imageFile,
      String tlf,
      String org,
      int price,
      bool isAdmin) async {
    try {
      final randId = getRandomString(28);
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

      String downlaodUrl = "";

      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createUsr');

      HttpsCallableResult? result;
      if (imageFile != null) {
        print("TAG_ANDRA Image file is not  null");
        Reference reference =
            FirebaseStorage.instance.ref().child("images/" + randId);

        UploadTask uploadTask = reference.putFile(imageFile);
        uploadTask.then((res) async {
          downlaodUrl = await res.ref.getDownloadURL().whenComplete(() async => {
              result = await callable.call(<String, dynamic>{
              "uid": randId,
              'email': email,
              'password': password,
              'name': username,
              'image': downlaodUrl,
              'tlf': tlf,
              'org': org,
              'isAdmin': isAdmin,
              'token': await _firebaseMessaging.getToken(),
              'price': price * 100,
              })
          });
        }).then((value) {
          print("TAG_ANDRA download url dobijen valjda");
          return result;
        });
      } else {
        result = await callable.call(<String, dynamic>{
          "uid": randId,
          'email': email,
          'password': password,
          'name': username,
          'image': "",
          'tlf': tlf,
          'org': org,
          'isAdmin': isAdmin,
          'token': await _firebaseMessaging.getToken(),
          'price': price * 100,
        }).then((value) {
          print("TAG_ANDRA Simi dobijen valjda");
           return result;
        });
      }

      print("TAG_ANDRA Is result done? " + result.toString());

      /*
      if (result == null) {
        return result;
      } else if (result!.data.toString().contains("email-already-exists")) {
        FirebaseAuthException e =
            new FirebaseAuthException(code: "email-already-exists");
        return getAuthErrorString(e);
      }
      StoredData.checkedStat = null;
      return {"email": email, "password": password};
       */

    } catch (e) {
      print(e);
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      await auth.signOut();
      StoredData.checkedStat = null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
