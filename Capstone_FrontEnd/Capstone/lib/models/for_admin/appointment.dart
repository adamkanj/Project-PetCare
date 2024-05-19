class Appointment {
  final String id;
  final String doctorName;
  final String petOwnerName;
  final String petName;
  final DateTime dateTime;
  final String description;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.petOwnerName,
    required this.petName,
    required this.dateTime,
    required this.description,
  });
}
