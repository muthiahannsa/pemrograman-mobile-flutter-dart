import 'package:flutter/material.dart';

import 'ui/screens/country_screen.dart';

void main() {
  runApp(const CountryExplorerApp());
}

class CountryExplorerApp extends StatelessWidget {
  const CountryExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C8FF0), brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF0B1220),
      ),
      home: const CountryScreen(),
    );
  }
}
