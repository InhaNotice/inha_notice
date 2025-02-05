abstract class HeadlineTagSelectors {
  static const String kNoticeBoard = '.artclTable .headline';
  static const String kNoticeTitleLink = '._artclTdTitle .artclLinkView';
  static const String kNoticeTitleStrong = '._artclTdTitle .artclLinkView strong';
  static const String kNoticeDate = '._artclTdRdate';
  static const String kNoticeWriter = '._artclTdWriter';
  static const String kNoticeAccess = '._artclTdAccess';
}

abstract class GeneralTagSelectors {
  static const String kNoticeBoard = '.artclTable tr:not(.headline)';
  static const String kNoticeTitleLink = '._artclTdTitle .artclLinkView';
  static const String kNoticeTitleStrong = '._artclTdTitle .artclLinkView strong';
  static const String kNoticeDate = '._artclTdRdate';
  static const String kNoticeWriter = '._artclTdWriter';
  static const String kNoticeAccess = '._artclTdAccess';
}
abstract class PageTagSelectors {
  static const String kPageBoard = '._paging ._inner';
  static const String kLastPage = 'a._last';
}