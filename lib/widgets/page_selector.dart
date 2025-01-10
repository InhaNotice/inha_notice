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
      return const SizedBox.shrink(); // 페이지가 없을 경우 빈 위젯 반환
    }

    return Container(
      color: const Color(0xFF292929),
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
                  fontWeight:
                  isCurrentPage ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentPage ? Colors.white : Colors.white60,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}