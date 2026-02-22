/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/user_preference/data/datasources/user_preference_local_data_source.dart';
import 'package:inha_notice/features/user_preference/domain/entities/bookmark_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/notice_board_default_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';

class _FakeSharedPrefsManager implements SharedPrefsManager {
  final Map<String, dynamic> _storage = {};

  @override
  T? getValue<T>(String key) {
    return _storage[key] as T?;
  }

  @override
  Future<void> setValue<T>(String key, T value) async {
    _storage[key] = value;
  }

  Future<bool> remove(String key) async {
    _storage.remove(key);
    return true;
  }

  Future<bool> clear() async {
    _storage.clear();
    return true;
  }

  bool containsKey(String key) {
    return _storage.containsKey(key);
  }

  Set<String> getKeys() {
    return _storage.keys.toSet();
  }

  @override
  Future<void> initialize() async {
    // Fake implementation - no-op
  }

  @override
  Future<void> loadPreferences() async {
    // Fake implementation - no-op
  }

  @override
  Future<void> setMajorPreference(
    String? currentMajorKey,
    String newMajorKey,
    String majorKeyType,
  ) async {
    // Fake implementation - no-op
  }
}

void main() {
  group('UserPreferenceLocalDataSourceImpl 테스트', () {
    late _FakeSharedPrefsManager sharedPrefsManager;
    late UserPreferenceLocalDataSourceImpl dataSource;

    setUp(() {
      sharedPrefsManager = _FakeSharedPrefsManager();
      dataSource = UserPreferenceLocalDataSourceImpl(
        sharedPrefsManager: sharedPrefsManager,
      );
    });

    group('getUserPreferences', () {
      test('저장된 값이 없을 때 기본값 반환', () {
        // Act
        final result = dataSource.getUserPreferences();

        // Assert
        expect(result.noticeBoardDefault, NoticeBoardDefaultType.general);
        expect(result.bookmarkDefaultSort, BookmarkDefaultSortType.newest);
        expect(
            result.searchResultDefaultSort, SearchResultDefaultSortType.rank);
      });

      test('저장된 값이 있을 때 해당 값 반환', () async {
        // Arrange
        await sharedPrefsManager.setValue<String>(
          SharedPrefKeys.kNoticeBoardDefaultType,
          NoticeBoardDefaultType.headline.value,
        );
        await sharedPrefsManager.setValue<String>(
          SharedPrefKeys.kBookmarkDefaultSort,
          BookmarkDefaultSortType.oldest.value,
        );
        await sharedPrefsManager.setValue<String>(
          SharedPrefKeys.kSearchResultDefaultSort,
          SearchResultDefaultSortType.date.value,
        );

        // Act
        final result = dataSource.getUserPreferences();

        // Assert
        expect(result.noticeBoardDefault, NoticeBoardDefaultType.headline);
        expect(result.bookmarkDefaultSort, BookmarkDefaultSortType.oldest);
        expect(
            result.searchResultDefaultSort, SearchResultDefaultSortType.date);
      });

      test('잘못된 값이 저장되어 있을 때 기본값 반환', () async {
        // Arrange
        await sharedPrefsManager.setValue<String>(
          SharedPrefKeys.kNoticeBoardDefaultType,
          'invalid_value',
        );
        await sharedPrefsManager.setValue<String>(
          SharedPrefKeys.kBookmarkDefaultSort,
          'invalid_value',
        );
        await sharedPrefsManager.setValue<String>(
          SharedPrefKeys.kSearchResultDefaultSort,
          'invalid_value',
        );

        // Act
        final result = dataSource.getUserPreferences();

        // Assert - fromValue에서 orElse로 기본값 반환
        expect(result.noticeBoardDefault, NoticeBoardDefaultType.general);
        expect(result.bookmarkDefaultSort, BookmarkDefaultSortType.newest);
        expect(
            result.searchResultDefaultSort, SearchResultDefaultSortType.rank);
      });
    });

    group('saveUserPreferences', () {
      test('사용자 설정을 SharedPreferences에 저장', () async {
        // Arrange
        const preferences = UserPreferenceEntity(
          noticeBoardDefault: NoticeBoardDefaultType.headline,
          bookmarkDefaultSort: BookmarkDefaultSortType.name,
          searchResultDefaultSort: SearchResultDefaultSortType.date,
        );

        // Act
        await dataSource.saveUserPreferences(preferences);

        // Assert
        final savedNoticeBoardDefault = sharedPrefsManager
            .getValue<String>(SharedPrefKeys.kNoticeBoardDefaultType);
        final savedBookmarkSort = sharedPrefsManager
            .getValue<String>(SharedPrefKeys.kBookmarkDefaultSort);
        final savedSearchResultSort = sharedPrefsManager
            .getValue<String>(SharedPrefKeys.kSearchResultDefaultSort);

        expect(savedNoticeBoardDefault, NoticeBoardDefaultType.headline.value);
        expect(savedBookmarkSort, BookmarkDefaultSortType.name.value);
        expect(savedSearchResultSort, SearchResultDefaultSortType.date.value);
      });

      test('저장 후 getUserPreferences로 확인 가능', () async {
        // Arrange
        const preferences = UserPreferenceEntity(
          noticeBoardDefault: NoticeBoardDefaultType.headline,
          bookmarkDefaultSort: BookmarkDefaultSortType.oldest,
          searchResultDefaultSort: SearchResultDefaultSortType.date,
        );

        // Act
        await dataSource.saveUserPreferences(preferences);
        final result = dataSource.getUserPreferences();

        // Assert
        expect(result.noticeBoardDefault, preferences.noticeBoardDefault);
        expect(result.bookmarkDefaultSort, preferences.bookmarkDefaultSort);
        expect(result.searchResultDefaultSort,
            preferences.searchResultDefaultSort);
      });
    });
  });
}
