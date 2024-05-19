import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:petcare/models/for_vet/review.dart';
import 'models/Equipment.dart';
import 'models/PetOwner.dart';
import 'models/for_pet_owner/Ownerpet.dart';
import 'models/for_pet_owner/ReviewProduct.dart';
import 'models/for_pet_owner/ReviewVet.dart';
import 'models/for_vet/MedicalRecord.dart';
import 'models/for_vet/appointment.dart';
import 'models/for_vet/vet_pet.dart';
import 'models/for_vet/vaccine.dart';
import 'models/veterinarian.dart';
import 'models/product.dart';

class ApiHandler {
  final String baseUrl = 'https://localhost:7281/api'; // Adjust the URL as needed

  // Login function
  Future<List<String>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usernameOrEmail': email,
        'password': password,
      }),
    );

    if (response.statusCode >= 200 || response.statusCode <= 299) {
      // Parse the response body
      final responseBody = jsonDecode(response.body);

      // Extract role information and ID
      final role = responseBody[0];
      final id = responseBody[1];

      return [role, id];
    } else {
      print('Failed to login with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }


  // Signup function
  Future<bool> createPetOwner(Map<String, dynamic> petOwnerData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/petowner'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(petOwnerData),
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      // Assuming the creation is successful if the status code is in the 200 range
      return true;
    } else {
      // Log error details for debugging
      print('Failed to create pet owner with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  Future<List<Veterinarian>> fetchVeterinarians() async {
  final response = await http.get(Uri.parse('$baseUrl/veterinarian'));

  if (response.statusCode == 200) {
  List<dynamic> vetsJson = jsonDecode(response.body);
  return vetsJson.map((json) => Veterinarian.fromJson(json)).toList();
  } else {
  throw Exception('Failed to load veterinarians');
  }
  }



  Future<bool> updateVeterinarian(int vetId, Veterinarian vet) async {
    Uri url = Uri.parse('$baseUrl/veterinarian/$vetId'); // Including vetId in the URL

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'vetId': vetId,
          'userId': 0,
          'specialty': vet.specialty ?? '',
          'workSchedule': vet.workSchedule ?? '',
          'qualifications': vet.qualifications ?? '',
          'yearsExperience': vet.yearsExperience?.toString() ?? '0',
          'image': vet.image != null ? base64Encode(vet.image!) : '',
          'username': vet.username,
          'password': "string", // Ensure the password is handled securely and needed here
          'email': vet.email,
          'fn': vet.firstName,
          'ln': vet.lastName,
          'dob': vet.dob != null ? DateFormat('yyyy-MM-dd').format(vet.dob!) : '',
          'gender': vet.gender ?? 'Unknown',
          'role':  'Veterinarian'
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update veterinarian: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception in updateVeterinarian: $e');
      return false;
    }
  }

  Future<bool> createVeterinarian(Veterinarian vet) async {
    Uri url = Uri.parse('$baseUrl/veterinarian');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'vetId': 0,
          'userId': 0, // Assuming you manage userId another way or it's generated by the backend
          'specialty': vet.specialty,
          'workSchedule': vet.workSchedule,
          'qualifications': vet.qualifications,
          'yearsExperience': vet.yearsExperience.toString(),
          'image': vet.image != null ? base64Encode(vet.image!) : '',
          'username': vet.username,
          'password': vet.Password,
          'email': vet.email,
          'fn': vet.firstName,
          'ln': vet.lastName,
          'dob': DateFormat('yyyy-MM-dd').format(vet.dob!),
          'gender': vet.gender,
          'role': 'Veterinarian' // Assuming this is a static role
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create veterinarian: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception in createVeterinarian: $e');
      return false;
    }
  }

  Future<List<Equipment>> fetchEquipments() async {
    final response = await http.get(Uri.parse('$baseUrl/equipment'));
    if (response.statusCode == 200) {
      try {
        List<dynamic> jsonList = jsonDecode(response.body) as List;
        List<Equipment> equipments = jsonList.map((json) => Equipment.fromJson(json)).toList();
        return equipments;
      } catch (e) {
        print('Error parsing equipments: $e');
        print('Raw response body: ${response.body}');
        throw Exception('Error parsing equipments');
      }
    } else {
      print('Failed to load equipments with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load equipments');
    }
  }



  Future<bool> createEquipment(Equipment equipment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/equipment'),
      headers: <String, String>{ 'Content-Type': 'application/json; charset=UTF-8' },
      body: jsonEncode({
        'name': equipment.name,
        'quantity': equipment.quantity,
        'category': equipment.category,
        'lastScanDate': equipment.lastScanDate != null ? DateFormat('yyyy-MM-dd').format(equipment.lastScanDate!) : null,
        'nextScanDate': equipment.nextScanDate != null ? DateFormat('yyyy-MM-dd').format(equipment.nextScanDate!) : null,
      }),
    );
    return response.statusCode == 201;
  }


  Future<bool> updateEquipment(Equipment equipment) async {
    final url = Uri.parse('$baseUrl/equipment/${equipment.id}');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'equipmentId': equipment.id,
        'name': equipment.name,
        'quantity': equipment.quantity,
        'category': equipment.category,
        'lastScanDate': equipment.lastScanDate != null ? DateFormat('yyyy-MM-dd').format(equipment.lastScanDate!) : null,
        'nextScanDate': equipment.nextScanDate != null ? DateFormat('yyyy-MM-dd').format(equipment.nextScanDate!) : null,
      }),
    );

    return response.statusCode == 200;
  }


  // Get a product by its ID
  Future<Product> getProductById(int productId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/$productId'));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  // Get all products
  Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/product'));
    if (response.statusCode == 200) {
      Iterable productsJson = jsonDecode(response.body);
      return List<Product>.from(productsJson.map((model) => Product.fromJson(model)));
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Create a new product
  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/product'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }

  // Update an existing product

  Future<bool> updateProduct(int productId, Product updatedProduct) async {
    // Example API endpoint URL and request construction
    final url = Uri.parse('$baseUrl/product/$productId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedProduct.toJson()), // Adjust to your `Product` model's `toJson` function
    );

    return response.statusCode == 200; // Consider 200 OK as success
  }

  Future<List<Appointment>> fetchAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/appointment'));

    if (response.statusCode == 200) {
      List<dynamic> appointmentsJson = jsonDecode(response.body);
      return appointmentsJson.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<PetOwner> getPetOwnerById(int ownerId) async {
    final response = await http.get(Uri.parse('$baseUrl/petowner/$ownerId'));
    if (response.statusCode >= 200 && response.statusCode <210) {
      return PetOwner.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load pet owner');
    }
  }

  // Example of sending a PUT request with JSON content
  // In ApiHandler
  Future<bool> updateAppointment(int appointmentId, Appointment updatedAppointment) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/appointment/$appointmentId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedAppointment.toJson()), // Ensure you have a toJson method
      );

      if (response.statusCode>= 200 && response.statusCode<300) {
        print('Appointment updated successfully.');
        return true;
      } else {
        print('Failed to update appointment: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception when updating appointment: $e');
      return false;
    }
  }



  Future<void> deleteAppointment(int appointmentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/appointment/$appointmentId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Appointment deleted successfully');
    } else {
      throw Exception('Failed to delete appointment: ${response.statusCode}');
    }
  }

  Future<void> createAppointment(Appointment appointment) async {
    final url = Uri.parse('$baseUrl/appointment');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(appointment.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode <210) {
        // Appointment created successfully
        return;
      } else if (response.statusCode == 409) {
        // Appointment slot is not available
        throw Exception('Appointment slot is not available');
      } else {
        // Handle other status codes
        throw Exception('Failed to create appointment: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      throw Exception('Failed to create appointment: $e');
    }
  }

  Future<List<Review>> getReviewsByVetId(int vetId) async {
    final response = await http.get(Uri.parse('$baseUrl/review/vet/$vetId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Review> reviews = jsonList.map((json) => Review(
        firstName: json['firstName'],
        lastName: json['lastName'],
        rating: json['rating'],
        comment: json['comment'],
        date: DateTime.parse(json['date']),
      )).toList();
      return reviews;
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<List<Appointment>> fetchAppointmentsbyVetid(vetId) async {
    final response = await http.get(Uri.parse('$baseUrl/appointment/vet/$vetId'));

    if (response.statusCode == 200) {
      List<dynamic> appointmentsJson = jsonDecode(response.body);
      return appointmentsJson.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<List<Appointment>> fetchAppointmentsbyOwnerid(OwnerId) async {
    final response = await http.get(Uri.parse('$baseUrl/appointment/owner/$OwnerId'));

    if (response.statusCode == 200) {
      List<dynamic> appointmentsJson = jsonDecode(response.body);
      return appointmentsJson.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<List<Vet_Pet>> fetchPets() async {
    final response = await http.get(Uri.parse('$baseUrl/Pet/details'));

    if (response.statusCode == 200) {
      List<dynamic> petsJson = jsonDecode(response.body);
      return petsJson.map((json) => Vet_Pet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pets');
    }
  }

  Future<List<VaccineRecord>> getAllVaccinationByPetId(int petId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/vaccination/pet/$petId'));

    if (response.statusCode == 200) {
      List<dynamic> vaccineJson = jsonDecode(response.body);
      return vaccineJson.map((json) => VaccineRecord.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vaccine records');
    }
  }


  Future<List<dynamic>> getPetsByOwnerId(int ownerId) async {
    final String endpoint = "$baseUrl/Pet/by-owner/$ownerId";
    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        // Parse the JSON data into a list
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        // Handle non-200 responses
        throw Exception(
            "Failed to load pets. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception("Error fetching pets: $e");
    }
  }



  Future<bool> createVaccination(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Vaccination'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  // Update an existing vaccination record
  Future<bool> updateVaccination(int vaccinationId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Vaccination/$vaccinationId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode >= 200 && response.statusCode <210;
  }

  // Delete a vaccination record
  Future<bool> deleteVaccination(int vaccinationId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/Vaccination/$vaccinationId'),
    );
    return response.statusCode == 204;
  }

  // Create a new medical record
  Future<bool> createMedicalRecord(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/medical-records'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  // Update an existing medical record
  Future<bool> updateMedicalRecord(int recordId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/medical-records/$recordId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode >= 200 && response.statusCode <210;
  }

  // Delete a medical record
  Future<bool> deleteMedicalRecord(int recordId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/medical-records/$recordId'),
    );
    return response.statusCode == 204;
  }

  // Retrieve all medical records for a specific pet
  Future<List<MedicalRecord>> getAllMedicalRecordsByPetId(int petId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/medical-records/pet/$petId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> recordJson = jsonDecode(response.body);
      return recordJson.map((json) => MedicalRecord.fromJson(json)).toList();
    } else {
      // Log detailed error information
      throw Exception('Failed to load medical records: Status code ${response.statusCode}, Body: ${response.body}');
    }

  }


  Future<Pet> createPet(Pet pet) async {
    final String endpoint = '$baseUrl/Pet';
    final Map<String, dynamic> petData = {
      'ownerId': pet.ownerId,
      'name': pet.name,
      'gender': pet.gender,
      'species': pet.species,
      'breed': pet.breed,
      'dob': pet.dob?.toIso8601String(),
      'image': pet.image != null ? base64Encode(pet.image!) : '',
    };

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(petData),
    );

    if (response.statusCode == 201) {
      return Pet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create pet. Status code: ${response.statusCode}');
    }
  }

  Future<bool> updatePet(int petId, Pet pet) async {
    final String endpoint = '$baseUrl/Pet/$petId';
    final Map<String, dynamic> petData = {
      'ownerId': pet.ownerId,
      'name': pet.name,
      'gender': pet.gender,
      'species': pet.species,
      'breed': pet.breed,
      'dob': pet.dob?.toIso8601String(),
      'image': pet.image != null ? base64Encode(pet.image!) : '',
    };

    final response = await http.put(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(petData),
    );

    return response.statusCode == 200;
  }

  // Create Review function
  Future<bool?> createReview(ReviewVet review) async {
    final url = Uri.parse('$baseUrl/Review'); // Adjust the endpoint if necessary
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      // Log the error message for more information
      print('Failed to post review: ${response.statusCode}');
      print('Error: ${response.body}');
      return false;
    }
  }

  Future<List<Review>> getProductReviewById(int ownerId) async {
    final response = await http.get(Uri.parse('$baseUrl/ProductReview/Product/$ownerId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Review> reviews = jsonList.map((json) => Review(
        firstName: json['firstName'],
        lastName: json['lastName'],
        rating: json['rating'],
        comment: json['comment'],
        date: DateTime.parse(json['date']),
      )).toList();
      return reviews;
    } else {
      throw Exception('Failed to load reviews');
    }
  }
  // Create Review function
  Future<bool?> createProductReview(ReviewProduct review) async {
    final url = Uri.parse('$baseUrl/ProductReview'); // Adjust the endpoint if necessary
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      // Log the error message for more information
      print('Failed to post review: ${response.statusCode}');
      print('Error: ${response.body}');
      return false;
    }
  }

  Future<Pet> getPetById(int petId) async {
    var url = Uri.parse('$baseUrl/pet/$petId');
    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return Pet.fromJson(jsonResponse); // Using the Pet.fromJson factory method
      } else {
        throw Exception('Failed to load pet with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch pet: $e');
      throw Exception('Failed to fetch pet: $e');
    }
  }

}

