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
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          onPressed: () {
            _openWithDialog(context);
          },
          child: ListTile(
            title: Text(
              'View TimeTable',
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            leading: Icon(
              Icons.table_chart,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openWithDialog(BuildContext context) async {
    try {
      // Path to your Google Sheets file in the assets folder
      const String assetPath = 'assets/timetablesheet.xlsx';
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
        // print('Error: ${result.message}');
        SnackBar(content: Text('Error: ${result.message}'));
      }
    } catch (e) {
      // print('Error: $e');
      // Handle errors here
      SnackBar(content: Text('Error: $e'));
    }
  }
}
