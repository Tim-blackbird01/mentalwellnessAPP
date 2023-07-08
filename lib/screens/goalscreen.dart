import 'package:flutter/material.dart';

import 'goal.dart';
import 'goal_database.dart';
import 'notification_helper.dart';

class GoalSettingScreen extends StatefulWidget {
  @override
  _GoalSettingScreenState createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  GoalDatabase goalDatabase = GoalDatabase(); // Create an instance of GoalDatabase

  List<Goal> goals = [];

  @override
  void initState() {
    super.initState();
    _fetchGoals();
    NotificationHelper.initializeNotifications(); // Initialize the notification helper
  }

  Future<void> _fetchGoals() async {
    List<Goal> fetchedGoals = await goalDatabase.getGoals(); // Access getGoals through the instance

    setState(() {
      goals = fetchedGoals;
    });
  }

  Future<void> _showAddGoalDialog() async {
    String goalText = '';
    String reminderText = '';
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Add New Goal'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        goalText = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Goal',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        reminderText = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Reminder',
                      ),
                    ),
                    ListTile(
                      title: const Text('Reminder Time'),
                      subtitle: selectedTime != null
                          ? Text(selectedTime!.format(context))
                          : null,
                      onTap: () async {
                        selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        setState(() {}); // Update the UI to reflect the selected time
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _addGoal(goalText, reminderText, selectedTime);
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addGoal(
      String goalText, String reminderText, TimeOfDay? selectedTime) async {
    Goal newGoal = Goal(
      goalText: goalText,
      reminderText: reminderText,
      progress: 0.0,
      completed: false,
    );

    await goalDatabase.insertGoal(newGoal); // Access insertGoal through the instance

    setState(() {
      goals.add(newGoal);
    });

    if (selectedTime != null) {
      // Schedule the reminder notification
      DateTime now = DateTime.now();
      DateTime goalDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      NotificationHelper.scheduleReminderNotification(
        newGoal.goalId ?? '',
        newGoal.goalText,
        goalDateTime,
      );
    }
  }

  Future<void> _deleteGoal(int index) async {
    Goal goalToDelete = goals[index];

    await goalDatabase.deleteGoal(goalToDelete.goalId!); // Pass the goalId to deleteGoal

    setState(() {
      goals.removeAt(index);
    });

    // Cancel the reminder notification
    NotificationHelper.cancelNotification(goalToDelete.goalId ?? '');
  }

  Future<void> _editGoal(int index) async {
    Goal goalToEdit = goals[index];

    String goalText = goalToEdit.goalText;
    String reminderText = goalToEdit.reminderText;
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Edit Goal'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        goalText = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Goal',
                      ),
                      controller: TextEditingController(text: goalText),
                    ),
                    TextField(
                      onChanged: (value) {
                        reminderText = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Reminder',
                      ),
                      controller: TextEditingController(text: reminderText),
                    ),
                    ListTile(
                      title: const Text('Reminder Time'),
                      subtitle: selectedTime != null
                          ? Text(selectedTime!.format(context))
                          : null,
                      onTap: () async {
                        selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        setState(() {}); // Update the UI to reflect the selected time
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _updateGoal(index, goalText, reminderText, selectedTime);
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _updateGoal(
      int index, String goalText, String reminderText, TimeOfDay? selectedTime) async {
    Goal goalToUpdate = Goal(
      goalText: goalText,
      reminderText: reminderText,
      progress: goals[index].progress,
      completed: goals[index].completed,
    );

    await goalDatabase.updateGoal(goalToUpdate); // Access updateGoal through the instance

    setState(() {
      goals[index] = goalToUpdate;
    });

    // Cancel the previous reminder notification
    NotificationHelper.cancelReminderNotification(goals[index].goalId ?? '');

    if (selectedTime != null) {
      // Schedule the new reminder notification
      DateTime now = DateTime.now();
      DateTime goalDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      NotificationHelper.scheduleReminderNotification(
        goals[index].goalId ?? '',
        goals[index].goalText,
        goalDateTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Setting'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/goalhome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Goals',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _showGoalDetails(index);
                      },
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              goals[index].goalText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              goals[index].reminderText,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Progress',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 30, // Specify the desired height of the container
                                  width: 200, // Specify the desired width of the slider
                                  child: Slider(
                                    value: goals[index].progress?.clamp(0.0, 100.0) ?? 0.0,
                                    onChanged: (value) {
                                      setState(() {
                                        goals[index].progress = value.clamp(0.0, 100.0);
                                      });
                                    },
                                    min: 0.0,
                                    max: 100.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: goals[index].progress! / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey[300],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGoalDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showGoalDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalDetailsScreen(
          goal: goals[index],
          onDelete: () {
            _deleteGoal(index);
          },
          onEdit: () {
            _editGoal(index);
          },
        ),
      ),
    );
  }
}

class GoalDetailsScreen extends StatelessWidget {
  final Goal goal;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  GoalDetailsScreen({
    required this.goal,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Details'),
        actions: [
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goal: ${goal.goalText}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Reminder: ${goal.reminderText}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Progress: ${goal.progress}%',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: goal.progress! / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
