/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-18
 */

abstract class NoticeSelectors {
  /// - 인하대 공식 홈페이지 (전체공지[학사], 장학, 모집/채용)
  /// - 학과 스타일(MajorStyle) 게시판
  static const standard = _StandardSelectors();
}

class _StandardSelectors {
  const _StandardSelectors();

  final headline = const _StandardHeadline();

  final general = const _StandardGeneral();

  final pagination = const _StandardPagination();
}

/// 표준 스타일의 중요 공지사항 선택자
class _StandardHeadline {
  const _StandardHeadline();

  /// 공지사항 행(Row) 전체
  final String row = '.artclTable .headline';

  /// 제목 (링크 포함)
  final String title = '._artclTdTitle .artclLinkView';

  /// 제목 강조 태그 (Strong)
  final String titleStrong = '._artclTdTitle .artclLinkView strong';

  /// 작성일
  final String date = '._artclTdRdate';

  /// 작성자
  final String writer = '._artclTdWriter';

  /// 조회수
  final String access = '._artclTdAccess';
}

/// 표준 스타일의 일반 공지사항 선택자
class _StandardGeneral {
  const _StandardGeneral();

  /// 일반 게시글 행(Row) 전체 (헤드라인 제외)
  final String row = '.artclTable tr:not(.headline)';

  /// 제목 (링크 포함)
  final String title = '._artclTdTitle .artclLinkView';

  /// 제목 강조 태그 (Strong)
  final String titleStrong = '._artclTdTitle .artclLinkView strong';

  /// 작성일
  final String date = '._artclTdRdate';

  /// 작성자
  final String writer = '._artclTdWriter';

  /// 조회수
  final String access = '._artclTdAccess';
}

/// 표준 스타일의 페이지네이션 선택자
class _StandardPagination {
  const _StandardPagination();

  /// 페이지 번호 컨테이너
  final String container = '._paging ._inner';

  /// 마지막 페이지 버튼
  final String lastPageParams = 'a._last';
}
