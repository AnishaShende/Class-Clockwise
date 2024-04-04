import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flip_card/flip_card.dart';

Map<String, Color> circleAvatorColor = {
  'DBMS': const Color.fromARGB(255, 243, 68, 126),
  'ADS': const Color.fromARGB(255, 8, 137, 242),
  'OS': Colors.green,
  'PS': const Color.fromARGB(255, 218, 197, 6),
  'ITWL': Colors.deepOrange,
  'TOC': Colors.purple,
  'SS': Colors.brown,
};

class ListItem extends StatefulWidget {
  const ListItem(
      this.title, this.subtitle, this.classroom, this.startTime, this.endTime, this.tutBatch,
      {super.key});

  final String title;
  final String subtitle;
  final String classroom;
  final String startTime;
  final String endTime;
  final String tutBatch;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
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
    // widget.title.toList();
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

  Widget flippableListItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        side: CardSide.FRONT,
        front: Container(
          margin: const EdgeInsets.all(8.0),
          child: Row(
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
                        fontFamily:
                            DefaultTextStyle.of(context).style.fontFamily),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    widget.endTime,
                    style: TextStyle(
                        fontFamily:
                            DefaultTextStyle.of(context).style.fontFamily),
                  ),
                ],
              )
            ],
          ),
        ),
        back: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8.0),
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
                            if (str.contains('A1') ||
                                str.contains('A2') ||
                                str.contains('A3')) {
                              return TextSpan(
                                  text: '$str\n',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold));
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
                    Text(widget.startTime),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Text(widget.endTime),
                  ],
                ),
              ],
            )
            //[A1,: [ADS, (PGC,) (B207,), A3,: ITWLL, (VAMI,) (B206,), A2,: SS, (PRR,) (B205])]
            ),
        // autoFlipDuration: const Duration(
        //     seconds:
        //         2), // The flip effect will work automatically after the 2 seconds
      ),
    );
    // return FlipCard(
    //   margin: const EdgeInsets.all(8.0),
    //   child: GestureDetector(
    //     onTap: () {
    //       setState(() {
    //         isExpanded = !isExpanded;
    //       });
    //     },
    //     child: AnimatedContainer(
    //       duration: const Duration(milliseconds: 300),
    //       transform: Matrix4.rotationY(isExpanded ? 3.14 : 0),
    //       child: ListTile(
    //         title: const Text('Lab'),
    //         subtitle: isExpanded ? Text(widget.title) : null,
    //         trailing: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             Text(widget.startTime),
    //             Text(widget.endTime),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
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
    }
    //   const ListTile(
    //     title: Center(
    //       child: Text(
    //         'No classes!',
    //         style: TextStyle(fontWeight: FontWeight.bold),
    //       ),
    //     ),
    //   );
    // }
    else if (widget.title.length >= 10) {
      return flippableListItem();
    } else if (widget.title.contains('TUT')) {
      return Card(
        child: ListTile(
          title: Text(
            '${widget.title} - ${widget.tutBatch}',
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
        ),
      );
    } else {
      return Card(
        child: ListTile(
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
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: listContent(),
        // ListTile(
        //   title: Text(
        //     title,
        //     style: const TextStyle(fontWeight: FontWeight.bold),
        //   ),
        //   subtitle: Text(subtitle),
        //   leading: CircleAvatar(
        //     radius: 25.0,
        //     child: Text(
        //       classroom,
        //       style: const TextStyle(fontWeight: FontWeight.bold),
        //     ),
        //   ),
        //   trailing: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       Text(startTime),
        //       Text(endTime),
        //     ],
        //   ),
        // ), // listContent(),
      ),
    );
  }
}
