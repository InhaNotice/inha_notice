/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-27
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inha_notice/constants/shared_pref_keys/shared_pref_keys.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/more/custom_tab_bar_page/custom_tab_bar_page_widgets/custom_tab_available_list.dart';
import 'package:inha_notice/screens/bottom_navigation/more/custom_tab_bar_page/custom_tab_bar_page_widgets/custom_tab_preview.dart';
import 'package:inha_notice/screens/bottom_navigation/more/custom_tab_bar_page/custom_tab_bar_page_widgets/custom_tab_save_button.dart';
import 'package:inha_notice/screens/bottom_navigation/more/custom_tab_bar_page/custom_tab_bar_page_widgets/custom_tab_selected_list.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/custom_tab_list_utils/custom_tab_list_utils.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_action_app_bar.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snack_bar.dart';

/// **CustomTabBarPage**
/// 사용자는 나만의 탭 구성으로 원하는 공지사항을 볼 수 있습니다.
///
/// ### 주요 기능:
/// - 최소 1개부터 최대 7개까지의 탭 구성 가능
class CustomTabBarPage extends StatefulWidget {
  const CustomTabBarPage({super.key});

  @override
  State<CustomTabBarPage> createState() => _CustomTabBarPageState();
}

class _CustomTabBarPageState extends State<CustomTabBarPage> {
  final ScrollController _selectedTabsScrollController = ScrollController();

  /// 사용자가 선택한 탭 목록
  late List<String> selectedTabs;

  /// 처음 로드한 탭 목록을 저장하여 변경 여부를 판단
  late List<String> _initialTabs;

  @override
  void initState() {
    super.initState();
    loadTabs();
  }

  Future<void> loadTabs() async {
    final List<String>? savedTabs =
        SharedPrefsManager().getPreference(SharedPrefKeys.kCustomTabList);
    if (savedTabs == null || savedTabs.isEmpty) {
      selectedTabs = List.from(CustomTabListUtils.kDefaultTabs);
    } else {
      selectedTabs = List.from(savedTabs);
    }
    // 원본 리스트 복사
    _initialTabs = List.from(selectedTabs);
    setState(() {});
  }

  /// 선택되지 않은 탭 옵션
  List<String> get availableTabs {
    final allTabs = {
      ...CustomTabListUtils.kAdditionalTabs,
      ...CustomTabListUtils.kDefaultTabs,
    }.toList();
    // 선택되지 않은 탭 반환
    return allTabs.where((tab) => !selectedTabs.contains(tab)).toList();
  }

  Future<void> saveTabs() async {
    await SharedPrefsManager()
        .setPreference(SharedPrefKeys.kCustomTabList, selectedTabs);
    // 저장 후 원본 리스트 업데이트
    _initialTabs = List.from(selectedTabs);
  }

  /// 초기 선택 목록과 현재 목록을 비교하여 변경사항이 있으면 true
  bool get hasChanges => !listEquals(selectedTabs, _initialTabs);

  Future<void> _handleSaveTabs() async {
    try {
      await saveTabs();
      if (mounted) {
        ThemedSnackBar.succeedSnackBar(context, '저장되었어요.');
      }
      setState(() {}); // 상태 갱신
    } catch (e) {
      if (mounted) {
        ThemedSnackBar.failSnackBar(context, '문제가 발생하였어요.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedActionAppBar(
        title: '나만의 탭 설정',
        titleSize: 20,
        isCenter: true,
        actionWidget: CustomTabSaveButton(
          hasChanges: hasChanges,
          onSave: _handleSaveTabs,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTabPreview(selectedTabs: selectedTabs),
            const SizedBox(height: 16),
            Text(
              '나만의 탭 설정으로 원하는 공지사항만 골라보세요!',
              style: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).defaultThemedTextColor),
            ),
            const SizedBox(height: 4),
            Text(
              '최소 1개부터 최대 7개까지 설정할 수 있어요!',
              style: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).defaultThemedTextColor),
            ),
            const SizedBox(height: 16),
            Text(
              '선택된 탭: ${selectedTabs.length}개',
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomTabSelectedList(
                  selectedTabs: selectedTabs,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final String item = selectedTabs.removeAt(oldIndex);
                      selectedTabs.insert(newIndex, item);
                    });
                  },
                  onRemove: (index) {
                    if (selectedTabs.length > 1) {
                      setState(() {
                        selectedTabs.removeAt(index);
                      });
                    } else {
                      ThemedSnackBar.warnSnackBar(context, '최소 하나는 선택해야 해요.');
                    }
                  },
                  scrollController: _selectedTabsScrollController,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '추가 가능한 탭: ${availableTabs.length}개',
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomTabAvailableList(
                  availableTabs: availableTabs,
                  onAdd: (tab) {
                    if (selectedTabs.length < 7) {
                      setState(() {
                        selectedTabs.add(tab);
                      });
                    } else {
                      ThemedSnackBar.warnSnackBar(context, '최대 개수를 넘어갈 수 없어요.');
                    }
                  },
                  scrollController: _selectedTabsScrollController,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
