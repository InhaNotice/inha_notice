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
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarkRefreshHeaderWidget extends StatelessWidget {
  const BookmarkRefreshHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
      idleText: "북마크를 새로고침하려면 아래로 당겨주세요.",
      releaseText: "놓으면 북마크를 다시 불러와요!",
      refreshingText: "잠시만 기다려주세요, 북마크를 가져오는 중이에요.",
      completeText: "북마크가 업데이트 되었어요. 확인해보세요!",
    );
  }
}
