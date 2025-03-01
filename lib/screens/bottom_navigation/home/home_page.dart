/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-28
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/constants/shared_pref_keys/shared_pref_keys.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/home/notice_board_tab.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_setting_page.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/custom_tab_list_utils/custom_tab_list_utils.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> selectedTabs = [];

  @override
  void initState() {
    super.initState();
    _loadSavedTabs();
  }

  /// **저장된 나의 탭 설정 불러오기**
  Future<void> _loadSavedTabs() async {
    // 저장된 나의 탭 불러오기 (상수시간, 캐싱 전략 사용)
    final List<String>? savedTabs =
        SharedPrefsManager().getPreference(SharedPrefKeys.kCustomTabList);

    // savedTabs는 null일 수도 있음
    if (savedTabs == null || savedTabs.isEmpty) {
      // 저장된 나의 탭이 없다면, 기본 탭 구성 사용
      selectedTabs = CustomTabListUtils.kDefaultTabs;
    } else {
      selectedTabs = List.from(savedTabs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: selectedTabs.length,
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
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedBlueText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '하',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedLightGreyText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '공',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedBlueText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '지',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
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
                  fontFamily: Font.kDefaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                tabs:
                    selectedTabs.map((tabName) => Tab(text: tabName)).toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: selectedTabs
              .map((tabName) => NoticeBoardTab(tabName: tabName))
              .toList(),
        ),
      ),
    );
  }
}
