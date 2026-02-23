/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/user_preference/domain/entities/bookmark_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/notice_board_default_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';

abstract class UserPreferenceLocalDataSource {
  UserPreferenceEntity getUserPreferences();
  Future<void> saveUserPreferences(UserPreferenceEntity preferences);
}

class UserPreferenceLocalDataSourceImpl
    implements UserPreferenceLocalDataSource {
  final SharedPrefsManager sharedPrefsManager;

  UserPreferenceLocalDataSourceImpl({required this.sharedPrefsManager});

  @override
  UserPreferenceEntity getUserPreferences() {
    final String noticeBoardDefault = sharedPrefsManager
            .getValue<String>(SharedPrefKeys.kNoticeBoardDefaultType) ??
        NoticeBoardDefaultType.general.value;

    final String bookmarkSort = sharedPrefsManager
            .getValue<String>(SharedPrefKeys.kBookmarkDefaultSort) ??
        BookmarkDefaultSortType.newest.value;

    final String searchResultSort = sharedPrefsManager
            .getValue<String>(SharedPrefKeys.kSearchResultDefaultSort) ??
        SearchResultDefaultSortType.rank.value;

    return UserPreferenceEntity(
      noticeBoardDefault: NoticeBoardDefaultType.fromValue(noticeBoardDefault),
      bookmarkDefaultSort: BookmarkDefaultSortType.fromValue(bookmarkSort),
      searchResultDefaultSort:
          SearchResultDefaultSortType.fromValue(searchResultSort),
    );
  }

  @override
  Future<void> saveUserPreferences(UserPreferenceEntity preferences) async {
    await sharedPrefsManager.setValue<String>(
      SharedPrefKeys.kNoticeBoardDefaultType,
      preferences.noticeBoardDefault.value,
    );

    await sharedPrefsManager.setValue<String>(
      SharedPrefKeys.kBookmarkDefaultSort,
      preferences.bookmarkDefaultSort.value,
    );

    await sharedPrefsManager.setValue<String>(
      SharedPrefKeys.kSearchResultDefaultSort,
      preferences.searchResultDefaultSort.value,
    );
  }
}
