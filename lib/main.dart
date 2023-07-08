import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/registrationscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFABCDEF), // Tranquil blue
        accentColor: Color(0xFF88CC99), // Calming green
        // Other theme properties
      ),
      home: RegistrationScreen(),
    );
  }
}
