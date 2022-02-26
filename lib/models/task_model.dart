import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

enum Category { Business, School, Payments }

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String Id;
  @HiveField(1)
  String Name;
  @HiveField(2)
  final DateTime EndDate;
  @HiveField(3)
  final String? TaskContent;
  @HiveField(4)
  final Category? category;

  Task(
      {required this.category,
      required this.Id,
      required this.EndDate,
      required this.Name,
      required this.TaskContent});
  factory Task.create(
      {required Category category,
      required String Name,
      required DateTime EndDate,
      required String taskContent}) {
    return Task(
        category: category,
        Id: const Uuid().v1(),
        Name: Name,
        EndDate: EndDate,
        TaskContent: taskContent);
  }
}
