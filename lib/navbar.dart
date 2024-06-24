/*
import 'package:flutter/material.dart';
import 'package:sh/pages/suhu.dart';
import 'package:sh/pages/calendar.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({Key? key}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CalendarPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuhuPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.thermostat),
          label: 'Suhu',
        ),
      ],
      currentIndex: _getCurrentIndex(context),
      selectedItemColor: Colors.amber[800],
      onTap: (index) => _onItemTapped(context, index),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final String? route = ModalRoute.of(context)?.settings.name;
    switch (route) {
      case '/suhu':
        return 1;
      case '/calendar':
      default:
        return 0;
    }
  }
}
*/