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
  bool _showGeneral = true;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF292929),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF101010),
                  width: 2.0,
                ),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showHeadlines = !_showHeadlines; // 상태 토글
                      if (!_showHeadlines && !_showGeneral) {
                        // 둘 다 선택되지 않은 경우 기본적으로 하나 선택
                        _showHeadlines = true;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('최소 하나의 옵션을 선택해야 합니다!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: _showHeadlines
                          ? Border.all(color: Colors.blue, width: 2.0)
                          : Border.all(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      '중요',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: _showHeadlines ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showGeneral = !_showGeneral; // 상태 토글
                      if (!_showHeadlines && !_showGeneral) {
                        // 둘 다 선택되지 않은 경우 기본적으로 하나 선택
                        _showGeneral = true;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('최소 하나의 옵션을 선택해야 합니다!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: _showGeneral
                          ? Border.all(color: Colors.blue, width: 2.0)
                          : Border.all(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      '일반',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: _showGeneral ? Colors.blue : Colors.grey),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _loadNotices(kInitialPage);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Icon(Icons.refresh,
                        color: Colors.white, size: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFF222222),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _showHeadlines && _showGeneral
                          ? _notices['headline'].length +
                              _notices['general'].length
                          : _showHeadlines
                              ? _notices['headline'].length
                              : _notices['general'].length,
                      itemBuilder: (context, index) {
                        if (_showHeadlines &&
                            index < _notices['headline'].length) {
                          final notice = _notices['headline'][index];
                          return Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF222222),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF222222),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  notice['title'] ?? 'No title',
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
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
                              ));
                        }
                        final generalIndex = index -
                            (_showHeadlines ? _notices['headline'].length : 0);
                        if (_showGeneral &&
                            generalIndex < _notices['general'].length) {
                          final notice = _notices['general'][generalIndex];
                          return Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF292929),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF222222),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  notice['title'] ?? 'No title',
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
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
                              ));
                        }
                        return const SizedBox.shrink();
                      }),
            ),
          )
        ],
      ),
    );
  }
}
