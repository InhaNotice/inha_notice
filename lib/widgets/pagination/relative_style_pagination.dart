import 'base_pagination.dart';

class RelativeStylePagination extends BasePagination {
  final String pageType;

  const RelativeStylePagination({
    super.key,
    required this.pageType,
    required super.pages,
    required super.currentPage,
    required super.loadNotices,
  });

  @override
  int getRelativePage(Map<String, dynamic> pageData) {
    return (pageType == 'LIBRARY')
        ? pageData['offset']
        : pageData['startCount'];
  }
}
