/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NoticeRefreshHeader extends StatelessWidget {
  const NoticeRefreshHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
      idleText: "최신 공지사항을 보려면 부드럽게 당겨주세요.",
      releaseText: "놓으면 따뜻한 소식이 도착해요.",
      refreshingText: "잠시만 기다려주세요, 공지사항을 가져오는 중이에요.",
      completeText: "공지사항이 업데이트 되었어요. 확인해보세요!",
    );
  }
}
