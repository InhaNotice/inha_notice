import 'package:flutter/material.dart';
import 'services/api.dart';
import 'screens/notice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSE Notices',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NoticeListPage(),
    );
  }
}

class NoticeListPage extends StatefulWidget {
  const NoticeListPage({super.key});

  @override
  State<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  final ApiService _apiService = ApiService();
  List<Map<String, String>> _notices = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    try {
      final notices = await _apiService.fetchNoticesWithLinks();
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
      appBar: AppBar(title: const Text('CSE Notices')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text('Error: $_error'))
          : ListView.builder(
        itemCount: _notices.length,
        itemBuilder: (context, index) {
          final notice = _notices[index];
          return ListTile(
            title: Text(notice['title'] ?? ''),
            onTap: () {
              // 공지사항 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoticePage(
                    url: notice['link'] ?? '',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}