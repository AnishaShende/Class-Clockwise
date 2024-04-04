import 'package:class_clockwise/models/time_table_model.dart';
import 'package:class_clockwise/pages/list_item.dart';
import 'package:class_clockwise/pages/sunday_page.dart';
import 'package:class_clockwise/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
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
  final List<String> days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY'
  ];

  @override
  void initState() {
    super.initState();
    // Get the current day of the week
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE');
    final String formattedDay = formatter.format(now);
    currentDay = formattedDay;
    currentTime = formattedDay.toUpperCase();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      currentTime = currentTime == 'THURSDAY'
          ? currentTime.substring(0, 5)
          : currentTime.substring(0, 3);
      final List<TimetableData> data = await TimetableData.fetchDataFromAPI();
      timetableData = data.where((data) => data.day == currentTime).toList();

      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  dropMenu(String text) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              alignment: Alignment.center,
              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              insetPadding: const EdgeInsets.fromLTRB(50, 100, 50, 100),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      children: days.map((day) {
                        return RadioListTile(
                          title: Text(
                            day,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.background),
                            textAlign: TextAlign.start,
                          ),
                          value: day,
                          groupValue: currentDay,
                          onChanged: (value) {
                            setState(() {
                              currentDay = value.toString();
                              currentTime = value.toString();
                              print(value);
                              fetchData();
                            });
                            Navigator.pop(context);
                          },
                        );
                      }).toList(), // Convert the iterable to a list
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            width: 2,
          ),
          Icon(
            Icons.arrow_drop_down_rounded,
            size: 30,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ],
      ),
    );
  }

  Widget content() {
    if (currentTime == 'SUN' || currentTime == 'SAT') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: dropMenu(currentDay),
              )
              // Text(currentDay),
              ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Column(
            children: [
              const SundayPage(),
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
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(child: dropMenu(currentDay)),
            // Text(currentDay),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
              itemCount: timetableData.length,
              itemBuilder: (context, index) {
                var data = timetableData[index];
                return ListItem(
                  filter1(data.subjects, index),
                  currentInitials,
                  classroom,
                  startTime,
                  endTime,
                  tutBatch,
                );
              },
            ),
          ),
        ],
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
    bool showSettingsPage = false;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Class Clockwise',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.9)),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        backgroundColor:
            Theme.of(context).colorScheme.background.withOpacity(0.7),
        bottomNavigationBar: BottomNavigationBar(
          key: ValueKey(currentTime),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'settings')
          ],
          onTap: (index) {
            if (index == 1) {
              setState(() {
                showSettingsPage = true;
              });
            } else {
              setState(() {
                showSettingsPage = false;
              });
            }
          },
        ),
        body: Stack(
          children: [
            content(),
            if (showSettingsPage) const SettingsPage(),
          ],
        ));
  }
}