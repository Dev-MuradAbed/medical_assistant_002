import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbController {
  static final DbController _instance = DbController._();

  factory DbController() {
    return _instance;
  }
  DbController._();

  late Database _database;

  Database get database => _database;

  Future<void> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'db.sql');
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) {
          db.execute(
            'CREATE TABLE tasks ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'title STRING, '
                'note TEXT, '
                'isCompleted INTEGER, '
                'color INTEGER, '
                'startTime STRING, '
                'endTime STRING, '
                'date INTEGER, '
                'remind INTEGER, '
                'repeat STRING)',
          );
          db.execute(
            'CREATE TABLE calender ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'title STRING, '
                'note TEXT, '
                'isCompleted INTEGER, '
                'color INTEGER, '
                'startTime STRING, '
                'endTime STRING, '
                'date INTEGER, '
                'remind INTEGER, '
                'repeat STRING)',
          );
          db.execute(
            'CREATE TABLE profile ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'name STRING, '
                'birthday STRING, '
                'medical_specialty STRING, '
                'image STRING)',
          );
        });
    print('Database created');
  }
}
