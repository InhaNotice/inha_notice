import 'package:flutter/material.dart';
import '../services/api.dart';
import 'notice.dart';

class LeftNoticePage extends StatefulWidget {
  const LeftNoticePage({super.key});

  @override
  State<LeftNoticePage> createState() => _LeftNoticePageState();
}

class _LeftNoticePageState extends State<LeftNoticePage> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic> _notices = {'headline': [], 'general': [], 'pages': []};
  bool _isLoading = true;
  String _error = '';
  int _currentPage = 1; // 현재 페이지 번호

  @override
  void initState() {
    super.initState();
    _loadNotices(); // 초기 로드
  }

  Future<void> _loadNotices({int page = 1}) async {
    setState(() {
      _isLoading = true; // 로딩 상태로 전환
    });

    try {
      final notices = await _apiService.fetchNoticesWithLinks(
          'https://swuniv.inha.ac.kr/swuniv/12703/subview.do?page=$page');
      setState(() {
        _notices = notices; // 공지사항 데이터 저장
        _currentPage = page; // 현재 페이지 업데이트
        _isLoading = false; // 로딩 종료
      });
    } catch (e) {
      setState(() {
        _error = e.toString(); // 오류 메시지 저장
        _isLoading = false; // 로딩 종료
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
                color: Color(0xEB292929), // 배경색 #292929, 투명도 92%
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator()) // 로딩 표시
                  : _error.isNotEmpty
                  ? Center(child: Text('Error: $_error')) // 오류 메시지 표시
                  : ListView(
                children: [
                  if (_notices['headline']!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Headline Notices',
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                        ..._notices['headline']!.map((notice) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Color(0x8C292929), // 배경색
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFF222222), // 하단 테두리 색상
                                  width: 2.0,
                                ),
                              ),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0), // 간격 추가
                            child: ListTile(
                              title: Text(
                                notice['title'] ?? 'No Title',
                                style: const TextStyle(
                                    color: Colors.white), // 제목 글자색
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NoticePage(
                                        url: notice['link'] ?? ''),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  if (_notices['general']!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'General Notices',
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 18,
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
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                notice['title'] ?? 'No Title',
                                style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.white), // 제목 글자색
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NoticePage(
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
                  children: _notices['pages']!.map<Widget>((pageData) {
                    final String pageNumber = pageData['page'].toString(); // 페이지 번호 추출
                    final bool isCurrentPage =
                    pageData['isCurrent'] as bool; // 현재 페이지 여부 확인
                    return TextButton(
                      onPressed: isCurrentPage
                          ? null
                          : () {
                        _loadNotices(page: int.parse(pageNumber)); // 해당 페이지로 이동
                      },
                      child: Text(
                        pageNumber,
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