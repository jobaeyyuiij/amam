import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'onboarding_page_1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Hide status bar for fullscreen splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Restore status bar
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingPage1()),
        );
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'images/splash.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
