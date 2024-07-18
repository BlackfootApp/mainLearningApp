import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final studyGoalProvider = StateNotifierProvider<StudyGoalNotifier, int>((ref) {
  return StudyGoalNotifier();
});

class StudyGoalNotifier extends StateNotifier<int> {
  static const _studyGoalKey = 'studyGoal';
  StudyGoalNotifier() : super(30) {
    _loadStudyGoal();
  }
  Future<void> _loadStudyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(_studyGoalKey) ?? 30;
  }

  Future<void> setStudyGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    state = goal;
    await prefs.setInt(_studyGoalKey, goal);
  }
}
