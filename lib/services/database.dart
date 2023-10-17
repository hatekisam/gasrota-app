import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grasrota/models/quiz.dart';
import 'package:grasrota/models/quizinfo.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/models/userscore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ""});

  final CollectionReference quizCol =
      FirebaseFirestore.instance.collection("quiz");
  final CollectionReference userCol =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference orgCol =
      FirebaseFirestore.instance.collection("org");
  late User firebaseuser;
  // get user stream
  Stream<UserModal?> userDataStream(user, String token) {
    firebaseuser = user;
    return userCol
        .doc(user != null ? user.uid : null)
        .snapshots()
        .map((e) => _userDataFromSnapshot(e, token));
  }

  UserModal? _userDataFromSnapshot(DocumentSnapshot snapshot, String token) {
    // ignore: unnecessary_null_comparison
    return snapshot != null
        ? UserModal(
            isAdmin: snapshot["isAdmin"] ?? false,
            profileImg: snapshot["image"] ?? "",
            uid: snapshot.id,
            score: snapshot["score"] ?? 0,
            name: snapshot["name"] ?? "",
            org: snapshot["org"] ?? "",
            tlf: snapshot["tlf"],
            played: snapshot["played"] ?? [],
            price: snapshot["price"] ?? 1500,
            uidtoken: token)
        : null;
  }

  Future saveProgress(
      String quizId,
      int cor,
      int wro,
      int questLength,
      int week,
      int newScore,
      int scoreProg,
      String orgId,
      String date,
      int totAddScore) async {
    await userCol.doc(uid).update({
      "score": newScore,
    });
    await orgCol.doc(orgId).collection("users").doc(uid).update({
      "score": newScore,
    });

    await userCol.doc(uid).collection("progress").doc(quizId).set({
      "correct": cor,
      "incorrect": wro,
      "questLength": questLength,
      "week": week,
      "score": scoreProg,
      "date": date,
    }, SetOptions(merge: true));

    await orgCol.doc(orgId).get().then((doc) async {
      dynamic totalScoreUsers = doc["totScore"] + totAddScore;
      dynamic numberOfUsers = doc["numberOfUsers"];

      var scorePoeng =
          (totalScoreUsers / (numberOfUsers * 700)).toStringAsFixed(2);

      if (double.parse(scorePoeng) > 1) {
        scorePoeng = 1;
      }
      await orgCol.doc(orgId).update({
        "totScore": totalScoreUsers,
        "score": double.parse(scorePoeng)
      }).catchError((err) {
        orgCol.doc(orgId).update({"score": 0});
      });
    }).catchError((err) => print(err));
  }

  Future newOrgRequest(String toMail, String name, String tlf) async {
    await FirebaseFirestore.instance
        .collection("newOrg")
        .add({"name": name, "to": toMail, "tlf": tlf});
  }

  Stream<List<UserScore>> userstream(afterDoc, orgId) {
    return orgCol
        .doc(orgId)
        .collection("users")
        .orderBy("score", descending: true)
        .limit(20)
        .startAfterDocument(afterDoc)
        .snapshots()
        .map(_userListFromSnapshot);
  }

  List<UserScore> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserScore(
        name: doc["name"] ?? "",
        score: doc["score"] ?? 0,
        profileImg: doc["image"] ?? "",
      );
    }).toList();
  }

  Stream<List<QuizInfo>> quizInfoStream(String quizId) {
    return quizCol
        .doc(quizId)
        .collection("questions")
        .snapshots()
        .map(_quizInfoListFromSnapshot);
  }

  getTopUser(orgId) async {
    return await orgCol
        .doc(orgId)
        .collection("users")
        .orderBy("score", descending: true)
        .limit(4)
        .get();
  }

  Future<bool> isOrgActive(orgId) async {
    return await orgCol.doc(orgId).get().then((doc) {
      if (doc.get("isActive") == true)
        return true;
      else
        return false;
    }).catchError((err) => false);
  }

  getQuizData(String quizId) async {
    return await quizCol.doc(quizId).collection("questions").get();
  }

  getQuizesStats() async {
    return await userCol
        .doc(uid)
        .collection("progress")
        .orderBy("date", descending: true)
        .get()
        .catchError((err) => print(err));
  }

  getUserQuizData(String quizId) async {
    return await userCol.doc(uid).collection("progress").doc(quizId).get();
  }

  updateUserPlayed(String docId) async {
    return await userCol.doc(uid).update({
      "played": FieldValue.arrayUnion([docId]),
    });
  }

  Future updateOrg(String newOrg, bool isAdmin) async {
    return await userCol.doc(uid).update({"org": newOrg, "isAdmin": isAdmin});
  }

  Future updateTlf(String newTlf, int newPrice) async {
    if (newPrice >= 15 && newTlf.length == 8) {
      return await userCol.doc(uid).update({
        "price": newPrice * 100,
        "tlf": newTlf,
      });
    } else if (newTlf.length == 8) {
      return await userCol.doc(uid).update({
        "tlf": newTlf,
      });
    } else {
      return await userCol.doc(uid).update({
        "price": newPrice * 100,
      });
    }
  }

  List<QuizInfo> _quizInfoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return QuizInfo(
          ans1: doc["ans1"] ?? "null",
          ans2: doc["ans2"] ?? "null",
          ans3: doc["ans3"] ?? "null",
          ans4: doc["ans4"] ?? "null",
          answer: doc["answer"] ?? "null",
          image: doc["image"] ?? "null",
          question: doc["question"] ?? "null",
          src: {});
    }).toList();
  }

  Stream<List<QuizMod>> get quizStream {
    final date = DateTime.now();

    final startOfYear = new DateTime(date.year, 1, 1, 0, 0);
    final firstMonday = startOfYear.weekday;
    final daysInFirstWeek = 8 - firstMonday;
    final diff = date.difference(startOfYear);
    var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();

    try {
      // It might differ how you want to treat the first week
      if (daysInFirstWeek > 3) {
        weeks += 1;
      }

      print('Week number: $weeks');
      print('quizCol : $quizCol');
      // Log the data of quizCol
      //       quizCol.get().then((querySnapshot) {
      //         querySnapshot.docs.forEach((doc) {
      //           print('Quiz Data for Document ID ${doc.id}:');
      //           print('Week: ${doc['week']}');
      //           print('Date: ${doc['date']}');
      //         });
      //       });

      return quizCol
          .where("week", isEqualTo: weeks)
          .snapshots()
          .map(_quizListFromSnapshot);
    } catch (e, stackTrace) {
      print('Error fetching quiz data: $e');
      print('Stack Trace: $stackTrace');
      return Stream.value([]); // Return an empty stream in case of an error.
    }
  }


  /*Stream<List<QuizMod>> get quizStream {
    var date = new DateTime.now();
    var dateWeek = int.parse(DateFormat("D").format(date));

    return quizCol
        .where("weekNr",
            isEqualTo: ((dateWeek - date.weekday + 10) / 7).floor())
        .where("yearNr", isEqualTo: date.year)
        .snapshots()
        .map(_quizListFromSnapshot);
  }*/

  List<QuizMod> _quizListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      print(doc);
      return QuizMod(
          id: doc.id, date: doc["date"] ?? "", week: doc["week"] ?? 0);
    }).toList();
  }
}
