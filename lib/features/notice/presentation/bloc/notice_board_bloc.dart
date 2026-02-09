/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/constants/page_constants.dart';
import 'package:inha_notice/core/keys/custom_tab_keys.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/core/utils/read_notice_manager.dart';
import 'package:inha_notice/features/notice/domain/entities/notice_board_entity.dart';
import 'package:inha_notice/features/notice/domain/failures/notice_board_failure.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_notices_use_case.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_event.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_state.dart';
import 'package:inha_notice/utils/custom_tab_list_utils/custom_tab_list_utils.dart';

class NoticeBoardBloc extends Bloc<NoticeBoardEvent, NoticeBoardState> {
  final GetAbsoluteNoticesUseCase getAbsoluteNoticesUseCase;
  final GetRelativeNoticesUseCase getRelativeNoticesUseCase;

  late String _noticeType;
  bool _isRelativeStyle = false;
  bool _isKeywordSearchable = false;
  bool _isPullRefreshing = false;
  Pages _currentPages = createPages();

  NoticeBoardBloc({
    required this.getAbsoluteNoticesUseCase,
    required this.getRelativeNoticesUseCase,
  }) : super(NoticeBoardInitial()) {
    on<LoadNoticeBoardEvent>(_onLoadNoticeBoard);
    on<LoadPageEvent>(_onLoadPage);
    on<LoadOffsetEvent>(_onLoadOffset);
    on<ToggleNoticeTypeEvent>(_onToggleNoticeType);
    on<SearchByKeywordEvent>(_onSearchByKeyword);
    on<RefreshNoticeBoardEvent>(_onRefresh);
    on<MarkNoticeAsReadEvent>(_onMarkNoticeAsRead);
  }

  Future<void> _onLoadNoticeBoard(
      LoadNoticeBoardEvent event, Emitter<NoticeBoardState> emit) async {
    _noticeType = event.noticeType;
    _isRelativeStyle = (event.noticeType == CustomTabKeys.LIBRARY);

    // 키워드 검색 가능 여부 판단
    _isKeywordSearchable = _checkKeywordSearchable(event.noticeType);

    // 유저 설정이 필요한 타입인지 확인
    if (CustomTabListUtils.isUserSettingType(event.noticeType)) {
      final String? userSettingKey =
          CustomTabListUtils.loadUserSettingKey(event.noticeType);
      if (userSettingKey == null) {
        final String? displayName =
            CustomTabListUtils.kTabMappingOnValue[event.noticeType];
        emit(NoticeBoardSettingRequired(
          noticeType: event.noticeType,
          displayName: displayName,
        ));
        return;
      }
    }

    emit(NoticeBoardLoading());

    if (_isRelativeStyle) {
      await _fetchRelativeNotices(
          emit, PageConstants.kInitialRelativePage, true);
    } else {
      await _fetchAbsoluteNotices(
          emit, PageConstants.kInitialAbsolutePage, true);
    }
  }

  Future<void> _onLoadPage(
      LoadPageEvent event, Emitter<NoticeBoardState> emit) async {
    emit(NoticeBoardLoading());
    await _fetchAbsoluteNotices(
        emit, event.page, false, event.searchColumn, event.searchWord);
  }

  Future<void> _onLoadOffset(
      LoadOffsetEvent event, Emitter<NoticeBoardState> emit) async {
    emit(NoticeBoardLoading());
    await _fetchRelativeNotices(emit, event.offset, false);
  }

  Future<void> _onToggleNoticeType(
      ToggleNoticeTypeEvent event, Emitter<NoticeBoardState> emit) async {
    if (state is NoticeBoardLoaded) {
      final current = state as NoticeBoardLoaded;
      emit(current.copyWith(isHeadlineSelected: event.isHeadline));
    }
  }

  Future<void> _onSearchByKeyword(
      SearchByKeywordEvent event, Emitter<NoticeBoardState> emit) async {
    // 키워드 검색 시 일반으로 전환
    emit(NoticeBoardLoading());
    await _fetchAbsoluteNotices(
      emit,
      PageConstants.kInitialAbsolutePage,
      true,
      event.searchColumn,
      event.searchWord,
    );
  }

  Future<void> _onRefresh(
      RefreshNoticeBoardEvent event, Emitter<NoticeBoardState> emit) async {
    _isPullRefreshing = true;
    try {
      if (_isRelativeStyle) {
        await _fetchRelativeNotices(
            emit, PageConstants.kInitialRelativePage, true);
      } else {
        await _fetchAbsoluteNotices(
            emit, PageConstants.kInitialAbsolutePage, true);
      }
    } finally {
      _isPullRefreshing = false;
    }
  }

  Future<void> _onMarkNoticeAsRead(
      MarkNoticeAsReadEvent event, Emitter<NoticeBoardState> emit) async {
    await ReadNoticeManager.addReadNotice(event.noticeId);
    // 현재 상태가 Loaded면 다시 emit하여 UI 갱신
    if (state is NoticeBoardLoaded) {
      final current = state as NoticeBoardLoaded;
      emit(current.copyWith());
    }
  }

  Future<void> _fetchAbsoluteNotices(
    Emitter<NoticeBoardState> emit,
    int page,
    bool updatePages, [
    String? searchColumn,
    String? searchWord,
  ]) async {
    final Either<NoticeBoardFailure, NoticeBoardEntity> result =
        await getAbsoluteNoticesUseCase(
      noticeType: _noticeType,
      page: page,
      searchColumn: searchColumn,
      searchWord: searchWord,
    );

    result.fold(
      (failure) => emit(NoticeBoardError(message: failure.message)),
      (entity) {
        final bool isKeywordSearch =
            (searchColumn != null && searchColumn.isNotEmpty) ||
                (searchWord != null && searchWord.isNotEmpty);

        Pages pages = _currentPages;
        if (page == PageConstants.kInitialAbsolutePage) {
          if (pages['pageMetas'].isEmpty ||
              isKeywordSearch ||
              _isPullRefreshing) {
            pages = Pages.from(entity.pages);
          }
        }
        _currentPages = pages;

        emit(NoticeBoardLoaded(
          headlineNotices: entity.headlineNotices,
          generalNotices: entity.generalNotices,
          pages: pages,
          currentPage: page,
          isHeadlineSelected: false,
          isKeywordSearchable: _isKeywordSearchable,
        ));
      },
    );
  }

  Future<void> _fetchRelativeNotices(
    Emitter<NoticeBoardState> emit,
    int offset,
    bool updatePages,
  ) async {
    final Either<NoticeBoardFailure, NoticeBoardEntity> result =
        await getRelativeNoticesUseCase(
      noticeType: _noticeType,
      offset: offset,
    );

    result.fold(
      (failure) => emit(NoticeBoardError(message: failure.message)),
      (entity) {
        Pages pages = _currentPages;
        if (offset == PageConstants.kInitialRelativePage &&
            pages['pageMetas'].isEmpty) {
          pages = Pages.from(entity.pages);
        }
        _currentPages = pages;

        final int currentPage = (offset ~/ 10) + 1;
        emit(NoticeBoardLoaded(
          headlineNotices: entity.headlineNotices,
          generalNotices: entity.generalNotices,
          pages: pages,
          currentPage: currentPage,
          isHeadlineSelected: false,
          isKeywordSearchable: false,
        ));
      },
    );
  }

  bool _checkKeywordSearchable(String noticeType) {
    return noticeType == CustomTabKeys.WHOLE ||
        noticeType == CustomTabKeys.SCHOLARSHIP ||
        noticeType == CustomTabKeys.RECRUITMENT ||
        noticeType == CustomTabKeys.INTERNATIONAL ||
        noticeType == CustomTabKeys.SWUNIV ||
        noticeType == CustomTabKeys.INHAHUSS ||
        CustomTabListUtils.isMajorType(noticeType) ||
        noticeType == CustomTabKeys.COLLEGE ||
        noticeType == CustomTabKeys.GRADUATESCHOOL;
  }
}
