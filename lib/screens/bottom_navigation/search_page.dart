import 'package:flutter/material.dart';
import 'package:inha_notice/screens/bottom_navigation/search/search_result_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _warning = '';

  void _search() {
    if (_searchController.text.length < 2) {
      setState(() {
        _warning = '검색어는 두 글자 이상 입력해주세요.';
      });
      return;
    }
    setState(() {
      _warning = '';
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultPage(query: _searchController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF292929),
        centerTitle: false,
        title: const Text(
          '검색',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      backgroundColor: Color(0xFF292929),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 50.0,
              decoration: BoxDecoration(
                color: const Color(0xFF424242),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: '검색어를 입력하세요',
                        hintStyle: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFFC4C4C4),
                        ),
                      ),
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 검색 기록',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '전체 삭제',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '실시간 인기 검색어',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '18:30',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildSearchItem(
                      index + 1, '성적', index == 1, index == 2);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildTag(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: Color(0xFF424242),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
  );
}

Widget _buildSearchItem(int rank, String keyword, bool up, bool down) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Text(
          '$rank',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            keyword,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        if (up)
          const Row(
            children: const [
              Icon(Icons.arrow_upward, color: Colors.red, size: 16),
              SizedBox(width: 4),
              Text('1', style: TextStyle(color: Colors.red)),
            ],
          ),
        if (down)
          const Row(
            children: [
              Icon(Icons.arrow_downward, color: Colors.blue, size: 16),
              SizedBox(width: 4),
              Text('2', style: TextStyle(color: Colors.blue)),
            ],
          ),
      ],
    ),
  );
}
