/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-28
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/constants/custom_tab_list/custom_tab_list_keys.dart';
import 'package:inha_notice/screens/notice_board/absolute_style_notice_board.dart';
import 'package:inha_notice/screens/notice_board/relative_style_notice_board.dart';
import 'package:inha_notice/utils/custom_tab_list_utils/custom_tab_list_utils.dart';

class NoticeBoardTab extends StatelessWidget {
  final String tabName;

  const NoticeBoardTab({
    super.key,
    required this.tabName,
  });

  @override
  Widget build(BuildContext context) {
    // tabName을 통한 매칭되는 키 가져오기
    final String? noticeType = CustomTabListUtils.kTabGroups[tabName];
    // 매핑에 없는 탭인 경우 빈 컨테이너 반환
    if (noticeType == null) return Container();

    // '정석'(LIBRARY) 탭인 경우 RelativeStyleNoticeBoard
    if (noticeType == CustomTabListKeys.LIBRARY) {
      return RelativeStyleNoticeBoard(noticeType: noticeType);
    }
    // 나머지 탭은 AbsoluteStyleNoticeBoard 사용
    return AbsoluteStyleNoticeBoard(noticeType: noticeType);
  }
}
