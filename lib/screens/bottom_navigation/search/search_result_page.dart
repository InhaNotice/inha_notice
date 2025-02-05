import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/web_page.dart';
import 'package:inha_notice/services/scraper/search_scraper.dart';

typedef NoticesMap = Map<String, dynamic>;
typedef PagesList = List<Map<String, dynamic>>;

class SearchResultPage extends StatefulWidget {
  final String query;

  const SearchResultPage({required this.query, super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final SearchScraper _searchAPI = SearchScraper();
  final TextEditingController _searchController = TextEditingController();
  NoticesMap _notices = {'notices': [], 'pages': []};
  PagesList _initialPages = [];

  bool _isLoading = false;
  String _error = Font.kEmptyString;
  int _currentPage = Font.kInitialPage;

  Future<void> loadNotices({int startCount = 0}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notices = await _searchAPI.fetchNotices(widget.query, startCount);
      setState(() {
        _notices = notices;

        if (startCount == 0) {
          _initialPages = PagesList.from(notices['pages']);
        }
        _currentPage = (startCount ~/ 10) + 1;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadNotices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text('검색 결과: ${widget.query}',
            style: const TextStyle(
              fontFamily: Font.kDefaultFont,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
      body: Container(
        color: const Color(0xFF292929), // 로딩 상태에서도 배경색 유지
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white, // 로딩 인디케이터 색상
                ),
              )
            : _error.isNotEmpty
                ? Center(
                    child: Text('Error: $_error',
                        style: const TextStyle(color: Colors.white)))
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color(0xFF292929),
                          child: ListView(
                            children: (_notices['notices'] ?? [])
                                .map<Widget>((notice) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF222222),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFF444444),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    notice['title'] ?? 'No Title',
                                    style: const TextStyle(
                                      fontFamily: Font.kDefaultFont,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WebPage(url: notice['link'] ?? ''),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      if (_initialPages.isNotEmpty)
                        Container(
                          color: const Color(0xFF292929),
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _initialPages.map<Widget>((pageData) {
                                final int pageNumber = pageData['page'];
                                final int startCount = pageData['startCount'];
                                final bool isCurrentPage =
                                    (startCount ~/ 10) + 1 == _currentPage;

                                return TextButton(
                                  onPressed: isCurrentPage
                                      ? null
                                      : () =>
                                          loadNotices(startCount: startCount),
                                  child: Text(
                                    pageNumber.toString(),
                                    style: TextStyle(
                                      color: isCurrentPage
                                          ? Colors.white
                                          : Colors.white60,
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
      ),
    );
  }
}
