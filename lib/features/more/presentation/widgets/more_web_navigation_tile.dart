/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/widgets/web_navigator_widget.dart';

/// **MoreWebNavigationTile**
/// 이 클래스는 더보기 페이지의 웹 네이게이션 타일을 정의하는 클래스입니다.
class MoreWebNavigationTile extends StatefulWidget {
  final String title;
  final String url;
  final IconData? icon;

  const MoreWebNavigationTile(
      {super.key, required this.title, required this.url, this.icon});

  @override
  State<MoreWebNavigationTile> createState() => _MoreWebNavigationTileState();
}

class _MoreWebNavigationTileState extends State<MoreWebNavigationTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (mounted) {
          await WebNavigatorWidget.navigate(context: context, url: widget.url);
        }
      },
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
                if (widget.icon != null)
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
            Icon(Icons.arrow_forward_ios,
                size: 16, color: Theme.of(context).iconTheme.color),
          ],
        ),
      ),
    );
  }
}
