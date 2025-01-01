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
  Map<String, List<Map<String, String>>> _notices = {'headline': [], 'general': []};
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    try {
      final notices = await _apiService.fetchNoticesWithLinks(
          'https://swuniv.inha.ac.kr/swuniv/12703/subview.do');
      setState(() {
        _notices = notices;
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
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xEB292929), // 배경색 #292929, 투명도 92% (Alpha: EB)
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
            ? Center(child: Text('Error: $_error'))
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
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  ..._notices['headline']!.map((notice) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: const Color(0x8C292929), // 배경색 #525050, 투명도 55% (Alpha: 8C)
                        border: const Border(
                          bottom: BorderSide(
                            color: Color(0x8C525050), // 하단 테두리 색상 #525050, 투명도 55% (Alpha: 8C)
                            width: 2.0, // 테두리 두께
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),  // 간격 추가
                      child: ListTile(
                        title: Text(
                          notice['title'] ?? 'No Title',
                          style: const TextStyle(color: Colors.white), // 제목 글자색 하얀색
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
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  ..._notices['general']!.map((notice) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: const Color(0x8C292929), // 배경색 #525050, 투명도 55% (Alpha: 8C)
                        border: const Border(
                          bottom: BorderSide(
                            color: Color(0x8C525050), // 하단 테두리 색상 #525050, 투명도 55% (Alpha: 8C)
                            width: 2.0, // 테두리 두께
                          ),
                        ),
                      ),
                      // margin: const EdgeInsets.symmetric(
                      //     vertical: 4.0, horizontal: 8.0), // 간격 추가
                      child: ListTile(
                        title: Text(
                          notice['title'] ?? 'No Title',
                          style: const TextStyle(color: Colors.white), // 제목 글자색 하얀색
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
    );
  }
}