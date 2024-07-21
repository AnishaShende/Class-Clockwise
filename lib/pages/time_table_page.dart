import 'dart:convert';
import 'package:class_clockwise/models/time_table_model.dart';
import 'package:class_clockwise/pages/holiday_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/drop_menu.dart';
import '../models/local_notifications.dart';
import 'list_item_ty.dart';

final List<String> days = [
  'MONDAY',
  'TUESDAY',
  'WEDNESDAY',
  'THURSDAY',
  'FRIDAY',
  'SATURDAY',
  'SUNDAY'
];

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  List<TimetableData> timetableData = [];
  String currentTime = '';
  String currentDay = '';
  String startTime = '';
  String endTime = '';
  String classroom = '';
  String currentSubject = '';
  String currentInitials = '';
  String formattedText = '';
  String tutBatch = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scrollController = ScrollController();
    // Get the current day of the week
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE');
    final String formattedDay = formatter.format(now);
    currentDay = formattedDay;
    currentTime = formattedDay.toUpperCase();
    loadTimetable();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadTimetable() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('timetableData');
    if (savedData != null) {
      print(
          '****************************************************Loading timetable data from SharedPreferences: $savedData');
      final List<dynamic> jsonData = jsonDecode(savedData);
      timetableData =
          jsonData.map((json) => TimetableData.fromJson(json)).toList();
      filterTimetableData();
      setState(() {});
    } else {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      currentTime = currentTime == 'THURSDAY'
          ? currentTime.substring(0, 5)
          : currentTime.substring(0, 3);
      final List<TimetableData> data = await TimetableData.fetchDataFromAPI();
      timetableData = data.where((data) => data.day == currentTime).toList();

      // Save data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('timetableData', jsonEncode(data));

      // Schedule notifications for each lecture in today's timetable
      for (var lecture in timetableData) {
        final lectureTime =
            DateFormat('HH:mm').parse(lecture.time.split('-').first.trim());
        print('*************************lecturetime: $lectureTime');
        final now = DateTime.now();
        final scheduledDateTime = DateTime(now.year, now.month, now.day,
                lectureTime.hour, lectureTime.minute)
            .subtract(Duration(minutes: 5));
        print('*************************scheduledDateTime: $scheduledDateTime');
        if (scheduledDateTime.isAfter(now)) {
          print('scheduledDateTime is after now!');
          await LocalNotifications.scheduleNotification(
            lectureTime: scheduledDateTime,
            lectureTitle: lecture.subjects,
          );
        }
      }

      filterTimetableData();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      SnackBar(content: Text('Error fetching data: $e'));
      setState(() {
        isLoading = false;
      });
    }
  }

  // void filterTimetableData() {
  //   timetableData =
  //       timetableData.where((data) => data.day == currentTime).toList();
  // }
  void filterTimetableData() {
    setState(() {
      timetableData =
          timetableData.where((data) => data.day == currentTime).toList();
    });
  }

  // Future<void> scheduleBackgroundTask(
  //     DateTime lectureTime, String lectureTitle) async {
  //   await Workmanager().registerOneOffTask(
  //     "uniqueName_${lectureTitle}_${lectureTime.toIso8601String()}",
  //     "simpleTask",
  //     inputData: {
  //       "lectureTime": lectureTime.toIso8601String(),
  //       "lectureTitle": lectureTitle,
  //     },
  //     initialDelay: Duration(seconds: 5),
  //   );
  // }

  Future<void> refreshTimetable() async {
    await fetchData();
  }

  showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }

  Widget content() {
    _controller.animateTo(1.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastEaseInToSlowEaseOut);
    _scrollController.animateTo(1.0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    if (currentTime == 'SUN' || currentTime == 'SAT') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: DropMenu(currentDay, currentTime, filterTimetableData),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Column(
            children: [
              const HolidayPage(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'No classes for today!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return RefreshIndicator(
        onRefresh: refreshTimetable,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child:
                      DropMenu(currentDay, currentTime, filterTimetableData)),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                itemCount: timetableData.length,
                itemBuilder: (context, index) {
                  var data = timetableData[index];
                  return ScaleTransition(
                    scale: _controller,
                    child: ListItemTy(
                      filter1(data.subjects, index),
                      currentInitials,
                      classroom,
                      startTime,
                      endTime,
                      tutBatch,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  String filter1(String subject, int index) {
    if (subject == 'Lunch Break') {
      currentInitials = '';
      classroom = '';
      tutBatch = '';
      startTime = index < timetableData.length
          ? timetableData[index].time.split('-').first.trim()
          : '';
      endTime = index < timetableData.length
          ? timetableData[index].time.split('-').last.trim()
          : '';
      return 'Lunch Break!';
    } else if (subject.isEmpty) {
      currentInitials = '';
      classroom = '';
      tutBatch = '';
      startTime = index < timetableData.length
          ? timetableData[index].time.split('-').first.trim()
          : '';
      endTime = index < timetableData.length
          ? timetableData[index].time.split('-').last.trim()
          : '';
      return 'No classes!';
    } else {
      RegExp regexExp = RegExp(r'([A-Z\s]+)|\(([A-Z0-9]+)\)');
      Iterable<Match> matches1 = regexExp.allMatches(subject);
      List<String> components1 = [];
      startTime = index < timetableData.length
          ? timetableData[index].time.split('-').first.trim()
          : '';
      endTime = index < timetableData.length
          ? timetableData[index].time.split('-').last.trim()
          : '';
      for (Match match in matches1) {
        String? group1 = match.group(1);
        String? group2 = match.group(2);
        if (group1 != null) {
          components1.add(group1.trim());
        }
        if (group2 != null) {
          components1.add(group2.trim());
        }
      }
      // Remove null elements from components1
      components1.removeWhere((element) => element.isEmpty);

      if (components1.length == 3) {
        currentSubject = components1[0];
        currentInitials = components1[1];
        classroom = components1[2];
        tutBatch = '';
        return currentSubject;
      } else if (components1.length == 4) {
        currentSubject = components1[0];
        tutBatch = components1[1];
        currentInitials = components1[2];
        classroom = components1[3];
        return currentSubject;
      } else {
        tutBatch = '';
        formattedText = components1.toString();
        currentInitials = '';

        return formattedText;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   appBar: AppBar(
        //     centerTitle: true,
        //     title: const Text(
        //       'Time Table',
        //     ),
        //   ),
        //   body:
        isLoading ? showLoadingIndicator() : content();
    // );
  }
}
