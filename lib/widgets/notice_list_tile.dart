import 'package:flutter/material.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/fonts/font.dart';

class NoticeListTile extends StatefulWidget {
  final Map<String, dynamic> notice;
  final String noticeType;
  final bool isRead;
  final bool isBookmarked;
  final Future<void> Function(String noticeId) markAsRead;
  final Future<void> Function(String noticeId) toggleBookmark;

  const NoticeListTile({
    super.key,
    required this.notice,
    required this.noticeType,
    required this.isRead,
    required this.isBookmarked,
    required this.markAsRead,
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

  @override
  Widget build(BuildContext context) {
    final readTextColor = Theme.of(context).readTextColor;
    // 읽음 상태를 전달받아서 제목 텍스트 색상을 결정합니다.
    final textColor = widget.isRead
        ? readTextColor
        : Theme.of(context).textTheme.bodyMedium?.color ??
        Theme.of(context).defaultColor;
    // 안전한 데이터 접근
    final title = widget.notice.containsKey('title') ? widget.notice['title'] ?? '제목이 없는 게시글입니다' : '제목이 없는 게시글입니다';
    final date = widget.notice.containsKey('date') ? widget.notice['date'] ?? '' : '';
    final access = widget.notice.containsKey('access') ? widget.notice['access'] : null;
    // final writer = widget.notice.containsKey('writer') ? widget.notice['writer'] ?? '' : '';

    return Column(children: [
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
      ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: Font.kDefaultFont,
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
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
                    SizedBox(width: Theme.of(context).visualDensity.horizontal),
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
                  widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: widget.isBookmarked ? Colors.yellow : Colors.grey,
                ),
                onPressed: () async {
                  if (widget.notice.containsKey('id') && widget.notice['id'] != null) {
                    await widget.toggleBookmark(widget.notice['id'].toString());
                  }
                },
              ),
            ],
          ))
    ]);
  }
}