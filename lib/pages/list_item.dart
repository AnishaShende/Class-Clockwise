import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flip_card/flip_card.dart';

Map<String, Color> circleAvatorColor = {
  'DBMS': const Color.fromARGB(255, 243, 68, 126),
  'ADS': Colors.blue,
  'OS': Colors.green,
  'PS': Colors.yellow,
  'ITWL': Colors.deepOrange,
  'TOC': Colors.purple,
  'SS': Colors.brown,
};

class ListItem extends StatefulWidget {
  const ListItem(
      this.title, this.subtitle, this.classroom, this.startTime, this.endTime,
      {super.key});

  final String title;
  final String subtitle;
  final String classroom;
  final String startTime;
  final String endTime;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late FlipCardController _controller;
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    print(widget.title);
    _controller = FlipCardController();
  }

  void flipCard() {
    _controller.toggleCard();
  }

  formattedText() {
    return widget.title; //
  }

  Widget flippableListItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        side: CardSide.BACK,
        front: Container(
          margin: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor:
                    circleAvatorColor[widget.title] ?? Colors.white,
                radius: 25.0,
                child: const Text(
                  'LAB',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const Text(
                'Lab',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.startTime),
                  Text(widget.endTime),
                ],
              )
            ],
          ),
        ),
        back: Container(
          margin: const EdgeInsets.all(8.0),
          child: Text(widget.title),
        ),
        autoFlipDuration: const Duration(
            seconds:
                2), // The flip effect will work automatically after the 2 seconds
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
      return const ListTile(
        title: Center(
          child: Text(
            'Lunch Break!',
            style: TextStyle(fontWeight: FontWeight.bold),
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
