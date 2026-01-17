/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';

class NoSearchResult extends StatefulWidget {
  const NoSearchResult({super.key});

  @override
  State<NoSearchResult> createState() => _NoSearchResultState();
}

class _NoSearchResultState extends State<NoSearchResult> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '공지사항을 찾지 못했어요!',
              style: TextStyle(
                  fontFamily: AppFont.nanumGothic.family,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).fixedGreyText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '아래로 당겨서 새로고침',
                      style: TextStyle(
                        fontFamily: AppFont.nanumGothic.family,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).fixedGreyText,
                      ),
                    ),
                    Text(
                      '을 하거나',
                      style: TextStyle(
                        fontFamily: AppFont.nanumGothic.family,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).fixedGreyText,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '검색 키워드',
                      style: TextStyle(
                        fontFamily: AppFont.nanumGothic.family,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).fixedGreyText,
                      ),
                    ),
                    Text(
                      '를 다시 입력해주세요!',
                      style: TextStyle(
                        fontFamily: AppFont.nanumGothic.family,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).fixedGreyText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
