/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

abstract class HeadlineTagSelectors {
  static const String kNoticeBoard = '.artclTable .headline';
  static const String kNoticeTitleLink = '._artclTdTitle .artclLinkView';
  static const String kNoticeTitleStrong =
      '._artclTdTitle .artclLinkView strong';
  static const String kNoticeDate = '._artclTdRdate';
  static const String kNoticeWriter = '._artclTdWriter';
  static const String kNoticeAccess = '._artclTdAccess';
}

abstract class GeneralTagSelectors {
  static const String kNoticeBoard = '.artclTable tr:not(.headline)';
  static const String kNoticeTitleLink = '._artclTdTitle .artclLinkView';
  static const String kNoticeTitleStrong =
      '._artclTdTitle .artclLinkView strong';
  static const String kNoticeDate = '._artclTdRdate';
  static const String kNoticeWriter = '._artclTdWriter';
  static const String kNoticeAccess = '._artclTdAccess';
}

abstract class PageTagSelectors {
  static const String kPageBoard = '._paging ._inner';
  static const String kLastPage = 'a._last';
}
