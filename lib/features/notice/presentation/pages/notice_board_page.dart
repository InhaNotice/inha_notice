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
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/constants/keyword_search_option_constants.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/notice_tile_widget.dart';
import 'package:inha_notice/core/presentation/widgets/rounded_toggle_widget.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_type.dart';
import 'package:inha_notice/features/notice/data/datasources/read_notice_local_data_source.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_bloc.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_event.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_state.dart';
import 'package:inha_notice/features/notice/presentation/widgets/keyword_search_dropdown.dart';
import 'package:inha_notice/features/notice/presentation/widgets/keyword_search_textfield.dart';
import 'package:inha_notice/features/notice/presentation/widgets/no_search_result_widget.dart';
import 'package:inha_notice/features/notice/presentation/widgets/notice_refresh_header.dart';
import 'package:inha_notice/features/notice/presentation/widgets/pagination_widget.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/college_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/graduate_school_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/university_settings/major_setting_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// **NoticeBoardPage**
/// AbsoluteStyleNoticeBoard와 RelativeStyleNoticeBoard를 통합한 BLoC 기반 페이지입니다.
class NoticeBoardPage extends StatefulWidget {
  final String noticeType;

  const NoticeBoardPage({super.key, required this.noticeType});

  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController _keywordSearchController =
      TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isKeywordSearchSelected = false;
  String _selectedKeywordSearchOption = KeywordSearchOptionConstants.kTitle;
  bool _isRelativeStyle = false;

  @override
  void initState() {
    super.initState();
    _isRelativeStyle = (widget.noticeType == CustomTabType.library.noticeType);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _keywordSearchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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

  void _onSearchSubmitted() {
    final bloc = context.read<NoticeBoardBloc>();
    bloc.add(SearchByKeywordEvent(
      searchColumn: _selectedKeywordSearchOption,
      searchWord: _keywordSearchController.text,
    ));
  }

  void _onRefresh() {
    final bloc = context.read<NoticeBoardBloc>();
    bloc.add(const RefreshNoticeBoardEvent());
    _refreshController.refreshCompleted();
    _deactivateKeywordSearch();
  }

  void _handleNavigateToSetting(String tab) {
    final tabType = CustomTabType.fromNoticeType(tab);
    if (tabType == null) return;

    late Widget settingPage;

    switch (tabType) {
      case CustomTabType.major:
        settingPage = MajorSettingPage(majorKeyType: SharedPrefKeys.kMajorKey);
        break;
      case CustomTabType.major2:
        settingPage = MajorSettingPage(majorKeyType: SharedPrefKeys.kMajorKey2);
        break;
      case CustomTabType.major3:
        settingPage = MajorSettingPage(majorKeyType: SharedPrefKeys.kMajorKey3);
        break;
      case CustomTabType.college:
        settingPage = const CollegeSettingPage();
        break;
      case CustomTabType.graduateSchool:
        settingPage = const GraduateSchoolSettingPage();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => settingPage),
    ).then((_) {
      context
          .read<NoticeBoardBloc>()
          .add(LoadNoticeBoardEvent(noticeType: widget.noticeType));
    });
  }

  void _markNoticeAsRead(String noticeId) {
    context
        .read<NoticeBoardBloc>()
        .add(MarkNoticeAsReadEvent(noticeId: noticeId));
  }

  Future<void> _toggleBookmark(NoticeTileModel notice) async {
    final bookmarkDs = di.sl<BookmarkLocalDataSource>();
    if (bookmarkDs.isBookmarked(notice.id)) {
      await bookmarkDs.removeBookmark(notice.id);
      if (!mounted) return;
      AppSnackBar.success(context, '삭제되었습니다.');
    } else {
      await bookmarkDs.addBookmark(notice);
      if (!mounted) return;
      AppSnackBar.success(context, '저장되었습니다.');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<NoticeBoardBloc, NoticeBoardState>(
        listener: (context, state) {
          if (state is NoticeBoardLoaded && !state.isRefreshing) {
            if (_refreshController.isRefresh) {
              _refreshController.refreshCompleted();
            }
          }
          if (state is NoticeBoardError) {
            if (_refreshController.isRefresh) {
              _refreshController.refreshFailed();
            }
          }
        },
        builder: (context, state) {
          if (state is NoticeBoardInitial || state is NoticeBoardLoading) {
            return const Center(child: BlueLoadingIndicatorWidget());
          }

          if (state is NoticeBoardSettingRequired) {
            return _buildSettingRequired(state);
          }

          if (state is NoticeBoardError) {
            return const NoSearchResult();
          }

          if (state is NoticeBoardLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(state),
                _buildMain(state),
                _buildFooter(state),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSettingRequired(NoticeBoardSettingRequired state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.displayName != null)
            Text(
              '${state.displayName}를 설정해주세요!',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).buttonBackgroundColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () => _handleNavigateToSetting(state.noticeType),
            icon: Icon(Icons.school_outlined,
                size: 20,
                color: Theme.of(context).appBarTheme.iconTheme?.color),
            label: Text(
              '${state.displayName ?? state.noticeType} 설정하기',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(NoticeBoardLoaded state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.all(10),
      child: state.isKeywordSearchable
          ? AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: _isKeywordSearchSelected
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstCurve: Curves.easeOutCubic,
              secondCurve: Curves.easeInCubic,
              sizeCurve: Curves.easeInOut,
              firstChild: _buildToggleRow(state),
              secondChild: _buildSearchRow(),
            )
          : _buildToggleRow(state),
    );
  }

  Widget _buildToggleRow(NoticeBoardLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (state.headlineNotices.isNotEmpty)
          RoundedToggleWidget(
            text: '중요',
            option: 'headline',
            isSelected: state.isHeadlineSelected,
            onTap: (option) {
              context.read<NoticeBoardBloc>().add(
                    const ToggleNoticeTypeEvent(isHeadline: true),
                  );
            },
          ),
        const SizedBox(width: 10),
        RoundedToggleWidget(
          text: '일반',
          option: 'general',
          isSelected: !state.isHeadlineSelected,
          onTap: (option) {
            context.read<NoticeBoardBloc>().add(
                  const ToggleNoticeTypeEvent(isHeadline: false),
                );
          },
        ),
        const Spacer(),
        if (state.isKeywordSearchable)
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.grey,
            onPressed: _activateKeywordSearch,
          ),
      ],
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
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
          onSubmitted: _onSearchSubmitted,
        ),
      ],
    );
  }

  Widget _buildMain(NoticeBoardLoaded state) {
    final notices =
        state.isHeadlineSelected ? state.headlineNotices : state.generalNotices;

    return Expanded(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: state.isRefreshing
            ? const Center(child: BlueLoadingIndicatorWidget())
            : SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                enablePullDown: true,
                header: const NoticeRefreshHeader(),
                child: notices.isEmpty
                    ? const NoSearchResult()
                    : ListView.builder(
                        itemCount: notices.length,
                        itemBuilder: (context, index) {
                          final notice = notices[index];
                          final isRead =
                              ReadNoticeLocalDataSource.isReadNotice(notice.id);
                          final isBookmarked = di
                              .sl<BookmarkLocalDataSource>()
                              .isBookmarked(notice.id);
                          return NoticeTileWidget(
                            notice: notice,
                            isRead: isRead,
                            isBookmarked: isBookmarked,
                            markNoticeAsRead: _markNoticeAsRead,
                            toggleBookmark: _toggleBookmark,
                          );
                        },
                      ),
              ),
      ),
    );
  }

  Widget _buildFooter(NoticeBoardLoaded state) {
    if (state.pages['pageMetas'].isEmpty || state.isHeadlineSelected) {
      return const SizedBox();
    }

    return PaginationWidget(
      pages: state.pages,
      currentPage: state.currentPage,
      isRelativeStyle: _isRelativeStyle,
      onAbsolutePageTap: (page) {
        final searchColumn = state.pages['searchOptions']['searchColumn'];
        final searchWord = state.pages['searchOptions']['searchWord'];
        context.read<NoticeBoardBloc>().add(LoadPageEvent(
              page: page,
              searchColumn: searchColumn,
              searchWord: searchWord,
            ));
      },
      onRelativePageTap: (offset) {
        context.read<NoticeBoardBloc>().add(LoadOffsetEvent(offset: offset));
      },
    );
  }
}
