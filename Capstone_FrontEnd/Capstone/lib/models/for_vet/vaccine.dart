import 'dart:convert';
import 'dart:typed_data';

class VaccineRecord {
  final int vaccinationId;
  final int petId;
  final String? vaccineName;
  final String? notes;
  final DateTime? dateAdministered;
  final DateTime? nextDueDate;
  final String? status;

  VaccineRecord({
    required this.vaccinationId,
    required this.petId,
    this.vaccineName,
    this.notes,
    this.dateAdministered,
    this.nextDueDate,
    this.status,
  });

  factory VaccineRecord.fromJson(Map<String, dynamic> json) {
    return VaccineRecord(
      vaccinationId: json['vaccinationId'],
      petId: json['petId'],
      vaccineName: json['vaccineName'],
      notes: json['notes'],
      dateAdministered: json['dateAdministered'] != null
          ? DateTime.parse(json['dateAdministered'])
          : null,
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.parse(json['nextDueDate'])
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vaccinationId': vaccinationId,
      'petId': petId,
      'vaccineName': vaccineName,
      'notes': notes,
      'dateAdministered': dateAdministered?.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'status': status,
    };
  }
}
