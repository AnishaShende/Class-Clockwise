import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

Map<String, Color> circleAvatorColor = {
  'DAA': const Color.fromARGB(255, 243, 68, 126),
  'DSML': const Color.fromARGB(255, 8, 137, 242),
  'CN': Colors.green,
  'IPR': const Color.fromARGB(255, 218, 197, 6),
  'SPM': Colors.deepOrange,
  'AI': Colors.purple,
  'BIDA': Colors.purple,
  'CG': Colors.purple,
  'IOT': Colors.purple,
  'Mainframe': Colors.purple,
  'Project-1': Colors.brown,
};

class FlipableList extends StatefulWidget {
  const FlipableList(this.title, this.subtitle, this.classroom, this.startTime,
      this.endTime, this.elective, this.formattedString, this.isElective,
      {super.key});

  final String title;
  final String subtitle;
  final String classroom;
  final String startTime;
  final String endTime;
  final String elective;
  final List formattedString;
  final bool isElective;

  @override
  State<FlipableList> createState() => _FlipableListState();
}

class _FlipableListState extends State<FlipableList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.FRONT,
          front: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor:
                        circleAvatorColor[widget.title] ?? Colors.white,
                    radius: 25.0,
                    child: Text(
                      widget.isElective ? 'ELT' : 'LAB',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily:
                              DefaultTextStyle.of(context).style.fontFamily),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      widget.isElective ? 'Elective' : 'Lab',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily:
                              DefaultTextStyle.of(context).style.fontFamily),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.startTime,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily:
                            DefaultTextStyle.of(context).style.fontFamily),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    widget.endTime,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily:
                            DefaultTextStyle.of(context).style.fontFamily),
                  ),
                ],
              )
            ],
          ),
          back: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: widget.isElective
                              ? TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: widget.formattedString
                                      .toString()
                                      .trim()
                                      .split('-')
                                      .join('\n')
                                      .replaceAll('[', '')
                                      .replaceAll(']', '')
                                      .replaceAll('-', '')
                                      .replaceAll(',', '')
                                      .split('-')
                                      .map((str) {
                                    return TextSpan(
                                        text: '$str\n',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500));
                                  }).toList(),
                                )
                              : TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: widget.formattedString
                                      .toString()
                                      .trim()
                                      .split('-')
                                      .join('\n')
                                      .replaceAll('[', '')
                                      .replaceAll(']', '')
                                      .replaceAll('-', '')
                                      .replaceAll(',', '')
                                      .split('-')
                                      .map((str) {
                                    if (str.contains('A1')) {
                                      return TextSpan(
                                          text: ' $str\n',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500));
                                    } else if (str.contains('A2') ||
                                        str.contains('A3')) {
                                      return TextSpan(
                                          text: '$str\n',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500));
                                    } else {
                                      return TextSpan(text: '$str\n');
                                    }
                                  }).toList(),
                                ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.startTime,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily:
                                DefaultTextStyle.of(context).style.fontFamily),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Text(
                        widget.endTime,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily:
                                DefaultTextStyle.of(context).style.fontFamily),
                      ),
                    ],
                  ),
                ],
              )
              //[A1,: [ADS, (PGC,) (B207,), A3,: ITWLL, (VAMI,) (B206,), A2,: SS, (PRR,) (B205])]
              ),
        ),
      ),
    );
  }
}
