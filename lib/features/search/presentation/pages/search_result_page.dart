/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-23
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/core/presentation/widgets/notice_tile_widget.dart';
import 'package:inha_notice/core/presentation/widgets/rounded_toggle_widget.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/features/notice/data/datasources/read_notice_local_data_source.dart';
import 'package:inha_notice/features/notice/presentation/widgets/no_search_result_widget.dart';
import 'package:inha_notice/features/notice/presentation/widgets/notice_refresh_header.dart';
import 'package:inha_notice/features/notice/presentation/widgets/pagination_widget.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_bloc.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_event.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_state.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// **SearchResultPage**
/// 사용자 입력에 따른 검색 결과를 BLoC 패턴으로 표시하는 페이지입니다.
class SearchResultPage extends StatelessWidget {
  final String query;

  const SearchResultPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<SearchResultBloc>()..add(LoadSearchResultEvent(query: query)),
      child: _SearchResultPageView(query: query),
    );
  }
}

class _SearchResultPageView extends StatefulWidget {
  final String query;

  const _SearchResultPageView({required this.query});

  @override
  State<_SearchResultPageView> createState() => _SearchResultPageViewState();
}

class _SearchResultPageViewState extends State<_SearchResultPageView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    context.read<SearchResultBloc>().add(const RefreshSearchResultEvent());
    _refreshController.refreshCompleted();
  }

  void _markNoticeAsRead(String noticeId) {
    context
        .read<SearchResultBloc>()
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
      appBar: CommonAppBarWidget(
        title: '검색 결과: ${widget.query}',
        titleSize: 17,
        isCenter: true,
      ),
      body: BlocConsumer<SearchResultBloc, SearchResultState>(
        listener: (context, state) {
          if (state is SearchResultLoaded && !state.isRefreshing) {
            if (_refreshController.isRefresh) {
              _refreshController.refreshCompleted();
            }
          }
          if (state is SearchResultError) {
            if (_refreshController.isRefresh) {
              _refreshController.refreshFailed();
            }
          }
        },
        builder: (context, state) {
          if (state is SearchResultInitial || state is SearchResultLoading) {
            return const Center(child: BlueLoadingIndicatorWidget());
          }

          if (state is SearchResultError) {
            return const NoSearchResult();
          }

          if (state is SearchResultLoaded) {
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

  Widget _buildHeader(SearchResultLoaded state) {
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
            option: SearchResultDefaultSortType.rank.value,
            isSelected: state.sortType == SearchResultDefaultSortType.rank,
            onTap: (_) {
              context.read<SearchResultBloc>().add(
                    const ChangeSortTypeEvent(
                        sortType: SearchResultDefaultSortType.rank),
                  );
            },
          ),
          const SizedBox(width: 10),
          RoundedToggleWidget(
            text: '최신순',
            option: SearchResultDefaultSortType.date.value,
            isSelected: state.sortType == SearchResultDefaultSortType.date,
            onTap: (_) {
              context.read<SearchResultBloc>().add(
                    const ChangeSortTypeEvent(
                        sortType: SearchResultDefaultSortType.date),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMain(SearchResultLoaded state) {
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
                child: state.notices.isEmpty
                    ? const NoSearchResult()
                    : ListView.builder(
                        itemCount: state.notices.length,
                        itemBuilder: (context, index) {
                          final notice = state.notices[index];
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

  Widget _buildFooter(SearchResultLoaded state) {
    if (state.pages['pageMetas'].isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: PaginationWidget(
        pages: state.pages,
        currentPage: state.currentPage,
        isRelativeStyle: true,
        onAbsolutePageTap: (_) {},
        onRelativePageTap: (offset) {
          context.read<SearchResultBloc>().add(LoadPageEvent(offset: offset));
        },
      ),
    );
  }
}
