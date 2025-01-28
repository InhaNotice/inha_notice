import 'package:flutter/material.dart';
import 'package:inha_notice/utils/major_storage.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/screens/bottom_navigation/more/major_utils.dart';

class MajorSettingPage extends StatefulWidget {
  const MajorSettingPage({super.key});

  @override
  State<MajorSettingPage> createState() => _MajorSettingPageState();
}

class _MajorSettingPageState extends State<MajorSettingPage> {
  late TextEditingController _searchController;
  late String? _currentMajor;
  late Map<String, Map<String, String>> _filteredMajorGroups;
  late List<String> _filteredMajors;

  @override
  void initState() {
    super.initState();
    _loadCurrentMajor();
    _setupFields();
  }

  Future<void> _loadCurrentMajor() async {
    String? majorKey = await MajorStorage.getMajor();
    setState(() {
      _currentMajor = MajorUtils.translateToKorean(majorKey);
    });
  }

  void _setupFields() {
    _searchController = TextEditingController();
    _filteredMajorGroups = MajorUtils.majorGroups;
    _filteredMajors = [];
    _currentMajor = '';
  }

  void _filterMajors(String query) {
    setState(() {
      if (query.isEmpty) {
        // 검색어가 없으면 단과대학 그룹으로 표시
        _filteredMajorGroups = MajorUtils.majorGroups;
        _filteredMajors = [];
      } else {
        // 검색어가 있으면 학과 리스트만 표시
        _filteredMajorGroups = {};
        _filteredMajors = [
          for (var group in MajorUtils.majorGroups.values)
            for (var major in group.keys)
              if (major.contains(query)) major,
        ];
      }
    });
  }

  Future<void> _saveMajor(String major) async {
    String majorKey = MajorUtils.translateToEnglish(major);
    await MajorStorage.saveMajor(majorKey);
    setState(() {
      _currentMajor = major;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$major 학과가 저장되었습니다.',
            style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultColor)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('학과 설정',
            style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
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
              decoration: const InputDecoration(
                labelText: '학과 검색',
                border: OutlineInputBorder(),
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
                    onTap: () => _saveMajor(major),
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
                        fontWeight: FontWeight.bold,
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
