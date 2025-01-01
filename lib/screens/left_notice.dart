import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/api.dart';
import 'notice.dart';
// import '../utils/file_utils.dart';

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
      // final jsonOutput = jsonEncode(notices);
      // await saveJsonToFile('left_notices.json', jsonOutput); // JSON 데이터를 파일로 저장
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
      body: _isLoading
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
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ..._notices['headline']!.map((notice) {
                  return ListTile(
                    title: Text(notice['title'] ?? 'No Title'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoticePage(
                              url: notice['link'] ?? ''),
                        ),
                      );
                    },
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
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ..._notices['general']!.map((notice) {
                  return ListTile(
                    title: Text(notice['title'] ?? 'No Title'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoticePage(
                              url: notice['link'] ?? ''),
                        ),
                      );
                    },
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }
}