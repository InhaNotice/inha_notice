/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/font/fonts.dart';
import 'package:inha_notice/widgets/app_bars/themed_app_bar.dart';

abstract class BaseSettingPage extends StatefulWidget {
  const BaseSettingPage({super.key});
}

abstract class BaseSettingPageState<T extends BaseSettingPage>
    extends State<T> {
  final TextEditingController _searchController = TextEditingController();
  bool isProcessing = false;

  /// 앱바에 표시할 제목 (예: '단과대 설정', '대학원 설정', '학과 설정')
  String get appBarTitle;

  /// 검색 필드의 라벨 (예: '단과대 검색', '대학원 검색', '학과 검색')
  String get searchLabel;

  /// 설정 대상의 명칭 (예: '단과대', '대학원', '학과')
  String get settingType;

  /// 현재 저장된 설정(표시용, 국문) – null이면 아직 설정되지 않음
  String? get currentSetting;

  /// 저장된 설정을 불러오는 메서드 (각 페이지별로 구현)
  Future<void> loadPreference();

  /// 사용자 입력에 따라 항목을 필터링하는 메서드 (각 페이지별로 구현)
  void filterItems(String query);

  /// 선택 가능한 항목들을 표시하는 리스트 위젯을 반환 (각 페이지별로 구현)
  Widget buildListView();

  /// 항목 선택 시 처리하는 메서드 (각 페이지별로 구현)
  Future<void> handleSelection(String item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(title: appBarTitle, titleSize: 20, isCenter: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildHeader(),
            TextField(
              controller: _searchController,
              onChanged: filterItems,
              decoration: InputDecoration(
                labelText: searchLabel,
                labelStyle: TextStyle(
                  fontFamily: Fonts.kDefaultFont,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).hintColor,
                ),
                filled: false,
                prefixIcon: Icon(Icons.search,
                    color: Theme.of(context).iconTheme.color),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).boxBorderColor,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: buildListView()),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        currentSetting != null
            ? '현재 $settingType: $currentSetting'
            : '$settingType를 설정해주세요!',
        style: TextStyle(
          fontFamily: Fonts.kDefaultFont,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyMedium?.color ??
              Theme.of(context).defaultThemedTextColor,
        ),
      ),
    );
  }
}
