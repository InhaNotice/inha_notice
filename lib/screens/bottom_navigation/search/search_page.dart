/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-20
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/search/topics_item.dart';
import 'package:inha_notice/services/trending_topics/trending_topics_api.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/recent_search/recent_search_manager.dart';
import 'package:inha_notice/widgets/search/search_result_page.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_app_bar.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snackbar.dart';
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

  late final List<AnimationController> _controllers = [];
  late final List<Animation<double>> _animations = [];

  List<Map<String, dynamic>> _topicsList = [];

  String _warning = Font.kEmptyString;
  String _makeTimes = Font.kEmptyString;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _fetchTrendingTopics();
  }

  void _initializeAnimations() {
    if (_topicsList.isEmpty) return;
    try {
      for (int i = 0; i < _topicsList.length; i++) {
        final controller = AnimationController(
          duration: const Duration(seconds: 1),
          vsync: this,
        );
        _controllers.add(controller);
        final animation = Tween(begin: 0.0, end: 1.0).animate(controller);
        _animations.add(animation);
      }
    } catch (e) {
      logger.e('${runtimeType.toString()} - _initializeAnimations() 오류: $e');
    }
  }

  Future<void> _triggerAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 300 * i));

      if (!mounted) return;

      try {
        await _controllers[i].forward();
      } catch (e) {
        logger.e('SearchPage - _triggerAnimation() 오류: $e');
      }
    }
  }

  Future<void> _fetchTrendingTopics() async {
    try {
      final response = await _trendingTopicsApi.fetchTrendingTopics();
      setState(() {
        _topicsList = response;
        if (response.isNotEmpty) {
          _makeTimes = response.first['makeTimes'] ?? '';
          _warning = '';
        } else {
          _warning = '인기 검색어가 없습니다.';
        }
      });
      _initializeAnimations();
      _triggerAnimations();
    } catch (error) {
      setState(() {
        _topicsList = [];
        _warning = '인기검색어를 불러오지 못하였습니다.';
      });
    }
  }

  void _search() async {
    final query = _searchController.text.trim();
    if (query.length < 2) {
      ThemedSnackbar.showSnackbar(context, '검색어는 두 글자 이상 입력해주세요.');
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
      ThemedSnackbar.showSnackbar(context, '최근검색어가 존재하지 않습니다!');
      return;
    }
    await RecentSearchManager.clearSearchHistory();
    setState(() {
      ThemedSnackbar.showSnackbar(context, '최근검색어를 모두 삭제하였습니다!');
    });
  }

  /// **최근검색어 특정 기록 삭제**
  void _removeRecentSearchTopic(String query) async {
    await RecentSearchManager.removeRecentSearch(query);
    setState(() {
      ThemedSnackbar.showSnackbar(context, '$query을(를) 삭제하였습니다!');
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
              _buildTrendingTopics(context),
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
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultColor,
              ),
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                hintStyle: TextStyle(
                  fontFamily: Font.kDefaultFont,
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
              '최근 검색 기록',
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultColor,
              ),
            ),
            GestureDetector(
              onTap: _clearRecentSearchTopics,
              child: Text(
                '전체 삭제',
                style: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      Theme.of(context).defaultColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
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
        child: Chip(
          label: Text(
            text,
            style: TextStyle(
              fontFamily: Font.kDefaultFont,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultColor,
            ),
          ),
          backgroundColor: Theme.of(context).tagBackgroundColor,
          deleteIcon: const Icon(Icons.close, size: 14),
          onDeleted: () => _removeRecentSearchTopic(text),
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
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultColor,
              ),
            ),
            Text(
              _makeTimes,
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _topicsList.isEmpty
            ? Center(
                child: Text(
                  _warning.isNotEmpty ? _warning : '실시간 인기 검색어를 불러오고 있습니다...',
                  style: TextStyle(
                    fontFamily: Font.kDefaultFont,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).defaultColor,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _topicsList.length,
                itemBuilder: (context, index) {
                  final topics = _topicsList[index];
                  return TopicsItem(
                    topic: topics,
                    rank: index + 1,
                    animation: _animations[index],
                  );
                },
              ),
      ],
    );
  }
}
