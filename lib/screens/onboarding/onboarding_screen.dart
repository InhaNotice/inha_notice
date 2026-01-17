/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:inha_notice/screens/bottom_navigation/bottom_nav_bar_page.dart';

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
      if (Platform.isIOS) {
        // 백그라운드 진행
        FirebaseService().requestPermission();
      }
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
                  TextSpan(
                    text: '인',
                    style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '하',
                    style: TextStyle(
                        fontFamily: AppFont.pretendard.family,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultThemedTextColor),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '공',
                    style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '지',
                    style: TextStyle(
                        fontFamily: AppFont.pretendard.family,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultThemedTextColor),
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
