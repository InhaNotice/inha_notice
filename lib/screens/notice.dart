import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom; // 별칭 추가

class NoticePage extends StatefulWidget {
  final String url;

  const NoticePage({super.key, required this.url});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<Map<String, String>> _contentList = []; // 텍스트와 이미지 저장
  String _textContent = ''; // 텍스트만 저장
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
        final contentElement = document.querySelector(
            'div.artclView'); // 콘텐츠 영역 선택

        if (contentElement != null) {
          final buffer = StringBuffer();
          final List<Map<String, String>> contentList = [];

          // 콘텐츠 영역의 모든 하위 노드 순회
          for (var child in contentElement.querySelectorAll('*')) {
            if (child.localName == 'img') {
              // 이미지 처리
              final imageUrl = child.attributes['src'];
              if (imageUrl != null) {
                final absoluteUrl = Uri.parse(widget.url)
                    .resolve(imageUrl)
                    .toString();
                contentList.add({'type': 'image', 'data': absoluteUrl});
              }
            } else if (child.localName == 'p') {
              // 텍스트 처리
              final text = child.text.trim();
              if (text.isNotEmpty) {
                buffer.writeln(text);
                contentList.add({'type': 'text', 'data': text});
              }
            }
          }

          setState(() {
            _textContent = buffer.toString(); // 텍스트만 저장
            _contentList = contentList; // 텍스트와 이미지를 모두 저장
            _isLoading = false;
          });
        } else {
          throw Exception('Content not found');
        }
      } else {
        throw Exception(
            'Failed to load notice content: ${response.statusCode}');
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _contentList.map((item) {
              if (item['type'] == 'text') {
                return Text(
                  item['data']!,
                  style: const TextStyle(fontSize: 16.0),
                );
              } else if (item['type'] == 'image') {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(
                    item['data']!,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Failed to load image');
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            }).toList(),
          ),
        ),
      ),
    );
  }
}