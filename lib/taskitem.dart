import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task_model.dart';



class TaskItem extends StatefulWidget {
  TaskItem(
      {Key? key,
      required this.onDelete,
      required this.task,
      required this.AllTasks,
      required this.localStorage,
      required this.index})
      : super(key: key);
  final Task task;
  late LocalStorage localStorage;
  late List<Task> AllTasks;
  late int index;
  final Function onDelete;
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
    return ListTile(
      trailing: Text(widget.task.EndDate.toString().substring(0, 16)),
      title: Text(widget.task.Name),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Image.asset("assets/images/todo_list_64px.png"),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AutoSizeText(
                        widget.task.TaskContent ?? "No Content",
                        minFontSize: 18,
                      ),
                    ),
                  ],
                ),
                height: 250,
                width: MediaQuery.of(context).size.width / 1.3,
              ));
            });
      },
      onLongPress: () {
        showMenu(
            color: Colors.red.shade300,
            context: context,
            position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height, 0, 0),
            items: [
              PopupMenuItem(
                child: Row(
                  children: [Icon(Icons.delete), const Text("Delete")],
                ),
                onTap: () {
                  widget.AllTasks.removeAt(widget.index);
                  widget.localStorage.DeleteTask(task: widget.task);
                  widget.onDelete();
                },
              )
            ]);
      },
      leading: Image.asset("assets/images/todo_list_64px.png"),
    );

    // return ExpansionTile(
    //   childrenPadding: EdgeInsets.all(20),
    //   title: Text(widget.task.Name),
    //   leading: Image.asset("assets/images/work1.png"),
    //   trailing: Text(widget.task.EndDate.toString().substring(0, 16)),
    //   children: [
    //     Text(
    //       widget.task.TaskContent ?? "null",
    //       style: TextStyle(fontSize: 22),
    //     )
    //   ],
    // );
  }
}
