import 'package:flutter/material.dart';
import 'package:bfootlearn/commitment_time/Achievement.dart';
import 'package:bfootlearn/components/custom_appbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double _studyGoal = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Learning Goal'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const Text(
              'Your Daily Learning Goal',
              style: TextStyle(
                fontSize: 30,
                color: Color(0xffbdbcfd),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Color(0xffbdbcfd),
                    size: 50,
                  ),
                  onPressed: _studyGoal > 5 ? () => _decrementGoal(5) : null,
                ),
                const SizedBox(width: 10),
                _buildStudyGoal(),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color(0xffbdbcfd),
                    size: 50,
                  ),
                  onPressed: _studyGoal < 300 ? () => _incrementGoal(5) : null,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              '( Selected Study Goal: $_studyGoal Mins )',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xffbdbcfd),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                onPressed: _saveStudyGoal,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  backgroundColor: Color(0xffbdbcfd),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyGoal() {
    return Column(
      children: [
        Text(
          '$_studyGoal',
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w900,
            color: Color(0xffbdbcfd),
          ),
        ),
        const Text(
          'Mins / Day',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xffbdbcfd),
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
    // Save the study goal to storage or database
    print('Saving study goal: $_studyGoal Mins');
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CongratulationPage(message: 'Awesome!'),
      ),
    );
  }
}
