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
import 'package:inha_notice/core/constants/page_constants.dart';
import 'package:inha_notice/core/constants/string_constants.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/core/presentation/widgets/notice_tile_widget.dart';
import 'package:inha_notice/core/presentation/widgets/rounded_toggle_widget.dart';
import 'package:inha_notice/features/notice/presentation/pages/base_notice_board_page.dart';
import 'package:inha_notice/features/notice/presentation/widgets/no_search_result_widget.dart';
import 'package:inha_notice/features/notice/presentation/widgets/notice_refresh_header.dart';
import 'package:inha_notice/features/notice/presentation/widgets/pagination_widget.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_bloc.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_event.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_state.dart';
import 'package:inha_notice/features/user_preference/domain/usecases/get_user_preference_use_case.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// **SearchResultPage**
/// 이 클래스는 사용자 입력에 따른 검색 결과를 불러오는 클래스입니다.
class SearchResultPage extends StatelessWidget {
  final String query;

  const SearchResultPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SearchResultBloc>(),
      child: _SearchResultPageContent(query: query),
    );
  }
}

class _SearchResultPageContent extends BaseNoticeBoardPage {
  final String query;

  const _SearchResultPageContent({required this.query});

  @override
  State<_SearchResultPageContent> createState() => _SearchResultPageState();
}

class _SearchResultPageState
    extends BaseNoticeBoardPageState<_SearchResultPageContent> {
  final logger = Logger();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// 초기화: 사용자 설정 불러오고 검색 시작
  void _initialize() {
    final getUserPreferenceUseCase = di.sl<GetUserPreferenceUseCase>();
    final result = getUserPreferenceUseCase();

    String sortType = StringConstants.kDefaultSortedType;

    result.fold(
      (failure) {
        logger.w('사용자 설정 불러오기 실패: ${failure.message}');
      },
      (preferences) {
        sortType = preferences.searchResultDefaultSort.value;
      },
    );

    context.read<SearchResultBloc>().add(
          SearchNoticesRequestedEvent(
            query: widget.query,
            startCount: PageConstants.kInitialRelativePage,
            sortType: sortType,
          ),
        );
  }

  /// **Refresh 컨트롤러(새로운 공지 불러옴)**
  void _onRefresh() {
    context.read<SearchResultBloc>().add(
          SearchPageChangedEvent(
            startCount: PageConstants.kInitialRelativePage,
          ),
        );
    _refreshController.refreshCompleted();
  }

  /// 정렬 옵션 변경
  void _toggleOption(String option) {
    context.read<SearchResultBloc>().add(
          SearchSortChangedEvent(sortType: option),
        );
  }

  /// 페이지 변경
  void _onPageChanged(int startCount) {
    context.read<SearchResultBloc>().add(
          SearchPageChangedEvent(startCount: startCount),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarWidget(
        title: '검색 결과: ${widget.query}',
        titleSize: 17,
        isCenter: true,
      ),
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

  @override
  Widget buildHeader() {
    return BlocBuilder<SearchResultBloc, SearchResultState>(
      builder: (context, state) => _buildHeaderContent(state),
    );
  }

  Widget _buildHeaderContent(SearchResultState state) {
    final sortType = (state is SearchResultLoaded)
        ? state.sortType
        : StringConstants.kDefaultSortedType;

    final showRank = sortType == 'RANK';
    final showDate = sortType == 'DATE';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RoundedToggleWidget(
            text: '정확도순',
            option: 'RANK',
            isSelected: showRank,
            onTap: _toggleOption,
          ),
          const SizedBox(width: 10),
          RoundedToggleWidget(
            text: '최신순',
            option: 'DATE',
            isSelected: showDate,
            onTap: _toggleOption,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildMain() {
    return BlocBuilder<SearchResultBloc, SearchResultState>(
      builder: (context, state) => _buildMainContent(state),
    );
  }

  Widget _buildMainContent(SearchResultState state) {
    return Expanded(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _buildMainBody(state),
      ),
    );
  }

  Widget _buildMainBody(SearchResultState state) {
    if (state is SearchResultInitial) {
      return const SizedBox.shrink();
    }

    if (state is SearchResultLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SearchResultError) {
      return Center(
        child: Text('오류: ${state.message}'),
      );
    }

    if (state is SearchResultLoaded) {
      if (state.notices.isEmpty) {
        return NoSearchResult();
      }

      return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        header: const NoticeRefreshHeader(),
        child: ListView.builder(
          itemCount: state.notices.length,
          itemBuilder: (context, index) {
            final notice = state.notices[index];
            final isRead = isNoticeRead(notice.id);
            final isBookmarked = isNoticeBookmarked(notice.id);
            return NoticeTileWidget(
              notice: notice,
              isRead: isRead,
              isBookmarked: isBookmarked,
              markNoticeAsRead: markNoticeAsRead,
              toggleBookmark: toggleBookmark,
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget buildFooter() {
    return BlocBuilder<SearchResultBloc, SearchResultState>(
      builder: (context, state) => _buildFooterContent(state),
    );
  }

  Widget _buildFooterContent(SearchResultState state) {
    if (state is! SearchResultLoaded) {
      return const SizedBox();
    }

    if (state.pages['pageMetas'].isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: PaginationWidget(
        pages: state.pages,
        currentPage: state.currentPage,
        isRelativeStyle: true,
        onAbsolutePageTap: (_) {},
        onRelativePageTap: _onPageChanged,
      ),
    );
  }
}
