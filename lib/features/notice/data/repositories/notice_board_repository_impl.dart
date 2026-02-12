/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_type.dart';
import 'package:inha_notice/features/notice/data/datasources/notice_board_remote_data_source.dart';
import 'package:inha_notice/features/notice/data/models/notice_board_model.dart';
import 'package:inha_notice/features/notice/domain/entities/notice_board_entity.dart';
import 'package:inha_notice/features/notice/domain/failures/notice_board_failure.dart';
import 'package:inha_notice/features/notice/domain/repositories/notice_board_repository.dart';

/// **NoticeBoardRepositoryImpl**
/// NoticeBoardRepository의 구현체입니다.
class NoticeBoardRepositoryImpl implements NoticeBoardRepository {
  final NoticeBoardRemoteDataSource remoteDataSource;
  final SharedPrefsManager sharedPrefsManager;

  const NoticeBoardRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPrefsManager,
  });

  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchAbsoluteNotices({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  }) async {
    try {
      final String scraperKey = _resolveScraperKey(noticeType);
      final NoticeBoardModel result =
          await remoteDataSource.fetchAbsoluteNotices(
        noticeType: scraperKey,
        page: page,
        searchColumn: searchColumn,
        searchWord: searchWord,
      );
      return Right(result);
    } catch (e) {
      return Left(NoticeBoardFailure.fetchNotices(e.toString()));
    }
  }

  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  }) async {
    try {
      final NoticeBoardModel result =
          await remoteDataSource.fetchRelativeNotices(
        noticeType: noticeType,
        offset: offset,
      );
      return Right(result);
    } catch (e) {
      return Left(NoticeBoardFailure.fetchNotices(e.toString()));
    }
  }

  /// noticeType에 대한 스크래퍼 키를 결정합니다.
  /// 유저 설정이 필요한 타입(학과, 단과대, 대학원)은 SharedPreferences에서 키를 가져옵니다.
  String _resolveScraperKey(String noticeType) {
    final tabType = CustomTabType.fromNoticeType(noticeType);
    if (tabType == null) return noticeType;

    final prefKey = tabType.userSettingPrefKey;
    if (prefKey == null) return noticeType;

    return sharedPrefsManager.getValue<String>(prefKey) ?? noticeType;
  }
}
