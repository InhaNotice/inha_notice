/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-10
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/widgets/in_app_web_page.dart';

/// **MoreWebNavigationTile**
/// 이 클래스는 더보기 페이지의 웹 네이게이션 타일을 정의하는 클래스입니다.
class MoreWebNavigationTile extends StatefulWidget {
  final String title;
  final String url;
  final IconData icon;

  const MoreWebNavigationTile(
      {super.key, required this.title, required this.url, required this.icon});

  @override
  State<MoreWebNavigationTile> createState() => _MoreWebNavigationTileState();
}

class _MoreWebNavigationTileState extends State<MoreWebNavigationTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                InAppWebPage(url: widget.url),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child; // 애니메이션 없이 바로 전환
            },
          ),
        );
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
                Icon(widget.icon,
                    size: 20, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: Font.kDefaultFont,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).defaultColor,
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
