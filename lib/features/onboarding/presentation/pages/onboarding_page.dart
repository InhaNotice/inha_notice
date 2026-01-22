/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-22
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/features/main_navigation/presentation/pages/main_navigation_page.dart';
import 'package:inha_notice/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:inha_notice/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:inha_notice/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:inha_notice/injection_container.dart' as di;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<OnboardingBloc>()..add(LoadOnboardingEvent()),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingNavigateToMain) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const MainNavigationPage()),
            );
          }
        },
        // 상태와 무관하게 '인하공지' 로고는 항상 렌더링
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: _buildOnboardingContent(context),
        ),
      ),
    );
  }

  Widget _buildOnboardingContent(BuildContext context) {
    return Center(
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
    );
  }
}
