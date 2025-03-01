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
import 'package:inha_notice/constants/shared_pref_keys/shared_pref_keys.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/home/notice_board_tab.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_setting_page.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/custom_tab_list_utils/custom_tab_list_utils.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/utils/university_utils/major_utils.dart';

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
    // 학과 타입이 아니면, noticeType을 번역해서 탭 이름을 반환
    // 학과 타입이 아닌 경우: MAJOR, MAJOR2, MAJOR3을 제외한 나머지
    if (!CustomTabListUtils.isMajorType(noticeType)) {
      return CustomTabListUtils.kTabMappingOnValue[noticeType]!;
    }
    // 학과 타입일 때, 유저 설정 값을 불러온다.
    final userSettingKey = CustomTabListUtils.loadUserSettingKey(noticeType);
    // 설정 값이 존재하지 않으면, 기본 탭 이름을 사용
    if (userSettingKey == null) {
      return CustomTabListUtils.kTabMappingOnValue[noticeType]!;
    } else {
      // 존재하면, 유저 설정 값을 번역해서 사용
      return MajorUtils.kMajorMappingOnValue[userSettingKey]!;
    }
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
