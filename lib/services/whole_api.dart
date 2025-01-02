import 'package:http/http.dart' as http;
import 'package:html/parser.dart';


class WholeAPI {
  Future<Map<String, dynamic>> fetchNoticesWithLinks(String url, String name, {int page = 1}) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parse(response.body);

        // name과 도메인 매핑
        final domainMap = {
          "whole": "https://www.inha.ac.kr",
        };

        // headline 공지사항
        final headlineElements = document.querySelectorAll(
            '.artclTable .headline ._artclTdTitle'); // headline CSS 셀렉터
        final headlineNotices = headlineElements.map((element) {
          final aTag = element.querySelector('.artclLinkView');
          if (aTag == null) return null; // a 태그가 없는 경우 null 반환

          // a 태그의 텍스트 노드만 선택 (span 태그 내용 제외)
          final title = aTag.nodes
              .where((node) => node.nodeType == 3) // 텍스트 노드만 선택
              .map((node) => node.text?.trim())
              .join() ?? ''; // 텍스트 노드 병합 및 공백 제거

          final baseUrl = domainMap[name] ?? ""; // name에 따라 도메인 결정
          final link = baseUrl + (aTag.attributes['href'] ?? '');
          return {'title': title, 'link': link};
        }).whereType<Map<String, String>>().toList(); // null 제거

        // 일반 공지사항
        final generalElements = document.querySelectorAll(
            '.artclTable tr:not(.headline)');

        // 첫 번째 <tr> 태그(테이블 헤더)를 제외
        final generalNotices = generalElements.skip(1).map((element) {
          final aTag = element.querySelector('._artclTdTitle a');
          if (aTag == null) return null; // a 태그가 없는 경우 null 반환

          final title = aTag.nodes
              .where((node) => node.nodeType == 3) // 텍스트 노드만 선택
              .map((node) => node.text?.trim())
              .join() ?? ''; // 텍스트 병합

          final baseUrl = domainMap[name] ?? "";
          final link = baseUrl + (aTag.attributes['href'] ?? '');
          return {'title': title, 'link': link};
        }).whereType<Map<String, String>>().toList(); // null 제거

        // 페이지 번호 크롤링
        final pageElements = document.querySelectorAll('._paging ._inner ul li');
        final pages = pageElements.map((element) {
          final isCurrent = element.localName == 'strong'; // 현재 페이지는 <strong> 태그
          return {
            'page': element.text.trim(),
            'isCurrent': isCurrent,
          };
        }).toList();

        return {
          'headline': headlineNotices,
          'general': generalNotices,
          'pages': pages,
        };
      } else {
        throw Exception('Failed to load notices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notices: $e');
    }
  }
}