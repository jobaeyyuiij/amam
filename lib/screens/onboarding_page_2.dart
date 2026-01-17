import 'package:flutter/material.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Illustration
              Image.asset(
                'images/2.png',
                width: 280,
                height: 280,
              ),
              const SizedBox(height: 60),
              // Title
              const Text(
                'حماية وأمان عالي',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // Description
              const Text(
                'يتم تأكيد استلام كل رسالة\nمن خلال رمز تحقق (OTP) لضمان الموثوقية',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPageIndicator(false),
                  const SizedBox(width: 8),
                  _buildPageIndicator(true),
                  const SizedBox(width: 8),
                  _buildPageIndicator(false),
                ],
              ),
              const SizedBox(height: 32),
              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to page 3
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DB6AC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'التالي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Skip button
              TextButton(
                onPressed: () {
                  // TODO: Navigate to main app
                },
                child: const Text(
                  'تخطي',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return Container(
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFFC107) : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
