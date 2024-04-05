import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SheetView extends StatelessWidget {
  const SheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _openFile();
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Text("Google Sheets"),
      ),
    );
  }

  Future<void> _openFile() async {
    try {
      const String assetPath = 'assets/timetablesheet.xlsx';
      final String tempPath = (await getTemporaryDirectory()).path;
      final String tempFilePath = '$tempPath/assets/timetablesheet.xlsx';

      // Copy the file from assets to temporary directory
      ByteData data = await rootBundle.load(assetPath);
      List<int> bytes = data.buffer.asUint8List();
      await File(tempFilePath).writeAsBytes(bytes);

      // Open the copied file
      await OpenFile.open(tempFilePath);
    } catch (e) {
      print('Error opening file: $e');
      // Handle errors here
    }
  }
}
