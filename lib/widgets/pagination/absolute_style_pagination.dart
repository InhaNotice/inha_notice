import 'base_pagination.dart';

/// **AbsoluteStylePagination**
/// 이 클래스는 절댓값으로 정해지는 페이지네이션을 정의하는 클래스입니다.
class AbsoluteStylePagination extends BasePagination {
  const AbsoluteStylePagination({
    super.key,
    required super.pages,
    required super.currentPage,
    required super.loadNotices,
  });

  @override
  int getRelativePage(Map<String, dynamic> pageData) {
    return pageData['page'];
  }
}
