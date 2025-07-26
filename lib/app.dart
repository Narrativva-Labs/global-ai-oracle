// lib/app.dart
// Defines the root MaterialApp widget and sets up the app's theme and routing.

import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global AI Oracle',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueGrey,
          secondary: Colors.teal,
        ),
      ),
      home: const DashboardPage(),
    );
  }
}