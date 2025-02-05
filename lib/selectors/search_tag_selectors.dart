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
  static const String kPageBoard = '.btn_num a.num';
}
