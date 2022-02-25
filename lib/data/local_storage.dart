import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/models/task_model.dart';

abstract class LocalStorage {
  Future<bool> AddTask({required Task Task});
  Future<List<Task>> GetAllTasks();
  Future<Task?> GetTask({required String id});
  Future<bool> DeleteTask({required Task task});
  Future<Task> UpdateTask({required Task task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _TaskBox;
  HiveLocalStorage() {
    _TaskBox = Hive.box<Task>("TaskBox");
  }
  @override
  Future<bool> AddTask({required Task Task}) async {
    try {
      await _TaskBox.put(Task.Id, Task);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  @override
  Future<bool> DeleteTask({required Task task}) async {
    try {
      await task.delete();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  @override
  Future<List<Task>> GetAllTasks() async {
    if (_TaskBox.values.toList().isNotEmpty) {
      return _TaskBox.values.toList();
    } else {
      return <Task>[];
    }
  }

  @override
  Future<Task> UpdateTask({required Task task}) async {
    await task.save();
    return task;
  }

  @override
  Future<Task?> GetTask({required String id}) async {
    if (_TaskBox.containsKey(id)) {
      return _TaskBox.get(id);
    } else {
      return null;
    }
  }
}
