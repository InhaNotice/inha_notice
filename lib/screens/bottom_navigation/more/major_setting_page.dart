/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-10
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/more/major_utils.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/dialogs/blocking_dialog.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_app_bar.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snack_bar.dart';
import 'package:logger/logger.dart';

/// **MajorSettingPage**
/// 이 클래스는 학과 설정하는 페이지를 구현하는 클래스입니다.
///
/// ### 주요 기능:
/// - 나의 학과를 설정 및 확인
class MajorSettingPage extends StatefulWidget {
  const MajorSettingPage({super.key});

  @override
  State<MajorSettingPage> createState() => _MajorSettingPageState();
}

class _MajorSettingPageState extends State<MajorSettingPage> {
  final Logger logger = Logger();

  /// 검색 필드를 정의하는 컨트롤러
  final TextEditingController _searchController = TextEditingController();

  /// 모든 단과 대학을 담는 컨테이너
  Map<String, Map<String, String>> _filteredMajorGroups =
      MajorUtils.majorGroups;

  /// 사용자의 입력에 따른 학과 재분류하는 컨테이너
  List<String> _filteredMajors = [];
  String? _currentMajor; // 한글 학과명
  String? _currentMajorKey; // 영문 학과명
  bool _isProcessing = false;

  String? get currentMajorKey => _currentMajorKey;

  @override
  void initState() {
    super.initState();
    _loadMajorPreference();
  }

  /// **저장된 나의 학과 설정 불러오기**
  Future<void> _loadMajorPreference() async {
    setState(() {
      _currentMajorKey = SharedPrefsManager().getPreference('major-key');
      if (_currentMajorKey != null) {
        _currentMajor = MajorUtils.translateToKorean(_currentMajorKey);
      }
    });
  }

  /// **사용자 입력에 따른 학과를 필터링**
  void _filterMajors(String query) {
    // 입력이 없다면 초기화면으로 설정
    if (query.isEmpty) {
      if (_filteredMajorGroups != MajorUtils.majorGroups) {
        setState(() {
          _filteredMajorGroups = MajorUtils.majorGroups;
          _filteredMajors = [];
        });
      }
      return;
    }

    // 사용자 입력에 따른 학과 재분류
    final List<String> filteredMajors = [
      for (var group in MajorUtils.majorGroups.values)
        for (var major in group.keys)
          if (major.contains(query)) major,
    ];

    setState(() {
      _filteredMajorGroups = {}; // 사용자 입력이 주어지면 빈 컨테이너로 설정
      _filteredMajors = filteredMajors;
    });
  }

  /// **학과 선택 핸들러**
  Future<void> _handleMajorSelection(String major) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      BlockingDialog.show(context);
    });

    String newMajorKey = MajorUtils.translateToEnglish(major);

    try {
      await SharedPrefsManager()
          .setMajorPreference(currentMajorKey, newMajorKey);

      final isMajorNotificationOn =
          SharedPrefsManager().getPreference('major-notification');
      if (isMajorNotificationOn) {
        await FirebaseService().updateMajorSubscription();
      }
      if (mounted) {
        ThemedSnackBar.succeedSnackBar(context, '$major로 설정되었습니다!');
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      logger.e('❌ Error saving major: $e');
      if (mounted) {
        ThemedSnackBar.failSnackBar(context, '저장 중 오류가 발생했습니다. 다시 시도해주세요!');
      }
    } finally {
      if (mounted) {
        BlockingDialog.dismiss(context);
      }
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(title: '학과 설정', titleSize: 20, isCenter: true),
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
                  color: Theme.of(context).hintColor,
                ),
                filled: false,
                prefixIcon: Icon(Icons.search,
                    color: Theme.of(context).iconTheme.color),
                // 검색 아이콘 추가
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).boxBorderColor,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2.5,
                  ),
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
                      children: _filteredMajorGroups.entries.map(
                        (entry) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              title: Text(
                                entry.key,
                                style: TextStyle(
                                  fontFamily: Font.kDefaultFont,
                                  fontSize: 19,
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
                            ),
                          );
                        },
                      ).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
