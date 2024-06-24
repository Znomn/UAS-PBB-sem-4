import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sh/header.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Event>> _events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
        title: "Calendar",
        onMenuPressed: () {},
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 41, 79, 184), Color.fromARGB(255, 65, 102, 207), Color.fromARGB(255, 13, 68, 139)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                eventLoader: (day) {
                  return _events[day] ?? [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  todayTextStyle: TextStyle(color: Colors.white),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  defaultTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.white),
                  outsideTextStyle: TextStyle(color: Colors.black),
                  disabledTextStyle: TextStyle(color: Colors.black),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue[900], // Warna biru tua
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(color: Colors.white),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _showAddEventDialog(_selectedDay),
                child: Text("Tambahkan Jadwal", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 22, 57, 140), // Background color
                ),
              ),
              ..._getEventsForDay(_selectedDay).map((event) => ListTile(
                title: Text(event.title, style: TextStyle(color: Colors.white)),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _removeEvent(_selectedDay, event),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _addEvent(DateTime day, String title) {
    final event = Event(title: title);
    setState(() {
      if (_events[day] != null) {
        _events[day]!.add(event);
      } else {
        _events[day] = [event];
      }
    });
  }

  void _removeEvent(DateTime day, Event event) {
    setState(() {
      _events[day]?.remove(event);
    });
  }

  void _showAddEventDialog(DateTime day) {
    final TextEditingController _eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Warna biru tua
        title: Text("Tambahkan Jadwal"),
        content: TextField(
          controller: _eventController,
          decoration: InputDecoration(hintText: "Nama Acara/jadwal"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_eventController.text.isNotEmpty) {
                _addEvent(day, _eventController.text);
              }
              Navigator.of(context).pop();
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  Event({required this.title});
}
