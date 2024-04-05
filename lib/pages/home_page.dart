import 'package:class_clockwise/pages/settings_page.dart';
import 'package:class_clockwise/pages/time_table_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TimeTable(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Class Clockwise',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.background.withOpacity(0.9)),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.7),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings')
        ],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor:
            Theme.of(context).colorScheme.background.withOpacity(0.9),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        unselectedItemColor:
            Theme.of(context).colorScheme.background.withOpacity(0.5),
        // elevation: 5,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
