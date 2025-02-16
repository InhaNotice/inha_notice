import 'package:flutter/material.dart';
import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/bottom_nav_bar_page.dart';
import 'package:inha_notice/themes/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();

    // 앱 시작 후 권한 요청 (최초 1회 실행)
    Future.delayed(Duration.zero, () {
      FirebaseService().requestPermission();
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNavBarPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '인',
                    style: TextStyle(
                      fontFamily: Font.kDefaultFont,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '하',
                    style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultColor),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '공',
                    style: TextStyle(
                      fontFamily: Font.kDefaultFont,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '지',
                    style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
