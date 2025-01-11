import 'package:flutter/material.dart';
import 'package:inha_notice/screens/web_page.dart';

class NoticeListTile extends StatefulWidget {
  final Map<String, dynamic> notice;
  final String noticeType;

  const NoticeListTile({
    super.key,
    required this.notice,
    required this.noticeType,
  });

  @override
  State<NoticeListTile> createState() => _NoticeListTileState();
}

class _NoticeListTileState extends State<NoticeListTile> {
  @override
  Widget build(BuildContext context) {
    const headlineBorderColor = Colors.blue;
    final generalBorderColor = Theme.of(context).dividerColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: (widget.noticeType == 'headline') ? headlineBorderColor: generalBorderColor,
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
            widget.notice['title'] ?? 'No title',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
          subtitle: Text(
            widget.notice['date'] ?? 'No date',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: textColor.withOpacity(0.6),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebPage(
                  url: widget.notice['link'] ?? '',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}