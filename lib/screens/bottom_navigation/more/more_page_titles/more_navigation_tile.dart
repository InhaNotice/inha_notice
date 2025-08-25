/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-25
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/font/fonts.dart';
import 'package:inha_notice/themes/theme.dart';

/// **MoreNavigationTile**
/// 이 클래스는 더보기 페이지의 다른 페이지로 이동하는 타일을 정의합니다.
class MoreNavigationTile extends StatefulWidget {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;

  const MoreNavigationTile(
      {super.key, required this.title, this.icon, required this.onTap});

  @override
  State<MoreNavigationTile> createState() => _MoreNavigationTileState();
}

class _MoreNavigationTileState extends State<MoreNavigationTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
                    fontFamily: Fonts.kDefaultFont,
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
