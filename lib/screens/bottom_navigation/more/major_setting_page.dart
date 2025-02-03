import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/more/major_utils.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/major_storage.dart';
import 'package:logger/logger.dart';

class MajorSettingPage extends StatefulWidget {
  const MajorSettingPage({super.key});

  @override
  State<MajorSettingPage> createState() => _MajorSettingPageState();
}

class _MajorSettingPageState extends State<MajorSettingPage> {
  final Logger logger = Logger();
  final TextEditingController _searchController = TextEditingController();
  Map<String, Map<String, String>> _filteredMajorGroups =
      MajorUtils.majorGroups;
  List<String> _filteredMajors = [];
  String? _currentMajor; // 한글 학과명
  String? _currentMajorKey; // 영문 학과명

  String? get currentMajorKey => _currentMajorKey;

  @override
  void initState() {
    super.initState();
    _loadCurrentMajor();
  }

  Future<void> _loadCurrentMajor() async {
    _currentMajorKey = await MajorStorage.getMajor();
    setState(() {
      if (_currentMajorKey != null) {
        _currentMajor = MajorUtils.translateToKorean(_currentMajorKey);
      }
    });
  }

  void _filterMajors(String query) {
    if (query.isEmpty) {
      if (_filteredMajorGroups != MajorUtils.majorGroups) {
        setState(() {
          _filteredMajorGroups = MajorUtils.majorGroups;
          _filteredMajors = [];
        });
      }
      return;
    }

    final List<String> filteredMajors = [
      for (var group in MajorUtils.majorGroups.values)
        for (var major in group.keys)
          if (major.contains(query)) major,
    ];

    setState(() {
      _filteredMajorGroups = {}; // 검색 시 단과대학 제거
      _filteredMajors = filteredMajors;
    });
  }

  Future<void> _handleMajorSelection(String major) async {
    // 화면 먼저 닫기
    if (mounted) Navigator.pop(context);

    String newMajorKey = MajorUtils.translateToEnglish(major);

    // 백그라운드에서 비동기적으로 실행
    try {
      await MajorUtils.subscribeToMajor(currentMajorKey, newMajorKey);
      await MajorUtils.saveMajor(newMajorKey);
    } catch (e) {
      logger.e('Error saving major: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text('학과 설정',
            style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultColor)),
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
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Theme.of(context).defaultColor),
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
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Theme.of(context).defaultColor),
                ),
              ),
            TextField(
              controller: _searchController,
              onChanged: _filterMajors,
              decoration: InputDecoration(
                labelText: '학과 검색',
                labelStyle: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      Theme.of(context).defaultColor,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredMajors.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredMajors.length,
                      itemBuilder: (context, index) {
                        final major = _filteredMajors[index];
                        return ListTile(
                          title: Text(major),
                          onTap: () async {
                            await _handleMajorSelection(major);
                          },
                        );
                      },
                    )
                  : ListView(
                      children: _filteredMajorGroups.entries.map((entry) {
                        return ExpansionTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultColor,
                            ),
                          ),
                          children: entry.value.keys
                              .map(
                                (major) => ListTile(
                                  title: Text(major),
                                  onTap: () async {
                                    await _handleMajorSelection(major);
                                  },
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
