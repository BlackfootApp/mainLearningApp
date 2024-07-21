import 'learning_time.dart';

class SavedLearningData {
  final String uid;
  final List<LearningTime> savedLearningTime;
  SavedLearningData({
    required this.uid,
    required this.savedLearningTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'savedLearningTime': savedLearningTime,
    };
  }

  factory SavedLearningData.fromJson(Map<String, dynamic> json) {
    return SavedLearningData(
      uid: json['uid'],
      savedLearningTime: json['savedLearningTime'],
    );
  }
}
