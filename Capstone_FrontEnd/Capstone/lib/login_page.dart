import 'package:flutter/material.dart';
import 'Admin/home.dart';
import 'ApiHandler.dart';
import 'Pet Owner/pet_home_page.dart';
import 'Vet/home_page.dart'; // Import the home page
import 'package:intl/intl.dart'; // Add this line at the top for date formatting

import 'package:provider/provider.dart';
import 'IdProvider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiHandler apiHandler = ApiHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/PetCare_transparent.png',
                width: 300, // Adjusted image size
                height: 300,
              ),// Add your logo image at the top of the login page
              SizedBox(height: 10), // Space between the logo and the login title

              Text(
                'Login',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Check for empty fields first
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Email and password cannot be empty."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return; // Stop further execution
                  }

                  try {
                    List<String>? loginResult = await apiHandler.login(emailController.text, passwordController.text);

                    if (loginResult != null && loginResult.length == 2) {
                      // Assuming role-based navigation, adapt as necessary
                      String role = loginResult[0];
                      int id = int.parse(loginResult[1]);

                      // Set the user ID in the IdProvider
                      Provider.of<IdProvider>(context, listen: false).setId(id);

                      if (role == 'PetOwner') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else if (role == 'Admin') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ManageSystemScreen()),
                        );
                      }
                      else if (role == 'Veterinarian') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      }
                    } else {
                      // Login failed due to incorrect credentials
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Login Failed"),
                          content: Text("Incorrect email or password."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("Try Again"),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    // Handle error case
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Error"),
                        content: Text("An error occurred: $e"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Add functionality for password recovery
                },
                child: Text('Forgot password?'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the signup page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text('Create an Account'),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  DateTime? dateOfBirth;
  String? gender = 'Male'; // Default gender

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Sign Up', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              SizedBox(height: 20),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dateOfBirth ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != dateOfBirth) {
                    setState(() {
                      dateOfBirth = picked;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: dateOfBirth == null ? 'Date of Birth' : DateFormat('yyyy-MM-dd').format(dateOfBirth!),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: <Widget>[
                  RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (passwordController.text != confirmPasswordController.text) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Passwords do not match."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  if (firstNameController.text.isEmpty || lastNameController.text.isEmpty || emailController.text.isEmpty ||
                      usernameController.text.isEmpty || passwordController.text.isEmpty || addressController.text.isEmpty ||
                      dateOfBirth == null || gender == null) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Error"),
                        content: Text("All fields must be filled."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  // Define petOwnerData using the input values
                  Map<String, dynamic> petOwnerData = {
                    'ownerId': 0,     // Assuming ownerId is auto-generated and you must send a default value like 0
                    'userId': 0,      // Similarly for userId, send a default or expected value
                    'address': addressController.text,
                    'username': usernameController.text,
                    'password': passwordController.text,
                    'email': emailController.text,
                    'fn': firstNameController.text,
                    'ln': lastNameController.text,
                    'dob': DateFormat('yyyy-MM-dd').format(dateOfBirth!), // Ensure date is formatted correctly
                    'gender': gender,
                    'role': 'PetOwner'  // Assuming 'role' is set to 'PetOwner' as default or based on some condition
                  };


                  bool success = await ApiHandler().createPetOwner(petOwnerData);
                  if (success) {
                    // Navigate to home page or show a success message
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),  // Adjust as necessary
                    );
                  } else {
                    // Show error dialog
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Signup Failed"),
                        content: Text("Unable to create account, please try again."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }

                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
