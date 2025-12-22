/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-12-22
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/font/fonts.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/theme/theme.dart';
import 'package:inha_notice/screens/bottom_navigation/home/notice_board_tab.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_setting_page.dart';
import 'package:inha_notice/utils/custom_tab_list_utils/custom_tab_list_utils.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';

/// **HomePage**
/// 홈 화면을 정의합니다.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> noticeTypeTabs = [];

  @override
  void initState() {
    super.initState();
    _loadSavedTabs();
  }

  /// **저장된 나의 탭 설정 불러오기**
  Future<void> _loadSavedTabs() async {
    // 저장된 나의 탭 불러오기
    final savedTabs = SharedPrefsManager()
        .getPreference(SharedPrefKeys.kCustomTabList) as List<String>?;

    // 저장된 탭이 존재하지 않으면, 기본 탭을 사용하고
    // 존재하면, 저장된 탭을 복사해서 사용함
    late List<String> selectedTabs = [];
    if (savedTabs == null || savedTabs.isEmpty) {
      selectedTabs = CustomTabListUtils.kDefaultTabs;
    } else {
      selectedTabs = List.from(savedTabs);
    }

    // 불러온 탭을 바탕으로 noticeType으로 변환하여 탭을 저장함
    noticeTypeTabs = selectedTabs
        .map((tabName) => CustomTabListUtils.kTabMappingOnKey[tabName]!)
        .toList();
  }

  String _loadTabName(String noticeType) {
    // noticeType이 학과 타입이 아니면(예: WHOLE, SWUNIV, LIBRARY 등), noticeType을 국문 탭 이름(예: 학사, SW중심대학사업단, 정석 등)으로 번역해서 반환
    if (!CustomTabListUtils.isMajorType(noticeType)) {
      return CustomTabListUtils.kTabMappingOnValue[noticeType]!;
    }

    // 학과 타입(예: MAJOR, MAJOR2, MAJOR3)이면, 유저의 설정 값(예: EES, MATH, CSE 등)를 불러옴
    final userSettingKey = CustomTabListUtils.loadUserSettingKey(noticeType);

    // 아직 유저가 학과 설정을 하지 않았다면 기본 탭 이름(예: 학과, 학과2, 학과3)을 반환
    if (userSettingKey == null) {
      return CustomTabListUtils.kTabMappingOnValue[noticeType]!;
    }

    // 유저가 학과 설정을 마쳤다면, 아래 함수를 통해 반환
    return CustomTabListUtils.getMajorDisplayName(userSettingKey);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: noticeTypeTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '인',
                      style: TextStyle(
                        fontFamily: Fonts.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedBlueText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '하',
                      style: TextStyle(
                        fontFamily: Fonts.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedLightGreyText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '공',
                      style: TextStyle(
                        fontFamily: Fonts.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedBlueText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '지',
                      style: TextStyle(
                        fontFamily: Fonts.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedLightGreyText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).appBarTheme.iconTheme?.color,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSettingPage(),
                    ),
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                indicatorColor: Theme.of(context).tabIndicatorColor,
                labelColor: Theme.of(context).tabLabelColor,
                unselectedLabelColor: Theme.of(context).tabUnSelectedLabelColor,
                labelStyle: TextStyle(
                  fontFamily: Fonts.kDefaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: Fonts.kDefaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                tabs: noticeTypeTabs
                    .map((noticeType) => Tab(text: _loadTabName(noticeType)))
                    .toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: noticeTypeTabs
              .map((noticeType) => NoticeBoardTab(noticeType: noticeType))
              .toList(),
        ),
      ),
    );
  }
}
