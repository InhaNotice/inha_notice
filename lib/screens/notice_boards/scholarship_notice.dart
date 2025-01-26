import 'package:flutter/material.dart';

import '../../services/search_api.dart'; // SearchAPI 클래스가 정의된 파일 경로
import '../web_page.dart'; // WebViewPage가 정의된 파일 경로

class ScholarshipNoticePage extends StatefulWidget {
  const ScholarshipNoticePage({super.key});

  @override
  State<ScholarshipNoticePage> createState() => _ScholarshipNoticePageState();
}

class _ScholarshipNoticePageState extends State<ScholarshipNoticePage> {
  final SearchAPI _searchAPI = SearchAPI();
  Map<String, dynamic> _notices = {'notices': [], 'pages': []};
  List<Map<String, dynamic>> _initialPages = [];

  bool _isLoading = true;
  String _error = '';
  int _currentPage = 1;
  static const String kQuery = '장학';

  @override
  void initState() {
    super.initState();
    _loadNotices(); // 초기 데이터 로드
  }

  Future<void> _loadNotices({int startCount = 0}) async {
    setState(() {
      _isLoading = true; // 로딩 상태
    });

    try {
      final notices = await _searchAPI.fetchNotices(kQuery, startCount);
      setState(() {
        _notices = notices; // 공지사항 데이터 저장
        if (startCount == 0) {
          _initialPages = List<Map<String, dynamic>>.from(notices['pages']);
        }
        _currentPage = (startCount ~/ 10) + 1; // 현재 페이지 계산
        _isLoading = false; // 로딩 상태 종료
      });
    } catch (e) {
      setState(() {
        _error = e.toString(); // 오류 메시지 저장
        _isLoading = false; // 로딩 상태 종료
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
                  ? Center(child: Text('Error: $_error')) // 오류 표시
                  : ListView(
                children: [
                  // 공지사항 목록
                  if (_notices['notices'].isNotEmpty)
                    ..._notices['notices'].map((notice) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF222222), // 항목 배경색
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF444444), // 하단 테두리
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
                              color: Colors.white, // 제목 글자색
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebPage(
                                  url: notice['link'] ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
          // 페이지네이션 버튼
          if (_notices['pages'].isNotEmpty)
            Container(
              color: const Color(0xFF292929), // 하단 배경색
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _initialPages.map<Widget>((pageData) {
                    final String pageNumber = pageData['page'].toString(); // 페이지 번호 추출
                    final String startCount = pageData['startCount'].toString(); // startCount 값
                    final bool isCurrentPage =
                        (int.parse(startCount) ~/ 10) + 1 == _currentPage; // 현재 페이지 여부 확인

                    return TextButton(
                      onPressed: isCurrentPage
                          ? null
                          : () => _loadNotices(startCount: int.parse(startCount)),
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