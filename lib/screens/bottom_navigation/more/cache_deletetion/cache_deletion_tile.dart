/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-18
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/dialogs/cache_deletion_dialog.dart';
import 'package:path_provider/path_provider.dart';

class CacheDeletionTile extends StatefulWidget {
  final String title;
  final IconData icon;

  const CacheDeletionTile({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<CacheDeletionTile> createState() => _CacheDeletionTileState();
}

class _CacheDeletionTileState extends State<CacheDeletionTile> {
  // 기본값 '0 MB'로 초기화하여 build 시점에 사용 가능하도록 함
  String description = '0 MB';

  @override
  void initState() {
    super.initState();
    _loadCacheCapacity();
  }

  Future<String> getDocumentsFolderSizeInMB() async {
    final directory = await getApplicationDocumentsDirectory();
    int totalBytes = 0;

    await for (var entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        totalBytes += await entity.length();
      }
    }

    final double mb = totalBytes / (1024 * 1024);
    return '${mb.toStringAsFixed(2)} MB';
  }

  /// **캐시 용량 불러오기(AppData/Documents/)**
  Future<void> _loadCacheCapacity() async {
    final String capacity = await getDocumentsFolderSizeInMB();
    // 계산된 크기를 상태에 업데이트하고 Preference에도 저장
    setState(() {
      description = capacity;
    });
    di
        .sl<SharedPrefsManager>()
        .setValue<String>(SharedPrefKeys.kCacheCapacity, capacity);
  }

  /// **다이얼로그 push -> pop 후, 변경사항 반영**
  Future<void> handleThemePreferenceTap() async {
    await showCupertinoDialog(
      context: context,
      builder: (context) => const CacheDeletionDialog(),
    );
    // pop이 완료되면 재 로딩
    setState(() {
      _loadCacheCapacity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleThemePreferenceTap,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(widget.icon,
                    size: 20, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).defaultThemedTextColor,
                  ),
                ),
              ],
            ),
            Text(
              description,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogGreyTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
