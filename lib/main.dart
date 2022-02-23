import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'quiz_brain.drat.dart';

void main() => runApp(Quizzler());

QuizBrain quizBrain = new QuizBrain();

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int qNo = 0;
  List<Icon> answers = [];

  void rightAns() {
    setState(() {
      answers.add(Icon(
        Icons.check,
        color: Colors.green,
      ));
    });
  }

  void wrongAns() {
    setState(() {
      answers.add(Icon(Icons.close, color: Colors.red));
    });
  }

  void lockAnswer(bool userAns) {
    if (quizBrain.isFinished() ) {
      showAlert();
    } else {
      bool ans = quizBrain.getCorrectAnswer();
      if (userAns == ans) {
        rightAns();
      } else {
        wrongAns();
      }

      setState(() {
        quizBrain.nextQuestion();
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: const Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                lockAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                lockAnswer(false);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),
          child: Row(
            children: answers,
          ),
        )
      ],
    );
  }

  void showAlert() {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Finished!",
      desc: "You have answered all the questions.",
      buttons: [
        DialogButton(
          child: Text(
            "Reset",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            setState(() {
              quizBrain.reset();
              answers = [];

            });
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }
}
