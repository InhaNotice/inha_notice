/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-11
 */
import 'package:html/dom.dart';
import 'package:inha_notice/constants/identifier_constants.dart';

/// **BaseAbsoluteStyleNoticeScraper**
/// 이 클래스는 Absolute Style의 공지사항을 크롤링을 정의하는 추상 클래스입니다.
abstract class BaseAbsoluteStyleNoticeScraper {
  Future<Map<String, dynamic>> fetchNotices(int page, String noticeType);

  List<Map<String, String>> fetchHeadlineNotices(Document document);

  List<Map<String, String>> fetchGeneralNotices(Document document);

  List<Map<String, dynamic>> fetchPages(Document document);

  String makeUniqueNoticeId(String postUrl) {
    // postUrl이 빈 문자열인지 확인
    if (postUrl.isEmpty) {
      return IdentifierConstants.kUnknownId;
    }

    final List<String> postUrlList = postUrl.split('/');
    // postUrlList가 정해진 규격을 따르는지 확인
    if (postUrlList.length <= 4) {
      return IdentifierConstants.kUnknownId;
    }

    final String provider = postUrlList[2];
    final String postId = postUrlList[4];
    final String uniqueNoticeId = '$provider-$postId';
    return uniqueNoticeId;
  }
}
