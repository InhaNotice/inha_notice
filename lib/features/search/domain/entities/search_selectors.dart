/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

abstract class SearchSelectors {
  /// 검색 결과 리스트 아이템 관련 선택자
  static const result = _SearchResultSelectors();

  /// 검색 페이지네이션 관련 선택자
  static const pagination = _SearchPaginationSelectors();
}

class _SearchResultSelectors {
  const _SearchResultSelectors();

  /// 검색 결과 리스트 컨테이너/아이템 (dl.resultsty_1)
  final String item = 'dl.resultsty_1';

  /// 제목 (a 태그)
  final String title = 'dt > a.tit';

  /// 제목 내 링크 속성명
  final String hrefAttr = 'href';

  /// 본문 미리보기
  final String body = 'dd';

  /// 날짜
  final String date = 'dt > span.tit_date';

  /// [속성] 타이틀 (a 태그의 title 속성)
  final String attrTitle = 'title';

  /// [속성] 온클릭 (자바스크립트 호출용)
  final String attrOnClick = 'onclick';
}

class _SearchPaginationSelectors {
  const _SearchPaginationSelectors();

  /// 페이지 번호 링크
  final String number = 'a.num';
}
