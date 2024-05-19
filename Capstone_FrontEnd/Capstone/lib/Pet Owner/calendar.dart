import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../ApiHandler.dart';
import '../../models/for_vet/appointment.dart';
import '../../IdProvider.dart';
import 'package:provider/provider.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late Map<DateTime, List<Appointment>> _appointments = {};
  DateTime _selectedDay = _stripTime(DateTime.now());
  DateTime _focusedDay = _stripTime(DateTime.now());

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<String> fetchPetName(int petId) async {
    try {
      final pet = await ApiHandler().getPetById(petId);
      return pet.name;
    } catch (e) {
      print('Error fetching pet name: $e');
      throw Exception('Failed to fetch pet name');
    }
  }

  Future<void> fetchAppointments() async {
    int ownerId = Provider.of<IdProvider>(context, listen: false).id!;

    try {
      List<Appointment> fetchedAppointments = await ApiHandler().fetchAppointmentsbyOwnerid(ownerId);
      setState(() {
        _appointments = groupAppointmentsByDate(fetchedAppointments);
      });
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  Map<DateTime, List<Appointment>> groupAppointmentsByDate(List<Appointment> appointments) {
    Map<DateTime, List<Appointment>> appointmentsMap = {};
    for (var appointment in appointments) {
      DateTime date = DateTime(appointment.appointmentDate.year, appointment.appointmentDate.month, appointment.appointmentDate.day);
      if (appointmentsMap.containsKey(date)) {
        appointmentsMap[date]!.add(appointment);
      } else {
        appointmentsMap[date] = [appointment];
      }
    }
    return appointmentsMap;
  }

  List<Appointment> _getEventsForDay(DateTime day) {
    return _appointments[_stripTime(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = _stripTime(selectedDay);
                _focusedDay = _stripTime(focusedDay);
              });
            },
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: _buildEventsMarker(date, events),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _getEventsForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay)[index];
                return ListTile(
                  title: event.petId == null
                      ? Text('${event.category}: ${event.status} at ${TimeOfDay.fromDateTime(event.appointmentDate)} - No Pet ID')
                      : FutureBuilder<String>(
                    future: fetchPetName(event.petId!), // Using the bang operator because we now know petId is not null
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('${event.category}: ${event.status} at ${TimeOfDay.fromDateTime(event.appointmentDate)} Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error loading pet details');
                      } else {
                        return Text('${event.category}: ${event.status} at ${TimeOfDay.fromDateTime(event.appointmentDate)} (for ${snapshot.data})');
                      }
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding to control the length of the divider
                child: Divider(
                  color: Colors.grey, // You can change the color to match your design
                  height: 1, // Can be adjusted to change the space around the divider
                  thickness: 1, // Can adjust the thickness of the divider
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return Positioned(
      bottom: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[400],
        ),
        width: 20.0,
        height: 20.0,
        child: Center(
          child: Text(
            '${events.length}',
            style: TextStyle().copyWith(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}

DateTime _stripTime(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}
