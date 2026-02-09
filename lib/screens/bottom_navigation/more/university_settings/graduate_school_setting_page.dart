/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/utils/blocking_dialog.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/notice/domain/entities/graduate_school_type.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/base_setting_page.dart';
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

  final List<String> _names = GraduateSchoolType.graduateSchoolNameList;
  List<String> _filteredNames = [];
  String? _graduateSchoolName;
  String? _graduateSchoolKey;

  @override
  String get appBarTitle => '대학원 설정';

  @override
  String get searchLabel => '대학원 검색';

  @override
  String get settingType => '대학원';

  @override
  String? get currentSetting => _graduateSchoolName;

  @override
  void initState() {
    super.initState();
    loadPreference();
  }

  @override
  Future<void> loadPreference() async {
    setState(() {
      _graduateSchoolKey = di
          .sl<SharedPrefsManager>()
          .getValue<String>(SharedPrefKeys.kGraduateSchoolKey);
      if (_graduateSchoolKey != null) {
        _graduateSchoolName =
            GraduateSchoolType.graduateSchoolMappingOnKey[_graduateSchoolKey];
      }
      _filteredNames = _names;
    });
  }

  @override
  void filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredNames = _names;
      });
      return;
    }
    final filtered = _names.where((item) => item.contains(query)).toList();
    setState(() {
      _filteredNames = filtered;
    });
  }

  @override
  Widget buildListView() {
    return ListView.builder(
      itemCount: _filteredNames.length,
      itemBuilder: (context, index) {
        final item = _filteredNames[index];
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
    String? newGraduateSchoolKey =
        GraduateSchoolType.graduateSchoolMappingOnName[item];

    if (_graduateSchoolKey != null &&
        _graduateSchoolKey == newGraduateSchoolKey) {
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
      await di.sl<SharedPrefsManager>().setValue<String>(
          SharedPrefKeys.kGraduateSchoolKey, newGraduateSchoolKey!);
      if (mounted) {
        AppSnackBar.success(context, '$item로 설정되었습니다!');
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      logger.e('❌ Error saving graduateSchool: $e');
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
