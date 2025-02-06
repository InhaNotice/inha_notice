import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/notice_board/base_notice_board.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/bookmark_manager.dart';
import 'package:inha_notice/widgets/notice_list_tile.dart';

class BookmarkPage extends BaseNoticeBoard {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends BaseNoticeBoardState<BookmarkPage> {
  bool orderName = false;
  bool orderDate = false;
  bool orderBookmark = true;
  List<Map<String, dynamic>> bookmarkedNotices = [];
  List<Map<String, dynamic>> originalBookmarkedNotices = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Future<void> initialize() async {
    try {
      await loadBookmarkedNotices();
    } catch (e) {
      debugPrint('Initialization error: $e');
    }
  }

  @override
  Future<void> loadNotices(int page) async {
    // 북마크 페이지는 페이지네이션이 적용되지 않습니다.
    await loadBookmarkedNotices();
  }

  /// **📌 북마크 정렬 옵션 변경**
  @override
  void toggleOption(String option) {
    setState(() {
      if (option == 'NAME') {
        orderName = true;
        orderDate = false;
        orderBookmark = false;
        bookmarkedNotices.sort((a, b) => a['title'].compareTo(b['title']));
      } else if (option == 'DATE') {
        orderName = false;
        orderDate = true;
        orderBookmark = false;
        bookmarkedNotices.sort((a, b) => b['date'].compareTo(a['date']));
      } else {
        orderName = false;
        orderDate = false;
        orderBookmark = true;
        bookmarkedNotices = List.from(originalBookmarkedNotices);
      }
    });
  }

  /// **📌 북마크된 공지사항 로드 (읽은 공지사항 반영)**
  Future<void> loadBookmarkedNotices() async {
    setState(() {
      isLoading = true;
    });
    final notices = await BookmarkManager.getAllBookmarks();
    setState(() {
      originalBookmarkedNotices = List.from(notices);
      bookmarkedNotices = List.from(notices);
      orderName = false;
      orderDate = false;
      orderBookmark = true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: false,
        title: Text('북마크',
            style: TextStyle(
              fontFamily: Font.kDefaultFont,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultColor,
            )),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          buildMain(),
        ],
      ),
    );
  }

  @override
  Widget buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => toggleOption('BOOKMARK'),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: orderBookmark
                    ? Border.all(color: Colors.blue, width: 2.0)
                    : Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                '북마크된 순서',
                style: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: orderBookmark ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => toggleOption('NAME'),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: orderName
                    ? Border.all(color: Colors.blue, width: 2.0)
                    : Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                '이름순',
                style: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: orderName ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => toggleOption('DATE'),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: orderDate
                    ? Border.all(color: Colors.blue, width: 2.0)
                    : Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                '날짜순',
                style: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: orderDate ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              loadBookmarkedNotices();
            },
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: Theme.of(context).iconTheme.color!, width: 2.0),
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
    );
  }

  @override
  Widget buildMain() {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookmarkedNotices.isEmpty
              ? Center(
                  child: Text(
                    "저장된 북마크가 없습니다.",
                    style: TextStyle(
                      fontFamily: Font.kDefaultFont,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Theme.of(context).defaultColor,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: bookmarkedNotices.length,
                  itemBuilder: (context, index) {
                    final notice = bookmarkedNotices[index];
                    final isRead = isNoticeRead(notice['id'].toString());
                    final isBookmarked =
                        isNoticeBookmarked(notice['id'].toString());
                    return NoticeListTile(
                      notice: notice,
                      isRead: isRead,
                      isBookmarked: isBookmarked,
                      markNoticeAsRead: markNoticeAsRead,
                      toggleBookmark: toggleBookmark,
                    );
                  },
                ),
    );
  }

  @override
  Widget buildFooter() {
    return const SizedBox();
  }
}
