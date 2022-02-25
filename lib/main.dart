import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/pages/HomePage.dart';
import 'package:get_it/get_it.dart';

Future<void> SetupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var TaskBox = Hive.openBox<Task>("TaskBox");
}

final locator = GetIt.instance;
void setup() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SetupHive();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
