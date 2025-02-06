import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/web_page.dart';
import 'package:inha_notice/themes/theme.dart';

class NoticeListTile extends StatefulWidget {
  final Map<String, dynamic> notice;
  final bool isRead;
  final bool isBookmarked;
  final void Function(String noticeId) markNoticeAsRead;
  final Future<void> Function(Map<String, dynamic>) toggleBookmark;

  const NoticeListTile({
    super.key,
    required this.notice,
    required this.isRead,
    required this.isBookmarked,
    required this.markNoticeAsRead,
    required this.toggleBookmark,
  });

  @override
  State<NoticeListTile> createState() => _NoticeListTileState();
}

class _NoticeListTileState extends State<NoticeListTile> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> navigateToWebPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebPage(
          url: widget.notice['link'] ?? Font.kEmptyString,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final readTextColor = Theme.of(context).readTextColor;
    // 읽음 상태를 전달받아서 제목 텍스트 색상을 결정합니다.
    final textColor = widget.isRead
        ? readTextColor
        : Theme.of(context).textTheme.bodyMedium?.color ??
            Theme.of(context).defaultColor;
    // 안전한 데이터 접근
    final title = widget.notice.containsKey('title')
        ? widget.notice['title'] ?? '제목이 없는 게시글입니다'
        : '제목이 없는 게시글입니다';
    final date =
        widget.notice.containsKey('date') ? widget.notice['date'] ?? '' : '';
    final access =
        widget.notice.containsKey('access') ? widget.notice['access'] : null;
    // final writer = widget.notice.containsKey('writer') ? widget.notice['writer'] ?? '' : '';

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).noticeBorderColor,
                width: 1.0,
              ),
              top: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            widget.markNoticeAsRead(widget.notice['id'].toString());
            if (mounted) {
              await navigateToWebPage(context);
            }
          },
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: Font.kDefaultFont,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                if (widget.notice.containsKey('body') &&
                    widget.notice['body'] != null)
                  Text(
                    widget.notice['body'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: Font.kDefaultFont,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (widget.notice['date'] != null)
                        Text(
                          date,
                          style: TextStyle(
                            fontFamily: Font.kDefaultFont,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      const SizedBox(width: 5),
                      if (widget.notice['access'] != null)
                        Text(
                          '조회 $access',
                          style: TextStyle(
                            fontFamily: Font.kDefaultFont,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: widget.isBookmarked ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () async {
                    if (widget.notice.containsKey('id') &&
                        widget.notice['id'] != null) {
                      await widget.toggleBookmark(widget.notice);
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
