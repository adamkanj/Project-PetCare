class PetOwner {
  final int? ownerId;
  final int? userId;
  final String firstName;
  final String lastName;

  final String email;
  final String username;
  final String? password;

  final String address;
  final String dateOfBirth;
  final String gender;
  final String? role;

  PetOwner({
    this.ownerId,
    this.userId,
    this.role,
    required this.address,
    required this.username,
    required this.email,
    this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,

  });

  factory PetOwner.fromJson(Map<String, dynamic> json) {
    return PetOwner(
      ownerId: json['ownerId'],
      userId: json['userId'],
      address: json['address'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      firstName: json['fn'],
      lastName: json['ln'],
      dateOfBirth: json['dob'],
      gender: json['gender'],
      role: json['role'],
    );
  }
}
