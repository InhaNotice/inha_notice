/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_policy.dart';
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_type.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_major_display_name_use_case.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_user_setting_value_by_notice_type_use_case.dart';
import 'package:inha_notice/features/notice/data/models/home_tab_model.dart';

abstract class HomeLocalDataSource {
  Future<List<HomeTabModel>> fetchHomeTabs();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final SharedPrefsManager sharedPrefsManager;
  final GetUserSettingValueByNoticeTypeUseCase
      getUserSettingValueByNoticeTypeUseCase;
  final GetMajorDisplayNameUseCase getMajorDisplayNameUseCase;

  HomeLocalDataSourceImpl(
    this.sharedPrefsManager, {
    required this.getUserSettingValueByNoticeTypeUseCase,
    required this.getMajorDisplayNameUseCase,
  });
  @override
  Future<List<HomeTabModel>> fetchHomeTabs() async {
    try {
      // 1. SharedPrefs에서 저장된 탭 키 리스트 가져오기
      final List<String>? savedTabs = sharedPrefsManager
          .getValue<List<String>>(SharedPrefKeys.kCustomTabList);

      late List<String> selectedTabs;
      if (savedTabs == null || savedTabs.isEmpty) {
        selectedTabs = CustomTabPolicy.kDefaultTabs;
      } else {
        selectedTabs = List.from(savedTabs);
      }

      // 2. 키를 이용해 Model 리스트 생성
      return selectedTabs.map((tabName) {
        final noticeType = CustomTabType.kTabMappingOnKey[tabName]!;
        final displayName = _resolveTabName(noticeType);

        return HomeTabModel(
          noticeType: noticeType,
          label: displayName,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load home tabs');
    }
  }

  String _resolveTabName(String noticeType) {
    if (!CustomTabType.isMajorTypeOf(noticeType)) {
      return CustomTabType.kTabMappingOnValue[noticeType]!;
    }
    final userSettingKey = getUserSettingValueByNoticeTypeUseCase(noticeType);
    if (userSettingKey == null) {
      return CustomTabType.kTabMappingOnValue[noticeType]!;
    }
    return getMajorDisplayNameUseCase(userSettingKey);
  }
}
