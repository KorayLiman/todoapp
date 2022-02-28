import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 2)
enum Category {
  @HiveField(0)
  Business,
  @HiveField(1)
  School,
  @HiveField(2)
  Payments,
  @HiveField(3)
  Other
}

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String Id;
  @HiveField(1)
  String Name;
  @HiveField(2)
  final DateTime EndDate;
  
  @HiveField(4)
  final Category? category;
  @HiveField(5)
  final int? NotificationId;

  Task({
    required this.category,
    required this.Id,
    required this.EndDate,
    required this.Name,
    
    required this.NotificationId
  });
  factory Task.create({
    required Category category,
    required String Name,
    required DateTime EndDate,
    
    required int NotificationId
  }) {
    return Task(
      category: category,
      Id: const Uuid().v1(),
      Name: Name,
      EndDate: EndDate,
      
      NotificationId: NotificationId
    );
  }
}
