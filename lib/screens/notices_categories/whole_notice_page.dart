import 'package:flutter/material.dart';
import 'package:inha_notice/services/whole_api.dart';
import 'package:inha_notice/widgets/notice_list_tile.dart';
import 'package:inha_notice/widgets/page_selector.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/utils/read_notice_manager.dart';
import 'package:inha_notice/utils/bookmark_manager.dart';

class WholeNoticePage extends StatefulWidget {
  const WholeNoticePage({super.key});

  @override
  State<WholeNoticePage> createState() => _WholeNoticePageState();
}

class _WholeNoticePageState extends State<WholeNoticePage> {
  final WholeAPI _wholeApi = WholeAPI();
  Map<String, dynamic> _notices = {'headline': [], 'general': [], 'pages': []};
  List<Map<String, dynamic>> _initialPages = [];
  Set<String> _readNotices = {}; // 읽은 공지를 관리하는 캐시값
  Set<String> _bookmarkedNotices = {}; // 북마크된 공지 캐시

  bool _isLoading = true;
  bool _showHeadlines = false;
  bool _showGeneral = true;
  int _currentPage = Font.kInitialPage;

  @override
  void initState() {
    super.initState();
    _initializeReadAndBookmark();
    _loadNotices(Font.kInitialPage);
  }

  // 읽은 공지와 북마크 초기화
  Future<void> _initializeReadAndBookmark() async {
    final readIds = await ReadNoticeManager.loadReadNotices();
    final bookmarkedIds = await BookmarkManager.getAllBookmarks();
    setState(() {
      _readNotices = readIds.toSet();
      _bookmarkedNotices = bookmarkedIds.toSet();
    });
  }

  // 공지를 읽었는지 확인
  bool _isNoticeRead(String noticeId) {
    return _readNotices.contains(noticeId);
  }

  // 공지가 북마크되었는지 확인
  bool _isNoticeBookmarked(String noticeId) {
    return _bookmarkedNotices.contains(noticeId);
  }

  // 공지를 읽음으로 표시
  Future<void> _markNoticeAsRead(String noticeId) async {
    _readNotices.add(noticeId);
    await ReadNoticeManager.saveReadNotices(_readNotices);
    setState(() {});
  }

  // 공지의 북마크 상태를 토글
  Future<void> _toggleBookmark(String noticeId) async {
    if (_bookmarkedNotices.contains(noticeId)) {
      _bookmarkedNotices.remove(noticeId);
      await BookmarkManager.removeBookmark(noticeId);
    } else {
      _bookmarkedNotices.add(noticeId);
      await BookmarkManager.addBookmark(noticeId);
    }
    setState(() {});
  }

  Future<void> _loadNotices(int page) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notices = await _wholeApi.fetchNotices(page);
      setState(() {
        _notices = notices;
        if (page == Font.kInitialPage) {
          _initialPages = List<Map<String, dynamic>>.from(notices['pages']);
        }
        _currentPage = page;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleOption(String option) {
    setState(() {
      if (option == 'headline') {
        _showHeadlines = true;
        _showGeneral = false;
      } else if (option == 'general') {
        _showHeadlines = false;
        _showGeneral = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _toggleOption('headline'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      // 옵션 버튼의 경계 색상 지정
                      border: _showHeadlines
                          ? Border.all(color: Colors.blue, width: 2.0)
                          : Border.all(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      '중요',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: _showHeadlines ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _toggleOption('general'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      // 옵션 버튼의 경계 색상 지정
                      border: _showGeneral
                          ? Border.all(color: Colors.blue, width: 2.0)
                          : Border.all(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      '일반',
                      style: TextStyle(
                          fontFamily: Font.kDefaultFont,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: _showGeneral ? Colors.blue : Colors.grey),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _loadNotices(Font.kInitialPage);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: Theme.of(context).iconTheme.color!,
                          width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: Theme.of(context).iconTheme.color,
                      size: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                // 중요 공지와 일반 공지 중 하나만 선택이 가능합니다.
                itemCount: _showHeadlines
                    ? _notices['headline'].length
                    : _notices['general'].length,
                itemBuilder: (context, index) {
                  final notice = _showHeadlines
                      ? _notices['headline'][index]
                      : _notices['general'][index];
                  // 공지 리스트에서 공지가 읽음 상태인지 확인하고, NoticeListTile에 그 상태를 전달합니다.
                  final isRead = _isNoticeRead(notice['id'].toString());
                  final isBookmarked =
                  _isNoticeBookmarked(notice['id'].toString());
                  return NoticeListTile(
                    notice: notice,
                    noticeType: _showHeadlines ? 'headline' : 'general',
                    isRead: isRead,
                    isBookmarked: isBookmarked,
                    markAsRead: _markNoticeAsRead, // 읽음 처리 함수 전달
                    toggleBookmark: _toggleBookmark,
                  );
                },
              ),
            ),
          ),
          if (_initialPages.isNotEmpty)
            PageSelector(
              pages: _initialPages,
              currentPage: _currentPage,
              onPageSelected: (page) {
                _loadNotices(page);
              },
            ),
        ],
      ),
    );
  }
}