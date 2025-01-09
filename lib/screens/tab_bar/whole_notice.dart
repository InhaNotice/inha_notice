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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFF222222),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showHeadlines = true;
                    });
                    print('중요 버튼 클릭됨');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Text(
                      '중요',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showHeadlines = false;
                    });
                    print('일반 버튼 클릭됨');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color:  Colors.transparent,
                      border: Border.all(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Text(
                      '일반',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    print('새로고침 버튼 클릭됨');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.refresh, color: Colors.white, size: 16.0),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}