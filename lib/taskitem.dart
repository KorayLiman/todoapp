import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task_model.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({Key? key, required this.task}) : super(key: key);
  final Task task;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _TaskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: EdgeInsets.all(20),
      title: Text(widget.task.Name),
      leading: Image.asset("assets/images/work1.png"),
      trailing: Text(widget.task.EndDate.toString().substring(0, 16)),
      children: [
        Text(
          widget.task.TaskContent ?? "null",
          style: TextStyle(fontSize: 22),
        )
      ],
    );
  }
}
