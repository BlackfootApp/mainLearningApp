import 'learning_time.dart';

class SavedLearningData {
  final String uid;
  final List<LearningTime> savedLearningTime;
  final int dailyGoal;

  SavedLearningData(
      {required this.uid,
      required this.savedLearningTime,
      required this.dailyGoal});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'savedLearningTime': savedLearningTime,
      'dailyGoal': dailyGoal,
    };
  }

  factory SavedLearningData.fromJson(Map<String, dynamic> json) {
    return SavedLearningData(
        uid: json['uid'],
        savedLearningTime: json['savedLearningTime'],
        dailyGoal: json['dailyGoal']);
  }
}
