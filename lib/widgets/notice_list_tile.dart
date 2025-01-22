import 'package:flutter/material.dart';
import 'package:inha_notice/screens/web_page.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/utils/read_notice_manager.dart';

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
  bool _isRead = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeNotice();
  }

  Future<void> _initializeNotice() async {
    await _checkReadStatus();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _checkReadStatus() async {
    final readIds = await ReadNoticeManager.loadReadNotices();
    _isRead = readIds.contains(widget.notice['id'].toString());
  }

  Future<void> _markAsRead() async {
    final readIds = await ReadNoticeManager.loadReadNotices();
    readIds.add(widget.notice['id'].toString());
    await ReadNoticeManager.saveReadNotices(readIds);
    if (mounted) {
      setState(() {
        _isRead = true;
      });
    }
  }

  Future<void> _navigateToWebPage() async {
    if (!mounted) return;
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
    final textColor = _isRead
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
              widget.notice['title'] ?? 'No title',
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16.0,
                fontWeight: (widget.noticeType == 'headline') ? FontWeight.w600 : FontWeight.normal,
                color: textColor,
              ),
            ),
            subtitle: Text(
              widget.notice['date'] ?? 'No date',
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: textColor.withOpacity(0.6),
              ),
            ),
            onTap: () async {
              await _markAsRead();
              await _navigateToWebPage();
            }),
      ],
    );
  }
}
