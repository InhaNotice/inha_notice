/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-25
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/font/fonts.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/base_setting_page.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/utils/university_utils/college_utils.dart';
import 'package:inha_notice/widgets/dialogs/blocking_dialog.dart';
import 'package:inha_notice/widgets/snack_bars/themed_snack_bar.dart';
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
  final List<String> _allItems = CollegeUtils.kCollegeKeyList;
  List<String> _filteredItems = [];
  String? _collegeKey;
  String? _collegeValue;

  @override
  String get appBarTitle => '단과대 설정';

  @override
  String get searchLabel => '단과대 검색';

  @override
  String get settingType => '단과대';

  @override
  String? get currentSetting => _collegeKey;

  @override
  void initState() {
    super.initState();
    loadPreference();
  }

  @override
  Future<void> loadPreference() async {
    setState(() {
      _collegeValue =
          SharedPrefsManager().getPreference(SharedPrefKeys.kCollegeKey);
      if (_collegeValue != null) {
        _collegeKey = CollegeUtils.kCollegeMappingOnValue[_collegeValue];
      }
      _filteredItems = _allItems;
    });
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
          title: Text(item,
              style: TextStyle(fontFamily: Fonts.kDefaultFont, fontSize: 18)),
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
    String? newCollegeValue = CollegeUtils.kCollegeMappingOnKey[item];

    // 이미 설정된 값과 동일하면 경고
    if (_collegeValue != null && _collegeValue == newCollegeValue) {
      if (mounted) {
        ThemedSnackBar.warnSnackBar(context, '이미 설정되어있습니다.');
      }
      return;
    }

    setState(() {
      isProcessing = true;
      BlockingDialog.show(context);
    });

    try {
      await SharedPrefsManager()
          .setPreference(SharedPrefKeys.kCollegeKey, newCollegeValue);

      if (mounted) {
        ThemedSnackBar.succeedSnackBar(context, '$item로 설정되었습니다!');
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      logger.e('❌ Error saving college: $e');
      if (mounted) {
        ThemedSnackBar.failSnackBar(context, '저장 중 오류가 발생했습니다. 다시 시도해주세요!');
      }
    } finally {
      if (mounted) BlockingDialog.dismiss(context);
      setState(() {
        isProcessing = false;
      });
    }
  }
}
