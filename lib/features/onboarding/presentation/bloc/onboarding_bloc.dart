/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-20
 */

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/notification/domain/usecases/request_initial_permission_usecase.dart';
import 'package:inha_notice/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:inha_notice/features/onboarding/presentation/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final RequestInitialPermissionUseCase requestPermissionUseCase;

  OnboardingBloc({required this.requestPermissionUseCase})
      : super(OnboardingInitial()) {
    on<LoadOnboardingEvent>(_onLoadOnboarding);
  }

  Future<void> _onLoadOnboarding(
      LoadOnboardingEvent event, Emitter<OnboardingState> emit) async {
    // 앱 시작 후 권한 요청 (최초 1회 실행)
    unawaited(requestPermissionUseCase());

    await Future.delayed(const Duration(seconds: 1));

    emit(OnboardingNavigateToMain());
  }
}
