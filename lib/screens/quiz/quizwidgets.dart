import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grasrota/models/quizinfo.dart';
import 'package:grasrota/models/usermodal.dart';
import 'package:grasrota/screens/quiz/allanswer.dart';
import 'package:grasrota/screens/quiz/question.dart';
import 'package:grasrota/services/database.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class QuizWidgets extends StatefulWidget {
  final UserModal user;
  final QuerySnapshot quiz;
  final int totalt;
  final String quizId;
  final String date;
  final int week;
  final int startCor;
  int correct;
  int incorrect;
  int questIndex;
  QuizWidgets({
    required this.quiz,
    required this.totalt,
    required this.quizId,
    required this.user,
    required this.correct,
    required this.incorrect,
    required this.questIndex,
    required this.date,
    required this.startCor,
    required this.week,
  });

  @override
  _QuizWidgetsState createState() => _QuizWidgetsState();
}

late AnimationController controller;
bool isAnswerd = false;
int nr = 0;
late VideoPlayerController _videoController;

class _QuizWidgetsState extends State<QuizWidgets>
    with TickerProviderStateMixin {
  QuizInfo getQuestionModelFromDatasnapshot(DocumentSnapshot snapshot) {
    QuizInfo quizinfo = QuizInfo(
        ans1: '',
        ans2: '',
        ans3: '',
        ans4: '',
        answer: '',
        image: '',
        question: '',
        src: {});
    quizinfo.question = snapshot["question"];

    List<String> options = [
      snapshot["ans1"],
      snapshot["ans2"],
      snapshot["ans3"],
      snapshot["ans4"],
    ];
    options.shuffle();

    quizinfo.ans1 = options[0];
    quizinfo.ans2 = options[1];
    quizinfo.ans3 = options[2];
    quizinfo.ans4 = options[3];

    quizinfo.answer = snapshot["answer"];
    quizinfo.src =
        (snapshot.data() as Map).containsKey("src") ? snapshot["src"] : null;

    return quizinfo;
  }

  QuizInfo? curQuiz;
  bool showSource = true;
  bool isDone = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    controller.value = 0.0;

    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        nr = 0;
        isAnswerd = true;
        Future.delayed(const Duration(milliseconds: 1250), () {
          setState(() {
            nextQuestion(0);
            isAnswerd = false;
          });
        });
      }
    });
    curQuiz =
        getQuestionModelFromDatasnapshot(widget.quiz.docs[widget.questIndex]);
    showSource = curQuiz!.src == null ? true : false;
    super.initState();
  }

  void nextQuestion(int nr) {
    setState(() {
      controller.value = 0.0;
      if (nr == 1) {
        widget.correct++;
      } else {
        widget.incorrect++;
      }
      if (widget.questIndex + 1 < widget.totalt) {
        widget.questIndex++;
        showSource = false;
      } else {
        done();
        isDone = true;
      }
    });
  }

  done() {
    DatabaseService(uid: widget.user.uid).saveProgress(
        widget.quizId,
        widget.correct,
        widget.incorrect,
        widget.questIndex + 1,
        widget.week,
        widget.user.score + ((widget.correct - widget.startCor) * 10),
        widget.correct * 10,
        widget.user.org,
        widget.date,
        ((widget.correct - widget.startCor) * 10));
    if (widget.questIndex + 1 >= widget.totalt) {
      DatabaseService(uid: widget.user.uid).updateUserPlayed(widget.quizId);
      Navigator.pop(context);
    }
    isAnswerd = false;
  }

  @override
  void dispose() {
    try {
      if (_videoController != null) _videoController.dispose();
    } catch (e) {}

    if (!isDone) {
      DatabaseService(uid: widget.user.uid).saveProgress(
        widget.quizId,
        nr == 1 ? widget.correct + 1 : widget.correct,
        nr == 1
            ? widget.incorrect
            : widget.questIndex + 1 >= widget.totalt
                ? widget.incorrect
                : widget.incorrect + 1,
        widget.questIndex + 1,
        widget.week,
        nr == 1
            ? widget.user.score + ((widget.correct - widget.startCor + 1) * 10)
            : widget.user.score + ((widget.correct - widget.startCor) * 10),
        nr != 1 ? widget.correct * 10 : (widget.correct + 1) * 10,
        widget.user.org,
        widget.date,
        nr == 1
            ? ((widget.correct - widget.startCor + 1) * 10)
            : ((widget.correct - widget.startCor) * 10),
      );
    }

    if (widget.questIndex + 1 >= widget.totalt) {
      DatabaseService(uid: widget.user.uid).updateUserPlayed(widget.quizId);
    }
    isAnswerd = false;
    controller.dispose();
    super.dispose();
  }

  void showSrc() {
    setState(() {
      showSource = !showSource;
    });
  }

  void checkVideo() {
    if (_videoController.value.position == _videoController.value.duration) {
      showSrc();
    }
  }

  @override
  Widget build(BuildContext context) {
    nr = 0;
    if (!isAnswerd) {
      curQuiz =
          getQuestionModelFromDatasnapshot(widget.quiz.docs[widget.questIndex]);
    }

    if (!curQuiz!.src["isImage"] && !showSource) {
      _videoController = VideoPlayerController.network(curQuiz!.src["src"]);

      _videoController.initialize().then((value) {
        _videoController.play();
      });
      _videoController.addListener(checkVideo);
    }

    void nextQuestion(int nr) {
      setState(() {
        controller.value = 1.0;
        if (nr == 1) {
          widget.correct++;
        } else {
          widget.incorrect++;
        }
        if (widget.questIndex + 1 < widget.totalt) {
          widget.questIndex++;
          showSource = false;
        } else {
          done();
        }
      });
    }

    return Column(
      children: [
        !showSource && !curQuiz!.src["isImage"]
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
                          minWidth: MediaQuery.of(context).size.width),
                      child: VideoPlayer(_videoController),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Container(
                    margin: curQuiz!.src["isImage"]
                        ? const EdgeInsets.only(top: 0)
                        : const EdgeInsets.only(top: 180),
                    child: Question(
                      questRight: widget.correct,
                      questWrong: widget.incorrect,
                      currentQuest: widget.questIndex,
                      totaltQuest: widget.totalt,
                      quizInfo: curQuiz!,
                    ),
                  ),
                  Transform.translate(
                      offset: curQuiz!.src["isImage"]
                          ? const Offset(0, -160)
                          : const Offset(0, -120),
                      child: AllAnswer(
                          curQuiz: curQuiz!, nextQuestion: nextQuestion)),
                ],
              ),
      ],
    );
  }
}
