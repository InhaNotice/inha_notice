/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/notice/data/datasources/home_local_data_source.dart';
import 'package:inha_notice/features/notice/data/datasources/notice_board_remote_data_source.dart';
import 'package:inha_notice/features/notice/data/models/home_tab_model.dart';
import 'package:inha_notice/features/notice/data/models/notice_board_model.dart';
import 'package:inha_notice/features/notice/data/repositories/home_repository_impl.dart';
import 'package:inha_notice/features/notice/data/repositories/notice_board_repository_impl.dart';

class _FakeNoticeBoardRemoteDataSource implements NoticeBoardRemoteDataSource {
  NoticeBoardModel absoluteResult = const NoticeBoardModel(
    headlineNotices: [],
    generalNotices: [],
    pages: {'pageMetas': [], 'searchOptions': {}},
  );
  NoticeBoardModel relativeResult = const NoticeBoardModel(
    headlineNotices: [],
    generalNotices: [],
    pages: {'pageMetas': [], 'searchOptions': {}},
  );
  Object? absoluteError;
  Object? relativeError;

  String? lastNoticeType;
  int? lastPage;
  int? lastOffset;

  @override
  Future<NoticeBoardModel> fetchAbsoluteNotices({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  }) async {
    if (absoluteError != null) {
      throw absoluteError!;
    }
    lastNoticeType = noticeType;
    lastPage = page;
    return absoluteResult;
  }

  @override
  Future<NoticeBoardModel> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  }) async {
    if (relativeError != null) {
      throw relativeError!;
    }
    lastNoticeType = noticeType;
    lastOffset = offset;
    return relativeResult;
  }
}

class _FakeSharedPrefsManager extends SharedPrefsManager {
  _FakeSharedPrefsManager() : super(null);

  final Map<String, dynamic> values = {};

  @override
  T? getValue<T>(String key) {
    final value = values[key];
    if (value is T) return value;
    return null;
  }
}

class _FakeHomeLocalDataSource implements HomeLocalDataSource {
  List<HomeTabModel> result = const [];
  Object? error;

  @override
  Future<List<HomeTabModel>> fetchHomeTabs() async {
    if (error != null) {
      throw error!;
    }
    return result;
  }
}

void main() {
  group('NoticeBoardRepositoryImpl 유닛 테스트', () {
    test('fetchAbsoluteNotices는 유저 설정 학과 키를 스크래퍼 키로 사용한다', () async {
      final remote = _FakeNoticeBoardRemoteDataSource();
      final prefs = _FakeSharedPrefsManager()..values['major-key'] = 'CSE';
      final repository = NoticeBoardRepositoryImpl(
        remoteDataSource: remote,
        sharedPrefsManager: prefs,
      );

      final result = await repository.fetchAbsoluteNotices(
        noticeType: 'MAJOR',
        page: 1,
      );

      expect(result.isRight(), isTrue);
      expect(remote.lastNoticeType, 'CSE');
    });

    test('fetchAbsoluteNotices 실패 시 fetchNotices Failure를 반환한다', () async {
      final remote = _FakeNoticeBoardRemoteDataSource()
        ..absoluteError = Exception('network failed');
      final prefs = _FakeSharedPrefsManager();
      final repository = NoticeBoardRepositoryImpl(
        remoteDataSource: remote,
        sharedPrefsManager: prefs,
      );

      final result = await repository.fetchAbsoluteNotices(
        noticeType: 'WHOLE',
        page: 1,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('network failed')),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('fetchRelativeNotices 성공 시 Right를 반환한다', () async {
      final remote = _FakeNoticeBoardRemoteDataSource();
      final prefs = _FakeSharedPrefsManager();
      final repository = NoticeBoardRepositoryImpl(
        remoteDataSource: remote,
        sharedPrefsManager: prefs,
      );

      final result = await repository.fetchRelativeNotices(
        noticeType: 'LIBRARY',
        offset: 10,
      );

      expect(result.isRight(), isTrue);
      expect(remote.lastNoticeType, 'LIBRARY');
      expect(remote.lastOffset, 10);
    });
  });

  group('HomeRepositoryImpl 유닛 테스트', () {
    test('getHomeTabs 성공 시 Right를 반환한다', () async {
      final local = _FakeHomeLocalDataSource()
        ..result = const [HomeTabModel(noticeType: 'WHOLE', label: '학사')];
      final repository = HomeRepositoryImpl(localDataSource: local);

      final result = await repository.getHomeTabs();

      expect(result.isRight(), isTrue);
    });

    test('getHomeTabs 실패 시 tabs Failure를 반환한다', () async {
      final local = _FakeHomeLocalDataSource()..error = Exception('prefs');
      final repository = HomeRepositoryImpl(localDataSource: local);

      final result = await repository.getHomeTabs();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('prefs')),
        (_) => fail('Left 이어야 합니다.'),
      );
    });
  });
}
