import 'package:flutter/material.dart';
import 'package:bfootlearn/commitment_time/Achievement.dart';
import 'package:bfootlearn/components/custom_appbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double _studyGoal = 1.0; // 初始学习目标时长，单位可以根据需求调整

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
        //title: Text('Study Goal Settings'),
         appBar: customAppBar(context: context, title: 'Learning Goal'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Your Study Goal:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Slider(
              value: _studyGoal,
              min: 0.5,
              max: 5.0,
              divisions: 9,
              label: '${_studyGoal.toStringAsFixed(1)} hours',
              onChanged: (double value) {
                setState(() {
                  _studyGoal = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Selected Study Goal: ${_studyGoal.toStringAsFixed(1)} hours',
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save the study goal to storage or database
                  _saveStudyGoal(_studyGoal);
                  Navigator.pop(context);
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CongratulationPage(message: 'Awesome!',)),
                 );
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to save study goal to storage or database
  void _saveStudyGoal(double studyGoal) {
    // Implement saving logic here, e.g., using SharedPreferences or other storage methods
    print('Saving study goal: $studyGoal hours');
  }
}