import 'package:flutter/material.dart';
import 'package:inha_notice/core/font/fonts.dart';
import 'package:inha_notice/core/theme/theme.dart';

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
                  fontFamily: Fonts.kNanumGothic,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).fixedGreyText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '아래로 당겨서 새로고침을 하거나\n검색 키워드를 다시 입력해주세요!',
              style: TextStyle(
                  fontFamily: Fonts.kNanumGothic,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).fixedGreyText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
