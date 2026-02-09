/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:inha_notice/core/keys/custom_tab_keys.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/absolute_style_scraper/base_absolute_style_notice_scraper.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/absolute_style_scraper/inha_design_style_notice_scraper.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/absolute_style_scraper/major_style_notice_scraper.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/absolute_style_scraper/whole_style_notice_scraper.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/relative_style_scraper/base_relative_style_notice_scraper.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/relative_style_scraper/library_scraper.dart';
import 'package:inha_notice/features/notice/data/models/notice_board_model.dart';
import 'package:inha_notice/features/notice/domain/entities/major_type.dart';

/// **NoticeBoardRemoteDataSource**
/// 공지사항 게시판 원격 데이터 소스 인터페이스입니다.
abstract class NoticeBoardRemoteDataSource {
  Future<NoticeBoardModel> fetchAbsoluteNotices({
    required String noticeType,
    required String scraperKey,
    required int page,
    String? searchColumn,
    String? searchWord,
  });

  Future<NoticeBoardModel> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  });
}

/// **NoticeBoardRemoteDataSourceImpl**
/// 스크래퍼를 래핑하여 공지사항을 가져오는 구현체입니다.
class NoticeBoardRemoteDataSourceImpl implements NoticeBoardRemoteDataSource {
  @override
  Future<NoticeBoardModel> fetchAbsoluteNotices({
    required String noticeType,
    required String scraperKey,
    required int page,
    String? searchColumn,
    String? searchWord,
  }) async {
    final BaseAbsoluteStyleNoticeScraper scraper =
        _createAbsoluteScraper(noticeType, scraperKey);
    final Map<String, dynamic> result =
        await scraper.fetchNotices(page, noticeType, searchColumn, searchWord);
    return _convertToModel(result);
  }

  @override
  Future<NoticeBoardModel> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  }) async {
    final BaseRelativeStyleNoticeScraper scraper =
        _createRelativeScraper(noticeType);
    final Map<String, dynamic> result = await scraper.fetchNotices(offset);
    return _convertToModel(result);
  }

  BaseAbsoluteStyleNoticeScraper _createAbsoluteScraper(
      String noticeType, String scraperKey) {
    // 학사, 장학, 모집/채용
    if (noticeType == CustomTabKeys.WHOLE ||
        noticeType == CustomTabKeys.SCHOLARSHIP ||
        noticeType == CustomTabKeys.RECRUITMENT) {
      return WholeStyleNoticeScraper(noticeType);
    }

    // 국제처, SW중심대학사업단, 기후위기대응사업단
    if (noticeType == CustomTabKeys.INTERNATIONAL ||
        noticeType == CustomTabKeys.SWUNIV ||
        noticeType == CustomTabKeys.INHAHUSS) {
      return MajorStyleNoticeScraper(noticeType);
    }

    // (예외) 디자인융합학과
    if (scraperKey == MajorType.inhaDesign.key) {
      return InhaDesignStyleNoticeScraper(scraperKey);
    }

    // (나머지) 학과, 단과대, 대학원
    return MajorStyleNoticeScraper(scraperKey);
  }

  BaseRelativeStyleNoticeScraper _createRelativeScraper(String noticeType) {
    if (noticeType == CustomTabKeys.LIBRARY) {
      return LibraryScraper();
    }
    throw Exception('Unsupported relative style notice type: $noticeType');
  }

  NoticeBoardModel _convertToModel(Map<String, dynamic> raw) {
    final List<dynamic> rawHeadline = raw['headline'] ?? [];
    final List<dynamic> rawGeneral = raw['general'] ?? [];
    final Pages pages = raw['pages'] ?? createPages();

    final List<NoticeTileModel> headlineNotices = rawHeadline
        .map((e) => NoticeTileModel.fromMap(e as Map<String, dynamic>))
        .toList();
    final List<NoticeTileModel> generalNotices = rawGeneral
        .map((e) => NoticeTileModel.fromMap(e as Map<String, dynamic>))
        .toList();

    return NoticeBoardModel(
      headlineNotices: headlineNotices,
      generalNotices: generalNotices,
      pages: pages,
    );
  }
}
