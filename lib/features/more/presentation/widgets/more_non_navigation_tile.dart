/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';

/// **MoreNonNavigationTile**
/// 이 클래스는 더보기 페이지의 다른 페이지로 이동하지 않는 타일을 정의합니다.
class MoreNonNavigationTile extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;

  const MoreNonNavigationTile(
      {super.key,
      required this.title,
      required this.description,
      required this.icon});

  @override
  State<MoreNonNavigationTile> createState() => _MoreNonNavigationTileState();
}

class _MoreNonNavigationTileState extends State<MoreNonNavigationTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            widget.description,
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
    );
  }
}
