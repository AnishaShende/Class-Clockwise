import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.7),
      body: Container(
        child: ElevatedButton(
          onPressed: () {
            // Show "View TimeTable" option
            _openWithDialog(context);
          },
          child: const Text('View TimeTable'),
        ),
      ),
    );
  }

  Future<void> _openWithDialog(BuildContext context) async {
    try {
      const String assetPath =
          'assets/timetablesheet.xlsx'; // Path to your Google Sheets file in the assets folder
      final String tempPath = (await getTemporaryDirectory()).path;
      final String tempFilePath = '$tempPath/timetablesheet.xlsx';

      // Copy the file from assets to temporary directory
      ByteData data = await rootBundle.load(assetPath);
      List<int> bytes = data.buffer.asUint8List();
      await File(tempFilePath).writeAsBytes(bytes);

      // Show "Open With" dialog
      final OpenResult result = await OpenFile.open(
        tempFilePath,
        type:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );

      if (result.type == ResultType.done ||
          result.type == ResultType.noAppToOpen) {
        // File opened successfully or no app to open
      } else {
        // Handle error
        print('Error: ${result.message}');
      }
    } catch (e) {
      print('Error: $e');
      // Handle errors here
    }
  }
}
