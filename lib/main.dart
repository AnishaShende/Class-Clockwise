import 'package:flutter/material.dart';
import 'package:class_clockwise/pages/home_page.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'models/local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  Workmanager()
      .initialize(LocalNotifications.callbackDispatcher, isInDebugMode: true);
  tz.initializeTimeZones(); // Initialize timezone data
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Class Clockwise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple.shade300, brightness: Brightness.dark),
      ),
      home: const HomePage(),
    );
  }
}
