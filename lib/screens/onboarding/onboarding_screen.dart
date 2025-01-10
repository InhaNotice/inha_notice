import 'package:flutter/material.dart';

import 'package:inha_notice/screens/bottom_navigation/bottom_nav_bar_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNavBarPage()),
      );
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/onboarding.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}