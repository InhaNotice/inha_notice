/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

enum BookmarkDefaultSortType {
  newest('newest', '최신순'),
  oldest('oldest', '과거순'),
  name('name', '이름순');

  final String value;
  final String displayName;

  const BookmarkDefaultSortType(this.value, this.displayName);

  static BookmarkDefaultSortType fromValue(String value) {
    return values.firstWhere(
      (type) => type.value == value,
      orElse: () => BookmarkDefaultSortType.newest,
    );
  }
}
