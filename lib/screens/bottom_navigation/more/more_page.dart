import 'package:flutter/material.dart';
import 'package:inha_notice/main.dart';
import 'package:inha_notice/themes/theme.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: false,
          title: Text(
            '더보기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).textTheme.bodyLarge?.color ??
                  Theme.of(context).defaultColor,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '공지사항',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: 400,
                      child: Divider(
                          color: Theme.of(context).dividerColor,
                          thickness: 2.0)),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '학과설정',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '공지사항 알림 설정',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '피드백',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: 400,
                      child: Divider(
                          color: Theme.of(context).dividerColor,
                          thickness: 2.0)),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '피드백 보내기',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '앱 정보',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: 400,
                      child: Divider(
                          color: Theme.of(context).dividerColor,
                          thickness: 2.0)),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '공지사항',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '앱 버전',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '개인정보 처리방침',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '이용약관',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '사용된 오픈소스',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '앱소개',
                          style: TextStyle(
                            fontFamily: 'Pretendart',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
