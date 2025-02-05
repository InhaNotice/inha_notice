import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';

class RelativePagination extends StatelessWidget {
  final String pageType;
  final List<Map<String, dynamic>> pages;
  final int currentPage;
  final Function(int) loadNotices;

  const RelativePagination({
    super.key,
    required this.pageType,
    required this.pages,
    required this.currentPage,
    required this.loadNotices,
  });

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return const SizedBox.shrink();
    }

    // 테마 기반 색상 설정
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final currentPageColor = Theme.of(context).textTheme.bodyLarge?.color;
    const otherPageColor = Colors.grey;

    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: pages.map<Widget>((pageData) {
            final int pageNumber = pageData['page'];
            final int relativePage = (pageType == 'LIBRARY')
                ? pageData['offset']
                : pageData['startCount'];
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
                      loadNotices(relativePage);
                    },
              child: Text(
                pageNumber.toString(),
                style: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontSize: 14,
                  fontWeight:
                      isCurrentPage ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentPage ? currentPageColor : otherPageColor,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
