// lib/providers/task_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:counter/models/task.dart';
import 'package:counter/utils/app_constants.dart';
import 'package:uuid/uuid.dart'; // Add this to pubspec.yaml if you don't have it already

class TaskProvider with ChangeNotifier {
  late Box<Task> _taskBox;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _taskBox = await Hive.openBox<Task>(AppConstants.taskBoxName);
    _loadTasks();
  }

  void _loadTasks() {
    _tasks = _taskBox.values.toList();
    // Sort tasks, e.g., incomplete first, then by title
    _tasks.sort((a, b) {
      if (a.isComplete != b.isComplete) {
        return a.isComplete ? 1 : -1; // Incomplete tasks first
      }
      return a.title.compareTo(b.title); // Then alphabetically
    });
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task); // Use task.id as the key
    _loadTasks(); // Reload to ensure sorted list
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
    _loadTasks(); // Reload to ensure sorted list
  }

  Future<void> incrementTaskCount(Task task) async {
    if (!task.isComplete) {
      task.currentCount++;
      await task.save(); // Save changes directly using HiveObject's save()
      _loadTasks();
    }
  }

  Future<void> resetTaskCount(Task task) async {
    task.currentCount = 0;
    await task.save();
    _loadTasks();
  }

  Future<void> deleteTask(Task task) async {
    await task.delete(); // Delete directly using HiveObject's delete()
    _loadTasks();
  }
}
