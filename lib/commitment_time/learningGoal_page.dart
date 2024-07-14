import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bfootlearn/commitment_time/settingPage.dart';
import 'package:bfootlearn/components/custom_appbar.dart';



class LearningGoalPage extends ConsumerStatefulWidget {
  const LearningGoalPage({super.key});

  @override
  ConsumerState<LearningGoalPage> createState() => _LearningPageState();

}

class _LearningPageState extends ConsumerState<LearningGoalPage> {
  @override
  Widget build(BuildContext context) {
return Scaffold(
  appBar: customAppBar(context: context, title: 'Learning Goal'),
  body: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      // 这里可以添加你的子小部件
      children: [
            // Add your widgets here
            _buildLearningTimeDisplay(),
            _buildLearningSettings(),
          ],
    ),
  ),
);

  }

  

  Widget _buildLearningTimeDisplay() {
    // Display the learning time here
    return const Text(
      'Learning Time: 1 hour',
      style: TextStyle(fontSize: 24),
    );
  }

  Widget _buildLearningSettings() {
    // Add settings widgets here
    return ElevatedButton(
        onPressed: () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingPage()),
  );
      },
      child: const Text('Set Learning Time'),
    );
  }
}

