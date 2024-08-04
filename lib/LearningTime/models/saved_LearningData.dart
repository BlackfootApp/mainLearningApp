import 'learning_time.dart';

class SavedLearningData {
  final String uid;
  final List<LearningTime> savedLearningTime;
  final int dailyGoal;
  final bool isPopupCongratsPage;

  SavedLearningData(
      {required this.uid,
      required this.savedLearningTime,
      required this.dailyGoal,
      required this.isPopupCongratsPage});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'savedLearningTime': savedLearningTime,
      'dailyGoal': dailyGoal,
      'isPopupCongratsPage': isPopupCongratsPage
    };
  }

  factory SavedLearningData.fromJson(Map<String, dynamic> json) {
    return SavedLearningData(
        uid: json['uid'],
        savedLearningTime: json['savedLearningTime'],
        dailyGoal: json['dailyGoal'],
        isPopupCongratsPage: json['isPopupCongratsPage']);
  }
}
