/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-25
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/font/fonts.dart';
import 'package:inha_notice/core/theme/theme.dart';
import 'package:inha_notice/screens/bottom_navigation/search/topics_item.dart';
import 'package:inha_notice/services/trending_topics/trending_topics_api.dart';
import 'package:inha_notice/utils/recent_search/recent_search_manager.dart';
import 'package:inha_notice/widgets/search/search_result_page.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_app_bar.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snack_bar.dart';
import 'package:logger/logger.dart';

/// **SearchPage**
/// 이 클래스는 검색 페이지를 구현합니다.
///
/// ### 주요 기능:
/// - 검색 기능 제공
/// - 인기 검색어 기능
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TrendingTopicsAPI _trendingTopicsApi = TrendingTopicsAPI();
  final logger = Logger();

  List<Map<String, dynamic>> _topicsList = [];

  String _warning = Fonts.kEmptyString;
  String _makeTimes = Fonts.kEmptyString;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchTrendingTopics();
  }

  Future<void> _fetchTrendingTopics() async {
    try {
      final response = await _trendingTopicsApi.fetchTrendingTopics();
      setState(() {
        _topicsList = response;
        if (response.isNotEmpty) {
          _makeTimes = response.first['makeTimes'] ?? Fonts.kEmptyString;
          _warning = Fonts.kEmptyString;
        } else {
          _warning = '인기 검색어가 없어요.';
        }
      });
    } catch (error) {
      setState(() {
        _topicsList = [];
        _warning = '인기 검색어를 불러오지 못하였어요.';
      });
    }
  }

  void _search() async {
    final query = _searchController.text.trim();
    if (query.length < 2) {
      ThemedSnackBar.warnSnackBar(context, '검색어는 두 글자 이상 입력해주세요.');
      return;
    }

    await RecentSearchManager.addRecentSearch(query);
    setState(() {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SearchResultPage(query: query, isSearchResultPage: true),
        ),
      );
    });
  }

  /// **최근검색어 모두 삭제**
  void _clearRecentSearchTopics() async {
    if (!RecentSearchManager.isCachedSearchHistory()) {
      ThemedSnackBar.warnSnackBar(context, '최근 검색어가 존재하지 않아요.');
      return;
    }
    await RecentSearchManager.clearSearchHistory();
    setState(() {
      ThemedSnackBar.succeedSnackBar(context, '최근 검색어를 모두 삭제하였어요!');
    });
  }

  /// **최근검색어 특정 기록 삭제**
  void _removeRecentSearchTopic(String query) async {
    await RecentSearchManager.removeRecentSearch(query);
    setState(() {
      ThemedSnackBar.succeedSnackBar(context, '$query이 삭제하였어요!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(title: '검색', titleSize: 20, isCenter: false),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchField(),
              const SizedBox(height: 16),
              _buildRecentSearches(),
              const SizedBox(height: 16),
              if (_topicsList.isNotEmpty) _buildTrendingTopics(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
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
              controller: _searchController,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontFamily: Fonts.kDefaultFont,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                hintStyle: TextStyle(
                  fontFamily: Fonts.kDefaultFont,
                  fontSize: 16,
                  color: Theme.of(context).textFieldTextColor,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              onSubmitted: (_) => _search(),
              onChanged: (value) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '최근 검색어',
              style: TextStyle(
                fontFamily: Fonts.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
            GestureDetector(
              onTap: _clearRecentSearchTopics,
              child: Text(
                '전체삭제',
                style: TextStyle(
                  fontFamily: Fonts.kDefaultFont,
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
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: RecentSearchManager.getRecentSearchTopics()
              .map((search) => _buildSearchTag(search))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSearchTag(String text) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          _searchController.text = text;
          _search();
        },
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Chip(
            label: Text(
              text,
              style: TextStyle(
                fontFamily: Fonts.kDefaultFont,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
            backgroundColor: Theme.of(context).tagBackgroundColor,
            deleteIcon: const Icon(Icons.close, size: 14),
            onDeleted: () => _removeRecentSearchTopic(text),
            deleteButtonTooltipMessage: Fonts.kEmptyString,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onTap: () {
            _searchController.text = text;
            _search();
          },
        ),
      ),
    );
  }

  Widget _buildTrendingTopics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '실시간 인기 검색어',
              style: TextStyle(
                fontFamily: Fonts.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
            Text(
              _makeTimes,
              style: TextStyle(
                fontFamily: Fonts.kDefaultFont,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _topicsList.isEmpty
            ? Center(
                child: Text(
                  _warning.isNotEmpty ? _warning : '실시간 인기 검색어를 불러오고 있어요...',
                  style: TextStyle(
                    fontFamily: Fonts.kDefaultFont,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).defaultThemedTextColor,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _topicsList.length,
                itemBuilder: (context, index) {
                  final topics = _topicsList[index];
                  return TopicsItem(
                    topic: topics,
                    rank: index + 1,
                  );
                },
              )
      ],
    );
  }
}
