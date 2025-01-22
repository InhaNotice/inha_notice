import 'package:flutter/material.dart';
import 'package:inha_notice/utils/major_storage.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';

class MajorSettingPage extends StatefulWidget {
  const MajorSettingPage({super.key});

  @override
  State<MajorSettingPage> createState() => _MajorSettingPageState();
}

class _MajorSettingPageState extends State<MajorSettingPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _currentMajor; // 현재 학과

  final Map<String, List<String>> _majorGroups = {
    '공과대학': [
      '기계공학과',
      '항공우주공학과',
      '조선해양공학과',
      '산업경영공학과',
      '화학공학과',
      '생명공학과',
      '고분자공학과'
      '신소재공학과',
      '사회인프라공학과',
      '환경공학과',
      '공간정보공학과',
      '건축학부',
      '에너지자원공학과',
      '전기공학과',
      '전자공학과',
      '정보통신공학과'
    ],
    '자연과학대학': [
      '수학과',
      '통계학과',
      '물리학과',
      '화학과',
      '생명과학과',
      '해양학과',
    ],
    '경영대학': [
      '식품영양학과',
      '경영학과',
      '글로벌금융학과',
      '아태물류학과',
      '국제통상학과'
    ],
    '사범대학': [
      '국어교육과',
      '영어교육과',
      '사회교육과',
      '체육교육과',
      '교육학과',
      '수학교육과',
    ],
    '사회과학대학': [
      '행정학과',
      '정치외교학과',
      '미디어커뮤니케이션학과',
      '경제학과',
      '소비자학과',
      '아동심리학과',
      '사회복지학과',
    ],
    '문과대학': [
      '한국어문학과',
      '사학과',
      '철학과',
      '중국학과',
      '일본언어문화학과',
      '영어영문학과',
      '프랑스어문화학과',
      '문화콘텐츠문화경영학과',
    ],
    '의과대학': [
      '의예과',
      '간호학과'
    ],
    '예술체육대학': [
      '조형예술학과',
      '디자인학부',
      '스포츠과학과',
      '연극영화학과',
      '의류디자인학과',
    ],
    '국제학부': [
      'IBT학과',
      'ISE학과'
    ],
    '미래융합대학': [
      '메카트로닉스공학과',
      '소프트웨어융합공학과',
      '산업경영학과',
      '금융투자학과'
    ],
    '소프트웨어융합대학': [
      '인공지능공학과',
      '스마트모빌리티공학과',
      '데이터사이언스학과',
      '디자인테크놀리지학과',
      '컴퓨터공학과'
    ],
    '프런티어학부대학': [
      '자유전공학부'
    ]
  };

  Map<String, List<String>> _filteredMajorGroups = {};

  @override
  void initState() {
    super.initState();
    _initializeStorage();
    _filteredMajorGroups = _majorGroups;
  }

  Future<void> _initializeStorage() async {
    await MajorStorage.init();
    await _loadCurrentMajor();
  }

  Future<void> _loadCurrentMajor() async {
    String? major = await MajorStorage.getMajor();
    setState(() {
      _currentMajor = major;
    });
  }

  void _filterMajors(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMajorGroups = _majorGroups;
      } else {
        _filteredMajorGroups = {
          for (var entry in _majorGroups.entries)
            if (entry.value.any((major) => major.contains(query)))
              entry.key: entry.value
                  .where((major) => major.contains(query))
                  .toList(),
        };
      }
    });
  }

  Future<void> _saveMajor(String major) async {
    await MajorStorage.saveMajor(major);
    setState(() {
      _currentMajor = major;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
          '$major 학과가 저장되었습니다.',
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).defaultColor
          )
      )
        , backgroundColor: Theme.of(context).scaffoldBackgroundColor,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '학과 설정',
            style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).defaultColor
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_currentMajor != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  '현재 학과: $_currentMajor',
                  style: TextStyle(
                      fontFamily: Font.kDefaultFont,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).defaultColor
                  ),
                ),
              )
            else
               Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  '학과를 설정해주세요!',
                  style: TextStyle(
                      fontFamily: Font.kDefaultFont,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).defaultColor
                  ),
                ),
              ),
            TextField(
              controller: _searchController,
              onChanged: _filterMajors,
              decoration: const InputDecoration(
                labelText: '학과 검색',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _filteredMajorGroups.entries.map((entry) {
                  return ExpansionTile(
                    title: Text(entry.key),
                    children: entry.value
                        .map(
                          (major) => ListTile(
                        title: Text(major),
                        onTap: () => _saveMajor(major),
                      ),
                    )
                        .toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}