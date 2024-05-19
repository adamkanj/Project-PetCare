import 'package:flutter/material.dart';
import 'IdProvider.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => IdProvider(),
      child: MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // This disables the debug banner
      title: 'PetCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
      },
    );
  }
}
