import 'package:flutter/material.dart';
import 'package:medical_assistant_002/database/controller/calender_controller.dart';
import 'package:medical_assistant_002/models/doctor_models/todo_model/calender_model.dart';

import '../../../database/controller/patient_controller.dart';
import '../../../models/doctor_models/todo_model/patient_todo_model.dart';



class CalenderTaskProvider extends ChangeNotifier {
  final CalenderTaskController _taskController = CalenderTaskController();
  List<Calender> listTask = <Calender>[];

  Future<int> addTask({required Calender task}) async {
    int newRow = await _taskController.insert(task);
    if (newRow != 0) {
      listTask.add(task);
      notifyListeners();
    }
    return newRow;
  }

  Future<void>getTask() async {
    final List<Map<String, dynamic>> tasks = await _taskController.query();
    listTask = tasks.map((Map<String, dynamic> task) => Calender.fromJson(task)).toList();
    notifyListeners();
  }
  void delete(Task task) async {
    await _taskController.delete(task.id!);
    getTask();
    notifyListeners();
  }
  Future<void> deleteAllTask() async {
    await _taskController.deleteAllTask();

    getTask();
    notifyListeners();
  }

  void markTaskCompleted(int id) async {
    await _taskController.update(id);
    getTask();
    notifyListeners();
  }
}
