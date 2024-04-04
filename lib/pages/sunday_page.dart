import 'package:flutter/material.dart';

class SundayPage extends StatelessWidget {
  const SundayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: Opacity(
            opacity: 0.6,
            child: Image.asset(
              'relax.jpg',
              fit: BoxFit.cover,
              width: 300,
              height: 300,
            )),
      ),
    );
  }
}
