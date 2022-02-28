import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:analog_clock/analog_clock.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late LocalStorage _localStorage;
  late List<Task> _AllTasks;
  late List<Task> _SchoolTasks;
  late List<Task> _PaymentTasks;
  late List<Task> _OtherTasks;
  late TabController _MyTabController;
  late Category category;
  var formKey = GlobalKey<FormState>();
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();

    _localStorage = locator<LocalStorage>();
    _AllTasks = <Task>[];
    _SchoolTasks = <Task>[];
    _PaymentTasks = <Task>[];
    _OtherTasks = <Task>[];
    _GetAllTasksFromDB();
    _MyTabController = TabController(length: 4, vsync: this);
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
              child: Padding(
                padding: const EdgeInsets.only(top: 58.0, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              "Hello...",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 230,
                            child: AutoSizeText(
                              "Manage your tasks easily",
                              style: Constants.MyStyle,
                              minFontSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 28.0, top: 0),
                            child: IconButton(
                              iconSize: 60,
                              onPressed: () {
                                showAboutDialog(
                                    context: context,
                                    applicationIcon: Image.asset(
                                        "assets/images/tasklist.png"),
                                    applicationVersion: "v1.0",
                                    children: [
                                      const Text(
                                        "This app made by Koray Liman",
                                        textAlign: TextAlign.center,
                                      ),
                                      const Text(
                                        "Enjoy :)",
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      const Text(
                                        "Sivas Cumhuriyet University",
                                        textAlign: TextAlign.center,
                                      )
                                    ]);
                              },
                              icon: Image.asset(
                                "assets/images/tasklist.png",
                                scale: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 230,
                        child: AutoSizeText(
                          "Press + button to add and long press to remove task",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          minFontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
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
                          child: Text("Work",
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
                        Tab(
                          child: Text("Other",
                              style: GoogleFonts.lobster(
                                color: Colors.black,
                              )),
                          height: 105,
                          icon: Image.asset(
                            "assets/images/other.png",
                            scale: 1.9,
                          ),
                        ),
                      ]),
                  Expanded(
                    child: TabBarView(
                      controller: _MyTabController,
                      children: [
                        SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var _CurrentListElement = _AllTasks[index];
                              return TaskItem(
                                task: _CurrentListElement,
                                AllTasks: _AllTasks,
                                localStorage: _localStorage,
                                index: index,
                                onDelete: () {
                                  setState(() {});
                                },
                              );
                            },
                            itemCount: _AllTasks.length,
                          ),
                        ),
                        SingleChildScrollView(
                            child: ListView.builder(
                                itemCount: _SchoolTasks.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var _CurrentListElement = _SchoolTasks[index];
                                  return TaskItem(
                                      onDelete: () {
                                        setState(() {});
                                      },
                                      task: _CurrentListElement,
                                      AllTasks: _SchoolTasks,
                                      localStorage: _localStorage,
                                      index: index);
                                })),
                        SingleChildScrollView(
                            child: ListView.builder(
                                itemCount: _PaymentTasks.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var _CurrentListElement =
                                      _PaymentTasks[index];
                                  return TaskItem(
                                      onDelete: () {
                                        setState(() {});
                                      },
                                      task: _CurrentListElement,
                                      AllTasks: _PaymentTasks,
                                      localStorage: _localStorage,
                                      index: index);
                                })),
                        SingleChildScrollView(
                            child: ListView.builder(
                                itemCount: _OtherTasks.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var _CurrentListElement = _OtherTasks[index];
                                  return TaskItem(
                                      onDelete: () {
                                        setState(() {});
                                      },
                                      task: _CurrentListElement,
                                      AllTasks: _OtherTasks,
                                      localStorage: _localStorage,
                                      index: index);
                                }))
                      ],
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
                maxLength: 40,
                onSubmitted: (value) {
                  Navigator.pop(context);
                  if (value.length > 1) {
                    DatePicker.showDateTimePicker(context,
                        //locale: TranslationHelper.getDeviceLanguage(context),
                        onConfirm: (time) {
                      if (time.millisecondsSinceEpoch >
                          DateTime.now().millisecondsSinceEpoch) {
                        _ShowCategorySelection(value, time);
                      } else {
                        showDialog(
                            context: super.context,
                            builder: (context) {
                              _timer = Timer(Duration(seconds: 2), () {
                                Navigator.pop(context);
                              });
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: const Text(
                                  "Oooops!!!",
                                  textAlign: TextAlign.center,
                                ),
                                content: const Text(
                                  "Selected time must be in the future",
                                  textAlign: TextAlign.center,
                                ),
                              );
                            });
                      }

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
    _AllTasks = await _localStorage.GetAllTasks(Category.Business);
    _SchoolTasks = await _localStorage.GetAllTasks(Category.School);
    _PaymentTasks = await _localStorage.GetAllTasks(Category.Payments);
    _OtherTasks = await _localStorage.GetAllTasks(Category.Other);

    setState(() {});
  }

  // void ShowContentTextField(String name, DateTime time) {
  //   showBarModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom),
  //           width: MediaQuery.of(context).size.width,
  //           child: ListTile(
  //               title: TextFormField(
  //             autovalidateMode: AutovalidateMode.onUserInteraction,
  //             validator: (value) {
  //               return value!.length < 2
  //                   ? "Content must be greater than 2 characters"
  //                   : null;
  //             },
  //             decoration: InputDecoration(hintText: "Please write the content"),
  //             maxLength: 100,
  //             autofocus: true,
  //             onFieldSubmitted: (value) async {
  //               if (value.length < 2) {
  //                 Navigator.pop(context);
  //                 showDialog(
  //                     context: context,
  //                     builder: (context) {
  //                       _timer = Timer(Duration(seconds: 2), () {
  //                         Navigator.pop(context);
  //                       });
  //                       return AlertDialog(
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(20)),
  //                         title: Text(
  //                           "Content must be greater than 2 characters",
  //                           style: TextStyle(color: Colors.black),
  //                         ),
  //                         backgroundColor: Colors.white,
  //                       );
  //                     });
  //               } else {
  //                 Navigator.pop(context);

  //                 _ShowCategorySelection(name, time);
  //               }
  //             },
  //           )),
  //         );
  //       });
  // }

  void _ShowCategorySelection(String name, DateTime time) {
    showMenu(
        color: Colors.blue.shade500,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        context: context,
        position: RelativeRect.fromLTRB(
            MediaQuery.of(context).size.width / 6,
            MediaQuery.of(context).size.height / 1.5,
            MediaQuery.of(context).size.width / 3,
            0),
        items: [
          PopupMenuItem(
              onTap: () async {
                category = Category.Business;
                int id;
                if (HiveLocalStorage.IntBox.isEmpty) {
                  id = 0;
                  HiveLocalStorage.IntBox.add(id);
                } else {
                  id = HiveLocalStorage.IntBox.getAt(
                      HiveLocalStorage.IntBox.length - 1)!;
                  HiveLocalStorage.IntBox.add(id + 1);
                }
                Task NewTask = Task.create(
                  NotificationId: id,
                  category: category,
                  Name: name,
                  EndDate: time,
                );
                _AllTasks.insert(0, NewTask);

                await _localStorage.AddTask(Task: NewTask);
                await flutterLocalNotificationsPlugin.zonedSchedule(
                    id,
                    'Hello, you have a scheduled task now',
                    '${NewTask.Name}',
                    tz.TZDateTime.now(tz.local).add(Duration(
                        milliseconds: (NewTask.EndDate.millisecondsSinceEpoch -
                            DateTime.now().millisecondsSinceEpoch))),
                    const NotificationDetails(
                        android: AndroidNotificationDetails(
                            'your channel id', 'your channel name',
                            channelDescription: 'your channel description')),
                    androidAllowWhileIdle: true,
                    uiLocalNotificationDateInterpretation:
                        UILocalNotificationDateInterpretation.absoluteTime);
                setState(() {});
              },
              child: Row(
                children: [
                  Image.asset("assets/images/business.png"),
                  const Text("Work")
                ],
              )),
          PopupMenuItem(
              onTap: () async {
                category = Category.School;
                int id;
                if (HiveLocalStorage.IntBox.isEmpty) {
                  id = 0;
                  HiveLocalStorage.IntBox.add(id);
                } else {
                  id = HiveLocalStorage.IntBox.getAt(
                      HiveLocalStorage.IntBox.length - 1)!;
                  HiveLocalStorage.IntBox.add(id + 1);
                }
                Task NewTask = Task.create(
                  NotificationId: id,
                  category: category,
                  Name: name,
                  EndDate: time,
                );
                _SchoolTasks.insert(0, NewTask);

                await _localStorage.AddTask(Task: NewTask);
                await flutterLocalNotificationsPlugin.zonedSchedule(
                    id,
                    'Hello, you have a scheduled task now',
                    '${NewTask.Name}',
                    tz.TZDateTime.now(tz.local).add(Duration(
                        milliseconds: (NewTask.EndDate.millisecondsSinceEpoch -
                            DateTime.now().millisecondsSinceEpoch))),
                    const NotificationDetails(
                        android: AndroidNotificationDetails(
                            'your channel id', 'your channel name',
                            channelDescription: 'your channel description')),
                    androidAllowWhileIdle: true,
                    uiLocalNotificationDateInterpretation:
                        UILocalNotificationDateInterpretation.absoluteTime);
                setState(() {});
              },
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/school.png",
                  ),
                  const Text("School")
                ],
              )),
          PopupMenuItem(
              onTap: () async {
//                 const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails('your channel id', 'your channel name',
//         channelDescription: 'your channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker');
// const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
// await flutterLocalNotificationsPlugin.show(
//     0, 'Title', 'Notification', platformChannelSpecifics,
//     payload: 'item x');

                category = Category.Payments;
                int id;
                if (HiveLocalStorage.IntBox.isEmpty) {
                  id = 0;
                  HiveLocalStorage.IntBox.add(id);
                } else {
                  id = HiveLocalStorage.IntBox.getAt(
                      HiveLocalStorage.IntBox.length - 1)!;
                  HiveLocalStorage.IntBox.add(id + 1);
                }
                Task NewTask = Task.create(
                  NotificationId: id,
                  category: category,
                  Name: name,
                  EndDate: time,
                );
                _PaymentTasks.insert(0, NewTask);

                await _localStorage.AddTask(Task: NewTask);
                await flutterLocalNotificationsPlugin.zonedSchedule(
                    id,
                    'Hello, you have a scheduled task now',
                    '${NewTask.Name}',
                    tz.TZDateTime.now(tz.local).add(Duration(
                        milliseconds: (NewTask.EndDate.millisecondsSinceEpoch -
                            DateTime.now().millisecondsSinceEpoch))),
                    const NotificationDetails(
                        android: AndroidNotificationDetails(
                            'your channel id', 'your channel name',
                            channelDescription: 'your channel description')),
                    androidAllowWhileIdle: true,
                    uiLocalNotificationDateInterpretation:
                        UILocalNotificationDateInterpretation.absoluteTime);
                setState(() {});
              },
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/bill.png",
                    scale: 1.9,
                  ),
                  const Text("Payments")
                ],
              )),
          PopupMenuItem(
              onTap: () async {
                category = Category.Other;
                int id;
                if (HiveLocalStorage.IntBox.isEmpty) {
                  id = 0;
                  HiveLocalStorage.IntBox.add(id);
                } else {
                  id = HiveLocalStorage.IntBox.getAt(
                      HiveLocalStorage.IntBox.length - 1)!;
                  HiveLocalStorage.IntBox.add(id + 1);
                }
                Task NewTask = Task.create(
                  NotificationId: id,
                  category: category,
                  Name: name,
                  EndDate: time,
                );
                _OtherTasks.insert(0, NewTask);

                await _localStorage.AddTask(Task: NewTask);
                await flutterLocalNotificationsPlugin.zonedSchedule(
                    id,
                    'Hello, you have a scheduled task now',
                    '${NewTask.Name}',
                    tz.TZDateTime.now(tz.local).add(Duration(
                        milliseconds: (NewTask.EndDate.millisecondsSinceEpoch -
                            DateTime.now().millisecondsSinceEpoch))),
                    const NotificationDetails(
                        android: AndroidNotificationDetails(
                            'your channel id', 'your channel name',
                            channelDescription: 'your channel description')),
                    androidAllowWhileIdle: true,
                    uiLocalNotificationDateInterpretation:
                        UILocalNotificationDateInterpretation.absoluteTime);
                setState(() {});
              },
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/other.png",
                    scale: 1.9,
                  ),
                  const Text("Other")
                ],
              )),
        ]);
  }
}
