import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';
@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String Id;
  @HiveField(1)
  String Name;
  @HiveField(2)
  final DateTime EndDate;

  Task({required this.Id, required this.EndDate, required this.Name});
  factory Task.create({required String Name, required DateTime EndDate}) {
    return Task(Id: const Uuid().v1(), Name: Name, EndDate: EndDate);
  }
}
