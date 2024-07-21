class LearningTime {
  final DateTime startTime;
  final DateTime endTime;
  final int model;

  LearningTime({
    required this.startTime,
    required this.endTime,
    required this.model,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'model': model
    };
  }

  factory LearningTime.fromJson(Map<String, dynamic> json) {
    return LearningTime(
      startTime: json['startTime']??'',
      endTime: json['endTime']??'',
      model: json['model']??''
    );
  }
}
