import 'package:flutter/material.dart';

import 'package:inha_notice/services/whole_api.dart';
import 'package:inha_notice/screens/web_page.dart';

class WholeNoticePage extends StatefulWidget {
  const WholeNoticePage({super.key});

  @override
  State<WholeNoticePage> createState() => _WholeNoticePageState();
}

class _WholeNoticePageState extends State<WholeNoticePage> {
  static const int kInitialPage = 1;
  static const String kEmptyString = '';

  final WholeAPI _wholeApi = WholeAPI();
  Map<String, dynamic> _notices = {'headline': [], 'general': [], 'pages': []};
  List<Map<String, dynamic>> _initialPages = [];

  bool _isLoading = true;
  bool _showHeadlines = false;
  int _currentPage = kInitialPage;
  String _error = kEmptyString;

  @override
  void initState() {
    super.initState();
    _loadNotices(kInitialPage);
  }

  Future<void> _loadNotices(int page) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notices = await _wholeApi.fetchNotices(page);
      setState(() {
        _notices = notices;
        if (page == kInitialPage) {
          _initialPages = List<Map<String, dynamic>>.from(notices['pages']);
        }
        _currentPage = page;
        _isLoading = false;
      });
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xEB292929),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                  ? Center(child: Text('Error: $_error'))
                  : ListView(
                children: [
                  if (_notices['headline']!.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showHeadlines = !_showHeadlines;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '중요 공지사항',
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                          if (_showHeadlines)
                            ..._notices['headline']!.map((notice) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF222222), // 배경색
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFF222222), // 하단 테두리 색상
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    notice['title'] ?? 'No Title',
                                    style: const TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2,
                                        color: Colors.white), // 제목 글자색
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebPage(
                                            url: notice['link'] ?? ''),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                        ],
                      ),
                    ),

                  // 일반 공지사항(General Notices)
                  if (_notices['general']!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '일반 공지사항',
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                        ..._notices['general']!.map((notice) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF292929), // 배경색
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0x8C525050), // 하단 테두리 색상
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                notice['title'] ?? 'No Title',
                                style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white), // 제목 글자색
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebPage(
                                        url: notice['link'] ?? ''),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (_notices['pages']!.isNotEmpty)
            Container(
              color: const Color(0xFF292929), // 하단 배경색
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _initialPages.map<Widget>((pageData) {
                    final int pageNumber = pageData['page']; // 페이지 번호 추출
                    final bool isCurrentPage = (pageNumber == _currentPage);
                    return TextButton(
                      onPressed: isCurrentPage
                          ? null
                          : () {
                        _loadNotices(pageNumber); // 해당 페이지로 이동
                      },
                      child: Text(
                        pageNumber.toString(),
                        style: TextStyle(
                          color: isCurrentPage ? Colors.white : Colors.white60,
                          fontWeight: isCurrentPage
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}