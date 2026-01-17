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
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/constants/keyword_search_option_constants.dart';
import 'package:inha_notice/core/constants/page_constants.dart';
import 'package:inha_notice/core/keys/custom_tab_keys.dart';
import 'package:inha_notice/core/keys/major_keys.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/rounded_toggle_widget.dart';
import 'package:inha_notice/models/pages_model.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/college_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/graduate_school_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/major_setting_page.dart';
import 'package:inha_notice/screens/notice_board/base_notice_board.dart';
import 'package:inha_notice/screens/notice_board/no_search_result.dart';
import 'package:inha_notice/screens/notice_board/notice_list_tile.dart';
import 'package:inha_notice/screens/pagination/absolute_style_pagination.dart';
import 'package:inha_notice/services/absolute_style_scraper/base_absolute_style_notice_scraper.dart';
import 'package:inha_notice/services/absolute_style_scraper/inha_design_style_notice_scraper.dart';
import 'package:inha_notice/services/absolute_style_scraper/major_style_notice_scraper.dart';
import 'package:inha_notice/services/absolute_style_scraper/whole_style_notice_scraper.dart';
import 'package:inha_notice/utils/custom_tab_list_utils/custom_tab_list_utils.dart';
import 'package:inha_notice/widgets/dropdowns/keyword_search_dropdown.dart';
import 'package:inha_notice/widgets/refresh_headers/notice_refresh_header.dart';
import 'package:inha_notice/widgets/textfields/keyword_search_textfield.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// **AbsoluteStyleNoticeBoard**
///
/// 이 클래스는 noticeType에 따른 공지사항을 제공하는 클래스입니다.
///
/// ### 주요 기능:
/// - noticeType에 따른 공지사항 제공
/// - 지원하는 공지: 학사, 장학, 모집/채용, 학과, 국제처, SW중심대학사업단, 단과대, 대학원

class AbsoluteStyleNoticeBoard extends BaseNoticeBoard {
  final String noticeType;

  const AbsoluteStyleNoticeBoard({super.key, required this.noticeType});

  @override
  State<AbsoluteStyleNoticeBoard> createState() =>
      _AbsoluteStyleNoticeBoardState();
}

class _AbsoluteStyleNoticeBoardState
    extends BaseNoticeBoardState<AbsoluteStyleNoticeBoard> {
  final Logger _logger = Logger();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController _keywordSearchController =
      TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late BaseAbsoluteStyleNoticeScraper _absoluteStyleNoticeScraper;
  late String? _userSettingKey;
  late String? _noticeTypeDisplayName;

  bool _isHeadlineSelected = false;
  bool _isGeneralSelected = true;
  bool _isUserSettingKey = false;
  bool _isPullRefreshing = false;
  bool _isKeywordSearchSelected = false;
  bool _isKeywordSearchableNoticeType = false;
  String _selectedKeywordSearchOption = KeywordSearchOptionConstants.kTitle;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  /// 초기화 순서(순서를 보장해야함): 스크래퍼 초기화 -> 공지사항 불러오기
  @override
  Future<void> initialize() async {
    try {
      await _initializeScraper();
      await _loadNotices(PageConstants.kInitialAbsolutePage);
    } catch (e) {
      _logger.e('NoticeBoard 초기화 오류: $e');
    }
  }

  @override
  void toggleOption(String option) {
    setState(() {
      if (option == 'headline') {
        _isHeadlineSelected = true;
        _isGeneralSelected = false;
      } else if (option == 'general') {
        _isHeadlineSelected = false;
        _isGeneralSelected = true;
      }
    });
  }

  void _disposeResources() {
    _refreshController.dispose();
    _searchFocusNode.dispose();
    _keywordSearchController.dispose();
  }

  /// 공지사항 새로고침 진행하는 함수
  Future<void> _loadNotices(int page,
      [String? searchColumn, String? searchWord]) async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedNotices = await _absoluteStyleNoticeScraper.fetchNotices(
          page, widget.noticeType, searchColumn, searchWord);
      if (!mounted) return;
      setState(() {
        notices = fetchedNotices;
        if (page == PageConstants.kInitialAbsolutePage) {
          final bool isKeywordSearch =
              (searchColumn != null && searchColumn.isNotEmpty) ||
                  (searchWord != null && searchWord.isNotEmpty);

          if (pages['pageMetas'].isEmpty ||
              isKeywordSearch ||
              _isPullRefreshing) {
            pages = Pages.from(notices['pages']);
          }
        }
        currentPage = page;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadNoticesByKeyword() async {
    // 중요 옵션이 선택된 경우, 토글을 일반 옵션으로 변경함
    if (_isHeadlineSelected) {
      toggleOption('general');
    }
    await _loadNotices(
      PageConstants.kInitialAbsolutePage,
      _selectedKeywordSearchOption,
      _keywordSearchController.text,
    );
  }

  void _activateKeywordSearch() {
    setState(() {
      _isKeywordSearchSelected = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _deactivateKeywordSearch() {
    setState(() {
      _isKeywordSearchSelected = false;
      _keywordSearchController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  /// **Refresh 컨트롤러(새로운 공지 불러옴)**
  void _refreshNotices() async {
    _isPullRefreshing = true;
    try {
      await _loadNotices(PageConstants.kInitialAbsolutePage);
      _refreshController.refreshCompleted();
      _deactivateKeywordSearch();
    } finally {
      _isPullRefreshing = false;
    }
  }

  /// **Preference 로드를 담당하는 함수**//
  void _loadPreference(String noticeType) {
    // 유저 설정값 불러오기
    _userSettingKey = CustomTabListUtils.loadUserSettingKey(noticeType);
    _isUserSettingKey = (_userSettingKey != null);
    _noticeTypeDisplayName =
        CustomTabListUtils.kTabMappingOnValue[noticeType] ?? noticeType;
  }

  /// **(선택) Preference 로드 -> (필수) 스크래퍼 초기화**
  Future<void> _initializeScraper() async {
    /// Preference 로드가 필요한지 여부 판단
    if (CustomTabListUtils.isUserSettingType(widget.noticeType)) {
      _loadPreference(widget.noticeType);
      if (!_isUserSettingKey) {
        return;
      }
    }

    // 학사, 장학, 모집/채용
    if (widget.noticeType == CustomTabKeys.WHOLE ||
        widget.noticeType == CustomTabKeys.SCHOLARSHIP ||
        widget.noticeType == CustomTabKeys.RECRUITMENT) {
      _absoluteStyleNoticeScraper = WholeStyleNoticeScraper(widget.noticeType);
      _isKeywordSearchableNoticeType = true;
      return;
    }

    // 학과 스타일(국제처, SW중심대학사업단)
    if (widget.noticeType == CustomTabKeys.INTERNATIONAL ||
        widget.noticeType == CustomTabKeys.SWUNIV ||
        widget.noticeType == CustomTabKeys.INHAHUSS) {
      _absoluteStyleNoticeScraper = MajorStyleNoticeScraper(widget.noticeType);
      _isKeywordSearchableNoticeType = true;
      return;
    }

    // (예외) 디자인융합학과인 경우
    if (_userSettingKey == MajorKeys.INHADESIGN) {
      _absoluteStyleNoticeScraper =
          InhaDesignStyleNoticeScraper(_userSettingKey!);
      return;
    }

    // (나머지) 학과, 단과대, 대학원
    _absoluteStyleNoticeScraper = MajorStyleNoticeScraper(_userSettingKey!);
    _isKeywordSearchableNoticeType = true;
  }

  /// **Preference 설정이 안 된 경우, 설정한 뒤에 초기화 진행함**
  void _handleToNavigate(String tab) {
    late Widget settingPage;

    /// tab의 케이스는 반드시 존재함
    switch (tab) {
      case CustomTabKeys.MAJOR:
        settingPage = MajorSettingPage(majorKeyType: SharedPrefKeys.kMajorKey);
        break;
      case CustomTabKeys.MAJOR2:
        settingPage = MajorSettingPage(majorKeyType: SharedPrefKeys.kMajorKey2);
        break;
      case CustomTabKeys.MAJOR3:
        settingPage = MajorSettingPage(majorKeyType: SharedPrefKeys.kMajorKey3);
        break;
      case CustomTabKeys.COLLEGE:
        settingPage = const CollegeSettingPage();
        break;
      case CustomTabKeys.GRADUATESCHOOL:
        settingPage = const GraduateSchoolSettingPage();
        break;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => settingPage),
    ).then((_) => initialize());
  }

  /// NoticeBoard 구조: Header(토글 버튼), Main(공지사항 리스트), Footer(페이지 버튼)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          buildMain(),
          buildFooter(),
        ],
      ),
    );
  }

  /// buildHeader: 토글 버튼 영역 정의
  @override
  Widget buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.all(10),
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 250),
        crossFadeState: _isKeywordSearchSelected
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstCurve: Curves.easeOutCubic,
        secondCurve: Curves.easeInCubic,
        sizeCurve: Curves.easeInOut,
        firstChild: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 중요공지가 있을때만 토글 버튼이 생성됩니다.
            if (notices['headline'].isNotEmpty)
              // 중요공지 버튼
              RoundedToggleWidget(
                text: '중요',
                option: 'headline',
                isSelected: _isHeadlineSelected,
                onTap: toggleOption,
              ),
            const SizedBox(width: 10),
            // 일반공지 버튼
            RoundedToggleWidget(
              text: '일반',
              option: 'general',
              isSelected: _isGeneralSelected,
              onTap: toggleOption,
            ),
            const Spacer(),
            if (_isKeywordSearchableNoticeType)
              IconButton(
                icon: const Icon(Icons.search),
                color: Colors.grey,
                onPressed: _activateKeywordSearch,
              ),
          ],
        ),
        secondChild: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.grey,
              ),
              onPressed: _deactivateKeywordSearch,
            ),
            KeywordSearchDropdown(
              value: _selectedKeywordSearchOption,
              onChanged: (value) {
                setState(() => _selectedKeywordSearchOption = value);
              },
            ),
            const SizedBox(width: 6),
            KeywordSearchTextField(
              controller: _keywordSearchController,
              focusNode: _searchFocusNode,
              onSubmitted: _loadNoticesByKeyword,
            ),
          ],
        ),
      ),
    );
  }

  /// buildMain: 공지사항 리스트 영역 정의
  @override
  Widget buildMain() {
    return Expanded(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: isLoading
            ? const Center(child: BlueLoadingIndicatorWidget())
            : (CustomTabListUtils.isUserSettingType(widget.noticeType) &&
                    !_isUserSettingKey)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 중앙 정렬
                      children: [
                        if (_noticeTypeDisplayName != null)
                          Text(
                            '$_noticeTypeDisplayName를 설정해주세요!',
                            style: TextStyle(
                              fontFamily: AppFont.pretendard.family,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultThemedTextColor,
                            ),
                          ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).buttonBackgroundColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          onPressed: () => _handleToNavigate(widget.noticeType),
                          icon: Icon(Icons.school_outlined,
                              size: 20,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .iconTheme
                                  ?.color),
                          label: Text(
                            '$_noticeTypeDisplayName 설정하기',
                            style: TextStyle(
                              fontFamily: AppFont.pretendard.family,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultThemedTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                // 모든 noticeType에 대응
                : SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _refreshNotices,
                    enablePullDown: true,
                    header: const NoticeRefreshHeader(),
                    // 일반 공지의 결과가 없는 경우, NoSearchResult 화면을 보여줌
                    child: (notices['general'].isEmpty)
                        ? NoSearchResult()
                        : ListView.builder(
                            // 중요 공지와 일반 공지 중 하나만 선택이 가능
                            itemCount: _isHeadlineSelected
                                ? notices['headline'].length
                                : notices['general'].length,
                            itemBuilder: (context, index) {
                              final notice = _isHeadlineSelected
                                  ? notices['headline'][index]
                                  : notices['general'][index];
                              final isRead =
                                  isNoticeRead(notice['id'].toString());
                              final isBookmarked =
                                  isNoticeBookmarked(notice['id'].toString());
                              return NoticeListTile(
                                notice: notice,
                                isRead: isRead,
                                isBookmarked: isBookmarked,
                                markNoticeAsRead: markNoticeAsRead,
                                toggleBookmark: toggleBookmark,
                              );
                            },
                          ),
                  ),
      ),
    );
  }

  /// buildFooter: 페이지 버튼 정의
  @override
  Widget buildFooter() {
    // 페이지 리스트가 초기화 되지 않았을 때
    if (pages['pageMetas'].isEmpty || _isHeadlineSelected) {
      return const SizedBox();
    }
    // 페이지 리스트가 초기화 되었을 때
    return AbsoluteStylePagination(
      pages: pages,
      currentPage: currentPage,
      loadNotices: _loadNotices,
    );
  }
}
