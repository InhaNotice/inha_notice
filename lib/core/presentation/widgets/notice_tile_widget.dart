/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/widgets/web_navigator_widget.dart';

/// **NoticeListTile**
/// 이 클래스는 공지사항 하나에 대한 정보를 출력하는 클래스입니다.
class NoticeTileWidget extends StatefulWidget {
  final NoticeTileModel notice;
  final bool isRead;
  final bool isBookmarked;
  final void Function(String noticeId) markNoticeAsRead;
  final Future<void> Function(NoticeTileModel) toggleBookmark;

  const NoticeTileWidget({
    super.key,
    required this.notice,
    required this.isRead,
    required this.isBookmarked,
    required this.markNoticeAsRead,
    required this.toggleBookmark,
  });

  @override
  State<NoticeTileWidget> createState() => _NoticeListTileState();
}

class _NoticeListTileState extends State<NoticeTileWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 읽은 공지면 readTextColor, 읽지 않은 공지면 기본 색상을 표시
    final Color textColor = widget.isRead
        ? Theme.of(context).readTextColor
        : Theme.of(context).textTheme.bodyMedium?.color ??
            Theme.of(context).defaultThemedTextColor;
    final String title =
        widget.notice.title.isNotEmpty ? widget.notice.title : '제목이 없는 게시글입니다';
    final String body = widget.notice.body ?? '';
    final String date = widget.notice.date.isNotEmpty ? widget.notice.date : '';
    final String access = widget.notice.access ?? '';

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
            widget.markNoticeAsRead(widget.notice.id.toString());
            if (mounted) {
              await WebNavigatorWidget.navigate(
                  context: context, url: widget.notice.link);
            }
          },
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                if (body.isNotEmpty)
                  Text(
                    body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: textColor.withValues(alpha: (0.2 * 255)),
                    ),
                  ),
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (date.isNotEmpty)
                        Text(
                          date,
                          style: TextStyle(
                            fontFamily: AppFont.pretendard.family,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: textColor.withValues(alpha: (0.2 * 255)),
                          ),
                        ),
                      const SizedBox(width: 5),
                      if (access.isNotEmpty)
                        Text(
                          '조회 $access',
                          style: TextStyle(
                            fontFamily: AppFont.pretendard.family,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: textColor.withValues(alpha: (0.2 * 255)),
                          ),
                        ),
                    ],
                  ),
                ),
                // 북마크 아이콘 정의
                IconButton(
                  icon: Icon(
                    widget.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: widget.isBookmarked ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () async {
                    await widget.toggleBookmark(widget.notice);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
