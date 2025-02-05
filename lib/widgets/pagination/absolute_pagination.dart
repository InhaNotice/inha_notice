import 'base_pagination.dart';

class AbsolutePagination extends BasePagination {
  const AbsolutePagination({
    super.key,
    required super.pages,
    required super.currentPage,
    required super.loadNotices,
  });

  @override
  int getRelativePage(Map<String, dynamic> pageData) {
    return pageData['page']; // 절대 페이지 번호 그대로 반환
  }
}
