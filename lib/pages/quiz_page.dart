import 'dart:async';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  int _timerSeconds = 20;
  int _currentIndex = 0;
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;

  List<Question> questions = [
    Question("What's your name?", "Tsá kitáánikko?",
        ["Option 1", "Tsá kitáánikko?", "Option 3", "Option 4"]),
  ];

  bool _shouldPauseTimer = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _timerSeconds),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
        nextQuestion();
      } else if (!_shouldPauseTimer) {
        setState(() {
          _timerSeconds--;
        });
      }
    });
  }

  void nextQuestion() {
    setState(() {
      _currentIndex++;
      if (_currentIndex < questions.length) {
        _timerSeconds = 20;
        _controller.reset();
        _controller.forward();
        startTimer();
      } else {}
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    // Pause the timer
    _shouldPauseTimer = true;

    // Show exit dialog
    bool shouldExit = await showDialog(
      context: context,
      barrierDismissible: false, // prevent tapping outside to dismiss
      builder: (context) => AlertDialog(
        title: Text("Exit Quiz?"),
        content: Text("Are you sure you want to exit the quiz?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Cancel the timer and navigate back
              _timer.cancel();
              _shouldPauseTimer = false;
              Navigator.of(context).pop(true);
            },
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              // Resume the timer
              _shouldPauseTimer = false;
              Navigator.of(context).pop(false);
            },
            child: Text("No"),
          ),
        ],
      ),
    );

    // Returning shouldExit to determine whether to pop or not
    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
          backgroundColor: Colors.deepPurple,
        ),
        body: _currentIndex < questions.length
            ? buildQuestionCard(questions[_currentIndex])
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Quiz Completed!',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Icon(
                      Icons.done_all,
                      size: 60.0,
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildQuestionCard(Question question) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: 10.0),
            DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  color: Colors.grey[200],
                  child: Text("Drag and drop your answer here"),
                );
              },
              onWillAccept: (data) => data == question.correctAnswer,
              onAccept: (data) {
                print("Selected Answer: $data");
                nextQuestion();
              },
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildOptionsList(question.options),
            ),
            SizedBox(height: 10.0),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value * 2 * 3.1416,
                  child: Icon(Icons.access_time,
                      size: 60.0, color: Colors.deepPurple),
                );
              },
            ),
            SizedBox(height: 10.0),
            Text(
              "Time left: $_timerSeconds seconds",
              style: TextStyle(fontSize: 24.0, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildOptionsList(List<String> options) {
    return options
        .map((option) => Draggable<String>(
              data: option,
              child: buildOptionCard(option),
              feedback: buildOptionCard(option, isDragging: true),
              childWhenDragging: Container(),
            ))
        .toList();
  }

  Widget buildOptionCard(String option, {bool isDragging = false}) {
    return Card(
      color: isDragging ? Colors.transparent : Colors.deepPurple,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          option,
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
    );
  }
}

class Question {
  String questionText;
  String correctAnswer;
  List<String> options;

  Question(this.questionText, this.correctAnswer, this.options);
}
