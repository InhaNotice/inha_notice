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
import 'package:inha_notice/core/theme/theme.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/base_setting_page.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/utils/university_utils/major_utils.dart';
import 'package:inha_notice/widgets/dialogs/blocking_dialog.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snack_bar.dart';
import 'package:logger/logger.dart';

class MajorSettingPage extends BaseSettingPage {
  final String majorKeyType;

  const MajorSettingPage({super.key, required this.majorKeyType});

  @override
  State<MajorSettingPage> createState() => _MajorSettingPageState();
}

class _MajorSettingPageState extends BaseSettingPageState<MajorSettingPage> {
  final Logger logger = Logger();

  // 학과 데이터: 그룹별 매핑 (국문:영문)
  final Map<String, Map<String, String>> _allMajorGroups =
      MajorUtils.majorGroups;
  Map<String, Map<String, String>> _filteredMajorGroups =
      MajorUtils.majorGroups;
  List<String> _filteredMajors = [];
  String? _currentMajor;
  String? _currentMajorKey;

  @override
  String get appBarTitle => '학과 설정';

  @override
  String get searchLabel => '학과 검색';

  @override
  String get settingType => '학과';

  @override
  String? get currentSetting => _currentMajor;

  @override
  void initState() {
    super.initState();
    loadPreference();
  }

  @override
  Future<void> loadPreference() async {
    setState(() {
      _currentMajorKey =
          SharedPrefsManager().getPreference(widget.majorKeyType);
      if (_currentMajorKey != null) {
        _currentMajor = MajorUtils.kMajorMappingOnValue[_currentMajorKey];
      }
      _filteredMajorGroups = _allMajorGroups;
      _filteredMajors = [];
    });
  }

  @override
  void filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredMajorGroups = _allMajorGroups;
        _filteredMajors = [];
      });
      return;
    }
    final List<String> filtered = [
      for (var group in _allMajorGroups.values)
        for (var major in group.keys)
          if (major.contains(query)) major,
    ];
    setState(() {
      _filteredMajorGroups = {}; // 검색 시 그룹 목록은 비움
      _filteredMajors = filtered;
    });
  }

  @override
  Widget buildListView() {
    if (_filteredMajors.isNotEmpty) {
      return ListView.builder(
        itemCount: _filteredMajors.length,
        itemBuilder: (context, index) {
          final major = _filteredMajors[index];
          return ListTile(
            title: Text(major,
                style: TextStyle(fontFamily: Fonts.kDefaultFont, fontSize: 18)),
            onTap: () async {
              await handleSelection(major);
            },
          );
        },
      );
    } else {
      return ListView(
        children: _filteredMajorGroups.entries.map((entry) {
          return Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              title: Text(
                entry.key,
                style: TextStyle(
                  fontFamily: Fonts.kDefaultFont,
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      Theme.of(context).defaultThemedTextColor,
                ),
              ),
              children: entry.value.keys.map((major) {
                return ListTile(
                  title: Text(major,
                      style: TextStyle(
                          fontFamily: Fonts.kDefaultFont, fontSize: 18)),
                  onTap: () async {
                    await handleSelection(major);
                  },
                );
              }).toList(),
            ),
          );
        }).toList(),
      );
    }
  }

  @override
  Future<void> handleSelection(String item) async {
    if (isProcessing) return;
    String? newMajorKey = MajorUtils.kMajorMappingOnKey[item];
    if (_currentMajorKey != null && _currentMajorKey == newMajorKey) {
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
      await SharedPrefsManager().setMajorPreference(
          _currentMajorKey, newMajorKey!, widget.majorKeyType);
      if (mounted) {
        ThemedSnackBar.succeedSnackBar(context, '$item로 설정되었습니다!');
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      logger.e('❌ Error saving major: $e');
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
