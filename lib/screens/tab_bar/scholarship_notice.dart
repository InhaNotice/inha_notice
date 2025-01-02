import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser; // HTML 파싱용
import 'package:http/http.dart' as http;

class ScholarshipNoticePage extends StatefulWidget {
  const ScholarshipNoticePage({Key? key}) : super(key: key);

  @override
  State<ScholarshipNoticePage> createState() => _ScholarshipNoticePageState();
}

class _ScholarshipNoticePageState extends State<ScholarshipNoticePage> {
  List<Map<String, String>> _boardNotices = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchBoardNotices();
  }

  Future<void> _fetchBoardNotices() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
        // 게시판 요소 추출 및 URL 생성
        final boardLink = 'https://www.inha.ac.kr/search/search.jsp?query=장학&collection=inhabbs';

        // 게시판 데이터 요청
        final boardResponse = await http.get(Uri.parse(boardLink));
        if (boardResponse.statusCode == 200) {
          final boardDocument = html_parser.parse(boardResponse.body);

          // 공지사항 제목과 링크 크롤링
          final notices = boardDocument.querySelectorAll('dl.resultsty_1');
          setState(() {
            _boardNotices = notices.map((notice) {
              final titleElement = notice.querySelector('dt > a.tit');
              final link = titleElement?.attributes['href'];
              final title = titleElement?.text.trim() ?? 'No Title';
              return {'title': title, 'link': link ?? ''};
            }).toList();
          });
        } else {
          setState(() {
            _error = 'Failed to load board page';
          });
        }
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarship Notices'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : ListView.builder(
        itemCount: _boardNotices.length,
        itemBuilder: (context, index) {
          final notice = _boardNotices[index];
          return ListTile(
            title: Text(
              notice['title'] ?? 'No Title',
              style: const TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WebViewPage(url: notice['link'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Detail'),
      ),
      body: Center(
        child: Text('WebView for $url'), // WebView 위젯으로 변경 필요
      ),
    );
  }
}