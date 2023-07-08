class Goal {
  String? goalId;
  final String goalText;
  final String reminderText;
  double? progress;
  bool completed;

  Goal({
    this.goalId,
    required this.goalText,
    required this.reminderText,
    this.progress,
    this.completed = false,
  });

  String get id => goalId ?? '';
}
