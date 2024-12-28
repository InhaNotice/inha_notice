import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class NoticePage extends StatefulWidget {
  final String url;

  const NoticePage({super.key, required this.url});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  String _content = '';
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchNoticeContent();
  }

  Future<void> _fetchNoticeContent() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        final document = parse(response.body);

        // 공지사항 본문을 선택하는 CSS 셀렉터
        final contentElement = document.querySelector('div.artclView'); // 본문 CSS 셀렉터
        if (contentElement != null) {
          // 'artclItem viewForm' 이전의 텍스트만 가져오기
          final buffer = StringBuffer();
          for (var child in contentElement.children) {
            if (child.classes.contains('artclItem') && child.classes.contains('viewForm')) {
              break; // 해당 태그가 나타나면 중지
            }
            if (child.text != null && child.text!.trim().isNotEmpty) {
              buffer.writeln(child.text!.trim()); // 줄바꿈 추가
            }
          }

          setState(() {
            _content = buffer.toString();
            _isLoading = false;
          });
        } else {
          throw Exception('Content not found');
        }
      } else {
        throw Exception('Failed to load notice content: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notice Detail')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text('Error: $_error'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            _content,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}