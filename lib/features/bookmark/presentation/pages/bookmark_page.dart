/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-15
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/core/presentation/widgets/notice_tile_widget.dart';
import 'package:inha_notice/core/presentation/widgets/rounded_toggle_widget.dart';
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_sorting_type.dart';
import 'package:inha_notice/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:inha_notice/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:inha_notice/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:inha_notice/features/bookmark/presentation/widgets/bookmark_refresh_header_widget.dart';
import 'package:inha_notice/features/notice/presentation/pages/base_notice_board_page.dart';
import 'package:inha_notice/injection_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// **BookmarkPage**
///
/// 이 클래스는 북마크 된 공지사항을 한 곳에서 관리 가능하도록 제공하는 클래스입니다.
/// 사용자는 모든 북마크 된 공지사항을 관리할 수 있습니다.
///
/// ### 주요 기능:
/// - 북마크 관리(삭제)
/// - 공지사항 정렬 옵션 제공(북마크된 순서, 이름순, 날짜순)
class BookmarkPage extends BaseNoticeBoardPage {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends BaseNoticeBoardPageState<BookmarkPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BookmarkBloc>()..add(const LoadBookmarksEvent(isRefresh: false)),
      child: Scaffold(
        appBar: const CommonAppBarWidget(
          title: '북마크',
          titleSize: 20,
          isCenter: false,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Builder(builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              buildMain(),
              buildFooter(),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget buildHeader() {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final BookmarkSortingType currentSortingType = (state is BookmarkLoaded)
            ? state.sortType
            : BookmarkSortingType.newest;

        final bool isEmpty =
            (state is BookmarkLoaded) ? state.bookmarks.isEmpty : true;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RoundedToggleWidget(
                text: '최신순',
                option: 'NEWEST',
                isSelected: currentSortingType == BookmarkSortingType.newest,
                onTap: (_) => context.read<BookmarkBloc>().add(
                      const ChangeSortingEvent(
                        sortType: BookmarkSortingType.newest,
                      ),
                    ),
              ),
              const SizedBox(width: 10),
              RoundedToggleWidget(
                text: '과거순',
                option: 'OLDEST',
                isSelected: currentSortingType == BookmarkSortingType.oldest,
                onTap: (_) => context.read<BookmarkBloc>().add(
                      const ChangeSortingEvent(
                        sortType: BookmarkSortingType.oldest,
                      ),
                    ),
              ),
              const SizedBox(width: 10),
              RoundedToggleWidget(
                text: '이름순',
                option: 'NAME',
                isSelected: currentSortingType == BookmarkSortingType.name,
                onTap: (_) => context.read<BookmarkBloc>().add(
                      const ChangeSortingEvent(
                        sortType: BookmarkSortingType.name,
                      ),
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Theme.of(context).iconTheme.color,
                  size: 25,
                ),
                onPressed: () {
                  if (isEmpty) {
                    AppSnackBar.warn(context, '삭제할 북마크가 없어요.');
                    return;
                  }
                  context.read<BookmarkBloc>().add(ClearBookmarksEvent());
                  AppSnackBar.success(context, '모두 삭제했어요!');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildMain() {
    return Expanded(
      child: BlocConsumer<BookmarkBloc, BookmarkState>(
        listener: (context, state) {
          if (state is BookmarkLoaded || state is BookmarkError) {
            _refreshController.refreshCompleted();
          }
        },
        builder: (context, state) {
          if (state is BookmarkLoading) {
            return const Center(child: BlueLoadingIndicatorWidget());
          }
          if (state is BookmarkError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  fontFamily: AppFont.pretendard.family,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).defaultThemedTextColor,
                ),
              ),
            );
          }
          if (state is BookmarkLoaded) {
            if (state.bookmarks.isEmpty) {
              return Center(
                child: Text(
                  '북마크한 공지사항이 없어요.',
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).fixedGreyText,
                  ),
                ),
              );
            } else {
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: () async {
                  final Completer completer = Completer();
                  context.read<BookmarkBloc>().add(
                        LoadBookmarksEvent(
                            isRefresh: true, completer: completer),
                      );
                  await completer.future;

                  _refreshController.refreshCompleted();
                },
                header: const BookmarkRefreshHeaderWidget(),
                child: ListView.builder(
                  itemCount: state.bookmarks.length,
                  itemBuilder: (context, index) {
                    final NoticeTileModel notice = state.bookmarks[index];
                    final bool isRead = isNoticeRead(notice.id);
                    return NoticeTileWidget(
                      notice: notice,
                      isRead: isRead,
                      isBookmarked: isNoticeBookmarked(notice.id),
                      markNoticeAsRead: markNoticeAsRead,
                      toggleBookmark: toggleBookmark,
                    );
                  },
                ),
              );
            }
          }

          return const SizedBox();
        },
      ),
    );
  }

  // 북마크 페이지는 페이지네이션을 정의하지 않음
  @override
  Widget buildFooter() {
    return const SizedBox();
  }
}
