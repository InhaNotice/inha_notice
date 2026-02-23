/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/features/custom_tab/presentation/pages/custom_tab_page.dart';
import 'package:inha_notice/features/more/presentation/widgets/more_navigation_tile.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_bloc.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_event.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_state.dart';
import 'package:inha_notice/features/user_preference/presentation/widgets/bookmark_sort_preference_tile.dart';
import 'package:inha_notice/features/user_preference/presentation/widgets/notice_board_preference_tile.dart';
import 'package:inha_notice/features/user_preference/presentation/widgets/search_result_sort_preference_tile.dart';
import 'package:inha_notice/injection_container.dart' as di;

class UserPreferencePage extends StatelessWidget {
  const UserPreferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<UserPreferenceBloc>()..add(const LoadUserPreferenceEvent()),
      child: const _UserPreferencePageView(),
    );
  }
}

class _UserPreferencePageView extends StatelessWidget {
  const _UserPreferencePageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBarWidget(
        title: '나만의 앱 설정',
        titleSize: 20,
        isCenter: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<UserPreferenceBloc, UserPreferenceState>(
        builder: (context, state) {
          if (state is UserPreferenceLoading ||
              state is UserPreferenceInitial) {
            return const Center(child: BlueLoadingIndicatorWidget());
          }

          if (state is UserPreferenceError) {
            return Center(child: Text(state.message));
          }

          if (state is UserPreferenceLoaded) {
            return _buildBody(context, state.preferences);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    UserPreferenceEntity preferences,
  ) {
    final primaryBlue = const Color(0xFF12B8FF);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 화면 설정 섹션
            _buildSectionCard(
              context,
              primaryBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.dashboard_customize_rounded,
                          color: primaryBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '화면 설정',
                        style: TextStyle(
                          fontFamily: AppFont.pretendard.family,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).defaultThemedTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '자주 보는 게시판을 모아 나만의 탭을 만들어보세요',
                    style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14,
                      color: Theme.of(context).fixedGreyText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  MoreNavigationTile(
                    title: '나만의 탭',
                    icon: Icons.tab_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomTabPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 기본 정렬 설정 섹션
            _buildSectionCard(
              context,
              primaryBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.sort_rounded,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '기본 정렬 설정',
                        style: TextStyle(
                          fontFamily: AppFont.pretendard.family,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).defaultThemedTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '화면에 출력되는 기본 정렬 방식을 설정해보세요',
                    style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14,
                      color: Theme.of(context).fixedGreyText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  NoticeBoardPreferenceTile(
                    currentType: preferences.noticeBoardDefault,
                  ),
                  BookmarkSortPreferenceTile(
                    currentType: preferences.bookmarkDefaultSort,
                  ),
                  SearchResultSortPreferenceTile(
                    currentType: preferences.searchResultDefaultSort,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    Color primaryBlue, {
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryBlue.withOpacity(isDark ? 0.5 : 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.1 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}
