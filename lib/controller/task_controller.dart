import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:remember_app/model/db_helper.dart';
import 'package:remember_app/model/task_data.dart';

import 'add_task_bar.dart';

class TaskController extends GetxController{

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    print("her is ur task : ${task!.toJson()}");
    return await DBHelper.insert(task!);
  }

  Future<int> updateTask({Task? task}) async {
    return await DBHelper.updateTask(task!);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  Future<Map> get(int id) async {
    List<Map<String, dynamic>> _tasks = await DBHelper.query();
    return _tasks.firstWhere((element) => element['id'] == id);;
  }

  void delete(Task task){
    DBHelper.delete(task);
    getTasks();
  }

  Future<void> markTAskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}