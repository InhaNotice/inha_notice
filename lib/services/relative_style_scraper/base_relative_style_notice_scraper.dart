abstract class BaseRelativeStyleNoticeScraper {
  Future<Map<String, dynamic>> fetchNotices(int offset);

  Future<List<Map<String, String>>> fetchNoticesWithParams(
      Map<String, String> params);

  List<Map<String, dynamic>> fetchPages();

  String makeUniqueNoticeId(String postId);
}
