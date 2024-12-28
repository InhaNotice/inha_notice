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
      final notices = await _apiService.fetchNoticesWithLinks(
          'https://swuniv.inha.ac.kr/swuniv/12703/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGc3d1bml2JTJGMzExMyUyRmFydGNsTGlzdC5kbyUzRg%3D%3D');
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
          : ListView.builder(
        itemCount: _notices.length,
        itemBuilder: (context, index) {
          final notice = _notices[index];
          return ListTile(
            title: Text(notice['title'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NoticePage(url: notice['link'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}