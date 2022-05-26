import 'package:medical_assistant_002/models/doctor_models/todo_model/calender_model.dart';
import 'package:sqflite/sqflite.dart';
import '../doctor_db.dart';
class CalenderTaskController {
  Database database = DbController().database;

  Future<int> insert(Calender task) async {
    return await database.insert('calender', task.toJson());
  }

  Future<int> delete(int id) async {
    return await database.delete('calender', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllTask() async {
    return await database.delete('calender');
  }

  Future<List<Map<String, dynamic>>> query() async {
    return await database.query('calender');
  }

  Future<int> update(int id) async {
    return await database.rawUpdate('''
    UPDATE calender 
    SET isCompleted = ? 
    WHERE id = ?  
    ''', [1, id]);
  }

  Future<bool> FutureCheckId(int id) async {
    var c = await database.rawQuery('''
    SELECT * 
    FROM calender 
    WHERE id = ?  
    ''', [id]);
    if (c.isEmpty) {
      return false;
    }
    return true;
  }
}
