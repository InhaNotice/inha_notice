import 'package:flutter/material.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/fonts/font.dart';

class MajorSettingPage extends StatefulWidget {
  const MajorSettingPage({super.key});

  @override
  State<MajorSettingPage> createState() => _MajorSettingPageState();
}

class _MajorSettingPageState extends State<MajorSettingPage> {
  final TextEditingController _searchController = TextEditingController();

  String _warning = Font.kEmptyString;

  @override
  void initState() {
    super.initState();
  }

  void _search() {
    if (_searchController.text.length < 2) {
      setState(() {
        _warning = '검색어는 두 글자 이상 입력해주세요.';
      });
      return;
    }
    setState(() {
      _warning = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: false,
          title: Text(
            '학과 설정',
            style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultColor),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '학과를 설정해주세요',
                        style: TextStyle(
                          fontFamily: Font.kDefaultFont,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color:
                            Theme.of(context).textTheme.bodyMedium?.color ??
                              Theme.of(context).defaultColor,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                                hintText: '학과를 입력해주세요',
                                hintStyle: TextStyle(
                                  fontFamily: Font.kDefaultFont,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFFC4C4C4),
                                )),
                            onSubmitted: (_) => print("Submitted!"),
                          ),
                        )
                      ],
                    )
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
                        '나의 학과',
                        style: TextStyle(
                          fontFamily: Font.kDefaultFont,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
