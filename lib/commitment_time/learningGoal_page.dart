import 'package:bfootlearn/commitment_time/settingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:bfootlearn/commitment_time/study_goal_provider.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';
import '../LearningTime/models/learning_time.dart';
import '../riverpod/river_pod.dart';

class LearningGoalPage extends ConsumerStatefulWidget {
  const LearningGoalPage({Key? key}) : super(key: key);
  @override
  _LearningGoalPageState createState() => _LearningGoalPageState();
}

class _LearningGoalPageState extends ConsumerState<LearningGoalPage> {
  List<bool> _completedGoals = [];
  int totalDays = 0;
  @override
  void initState() {
    _fetchLearningTimeData();
    super.initState();
  }

  Future<void> _fetchLearningTimeData() async {
    final user = ref.read(userProvider.notifier);

    await user.getSavedLearningTime(DateTime.now());
    setState(() {});
  }

  List<String> GetDateList() {
    DateTime dt = DateTime.now();
    // Weekday constants that are returned by [weekday] method:
    // static const int monday = 1;
    // static const int tuesday = 2;
    // static const int wednesday = 3;
    // static const int thursday = 4;
    // static const int friday = 5;
    // static const int saturday = 6;
    // static const int sunday = 7;
    List<String> list = [];
    for (int i = 1; i < 8; i++) {
      int day = dt.weekday - i;
      list.add(DateFormat('yyyy-MM-dd').format(dt.add(Duration(days: -day))));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    int studyGoal = ref.watch(studyGoalProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    int dailyGoal = 0;

    double totalSeconds = 0;
    final user = ref.watch(userProvider);
    final data = user.getUserSavedLearningData();
    final history = user.getUserSavedLearningHistory();

    dailyGoal = data.dailyGoal ?? 30;

    if (studyGoal > 0 && studyGoal != studyGoal) {
      studyGoal = dailyGoal;
    }

    data.savedLearningTime.forEach((phraseData) {
      DateTime start = phraseData.startTime;
      DateTime end = phraseData.endTime;
      int duration = 0;

      duration = end.difference(start).inSeconds;
      if (duration > 0) {
        totalSeconds += duration;
      }
    });

    var hisotryData = groupBy(history.savedLearningTime,
        (LearningTime obj) => DateFormat('yyyy-MM-dd').format(obj.startTime));

    totalDays = hisotryData.length;
    List<String> weekDays = GetDateList();
    _completedGoals = [];
    for (final d in weekDays) {
      if (hisotryData.containsKey(d))
        _completedGoals.add(true);
      else
        _completedGoals.add(false);
    }

    double learningTime = 0;
    String learningTimeStr = '0:00';
    int learningMins = (totalSeconds / 60).toInt();
    int learningSeconds = (totalSeconds - learningMins * 60).toInt();
    learningTime = learningMins + learningSeconds / 100;
    if (learningMins < 100) {
      learningTimeStr =
          learningMins.toString() + ':' + (learningSeconds).toString();
    } else {
      learningTimeStr = learningMins.toString();
    }

    return Scaffold(
      appBar: customAppBar(context: context, title: 'Learning Goal'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLearningProgress(studyGoal, screenWidth, screenHeight,
                learningTime, learningTimeStr),
            const SizedBox(height: 60),
            _buildLearningSettings(),
            const SizedBox(height: 80),
            _buildWeekdaysIndicator(),
            const SizedBox(height: 30),
            _buildLearningDaysCount(totalDays),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdaysIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
              border: Border.all(
                color:
                    _completedGoals[index] ? Colors.purple : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'][index],
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLearningProgress(int studyGoal, double screenWidth,
      double screenHeight, double learningTime, String learningTimeStr) {
    double progress = learningTime / studyGoal;
    if (learningTime > studyGoal) {
      progress = 1;
    }
    return Column(
      children: [
        Text(
          "Today's Learning",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            fontFamily: 'Chewy',
            foreground: Paint()
              ..shader = LinearGradient(
                colors: <Color>[
                  Color(0xffbdbcfd),
                  Color.fromARGB(255, 175, 145, 230),
                ],
              ).createShader(Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
          ),
        ),
        const SizedBox(height: 60),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(screenWidth * 0.7, screenWidth * 0.4),
                  painter: SemicircularProgressPainter(progress),
                ),
                Positioned(
                  top: screenWidth * 0.1,
                  child: Text(
                    learningTimeStr,
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Chewy',
                      color: Color.fromARGB(255, 175, 145, 230),
                      shadows: [
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 5.0,
                          color: Color.fromARGB(255, 120, 54, 172),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          '(Goal: $studyGoal mins)',
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 175, 145, 230),
          ),
        ),
      ],
    );
  }

  Widget _buildLearningDaysCount(int total_days) {
    return Text(
      "You've been studying for $total_days days.",
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w900,
        fontFamily: 'Chewy',
        color: Color.fromARGB(255, 175, 145, 230),
      ),
    );
  }

  Widget _buildLearningSettings() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingPage(),
            ));
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        elevation: 10,
        shadowColor: Color.fromARGB(255, 58, 13, 79),
        backgroundColor: Color.fromARGB(255, 175, 145, 230),
      ),
      child: const Text(
        'Reset Your Goal',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class SemicircularProgressPainter extends CustomPainter {
  final double progress;
  SemicircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Paint foregroundPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Rect rect = Rect.fromLTRB(0, 0, size.width, size.height * 2);
    double startAngle = -3.14;
    double sweepAngle = 3.14 * progress;

    canvas.drawArc(rect, startAngle, 3.14, false, backgroundPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
