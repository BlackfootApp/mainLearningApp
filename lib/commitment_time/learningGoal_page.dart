import 'package:bfootlearn/commitment_time/settingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:bfootlearn/commitment_time/study_goal_provider.dart';

class LearningGoalPage extends ConsumerStatefulWidget {
  const LearningGoalPage({Key? key}) : super(key: key);

  @override
  _LearningGoalPageState createState() => _LearningGoalPageState();
}

class _LearningGoalPageState extends ConsumerState<LearningGoalPage> {
  @override
  Widget build(BuildContext context) {
    final studyGoal = ref.watch(studyGoalProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: customAppBar(context: context, title: 'Learning Goal'),
      body: Center(
        // 这里添加 Center 组件
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLearningProgress(studyGoal, screenWidth, screenHeight),
              const SizedBox(height: 20),
              _buildLearningTimeDisplay(),
              const SizedBox(height: 20),
              _buildLearningDaysCount(),
              const SizedBox(height: 20),
              _buildLearningSettings(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearningProgress(
      int studyGoal, double screenWidth, double screenHeight) {
    return Column(
      children: [
        const Text(
          "Today's Learning",
          style: TextStyle(fontSize: 24, color: Colors.purple),
        ),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.5, // 动态调整圆环的大小
              height: screenWidth * 0.5,
              child: CircularProgressIndicator(
                value: 8.21 / studyGoal,
                strokeWidth: 10,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            ),
            Text(
              '8:21',
              style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  color: Colors.purple), // 动态调整文字大小
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Goal: $studyGoal mins',
          style: TextStyle(
              fontSize: screenWidth * 0.04, color: Colors.purple), // 动态调整文字大小
        ),
      ],
    );
  }

  Widget _buildLearningTimeDisplay() {
    return ElevatedButton(
      onPressed: () {
        // Handle continue learning button press
      },
      child: const Text('Continue learning'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildLearningDaysCount() {
    return const Text(
      "You've been studying for 5 days.",
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildLearningSettings() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingPage()),
        );
      },
      child: const Text('Set Learning Goal'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}
