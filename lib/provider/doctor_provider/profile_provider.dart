import 'package:flutter/material.dart';
import '../../database/controller/doctor_controller/profile_controller.dart';
import '../../models/doctor_models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  final profileController _taskController = profileController();
  List<Profile> listTask = <Profile>[];
  Future<int> addTask({required Profile task}) async {
    int newRow = await _taskController.insert(task);
    if (newRow != 0) {
      listTask.add(task);
      notifyListeners();
    }
    return newRow;
  }
  Future<int> updateProfile({required Profile task}) async {
    int newRow = await _taskController.updateprofile(task);
    if (newRow != 0) {
      listTask.add(task);
      notifyListeners();
    }
    return newRow;

  }

  Future<void> getTask() async {
    final List<Map<String, dynamic>> tasks = await _taskController.query();
    listTask = tasks
        .map((Map<String, dynamic> task) => Profile.fromJson(task))
        .toList();

    notifyListeners();
  }

  void markTaskCompleted(int id) async {
    await _taskController.update(id);
    getTask();
    notifyListeners();
  }
}
