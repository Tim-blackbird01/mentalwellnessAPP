import 'package:cloud_firestore/cloud_firestore.dart';

import 'goal.dart';

class GoalDatabase {
  CollectionReference goalsCollection = FirebaseFirestore.instance.collection('goals');

  Future<void> insertGoal(Goal goal) async {
    await goalsCollection.add({
      'goalText': goal.goalText,
      'reminderText': goal.reminderText,
      'progress': goal.progress,
      'completed': goal.completed,
    });
  }

  Future<List<Goal>> getGoals() async {
    QuerySnapshot snapshot = await goalsCollection.get();

    List<Goal> fetchedGoals = [];

    snapshot.docs.forEach((doc) {
      String goalText = doc['goalText'] as String;
      String reminderText = doc['reminderText'] as String;
      dynamic progressValue = doc['progress'];
      bool completed = doc['completed'] ?? false;

      double? progress;
      if (progressValue is int || progressValue is double) {
        progress = progressValue.toDouble();
      }

      fetchedGoals.add(Goal(
        goalText: goalText,
        reminderText: reminderText,
        progress: progress,
        completed: completed,
      ));
    });

    return fetchedGoals;
  }

  Future<void> deleteGoal(String goalId) async {
    await goalsCollection.doc(goalId).delete();
  }

  Future<void> updateGoal(Goal goal) async {
    await goalsCollection.doc(goal.goalId).update({
      'goalText': goal.goalText,
      'reminderText': goal.reminderText,
      'progress': goal.progress,
      'completed': goal.completed,
    });
  }
}
