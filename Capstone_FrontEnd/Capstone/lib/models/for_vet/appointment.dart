import 'package:flutter/material.dart';

class Appointment {
  int appointmentId;
  int? ownerId;
  int? vetId;
  int? petId;
  String? description;
  DateTime appointmentDate;
  String? category;
  String? status;

  Appointment({
    required this.appointmentId,
    this.ownerId,
    this.vetId,
    this.petId,
    this.description,
    required this.appointmentDate,
    this.category,
    this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointmentId'],
      ownerId: json['ownerId'],
      vetId: json['vetId'],
      petId: json['petId'],
      description: json['description'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      category: json['category'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'ownerId': ownerId,
      'vetId': vetId,
      'petId': petId,
      'description': description,
      'appointmentDate': appointmentDate.toIso8601String(),
      'category': category,
      'status': status,
    };
  }
}
