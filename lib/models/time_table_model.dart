import 'dart:convert';
import 'package:http/http.dart' as http;

class TimetableData {
  final String day;
  final String time;
  final String subjects;
  final String initials;

  TimetableData({
    required this.day,
    required this.time,
    required this.subjects,
    required this.initials,
  });

  factory TimetableData.fromJson(Map<String, dynamic> json) {
    return TimetableData(
      day: json['day'],
      time: json['time'],
      subjects: json['subjects'] ?? 'No classes',
      initials: json['initials'] ?? 'Unassigned',
    );
  }

  static Future<List<TimetableData>> fetchDataFromAPI() async {
    // print('fetchDataFromAPI');
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbxL2PsxUE1ytvLcQ_N_AocnmHNwIR08jmpmiX6aP86g7hnoM3qxF9Vx8_sYZ3W18z_N/exec'));
    // print('response: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => TimetableData.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load timetable data. Please check your internet connection :(');
    }
  }
}
