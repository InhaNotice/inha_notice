/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/features/search/domain/entities/trending_topic_entity.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_bloc.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_event.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_state.dart';
import 'package:inha_notice/features/search/presentation/pages/search_result_page.dart';
import 'package:inha_notice/features/search/presentation/widgets/trending_topics_item_widget.dart';
import 'package:inha_notice/injection_container.dart' as di;

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SearchBloc>()..add(LoadSearchEvent()),
      child: const _SearchPageView(),
    );
  }
}

class _SearchPageView extends StatefulWidget {
  const _SearchPageView();

  @override
  State<_SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<_SearchPageView> {
  final TextEditingController _searchController = TextEditingController();

  void _search(String query) {
    if (query.trim().length < 2) {
      AppSnackBar.warn(context, '검색어는 두 글자 이상 입력해주세요.');
      return;
    }

    context.read<SearchBloc>().add(AddRecentSearchWordEvent(query: query));

    // 결과 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SearchResultPage(query: query, isSearchResultPage: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const CommonAppBarWidget(title: '검색', titleSize: 20, isCenter: false),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchField(context),
                  const SizedBox(height: 16),
                  _buildRecentSearches(context, state.recentSearchWords),
                  const SizedBox(height: 16),
                  _buildTrendingTopics(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 50.0,
      decoration: BoxDecoration(
        color: Theme.of(context).boxTextFieldBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.blue,
              controller: _searchController,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                hintStyle: TextStyle(
                  fontFamily: AppFont.pretendard.family,
                  fontSize: 16,
                  color: Theme.of(context).textFieldTextColor,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () => _searchController.clear(),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              onSubmitted: (value) => _search(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(
      BuildContext context, List<String> recentSearches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '최근 검색어',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (recentSearches.isEmpty) {
                  AppSnackBar.warn(context, '최근 검색어가 존재하지 않아요.');
                  return;
                }
                context.read<SearchBloc>().add(ClearRecentSearchWordsEvent());
                AppSnackBar.success(context, '최근 검색어를 모두 삭제하였어요!');
              },
              child: Text(
                '전체삭제',
                style: TextStyle(
                  fontFamily: AppFont.pretendard.family,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      Theme.of(context).defaultThemedTextColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (recentSearches.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child:
                Text("최근 검색 기록이 없습니다.", style: TextStyle(color: Colors.grey)),
          )
        else
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: recentSearches
                .map((search) => _buildSearchTag(context, search))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildSearchTag(BuildContext context, String text) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          _searchController.text = text;
          _search(text);
        },
        child: Chip(
          label: Text(
            text,
            style: TextStyle(
              fontFamily: AppFont.pretendard.family,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultThemedTextColor,
            ),
          ),
          backgroundColor: Theme.of(context).tagBackgroundColor,
          deleteIcon: const Icon(Icons.close, size: 14),
          onDeleted: () {
            context
                .read<SearchBloc>()
                .add(RemoveRecentSearchWordEvent(query: text));
            AppSnackBar.success(context, '$text이 삭제되었어요!');
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingTopics(BuildContext context, SearchState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '실시간 인기 검색어',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
            Text(
              state.makeTimes,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.status == SearchStatus.loading)
          const Center(child: BlueLoadingIndicatorWidget())
        else if (state.trendingTopics.isEmpty)
          Center(
            child: Text(
              state.errorMessage ?? '인기 검색어가 없어요.',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.trendingTopics.length,
            itemBuilder: (context, index) {
              final TrendingTopicEntity topic = state.trendingTopics[index];
              return TrendingTopicsItemWidget(
                topic: topic,
                rank: index + 1,
              );
            },
          )
      ],
    );
  }
}
