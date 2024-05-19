import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../ApiHandler.dart';
import '../../models/for_vet/appointment.dart';
import 'appointment_manage/create_appointment_page.dart';
import 'appointment_manage/update_appointment_page.dart';
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

  Future<String> fetchPetOwnerName(int? ownerId) async {
    if (ownerId == null) {
      throw ArgumentError('Owner ID cannot be null.');
    }
    try {
      final petOwner = await ApiHandler().getPetOwnerById(ownerId);
      return '${petOwner.firstName} ${petOwner.lastName}';
    } catch (e) {
      print('Error fetching pet owner: $e');
      throw Exception('Failed to fetch pet owner');
    }
  }




  Future<void> fetchAppointments() async {

    try {
      List<Appointment> fetchedAppointments = await ApiHandler().fetchAppointments();
      setState(() {
        _appointments = groupAppointmentsByDate(fetchedAppointments);
      });
    } catch (e) {
      print('Error fetching appointments: $e');
      // Handle error
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
        title: Text('Manage Appointments'),
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
            child: ListView.builder(
              itemCount: _getEventsForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay)[index];
                return ListTile(
                  title: Text('${event.category}: ${event.status} at ${TimeOfDay.fromDateTime(event.appointmentDate)}'),
                  subtitle: FutureBuilder<String>(
                    future: fetchPetOwnerName(event.ownerId),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error loading pet owner');
                      } else if (!snapshot.hasData) {
                        return Text('Pet owner not found');
                      } else {
                        return Text('PetId: ${event.petId}, owned by ${snapshot.data}');
                      }
                    },
                  ),



                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditAppointmentPage(appointment: event))).then((_) {
                      fetchAppointments(); // Update the list of appointments after returning from the EditAppointmentPage
                    });

                  },
                );

              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAppointmentPage())).then((_) {
            fetchAppointments(); // Update the list of appointments after returning from the create AppointmentPage
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Add Appointment',
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
