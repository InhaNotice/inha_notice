/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/utils/bookmark/bookmark_manager.dart';
import 'package:inha_notice/utils/read_notice/read_notice_manager.dart';
import 'package:inha_notice/utils/recent_search/recent_search_manager.dart';
import 'package:inha_notice/widgets/snack_bars/themed_snack_bar.dart';

class CacheDeletionDialog extends StatefulWidget {
  const CacheDeletionDialog({
    super.key,
  });

  @override
  State<CacheDeletionDialog> createState() => _CacheDeletionDialogState();
}

class _CacheDeletionDialogState extends State<CacheDeletionDialog> {
  /// **모든 캐시를 삭제**
  Future<void> _deleteAllCaches() async {
    try {
      await Future.wait([
        BookmarkManager.clearAllBookmarks(),
        ReadNoticeManager.clearAllReadNotices(),
        RecentSearchManager.clearSearchHistory()
      ]);

      if (mounted) {
        ThemedSnackBar.succeedSnackBar(context, '모두 삭제되었어요!');
      }
    } catch (e) {
      if (mounted) {
        ThemedSnackBar.failSnackBar(context, '실패하였어요. 다시 시도해보세요.');
      }
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // iOS 환경
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(
          '캐시 삭제',
          style: TextStyle(
            fontFamily: AppFont.pretendard.family,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              '읽은 공지, 북마크, 검색 기록이\n모두 깔끔하게 정리돼요!',
              softWrap: true,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(
              '취소',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogTextColor,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => _deleteAllCaches(),
            child: Text(
              '삭제',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogDeleteTextColor,
              ),
            ),
          ),
        ],
      );
    } else {
      // Android 환경
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          '캐시 삭제',
          style: TextStyle(
            fontFamily: AppFont.pretendard.family,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        content: Text(
          '읽은 공지, 북마크, 검색 기록이\n모두 깔끔하게 정리돼요!',
          softWrap: true,
          style: TextStyle(
            fontFamily: AppFont.pretendard.family,
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(
              '취소',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _deleteAllCaches(),
            child: Text(
              '삭제',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogDeleteTextColor,
              ),
            ),
          ),
        ],
      );
    }
  }
}
