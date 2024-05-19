import 'dart:convert';
import 'dart:typed_data';

class Veterinarian {
  final int id;
  final String username;
  final String email;
  String? firstName;
  String? lastName;
  String? Password;
  DateTime? dob;
  String? gender;
  String? specialty;
  String? workSchedule;
  String? qualifications;
  int? yearsExperience;
  Uint8List? image;
  String? phoneNumber;

  Veterinarian({
    required this.id,
    required this.username,
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
    this.Password,
  });

  factory Veterinarian.fromJson(Map<String, dynamic> json) {
    return Veterinarian(
      id: json['vetId'],
      username: json['username'],
      email: json['email'],
      firstName: json['fn'],
      lastName: json['ln'],
      dob: DateTime.tryParse(json['dob']),
      gender: json['gender'],
      specialty: json['specialty'],
      workSchedule: json['workSchedule'],
      qualifications: json['qualifications'],
      yearsExperience: int.tryParse(json['yearsExperience'] ?? '0'),
      phoneNumber: json['phoneNumber'],
      // Assuming you store base64 image string in your backend
      image: (json['image'] != null && json['image'].isNotEmpty) ? base64Decode(json['image']) : null,
    );
  }


}
