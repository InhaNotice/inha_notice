/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/widgets/platform_selection_dialog.dart';

import '../../../support/widget_test_pump_app.dart';

enum _TestOption {
  option1('옵션1'),
  option2('옵션2'),
  option3('옵션3');

  final String displayName;
  const _TestOption(this.displayName);
}

void main() {
  group('showPlatformSelectionDialog 테스트', () {
    testWidgets('모든 옵션이 표시된다', (tester) async {
      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformSelectionDialog<_TestOption>(
                context: context,
                options: _TestOption.values,
                currentValue: _TestOption.option1,
                getDisplayName: (option) => option.displayName,
                onSelected: (value) {},
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 모든 옵션이 표시되는지 확인
      expect(find.text('옵션1'), findsOneWidget);
      expect(find.text('옵션2'), findsOneWidget);
      expect(find.text('옵션3'), findsOneWidget);
    });

    testWidgets('옵션 선택 시 onSelected 콜백이 호출된다', (tester) async {
      _TestOption? selectedValue;

      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformSelectionDialog<_TestOption>(
                context: context,
                options: _TestOption.values,
                currentValue: _TestOption.option1,
                getDisplayName: (option) => option.displayName,
                onSelected: (value) {
                  selectedValue = value;
                },
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 옵션2 선택
      await tester.tap(find.text('옵션2'));
      await tester.pumpAndSettle();

      // 콜백이 호출되었는지 확인
      expect(selectedValue, _TestOption.option2);
    });

    testWidgets('현재 선택된 옵션이 체크된다', (tester) async {
      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformSelectionDialog<_TestOption>(
                context: context,
                options: _TestOption.values,
                currentValue: _TestOption.option2,
                getDisplayName: (option) => option.displayName,
                onSelected: (value) {},
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // RadioListTile 확인
      final radioTiles = tester.widgetList<RadioListTile<_TestOption>>(
        find.byType(RadioListTile<_TestOption>),
      );

      expect(radioTiles.length, 3);
      expect(radioTiles.first.groupValue, _TestOption.option2);
      expect(radioTiles.elementAt(1).value, _TestOption.option2);
    });

    testWidgets('선택 후 다이얼로그가 닫힌다', (tester) async {
      _TestOption? selectedValue;

      await pumpInhaApp(
        tester,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showPlatformSelectionDialog<_TestOption>(
                context: context,
                options: _TestOption.values,
                currentValue: _TestOption.option1,
                getDisplayName: (option) => option.displayName,
                onSelected: (value) {
                  selectedValue = value;
                },
              );
            },
            child: const Text('다이얼로그 열기'),
          ),
        ),
      );

      // 다이얼로그 열기
      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // 옵션 선택
      await tester.tap(find.text('옵션3'));
      await tester.pumpAndSettle();

      // 콜백이 호출되었는지 확인
      expect(selectedValue, _TestOption.option3);

      // 다이얼로그 옵션이 더 이상 표시되지 않는지 확인 (다이얼로그가 닫힘)
      expect(find.byType(RadioListTile<_TestOption>), findsNothing);
    });
  });
}
