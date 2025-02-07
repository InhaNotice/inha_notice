import 'package:html/dom.dart';
import 'package:inha_notice/constants/identifier_constants.dart';

abstract class BaseAbsoluteStyleNoticeScraper {
  Future<Map<String, dynamic>> fetchNotices(int page, String noticeType);

  List<Map<String, String>> fetchHeadlineNotices(Document document);

  List<Map<String, String>> fetchGeneralNotices(Document document);

  List<Map<String, dynamic>> fetchPages(Document document);

  String makeUniqueNoticeId(String postUrl) {
    // postUrl이 빈 문자열인지 확인합니다.
    if (postUrl.isEmpty) {
      return IdentifierConstants.kUnknownId;
    }

    final List<String> postUrlList = postUrl.split('/');
    // postUrlList가 정해진 규격을 따르는지 확인합니다.
    if (postUrlList.length <= 4) {
      return IdentifierConstants.kUnknownId;
    }

    final String provider = postUrlList[2];
    final String postId = postUrlList[4];
    final String uniqueNoticeId = '$provider-$postId';
    return uniqueNoticeId;
  }
}
