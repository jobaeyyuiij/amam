import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FilterApp());
}

class FilterApp extends StatelessWidget {
  const FilterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'اعمام',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Cairo',
      ),
      // Set RTL text direction for Arabic
      locale: const Locale('ar', 'IQ'),
      home: const SplashScreen(),
    );
  }
}
