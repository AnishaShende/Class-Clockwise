import 'package:class_clockwise/pages/settings_page.dart';
import 'package:class_clockwise/pages/time_table_page.dart';
import 'package:flutter/material.dart';
import '../models/local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = true;

  void _toggleBrightness() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

  listenToNotifications() {
    print('Listening to notifications');
    LocalNotifications.onClickNotification.stream.listen((event) {
      print('Notification tapped');
    });
  }

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TimeTable(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple.shade300,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Class Clockwise',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          actions: [
            IconButton(
              icon: _isDarkMode
                  ? Icon(Icons.sunny)
                  : Icon(Icons.nightlight_round),
              onPressed: _toggleBrightness,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'settings'),
          ],
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.9),
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          unselectedItemColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.5),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
