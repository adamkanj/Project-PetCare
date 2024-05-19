import 'dart:convert';
import 'dart:typed_data';

class Pet {
  final int petId;
  final int ownerId;
  final String name;
  final String? species;
  final String? breed;
  final String? gender;
  final DateTime? dob;
  final Uint8List? image;

  Pet({
    required this.petId,
    required this.ownerId,
    required this.name,
    this.species,
    this.breed,
    this.gender,
    this.dob,
    this.image,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petId: json['petId'],
      ownerId: json['ownerId'],
      name: json['name'],
      species: json['species'],
      breed: json['breed'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      image: json['image'] != null ? base64Decode(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petId': petId,
      'ownerId': ownerId,
      'name': name,
      'species': species,
      'breed': breed,
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'image': image != null ? base64Encode(image!) : null,
    };
  }
}