import 'package:flutter/material.dart';

import '../pages/time_table_page.dart';

class DropMenu extends StatefulWidget {
  DropMenu(this.currentDay, this.currentTime, this.filterTimetableData,
      {super.key});
  String currentDay;
  String currentTime;
  final void Function() filterTimetableData;

  @override
  State<DropMenu> createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> {
  @override
  Widget build(BuildContext context) {
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
                          selected: true,
                          title: Text(
                            day,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.surface),
                            textAlign: TextAlign.start,
                          ),
                          value: day,
                          groupValue: widget.currentDay,
                          onChanged: (value) {
                            setState(() {
                              widget.currentDay = value.toString();
                              widget.currentTime = value.toString();
                              widget.filterTimetableData();
                            });
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
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
            widget.currentDay.toUpperCase(),
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
}
