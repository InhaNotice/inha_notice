/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';

/// **BasePagination**
/// 이 클래스는 페이지네이션을 정의하는 추상 클래스입니다.
abstract class BasePagination extends StatelessWidget {
  final List<Map<String, dynamic>> pages;
  final int currentPage;
  final Function(int) loadNotices;

  const BasePagination({
    super.key,
    required this.pages,
    required this.currentPage,
    required this.loadNotices,
  });

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return const SizedBox.shrink();
    }

    final pageButtonBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final selectedPageButtonTextColor =
        Theme.of(context).selectedPageButtonTextColor;
    final unSelectedPageButtonTextColor =
        Theme.of(context).unSelectedPageButtonTextColor;

    return Container(
      color: pageButtonBackgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: pages.map<Widget>((pageData) {
            final int pageNumber = pageData['page'];
            final bool isCurrentPage = (pageNumber == currentPage);
            final int relativePage = getRelativePage(pageData);

            return TextButton(
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: isCurrentPage ? null : () => loadNotices(relativePage),
              child: Text(
                pageNumber.toString(),
                style: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontSize: 14,
                  fontWeight:
                      isCurrentPage ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentPage
                      ? selectedPageButtonTextColor
                      : unSelectedPageButtonTextColor,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// **각 서브 클래스에서 페이지 계산 방식이 다르므로 오버라이딩 필수**
  int getRelativePage(Map<String, dynamic> pageData);
}
