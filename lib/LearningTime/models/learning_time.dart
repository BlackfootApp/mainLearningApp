class LearningTime {
  final DateTime startTime;
  final DateTime endTime;
  final int
      model; //learning time model:   1: vocabulary  2: stories 3:quiz  4:categories  5: saved phrases

  LearningTime({
    required this.startTime,
    required this.endTime,
    required this.model,
  });

  Map<String, dynamic> toJson() {
    return {'startTime': startTime, 'endTime': endTime, 'model': model};
  }

  factory LearningTime.fromJson(Map<String, dynamic> json) {
    return LearningTime(
        startTime: json['startTime'].toDate() ?? DateTime.now(),
        endTime: json['endTime'].toDate() ?? DateTime.now(),
        model: json['model'] ?? 1);
  }
}
