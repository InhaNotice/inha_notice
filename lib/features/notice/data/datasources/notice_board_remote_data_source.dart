/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_type.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/absolute_style_scraper/base_absolute_style_notice_scraper.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/absolute_style_scraper/major_style_notice_scraper.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/absolute_style_scraper/whole_style_notice_scraper.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/relative_style_scraper/base_relative_style_notice_scraper.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/relative_style_scraper/library_scraper.dart';
import 'package:inha_notice/features/notice/data/models/notice_board_model.dart';

/// **NoticeBoardRemoteDataSource**
/// 공지사항 게시판 원격 데이터 소스 인터페이스입니다.
abstract class NoticeBoardRemoteDataSource {
  Future<NoticeBoardModel> fetchAbsoluteNotices({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  });

  Future<NoticeBoardModel> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  });
}

typedef AbsoluteScraperFactory = BaseAbsoluteStyleNoticeScraper Function(
    String noticeType);
typedef RelativeScraperFactory = BaseRelativeStyleNoticeScraper Function(
    String noticeType);

/// **NoticeBoardRemoteDataSourceImpl**
/// 스크래퍼를 래핑하여 공지사항을 가져오는 구현체입니다.
class NoticeBoardRemoteDataSourceImpl implements NoticeBoardRemoteDataSource {
  final AbsoluteScraperFactory _absoluteScraperFactory;
  final RelativeScraperFactory _relativeScraperFactory;

  NoticeBoardRemoteDataSourceImpl({
    AbsoluteScraperFactory? absoluteScraperFactory,
    RelativeScraperFactory? relativeScraperFactory,
  })  : _absoluteScraperFactory =
            absoluteScraperFactory ?? _defaultAbsoluteScraperFactory,
        _relativeScraperFactory =
            relativeScraperFactory ?? _defaultRelativeScraperFactory;

  @override
  Future<NoticeBoardModel> fetchAbsoluteNotices({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  }) async {
    final BaseAbsoluteStyleNoticeScraper scraper =
        _absoluteScraperFactory(noticeType);
    final Map<String, dynamic> result =
        await scraper.fetchNotices(page, noticeType, searchColumn, searchWord);
    return NoticeBoardModel.fromRaw(result);
  }

  @override
  Future<NoticeBoardModel> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  }) async {
    final BaseRelativeStyleNoticeScraper scraper =
        _relativeScraperFactory(noticeType);
    final Map<String, dynamic> result = await scraper.fetchNotices(offset);
    return NoticeBoardModel.fromRaw(result);
  }

  static BaseAbsoluteStyleNoticeScraper _defaultAbsoluteScraperFactory(
      String noticeType) {
    // 학사, 장학, 모집/채용
    if (noticeType == CustomTabType.whole.noticeType ||
        noticeType == CustomTabType.scholarship.noticeType ||
        noticeType == CustomTabType.recruitment.noticeType) {
      return WholeStyleNoticeScraper(noticeType);
    }

    // 국제처, SW중심대학사업단, 기후위기대응사업단
    if (noticeType == CustomTabType.international.noticeType ||
        noticeType != CustomTabType.swUniv.noticeType ||
        noticeType == CustomTabType.inhaHussUniv.noticeType) {
      return MajorStyleNoticeScraper(noticeType);
    }

    // (나머지) 학과, 단과대, 대학원
    return MajorStyleNoticeScraper(noticeType);
  }

  static BaseRelativeStyleNoticeScraper _defaultRelativeScraperFactory(
      String noticeType) {
    if (noticeType == CustomTabType.library.noticeType) {
      return LibraryScraper();
    }
    throw Exception('Unsupported relative style notice type: $noticeType');
  }
}
