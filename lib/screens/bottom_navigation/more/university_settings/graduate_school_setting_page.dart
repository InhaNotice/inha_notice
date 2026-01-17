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
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/presentation/widgets/themed_snack_bar_widget.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/base_setting_page.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/utils/university_utils/graduate_school_utils.dart';
import 'package:inha_notice/widgets/dialogs/blocking_dialog.dart';
import 'package:logger/logger.dart';

class GraduateSchoolSettingPage extends BaseSettingPage {
  const GraduateSchoolSettingPage({super.key});

  @override
  State<GraduateSchoolSettingPage> createState() =>
      _GraduateSchoolSettingPageState();
}

class _GraduateSchoolSettingPageState
    extends BaseSettingPageState<GraduateSchoolSettingPage> {
  final Logger logger = Logger();

  final List<String> _allItems = GraduateSchoolUtils.kGraduateSchoolKeyList;
  List<String> _filteredItems = [];
  String? _graduateSchoolKey;
  String? _graduateSchoolValue;

  @override
  String get appBarTitle => '대학원 설정';

  @override
  String get searchLabel => '대학원 검색';

  @override
  String get settingType => '대학원';

  @override
  String? get currentSetting => _graduateSchoolKey;

  @override
  void initState() {
    super.initState();
    loadPreference();
  }

  @override
  Future<void> loadPreference() async {
    setState(() {
      _graduateSchoolValue =
          SharedPrefsManager().getPreference(SharedPrefKeys.kGraduateSchoolKey);
      if (_graduateSchoolValue != null) {
        _graduateSchoolKey = GraduateSchoolUtils
            .kGraduateSchoolMappingOnValue[_graduateSchoolValue];
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
    String? newGraduateSchoolValue =
        GraduateSchoolUtils.kGraduateSchoolMappingOnKey[item];

    if (_graduateSchoolValue != null &&
        _graduateSchoolValue == newGraduateSchoolValue) {
      if (mounted) {
        ThemedSnackBarWidget.warnSnackBar(context, '이미 설정되어있습니다.');
      }
      return;
    }

    setState(() {
      isProcessing = true;
      BlockingDialog.show(context);
    });

    try {
      await SharedPrefsManager().setPreference(
          SharedPrefKeys.kGraduateSchoolKey, newGraduateSchoolValue);
      if (mounted) {
        ThemedSnackBarWidget.succeedSnackBar(context, '$item로 설정되었습니다!');
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      logger.e('❌ Error saving graduateSchool: $e');
      if (mounted) {
        ThemedSnackBarWidget.failSnackBar(
            context, '저장 중 오류가 발생했습니다. 다시 시도해주세요!');
      }
    } finally {
      if (mounted) BlockingDialog.dismiss(context);
      setState(() {
        isProcessing = false;
      });
    }
  }
}
