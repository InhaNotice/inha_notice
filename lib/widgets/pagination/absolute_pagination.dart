import 'base_pagination.dart';

class AbsolutePagination extends BasePagination {
  const AbsolutePagination({
    super.key,
    required List<Map<String, dynamic>> pages,
    required int currentPage,
    required Function(int) loadNotices,
  }) : super(pages: pages, currentPage: currentPage, loadNotices: loadNotices);

  @override
  int getRelativePage(Map<String, dynamic> pageData) {
    return pageData['page']; // 절대 페이지 번호 그대로 반환
  }
}
