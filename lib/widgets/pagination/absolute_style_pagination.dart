/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-10
 */
import 'base_pagination.dart';

/// **AbsoluteStylePagination**
/// 이 클래스는 절댓값으로 정해지는 페이지네이션을 정의하는 클래스입니다.
class AbsoluteStylePagination extends BasePagination {
  const AbsoluteStylePagination({
    super.key,
    required super.pages,
    required super.currentPage,
    required super.loadNotices,
  });

  @override
  int getRelativePage(Map<String, dynamic> pageData) {
    return pageData['page'];
  }
}
