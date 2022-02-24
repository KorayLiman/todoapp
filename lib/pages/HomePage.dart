import 'dart:ui';

import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quds_ui_kit/viewers/quds_digital_clock_viewer.dart';
import 'package:quds_ui_kit/viewers/quds_digital_time_viewer.dart';
import 'package:todoapp/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Manage your tasks easily",
                      style: Constants.MyStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 30),
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
            flex: 9,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 30),
                        child: const Text(
                          "Here are your Tasks",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: CircleAvatar(
                          child: IconButton(
                              onPressed: () {}, icon: Icon(Icons.search)),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Dismissible(
                          onDismissed: (direction) {},
                          key: Key(index.toString()),
                          child: ExpansionTile(
                              childrenPadding: EdgeInsets.all(20),
                              title: const Text("Test Task"),
                              leading: Image.asset("assets/images/work1.png")),
                        ),
                        itemCount: 50,
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
}
