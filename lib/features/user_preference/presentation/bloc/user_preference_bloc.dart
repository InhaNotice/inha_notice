/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';
import 'package:inha_notice/features/user_preference/domain/failures/user_preference_failure.dart';
import 'package:inha_notice/features/user_preference/domain/usecases/get_user_preference_use_case.dart';
import 'package:inha_notice/features/user_preference/domain/usecases/update_user_preference_use_case.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_event.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_state.dart';

class UserPreferenceBloc
    extends Bloc<UserPreferenceEvent, UserPreferenceState> {
  final GetUserPreferenceUseCase getUserPreferencesUseCase;
  final UpdateUserPreferenceUseCase updateUserPreferencesUseCase;

  UserPreferenceBloc({
    required this.getUserPreferencesUseCase,
    required this.updateUserPreferencesUseCase,
  }) : super(UserPreferenceInitial()) {
    on<LoadUserPreferenceEvent>(_onLoadUserPreferences);
    on<UpdateNoticeBoardDefaultEvent>(_onUpdateNoticeBoardDefault);
    on<UpdateBookmarkDefaultSortEvent>(_onUpdateBookmarkDefaultSort);
    on<UpdateSearchResultDefaultSortEvent>(_onUpdateSearchResultDefaultSort);
  }

  Future<void> _onLoadUserPreferences(
    LoadUserPreferenceEvent event,
    Emitter<UserPreferenceState> emit,
  ) async {
    emit(UserPreferenceLoading());

    final result = getUserPreferencesUseCase();

    result.fold(
      (failure) {
        final String message = failure.when(
          storage: (msg) => msg,
          unknown: (msg) => msg,
        );
        emit(UserPreferenceError(message: message));
      },
      (preferences) {
        emit(UserPreferenceLoaded(preferences: preferences));
      },
    );
  }

  Future<void> _onUpdateNoticeBoardDefault(
    UpdateNoticeBoardDefaultEvent event,
    Emitter<UserPreferenceState> emit,
  ) async {
    if (state is UserPreferenceLoaded) {
      final UserPreferenceLoaded currentState = state as UserPreferenceLoaded;
      final UserPreferenceEntity updatedPreferences = UserPreferenceEntity(
        noticeBoardDefault: event.type,
        bookmarkDefaultSort: currentState.preferences.bookmarkDefaultSort,
        searchResultDefaultSort:
            currentState.preferences.searchResultDefaultSort,
      );

      final result = await updateUserPreferencesUseCase(updatedPreferences);

      result.fold(
        (failure) {
          final String message = failure.when(
            storage: (msg) => msg,
            unknown: (msg) => msg,
          );
          emit(UserPreferenceError(message: message));
        },
        (preferences) {
          emit(UserPreferenceLoaded(preferences: preferences));
        },
      );
    }
  }

  Future<void> _onUpdateBookmarkDefaultSort(
    UpdateBookmarkDefaultSortEvent event,
    Emitter<UserPreferenceState> emit,
  ) async {
    if (state is UserPreferenceLoaded) {
      final UserPreferenceLoaded currentState = state as UserPreferenceLoaded;
      final UserPreferenceEntity updatedPreferences = UserPreferenceEntity(
        noticeBoardDefault: currentState.preferences.noticeBoardDefault,
        bookmarkDefaultSort: event.type,
        searchResultDefaultSort:
            currentState.preferences.searchResultDefaultSort,
      );

      final result = await updateUserPreferencesUseCase(updatedPreferences);

      result.fold(
        (failure) {
          final String message = failure.when(
            storage: (msg) => msg,
            unknown: (msg) => msg,
          );
          emit(UserPreferenceError(message: message));
        },
        (preferences) {
          emit(UserPreferenceLoaded(preferences: preferences));
        },
      );
    }
  }

  Future<void> _onUpdateSearchResultDefaultSort(
    UpdateSearchResultDefaultSortEvent event,
    Emitter<UserPreferenceState> emit,
  ) async {
    if (state is UserPreferenceLoaded) {
      final UserPreferenceLoaded currentState = state as UserPreferenceLoaded;
      final UserPreferenceEntity updatedPreferences = UserPreferenceEntity(
        noticeBoardDefault: currentState.preferences.noticeBoardDefault,
        bookmarkDefaultSort: currentState.preferences.bookmarkDefaultSort,
        searchResultDefaultSort: event.type,
      );

      final result = await updateUserPreferencesUseCase(updatedPreferences);

      result.fold(
        (failure) {
          final String message = failure.when(
            storage: (msg) => msg,
            unknown: (msg) => msg,
          );
          emit(UserPreferenceError(message: message));
        },
        (preferences) {
          emit(UserPreferenceLoaded(preferences: preferences));
        },
      );
    }
  }
}
