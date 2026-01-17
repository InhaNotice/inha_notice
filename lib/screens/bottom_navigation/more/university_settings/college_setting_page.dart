/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/keys/college_type.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/utils/blocking_dialog.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/base_setting_page.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:logger/logger.dart';

class CollegeSettingPage extends BaseSettingPage {
  const CollegeSettingPage({super.key});

  @override
  State<CollegeSettingPage> createState() => _CollegeSettingPageState();
}

class _CollegeSettingPageState
    extends BaseSettingPageState<CollegeSettingPage> {
  final Logger logger = Logger();

  // 데이터 원본: 단과대 키 리스트 (국문)와 매핑 (영문)
  final List<String> _allItems = CollegeType.names;
  List<String> _filteredItems = [];
  String? _collegeName;
  String? _collegeKey;

  @override
  String get appBarTitle => '단과대 설정';

  @override
  String get searchLabel => '단과대 검색';

  @override
  String get settingType => '단과대';

  @override
  String? get currentSetting => _collegeName;

  @override
  void initState() {
    super.initState();
    loadPreference();
  }

  @override
  Future<void> loadPreference() async {
    final String? savedKey =
        SharedPrefsManager().getValue<String>(SharedPrefKeys.kCollegeKey);

    String? convertedName;
    if (savedKey != null) {
      convertedName = CollegeType.getByKey(savedKey).name;
    }

    if (mounted) {
      setState(() {
        _collegeKey = savedKey; // 영어 키 저장
        _collegeName = convertedName; // 한글 이름 저장
        _filteredItems = _allItems; // 필터 초기화
      });
    }
  }

  @override
  void filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = _allItems;
      });
      return;
    }
    final filtered = _allItems.where((item) => item.contains(query)).toList();
    setState(() {
      _filteredItems = filtered;
    });
  }

  @override
  Widget buildListView() {
    return ListView.builder(
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return ListTile(
          title: Text(
            item,
            style: TextStyle(
              fontFamily: AppFont.pretendard.family,
              fontSize: 18,
            ),
          ),
          onTap: () async {
            await handleSelection(item);
          },
        );
      },
    );
  }

  @override
  Future<void> handleSelection(String item) async {
    if (isProcessing) return;
    String? newCollegeKey = CollegeType.getByName(item).key;

    // 이미 설정된 값과 동일하면 경고
    if (_collegeKey != null && _collegeKey == newCollegeKey) {
      if (mounted) {
        AppSnackBar.warn(context, '이미 설정되어있습니다.');
      }
      return;
    }

    setState(() {
      isProcessing = true;
      BlockingDialog.show(context);
    });

    try {
      await SharedPrefsManager()
          .setValue<String>(SharedPrefKeys.kCollegeKey, newCollegeKey);

      if (mounted) {
        AppSnackBar.success(context, '$item로 설정되었습니다!');
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      logger.e('❌ Error saving college: $e');
      if (mounted) {
        AppSnackBar.error(context, '저장 중 오류가 발생했습니다. 다시 시도해주세요!');
      }
    } finally {
      if (mounted) BlockingDialog.dismiss(context);
      setState(() {
        isProcessing = false;
      });
    }
  }
}
