/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';

/// **PaginationWidget**
/// Absolute/Relative 스타일의 페이지네이션을 통합한 위젯입니다.
class PaginationWidget extends StatelessWidget {
  final Pages pages;
  final int currentPage;
  final bool isRelativeStyle;
  final void Function(int page) onAbsolutePageTap;
  final void Function(int offset)? onRelativePageTap;
  final String? searchColumn;
  final String? searchWord;

  const PaginationWidget({
    super.key,
    required this.pages,
    required this.currentPage,
    this.isRelativeStyle = false,
    required this.onAbsolutePageTap,
    this.onRelativePageTap,
    this.searchColumn,
    this.searchWord,
  });

  @override
  Widget build(BuildContext context) {
    if (pages['pageMetas'].isEmpty) {
      return const SizedBox.shrink();
    }

    final pageButtonBackgroundColor =
        Theme.of(context).scaffoldBackgroundColor;
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
          children: pages['pageMetas'].map<Widget>((pageMeta) {
            final int pageNumber = pageMeta['page'];
            final bool isCurrentPage = (pageNumber == currentPage);

            return TextButton(
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: isCurrentPage
                  ? null
                  : () {
                      if (isRelativeStyle) {
                        final int relativeValue =
                            pageMeta['offset'] ?? pageMeta['startCount'] ?? 0;
                        onRelativePageTap?.call(relativeValue);
                      } else {
                        onAbsolutePageTap(pageMeta['page']);
                      }
                    },
              child: Text(
                pageNumber.toString(),
                style: TextStyle(
                  fontFamily: AppFont.pretendard.family,
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
}
