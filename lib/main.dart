// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_app/screens/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      home: const HomeScreen(), // Rename MyHomePage to HomeScreen or match the class name you actually defined
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to your LoginScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  EmailSignUpScreen()),
            );
          },
          child: const Text("Go to Login"),
        ),
      ),
    );
  }
}
