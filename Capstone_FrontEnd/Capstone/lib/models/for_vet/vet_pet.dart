import 'dart:convert';
import 'dart:typed_data';

class Vet_Pet {
  final int id;
   String name;
   String? breed;
   Uint8List? imageUrl;
   String? ownerName;
   DateTime? dob;

  Vet_Pet({
    required this.id,
    required this.name,
    this.breed,
    this.imageUrl,
    this.ownerName,
    this.dob,
  });

  factory Vet_Pet.fromJson(Map<String, dynamic> json) {
    return Vet_Pet(
      id: json['id'] ,
      name: json['name'] ,
      breed: json['breed'] ?? '',
      imageUrl: (json['image'] != null && json['image'].isNotEmpty)
          ? base64Decode(json['image'])
          : null,
      ownerName: json['ownerName'] ?? '',
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'image': imageUrl != null ? base64Encode(imageUrl!) : null,
      'ownerName': ownerName,
      'dob': dob != null ? dob!.toIso8601String() : null,
    };
  }
}
