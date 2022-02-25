import 'dart:ui';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quds_ui_kit/viewers/quds_digital_clock_viewer.dart';
import 'package:quds_ui_kit/viewers/quds_digital_time_viewer.dart';
import 'package:todoapp/constants.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/helper/translation_helper.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/taskitem.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late LocalStorage _localStorage;
  late List<Task> _AllTasks;
  late TabController _MyTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
    _AllTasks = <Task>[];
    _GetAllTasksFromDB();
    _MyTabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(4, 12, 58, 1),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              color: Color.fromRGBO(4, 12, 58, 1),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0, left: 40),
                        child: Text(
                          "Hello...",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0, right: 30),
                        child: Image.asset(
                          "assets/images/tasklist.png",
                          scale: 1.2,
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 5,
                    left: 40,
                    child: Text(
                      "Manage your tasks easily",
                      style: Constants.MyStyle,
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    left: 40,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 200,
                      child: const Text(
                        "Press + button to add and swipe right to remove task",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 40.0, bottom: 20),
                    child: QudsDigitalClockViewer(
                      backgroundColor: Colors.deepPurple,
                      amText: "",
                      pmText: "",
                      showSeconds: true,
                      style: TextStyle(fontSize: 34, color: Colors.white),
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      _ShowAddTaskBottomModelSheet(context);
                    },
                    child: Icon(Icons.add),
                  ),
                )
              ],
            ),
            flex: 3,
          ),
          Expanded(
            flex: 11,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      controller: _MyTabController,
                      tabs: [
                        Tab(
                          child: Text("Business",
                              style: GoogleFonts.lobster(
                                color: Colors.black,
                              )),
                          height: 80,
                          icon: Image.asset(
                            "assets/images/business.png",
                          ),
                        ),
                        Tab(
                          child: Text("School",
                              style: GoogleFonts.lobster(
                                color: Colors.black,
                              )),
                          height: 80,
                          icon: Image.asset("assets/images/school.png"),
                        ),
                        Tab(
                          child: Text("Payments",
                              style: GoogleFonts.lobster(
                                color: Colors.black,
                              )),
                          height: 105,
                          icon: Image.asset(
                            "assets/images/bill.png",
                            scale: 1.9,
                          ),
                        ),
                      ]),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var _CurrentListElement = _AllTasks[index];
                          return Dismissible(
                              onDismissed: (direction) {
                                setState(() {
                                  _AllTasks.removeAt(index);
                                  _localStorage.DeleteTask(
                                      task: _CurrentListElement);
                                });
                              },
                              key: Key(_CurrentListElement.Id),
                              child: TaskItem(
                                task: _CurrentListElement,
                              ));
                        },
                        itemCount: _AllTasks.length,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _ShowAddTaskBottomModelSheet(BuildContext context) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                maxLength: 30,
                onSubmitted: (value) {
                  Navigator.pop(context);
                  if (value.length > 1) {
                    DatePicker.showDateTimePicker(context,
                        //locale: TranslationHelper.getDeviceLanguage(context),
                        onConfirm: (time) async {
                      ShowContentTextField(value, time);

                      // Task NewTask = Task.create(
                      //     Name: value,
                      //     EndDate: time,
                      //     taskContent: "test content");
                      // //
                      // // Should insert sorted
                      // //
                    }, minTime: DateTime.now());
                  }
                },
                decoration: InputDecoration(hintText: "Add Task"),
                autofocus: true,
              ),
            ),
          );
        });
    // showModalBottomSheet(
    //     context: context,
    //     builder: (context) {
    //       return Container(
    //         padding: EdgeInsets.only(
    //             bottom: MediaQuery.of(context).viewInsets.bottom),
    //         width: MediaQuery.of(context).size.width,
    //         child: ListTile(
    //           title: TextField(
    //             autofocus: true,
    //           ),
    //         ),
    //       );
    //     });
  }

  void _GetAllTasksFromDB() async {
    _AllTasks = await _localStorage.GetAllTasks();
    setState(() {});
  }

  void ShowContentTextField(String name, DateTime time) {
    showBarModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
                title: TextField(
              decoration: InputDecoration(hintText: "Please write the content"),
              maxLength: 100,
              autofocus: true,
              onSubmitted: (value) async {
                Navigator.pop(context);
                Task NewTask =
                    Task.create(Name: name, EndDate: time, taskContent: value);
                _AllTasks.insert(0, NewTask);

                await _localStorage.AddTask(Task: NewTask);
                setState(() {});
              },
            )),
          );
        });
  }
}
