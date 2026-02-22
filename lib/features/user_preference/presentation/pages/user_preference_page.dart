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
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/features/custom_tab/presentation/pages/custom_tab_page.dart';
import 'package:inha_notice/features/more/presentation/widgets/more_navigation_tile.dart';
import 'package:inha_notice/features/more/presentation/widgets/more_title_tile.dart';
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
        title: '개인화 설정',
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MoreTitleTile(text: '화면 설정', fontSize: 16),
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
            const SizedBox(height: 20),
            const MoreTitleTile(text: '기본 정렬 설정', fontSize: 16),
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
    );
  }
}
