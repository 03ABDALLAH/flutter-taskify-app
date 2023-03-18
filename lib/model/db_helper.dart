import 'package:remember_app/model/category.dart';
import 'package:sqflite/sqflite.dart';

import 'task_data.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 8;
  static final String _tableName = "tasks";
  static final String _tableName2 = "category";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print("creating a new one");
        db.execute(
          "CREATE TABLE $_tableName("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "title STRING, note TEXT, date STRING, "
          "startTime STRING, endTime STRING, "
          "remind INTEGER, repeat STRING,"
          "color INTEGER, "
          "isCompleted INTEGER,"
          "category_id INTEGER, "
          "FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE)",
        );
        db.execute(
          "CREATE TABLE $_tableName2("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name STRING, "
          "color INTEGER)",
        );
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task task) async {
    print("insert function called");
    print("her is ur task frm db : ${task!.toJson()}");
    return await _db?.insert(_tableName, task.toJson()) ?? 1;
  }

  static Future<int> insertCategory(Category category) async {
    print("wa tzaad");
    return await _db?.insert(_tableName2, category.toJson()) ?? 1;
  }

  static Future<int> updateTask(Task task) async {
    return await _db?.update(_tableName, task.toJson(),
            where: "id = ?", whereArgs: [task.id]) ??
        1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static Future<List<Map<String, dynamic>>> queryCategory() async {
    print("query function called");
    return await _db!.query(_tableName2);
  }

  static Future<List<Map<String, Object?>>> getTasksFromCategoryId(int categoryId) async {
    return await _db!.query(_tableName, where: 'category_id = ?', whereArgs: [categoryId]);
  }

  static delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static deleteCategory(Category category) async {
    return await _db!
        .delete(_tableName2, where: 'id=?', whereArgs: [category.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
      ''', [1, id]);
  }

  static Future<int> getTaskCountByCategory(int categoryId) async {
    // final db = await SQLhelper.db();
    var result = await _db!.rawQuery('SELECT COUNT(*) FROM tasks WHERE category_id = ?',
      [categoryId]);
    print("object ${result.length}");
    if (result[0]['COUNT(*)'] == null){
      return 0;
    } else{
      return result[0]['COUNT(*)'] as int;
    }
  }
}