/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

abstract class NoticeTagSelectors {
  static const String kNoticeBoard = 'dl.resultsty_1';
  static const String kNoticeTitle = 'dt > a.tit';
  static const String kNoticeTitleHref = 'href';
  static const String kNoticeBody = 'dd';
  static const String kNoticeDate = 'dt > span.tit_date';
  static const String kAttributeTitle = 'title';
  static const String kAttributeOnClick = 'onclick';
}

abstract class PageTagSelectors {
  static const String kPageBoard = 'a.num';
}
