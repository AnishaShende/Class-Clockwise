import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

import '../component/flipable_list.dart';
import 'list_item_sy.dart';

class ListItemTy extends StatefulWidget {
  const ListItemTy(this.title, this.subtitle, this.classroom, this.startTime,
      this.endTime, this.tutBatch,
      {super.key});

  final String title;
  final String subtitle;
  final String classroom;
  final String startTime;
  final String endTime;
  final String tutBatch;

  @override
  State<ListItemTy> createState() => _ListItemTyState();
}

class _ListItemTyState extends State<ListItemTy> {
  List batch = [];
  List labSubjects = [];
  List labInitials = [];
  List labRooms = [];
  late FlipCardController _controller;
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    // print(widget.title);
    // [ADS, A1, PGC, B207, ITWLL, A3, VAMI, B206, SS, A2, PRR, B205]
    _controller = FlipCardController();
  }

  void flipCard() {
    _controller.toggleCard();
  }

  List formattedText() {
    List<String> titleList = widget.title.split(' ');
    List output = [];
    for (var i = 0; i < titleList.length; i += 4) {
      output.add(
          "${titleList[i + 1].trim()}: ${titleList[i]} (${titleList[i + 2]}) (${titleList[i + 3]})");
      batch.add(titleList[i + 1]);
      labSubjects.add(titleList[i]);
      labInitials.add(titleList[i + 2]);
      labRooms.add(titleList[i + 3]);
      output.add('-');

      // "${titleList[i + 1]}: ${titleList[i]} (${titleList[i + 2]}) (${titleList[i + 3]})";
      // print(output);
    }
    return output; // [ADS, A1, PGC, B207, ITWLL, A3, VAMI, B206, SS, A2, PRR, B205]

    // 1, 5, 9
  }

  List formattedText1() {
    List<String> titleList = widget.title.split(' ');
    // print(
    // "**********************1 $titleList"); //  [[DAAL,, A1,, MPK,, B207,, CNL,, A2,, NNS,, B206,, DSML,, A3,, PDM,, B205]]
    List output =
        []; // [A1,, MPK,, B207,, CNL,, A2,, NNS,, B206,, DSML,, A3,, PDM,, B205]]
    for (var i = 0; i < titleList.length; i += 4) {
      output.add(
          "${titleList[i + 1].trim()}: ${titleList[i]} (${titleList[i + 2]}) (${titleList[i + 3]})");
      batch.add(titleList[i + 1]);
      labSubjects.add(titleList[i]);
      labInitials.add(titleList[i + 2]);
      labRooms.add(titleList[i + 3]);
      output.add('-');

      // "${titleList[i + 1]}: ${titleList[i]} (${titleList[i + 2]}) (${titleList[i + 3]})";
      // print(output);
    }
    return output; // [ADS, A1, PGC, B207, ITWLL, A3, VAMI, B206, SS, A2, PRR, B205]

    // 1, 5, 9
  }

  List formattedText2() {
    List<String> titleList = widget.title.split(' ');
    titleList.removeAt(0);
    // print("**********************2 $titleList");
    List output = [];
    for (var i = 0; i < titleList.length; i += 3) {
      output.add(
          "${titleList[i].trim()}: ${titleList[i + 1]} (${titleList[i + 2]})");
      // batch.add(titleList[i + 1]);

      labSubjects.add(titleList[i]);
      labInitials.add(titleList[i + 1]);
      labRooms.add(titleList[i + 2]);
      output.add('-');
      // print("printing output!!!!!!!!! $output");

      // "${titleList[i + 1]}: ${titleList[i]} (${titleList[i + 2]}) (${titleList[i + 3]})";
      // print(output);
      // Elective Mainframe(YKS)(B104), BIDA(MPK)(B301), IOT(YVD)(B101), AI(MPM)(B201)
      // [Elective, Mainframe, YKS, B104, .. ]
    }
    // print("*****output $output");
    return output; // [ADS, A1, PGC, B207, ITWLL, A3, VAMI, B206, SS, A2, PRR, B205]

    // 1, 5, 9
  }

  listContent() {
    if (widget.title == 'Lunch Break!') {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Colors.green,
            width: 2.0,
          ),
        ),
        child: const ListTile(
          title: Center(
            child: Text(
              'Lunch Break!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } else if (widget.title == 'No classes!') {
      return null;
    } else if (widget.title.contains('Elective')) {
      return FlipableList(
          widget.title,
          widget.subtitle,
          widget.classroom,
          widget.startTime,
          widget.endTime,
          widget.tutBatch,
          formattedText2(),
          true);
    } else if (widget.title.length >= 10) {
      return flippableListItem();
    } else if (widget.title.contains('ElectiveLab')) {
      return FlipableList(
          widget.title,
          widget.subtitle,
          widget.classroom,
          widget.startTime,
          widget.endTime,
          widget.tutBatch,
          formattedText2(),
          true);
    } else if (widget.title.contains('A3')) {
      return FlipableList(
          widget.title,
          widget.subtitle,
          widget.classroom,
          widget.startTime,
          widget.endTime,
          widget.tutBatch,
          formattedText1(),
          false);
    } else {
      return ListTile(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.subtitle),
        leading: CircleAvatar(
          backgroundColor: circleAvatorColor[widget.title] ??
              const Color.fromARGB(255, 241, 81, 134),
          radius: 25.0,
          child: Text(
            widget.classroom,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.startTime),
            Text(widget.endTime),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: listContent(),
      ),
    );
  }

  Widget flippableListItem() {
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
                      'LAB',
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
                      'Lab',
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
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: formattedText()
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
