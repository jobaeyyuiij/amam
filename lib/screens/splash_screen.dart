import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'onboarding_screen.dart';
import 'main_container.dart';
import '../services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Hide status bar for fullscreen splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Wait for splash screen display
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    // Check if user is already logged in
    final token = await _apiService.getToken();
    
    // Restore status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    if (token != null && token.isNotEmpty) {
      // User is logged in, go to main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainContainer()),
      );
    } else {
      // User is not logged in, show onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
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
