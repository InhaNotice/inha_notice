import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../services/search_api.dart'; // SearchAPI 클래스가 정의된 파일 경로
import '../web_page.dart'; // WebViewPage가 정의된 파일 경로

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  final SearchAPI _searchAPI = SearchAPI();
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> _notices = {'notices': [], 'pages': []};
  List<Map<String, dynamic>> _initialPages = [];
  bool _isLoading = false; // 초기 로딩 상태 false
  String _error = '';
  String _warning = ''; // 경고 메시지
  int _currentPage = 1;
  String _query = ''; // 초기 검색어 빈 문자열

  Future<void> _loadNotices({int startCount = 0}) async {
    if (_query.isEmpty || _query.length < 2) {
      setState(() {
        _warning = '검색어는 두 글자 이상 입력해주세요.'; // 경고 메시지 설정
      });
      return;
    }

    setState(() {
      _isLoading = true; // 로딩 상태
      _warning = ''; // 경고 메시지 초기화
    });

    try {
      final searchUrl = dotenv.get('SEARCH_URL', fallback: '');
      final collection = dotenv.get('COLLECTION', fallback: '');
      final url =
          '$searchUrl?query=$_query&collection=$collection&startCount=$startCount';
      final notices = await _searchAPI.fetchNoticesWithLinks(url, _query);
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: '검색어를 입력하세요',
                  hintStyle: TextStyle(color: Color(0xFFBAB6B6)),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  if (value.length < 2) {
                    setState(() {
                      _warning = '검색어는 두 글자 이상 입력해주세요.'; // 경고 메시지 설정
                    });
                  } else {
                    setState(() {
                      _query = value; // 입력된 검색어 저장
                    });
                    _loadNotices(); // 새로운 검색어로 데이터 로드
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                if (_searchController.text.length < 2) {
                  setState(() {
                    _warning = '검색어는 두 글자 이상 입력해주세요.'; // 경고 메시지 설정
                  });
                } else {
                  setState(() {
                    _query = _searchController.text; // 입력된 검색어 저장
                  });
                  _loadNotices(); // 새로운 검색어로 데이터 로드
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_warning.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _warning,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ), // 경고 메시지 표시
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xEB292929), // 배경색 #292929, 투명도 92%
              ),
              child: _query.isEmpty
                  ? const Center(
                child: Text(
                  '검색어를 입력하세요',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ) // 검색어가 없으면 빈 화면 표시
                  : _isLoading
                  ? const Center(child: CircularProgressIndicator()) // 로딩 표시
                  : _error.isNotEmpty
                  ? Center(child: Text('Error: $_error')) // 오류 표시
                  : ListView(
                children: [
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
          if (_query.isNotEmpty && _initialPages.isNotEmpty)
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