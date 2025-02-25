import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NoticeRefreshHeader extends StatelessWidget {
  const NoticeRefreshHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClassicHeader(
      idleText: "공지사항 새로 불러오려면 당겨주세요",
      releaseText: "놓으면 최신 공지사항을 불러옵니다",
      refreshingText: "공지사항을 불러오는 중...",
      completeText: "공지사항 업데이트 완료!",
    );
  }
}
