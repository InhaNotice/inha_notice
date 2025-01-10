import 'package:flutter/material.dart';
import 'package:inha_notice/screens/web_page.dart';

class NoticeListTile extends StatelessWidget {
  final Map<String, dynamic> notice;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  const NoticeListTile({
    super.key,
    required this.notice,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 2.0,
          ),
        ),
      ),
      child: ListTile(
        title: Text(
          notice['title'] ?? 'No title',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: textColor,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebPage(
                url: notice['link'] ?? '',
              ),
            ),
          );
        },
      ),
    );
  }
}