// veterinarian.dart
class Veterinarian {
  final String id;
  final String username;
  final String password;
  final String email;
  String? firstName;
  String? lastName;
  DateTime? dob;
  String? gender;
  String? specialty;
  String? workSchedule;
  String? qualifications;
  int? yearsExperience;
  String? image; // URL or local path
  String? phoneNumber;  // Added phone number field

  Veterinarian({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
    this.specialty,
    this.workSchedule,
    this.qualifications,
    this.yearsExperience,
    this.image,
    this.phoneNumber,
  });
}
