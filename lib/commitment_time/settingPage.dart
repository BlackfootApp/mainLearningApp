import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bfootlearn/User/user_provider.dart';
import 'package:bfootlearn/commitment_time/Achievement.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:bfootlearn/commitment_time/study_goal_provider.dart';
import '../LearningTime/models/learning_time.dart';
import '../riverpod/river_pod.dart';
import 'learningGoal_page.dart';

class SettingPage extends ConsumerStatefulWidget {
  SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  late int _studyGoal;
  late String uid;
  late final UserProvider userRepo;

  @override
  void initState() {
    super.initState();
    _studyGoal = ref.read(studyGoalProvider);
    userRepo = ref.read(userProvider);
    uid = userRepo.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Setting Goal'),
      body: Column(
        children: [
          Image.asset(
            'assets/settingPage.jpg',
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            'Your Daily Learning Goal',
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
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_circle,
                  color: Color.fromARGB(255, 232, 165, 176),
                  size: 50,
                ),
                onPressed: _studyGoal > 5 ? () => _decrementGoal(5) : null,
              ),
              const SizedBox(width: 30),
              _buildStudyGoal(),
              const SizedBox(width: 30),
              IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Color.fromARGB(255, 232, 165, 176),
                  size: 50,
                ),
                onPressed: _studyGoal < 300 ? () => _incrementGoal(5) : null,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '( Selected Study Goal: $_studyGoal Mins )',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 175, 145, 230),
            ),
          ),
          const SizedBox(height: 60),
          Center(
            child: ElevatedButton(
              onPressed: _saveStudyGoal,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                elevation: 10,
                shadowColor: Color.fromARGB(255, 58, 13, 79),
                backgroundColor: Color.fromARGB(255, 175, 145, 230),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyGoal() {
    return Column(
      children: [
        Text(
          '$_studyGoal',
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
        const Text(
          'Mins / Day',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 175, 145, 230),
          ),
        ),
      ],
    );
  }

  void _decrementGoal(int amount) {
    setState(() {
      _studyGoal -= amount;
    });
  }

  void _incrementGoal(int amount) {
    setState(() {
      _studyGoal += amount;
    });
  }

  void _saveStudyGoal() {
    ref.read(studyGoalProvider.notifier).setStudyGoal(_studyGoal);
    print('Saving study goal: $_studyGoal Mins');
    final user = ref.read(userProvider.notifier);

    if (_studyGoal > 0) {
      user.updateDailyGoal(_studyGoal);
      user.updateIsPopupCongratsPage(false);
    }
    ref.read(studyGoalProvider.notifier).setStudyGoal(_studyGoal);

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Success', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
              'You have successfully set your goal to  $_studyGoal Mins. Great job on taking this important step!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LearningGoalPage(),
                  ),
                ); // Navigate to learning goal page
              },
              child: Text('OK', style: TextStyle(fontSize: 18)),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 175, 145, 230),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
