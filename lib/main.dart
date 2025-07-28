import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
void main() {
  runApp(const LikhaApp());
}

class LikhaApp extends StatelessWidget {
  const LikhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LIKHA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF2C2F38),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: const WelcomeScreen(), 
    );
  }
}
