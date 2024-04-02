import 'package:class_clockwise/models/time_table_model.dart';
import 'package:class_clockwise/pages/list_item.dart';
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

  @override
  void initState() {
    super.initState();
    // Get the current day of the week
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE');
    final String formattedDay = formatter.format(now);
    currentDay = formattedDay;
    currentTime = formattedDay.toUpperCase();
    currentTime = currentTime == 'THURSDAY'
        ? currentTime.substring(0, 5)
        : currentTime.substring(0, 3);
    // print('currentTime: $currentTime');
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final List<TimetableData> data = await TimetableData.fetchDataFromAPI();

      timetableData = data.where((data) => data.day == currentTime).toList();

      // startTime = timetableData.isNotEmpty
      //     ? timetableData.first.time.split('-').first.trim()
      //     : '';
      // endTime = timetableData.isNotEmpty
      //     ? timetableData.last.time.split('-').last.trim()
      //     : '';
      // print(data);
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Widget content() {
    if (currentTime == 'SUN') {
      return const Text('No classes on Sunday!');
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              currentDay,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              textAlign: TextAlign.start,
            ),
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
        return currentSubject;
      } else if (components1.length == 4) {
        currentSubject = components1[0];
        currentInitials = components1[2];
        classroom = components1[3];
        return currentSubject;
      } else {
        formattedText = components1.toString();
        currentInitials = 'qwerty';

        return formattedText;
      }
    }
  }

  // filter() {
  //   String text = "DBMS(MPK)(B201)";
  //   RegExp regex = RegExp(r'([A-Z]+)\(([A-Z]+)\)\(([A-Z0-9]+)\)');

  //   Match? match = regex.firstMatch(text);

  //   if (match != null) {
  //     String subject = match.group(1)!; // DBMS
  //     String teacherInitials = match.group(2)!; // MPK
  //     String classroom = match.group(3)!; // B201

  //     // print("Subject: $subject");
  //     // print("Teacher Initials: $teacherInitials");
  //     // print("Classroom: $classroom");
  //   } else {
  //     print("No match found");
  //   }
  //   String text1 = "PS TUT (A3) (NNW) (B314)";
  //   String text2 =
  //       "ITWL (A1) (PPG) (B205), OS (A2) (NNS) (B207), DMS (A3) (MPK) (B206)";
  //   // If length is more than 4 it is text2

  //   // Regular expression pattern to match different components
  //   RegExp regexText = RegExp(r'([A-Z\s]+)|\(([A-Z0-9]+)\)');

  //   // Match text1
  //   Iterable<Match> matches1 = regexText.allMatches(text2); //text1
  //   List<String> components1 = [];
  //   for (Match match in matches1) {
  //     String? group1 = match.group(1);
  //     String? group2 = match.group(2);
  //     if (group1 != null) {
  //       components1.add(group1.trim());
  //     }
  //     if (group2 != null) {
  //       components1.add(group2.trim());
  //     }
  //   }

  //   // // Match text2
  //   // Iterable<Match> matches2 = regexText.allMatches(text2);
  //   // List<String> components2 = [];
  //   // for (Match match in matches2) {
  //   //   String? group1 = match.group(1);
  //   //   String? group2 = match.group(2);
  //   //   if (group1 != null) {
  //   //     components2.add(group1.trim());
  //   //   }
  //   //   if (group2 != null) {
  //   //     components2.add(group2.trim());
  //   //   }
  //   // }
  //   List<String> text2List = text2.split(',');

  //   // Match each string from text2List
  //   List<List<String>> nestedComponents = [];
  //   for (String text in text2List) {
  //     Iterable<Match> matches = regexText.allMatches(text);
  //     List<String> currentList = [];
  //     for (Match match in matches) {
  //       String? group1 = match.group(1);
  //       String? group2 = match.group(2);
  //       if (group1 != null) {
  //         currentList.add(group1.trim());
  //       }
  //       if (group2 != null) {
  //         currentList.add(group2.trim());
  //       }
  //     }

  //     // Remove null elements from currentList
  //     currentList.removeWhere((element) => element.isEmpty);
  //     if (currentList.isNotEmpty) {
  //       nestedComponents.add(currentList);
  //     }
  //   }

  //   // Output results
  //   print("Text 1 Components: $components1");
  //   print("Text 2 Components: $nestedComponents");

  //   // Subject: DBMS
  //   // Teacher Initials: MPK
  //   // Classroom: B201
  //   // Text 1 Components: [PS TUT, A3, , NNW, , B314]
  //   // Text 2 Components: [[ITWL, A1, PPG, B205], [OS, A2, NNS, B207], [DMS, A3, MPK, B206]]
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Class Clockwise',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.background.withOpacity(0.9)),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.9),
      bottomNavigationBar: BottomNavigationBar(
        key: ValueKey(currentTime),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'abc'),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm), label: 'alarm')
        ],
      ),
      body: content(),
    );
  }
}



                // Display start time at upper right corner
                // if (startTime.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                //     child: Align(
                //       alignment: Alignment.topRight,
                //       child: Text(
                //         'Start Time: $startTime',
                //         style: const TextStyle(
                //             fontSize: 16, fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ),
                // Display timetable data
                // DBMS(MPK)(B201)
                // 1st value is subject, 2nd value is initials, 3rd value is classroom


                // filter(),
                // Display end time at lower right corner
                // if (endTime.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                //     child: Align(
                //       alignment: Alignment.bottomRight,
                //       child: Text(
                //         'End Time: $endTime',
                //         style: const TextStyle(
                //             fontSize: 16, fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ),