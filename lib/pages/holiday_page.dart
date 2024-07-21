import 'package:flutter/material.dart';

class HolidayPage extends StatelessWidget {
  const HolidayPage({super.key, required this.isSunday});
  final bool isSunday;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: Opacity(
            opacity: 0.6,
            child: Image.asset(
              isSunday ? 'assets/relax.jpg' : 'assets/placement.jpg',
              fit: BoxFit.cover,
              width: 300,
              height: 300,
            )),
      ),
    );
  }
}
