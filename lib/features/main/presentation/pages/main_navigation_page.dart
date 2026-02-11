/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/presentation/widgets/web_navigator_widget.dart';
import 'package:inha_notice/features/bookmark/presentation/pages/bookmark_page.dart';
import 'package:inha_notice/features/main/presentation/bloc/main_navigation_bloc.dart';
import 'package:inha_notice/features/main/presentation/bloc/main_navigation_event.dart';
import 'package:inha_notice/features/main/presentation/bloc/main_navigation_state.dart';
import 'package:inha_notice/features/more/presentation/pages/more_page.dart';
import 'package:inha_notice/features/notice/presentation/pages/home_page.dart';
import 'package:inha_notice/features/search/presentation/pages/search_page.dart';
import 'package:inha_notice/injection_container.dart' as di;

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<MainNavigationBloc>()..add(CheckNoticeNotificationEvent()),
      child: const _MainNavigationPageView(),
    );
  }
}

class _MainNavigationPageView extends StatefulWidget {
  const _MainNavigationPageView();

  @override
  State<_MainNavigationPageView> createState() =>
      _MainNavigationPageViewState();
}

class _MainNavigationPageViewState extends State<_MainNavigationPageView> {
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const BookmarkPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainNavigationBloc, MainNavigationState>(
      // targetUrl이 변경되었고, null이 아닐 때만 리스너 동작
      listenWhen: (previous, current) =>
          previous.targetUrl != current.targetUrl,
      listener: (context, state) {
        WebNavigatorWidget.navigate(context: context, url: state.targetUrl);
      },
      child: BlocBuilder<MainNavigationBloc, MainNavigationState>(
        buildWhen: (previous, current) => previous.tabIndex != current.tabIndex,
        builder: (context, state) {
          return Scaffold(
            body: _pages[state.tabIndex],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory, // 물결 효과 제거
                highlightColor: Colors.transparent, // 하이라이트 효과 제거
              ),
              child: BottomNavigationBar(
                currentIndex: state.tabIndex,
                onTap: (index) {
                  context
                      .read<MainNavigationBloc>()
                      .add(ChangeMainTabEvent(index));
                },
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(
                  fontSize: 12, // 선택된 탭 글자 크기
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 10, // 선택되지 않은 탭 글자 크기
                ),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '홈',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: '검색',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark),
                    label: '북마크',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz),
                    label: '더보기',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
