/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-03-01
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/constants/custom_tab_list/custom_tab_list_keys.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/college_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/graduate_school_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/major_setting_page.dart';
import 'package:inha_notice/utils/custom_tab_list_utils/custom_tab_list_utils.dart';

import '../../../../../constants/shared_pref_keys/shared_pref_keys.dart';

/// **BaseTabList**
/// 공통 기능을 모듈화한 추상 클래스입니다.
/// - 설정 페이지로 이동하는 _handleToNavigate 메서드
/// - Scrollbar + ListView (혹은 ReorderableListView) 뼈대
/// - 자식 클래스에서 buildListTile, buildListWidget을 오버라이드하여 구현
abstract class BaseCustomTabList extends StatefulWidget {
  final List<String> tabs;
  final ScrollController scrollController;

  const BaseCustomTabList({
    super.key,
    required this.tabs,
    required this.scrollController,
  });

  @override
  BaseCustomTabListState createState();
}

abstract class BaseCustomTabListState<T extends BaseCustomTabList>
    extends State<T> {
  /// 자식 클래스에서 다른 onTap 로직을 추가할 수 있도록,
  /// 설정 페이지로 이동하는 로직만 공통으로 제공
  void handleToNavigate(String tab) {
    switch (tab) {
      case CustomTabListKeys.kMajor:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const MajorSettingPage(majorKeyType: SharedPrefKeys.kMajorKey),
          ),
        );
        break;
      case CustomTabListKeys.kMajor2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const MajorSettingPage(majorKeyType: SharedPrefKeys.kMajorKey2),
          ),
        );
        break;
      case CustomTabListKeys.kMajor3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const MajorSettingPage(majorKeyType: SharedPrefKeys.kMajorKey3),
          ),
        );
        break;
      case CustomTabListKeys.kCollege:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CollegeSettingPage(),
          ),
        );
        break;
      case CustomTabListKeys.kGraduateSchool:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GraduateSchoolSettingPage(),
          ),
        );
        break;
      default:
        return;
    }
  }

  /// 탭에 따라 설정 페이지 이동 아이콘(arrow)을 표시할지 여부
  bool showArrow(String tab) => CustomTabListUtils.doesTabHaveSettingsPage(tab);

  /// 자식 클래스에서 구현해야 할 메서드
  /// - ListTile(혹은 itemBuilder)에서의 trailing UI (add/remove 버튼 등)
  Widget buildTrailing(BuildContext context, String tab, int index);

  /// 자식 클래스에서 구현해야 할 메서드
  /// - ReorderableListView 또는 일반 ListView 등을 반환
  Widget buildListWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: widget.scrollController,
      thumbVisibility: true,
      child: buildListWidget(context),
    );
  }
}
