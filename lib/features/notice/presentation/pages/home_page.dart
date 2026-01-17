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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/features/notice/presentation/bloc/home_bloc.dart';
import 'package:inha_notice/features/notice/presentation/bloc/home_event.dart';
import 'package:inha_notice/features/notice/presentation/bloc/home_state.dart';
import 'package:inha_notice/injection_container.dart';
import 'package:inha_notice/screens/bottom_navigation/home/notice_board_tab.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_setting_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(HomeTabsRequested()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: _buildAppTitle(context),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeError) {
              return Center(
                  child: Text(state.message,
                      style: TextStyle(
                          fontFamily: AppFont.pretendard.family,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)));
            }
            if (state is HomeLoaded) {
              return _buildTabContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAppTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '인',
                style: TextStyle(
                  fontFamily: AppFont.pretendard.family,
                  fontSize: 16,
                  color: Theme.of(context).fixedBlueText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '하',
                style: TextStyle(
                  fontFamily: AppFont.pretendard.family,
                  fontSize: 16,
                  color: Theme.of(context).fixedLightGreyText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '공',
                style: TextStyle(
                  fontFamily: AppFont.pretendard.family,
                  fontSize: 16,
                  color: Theme.of(context).fixedBlueText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '지',
                style: TextStyle(
                  fontFamily: AppFont.pretendard.family,
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
    );
  }

  Widget _buildTabContent(BuildContext context, HomeLoaded state) {
    return DefaultTabController(
      length: state.tabs.length,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            width: double.infinity,
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
                  fontFamily: AppFont.pretendard.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: AppFont.pretendard.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                tabs: state.tabs.map((tab) => Tab(text: tab.label)).toList(),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: state.tabs
                  .map((tab) => NoticeBoardTab(noticeType: tab.noticeType))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
