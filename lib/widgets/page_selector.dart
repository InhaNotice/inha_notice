import 'package:flutter/material.dart';

class PageSelector extends StatelessWidget {
  final List<Map<String, dynamic>> pages;
  final int currentPage;
  final Function(int) onPageSelected;

  const PageSelector({
    super.key,
    required this.pages,
    required this.currentPage,
    required this.onPageSelected,
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
            final bool isCurrentPage = (pageNumber == currentPage);
            return TextButton(
              onPressed: isCurrentPage
                  ? null
                  : () {
                onPageSelected(pageNumber);
              },
              child: Text(
                pageNumber.toString(),
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
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