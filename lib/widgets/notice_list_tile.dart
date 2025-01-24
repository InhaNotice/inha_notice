import 'package:flutter/material.dart';
import 'package:inha_notice/screens/web_page.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/fonts/font.dart';

class NoticeListTile extends StatelessWidget {
  final Map<String, dynamic> notice;
  final String noticeType;
  final bool isRead;
  final Future<void> Function(String noticeId) markAsRead;

  const NoticeListTile({
    super.key,
    required this.notice,
    required this.noticeType,
    required this.isRead,
    required this.markAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final readTextColor = Theme.of(context).readTextColor;
    // 읽음 상태를 전달받아서 제목 텍스트 색상을 결정합니다.
    final textColor = isRead
        ? readTextColor
        : Theme.of(context).textTheme.bodyMedium?.color ??
        Theme.of(context).defaultColor;

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
        ListTile(
            title: Text(
              notice['title'] ?? '제목이 없는 게시글입니다',
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: textColor,
              ),
            ),
            subtitle: Text(
              notice['date'] ?? '',
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: textColor.withOpacity(0.6),
              ),
            ),
            onTap: () async {
              await markAsRead(notice['id'].toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebPage(
                    url: notice['link'] ?? Font.kEmptyString,
                  ),
                ),
              );
            }),
      ],
    );
  }
}