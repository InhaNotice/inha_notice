import 'base_pagination.dart';

class RelativePagination extends BasePagination {
  final String pageType;

  const RelativePagination({
    super.key,
    required this.pageType,
    required List<Map<String, dynamic>> pages,
    required int currentPage,
    required Function(int) loadNotices,
  }) : super(pages: pages, currentPage: currentPage, loadNotices: loadNotices);

  @override
  int getRelativePage(Map<String, dynamic> pageData) {
    return (pageType == 'LIBRARY')
        ? pageData['offset']
        : pageData['startCount'];
  }
}
